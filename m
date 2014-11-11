Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaKKQ0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:26:15 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33576 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaKKQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:26:11 -0500
Date: Tue, 11 Nov 2014 10:26:07 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        seth.forshee@canonical.com
Subject: Re: [PATCH v5 1/4] fuse: Add support for pid namespaces
Message-ID: <20141111162607.GD7906@ubuntu-hedt>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-2-git-send-email-seth.forshee@canonical.com>
 <20141111132734.GC333@tucsk>
 <20141111152429.GA7906@ubuntu-hedt>
 <CALCETrUzkyu85BtM=Zn8+x6NqyZj+-d2u-1EiPkOO8-dwzYN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUzkyu85BtM=Zn8+x6NqyZj+-d2u-1EiPkOO8-dwzYN_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 07:39:09AM -0800, Andy Lutomirski wrote:
> On Tue, Nov 11, 2014 at 7:24 AM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Tue, Nov 11, 2014 at 02:27:34PM +0100, Miklos Szeredi wrote:
> >> On Wed, Oct 22, 2014 at 04:24:17PM -0500, Seth Forshee wrote:
> >> > If the userspace process servicing fuse requests is running in
> >> > a pid namespace then pids passed via the fuse fd need to be
> >> > translated relative to that namespace. Capture the pid namespace
> >> > in use when the filesystem is mounted and use this for pid
> >> > translation.
> >>
> >> But WHY?
> >>
> >> I know it's been discussed, but the reasons should be spelled out here:
> >
> > The reasons relate much more to user namespaces rather than pid
> > namespaces, but in my opinion it doesn't make much sense to handle them
> > differently. It might make more sense to reorder the patches to add user
> > namespace support first, give the justification there, and then for this
> > one just say "to be consistent with userns support."
> >
> >>  - capturing the namespace makes the code less complex (the strongest argument
> >>    that I've heard)
> >
> > For pid namespaces it's not so bad, except maybe for file locking (I
> > can't remember for sure about that). For user namespaces though it does
> > get much more complex to use the namespace from the /dev/fuse IO path,
> > because frequently the raw data from userspace is being handed off to
> > another thread before it is interpreted. That means we either have to
> > capture the userns and pass it along with the data or restructure the
> > code to do all of this in the IO paths. Either way having a static
> > namespace in fuse_conn works out to be much simpler.
> >
> >>  - there's a security concern with translating to current namespace (that I
> >>    still don't fully understand)
> >
> > There's the one I explained with suid, which in reality should be
> > mitigated by some of the other protections in fuse. Other than that I
> > don't know of anything specific Eric had in mind other than the fact
> > that other sources of userns security bugs have been "time of open
> > versus time of use" sorts of problems, and he believes that capturing
> > the userns at IO time instead of mount time is likely to be similarly
> > vulnerable.
> >
> 
> The general concern is that read(2) and write(2) really have no
> business looking at creds.  ioctl is considerably less dangerous.  The
> risk is that you get an fd and use at as stderr for a setuid process
> or something along those lines.
> 
> > Otherwise I can't add any specifics beyond what Eric has already said in
> > http://lkml.kernel.org/g/87egv26mcz.fsf@x220.int.ebiederm.org. Maybe
> > Eric or Andy could elaborate further. I'll also look at some of the past
> > vulnerabilities and see if I get any ideas for specific attacks.
> >
> >>  - changing the pid namespace after mounting is unlikely to be of any use
> >
> > This sounds like trying to prove a negative. All I can say is that no
> > one has stepped forward to voice any specific use cases which would
> > require it.
> >
> >>  - if it turns out to be useful, we can still fix this later (can we?)
> >
> > I don't see why we couldn't as long as nothing in userspace came to rely
> > upon the behavior.
> 
> Just to be clear, the current behavior is to reject /dev/fuse io
> attempts with namespaces that don't match the opener, right?  If so,
> that seems like the conservative option, and changing it won't break
> things.
> 
> >
> >> What happens when the server does indeed change pid namespace after mounting?
> >> Will just receive bogus pid values?  Shouldn't it receive an error instead?
> >
> > Yeah, I suppose it does receive bogus pids and userid values. About all
> > we could do to prevent this is make the /dev/fuse read/write paths
> > return an error if the current namespace isn't the same as the one at
> > mount time. But then requests could get stuck in the queue forever, so
> > maybe we should also fail all requests in the queue when this happens.
> > Unless you have a better idea?
> >
> 
> If this is actually read(2)/write(2), then I think you need to either
> error out or use the namespaces at the time of open.  Anything else is
> asking for trouble when the caller of read(2) or write(2) doesn't
> realize that the fd is a /dev/fuse fd.

I'll lay things out explicitly just to be sure there's no confusion.

There are two sides of the transaction. The first is the process
accessing the fuse mount, whose access attempt results in a request
being queued for reading on /dev/fuse. I'll call this side the client.
The other side is that of the process which reads the request from
/dev/fuse, processes it, and writes the response back to /dev/fuse.
I'll call this process the server.

In my current patches the pid and user namespaces are captured at mount
time, and the userns is also required to be the same as when opening
/dev/fuse or else the mount attempt fails. These namespaces are used for
all subsequent translations for IO on /dev/fuse, even if the server
switches to a different namespace.

One of the things Miklos is asking for is more convincing arguments that
we must use the namespaces from /dev/fuse open time and not the current
namespace of the server at IO time.

His other question is, assuming that we must use the namespaces from
/dev/fuse open, should the server recieve an error when it tries to do
IO on /dev/fuse from a different namespace? In this case the server will
know that the fd is a /dev/fuse fd.

But if the server cannot process requests due to switching namespaces it
could cause clients who have pending requests to block indefinitely. The
clients do not have fds to /dev/fuse but to some file within the fuse
mount. My suggestion was that whenever we refuse /dev/fuse IO for a
server which has switched namespaces we should assume that pending
requests aren't going to get processed and return errors to the clients
for pending IO operations on files within the fuse mount.

Does that make sense?

Thanks,
Seth

> 
> --Andy
> 
> >>
> >> More comments inline.
> >>
> >> > File locking changes based on previous work done by Eric
> >> > Biederman.
> >> >
> >> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> >> > Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
> >> > Cc: Andy Lutomirski <luto@amacapital.net>
> >> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >> > ---
> >> >  fs/fuse/dev.c    |  9 +++++----
> >> >  fs/fuse/file.c   | 38 +++++++++++++++++++++++++++-----------
> >> >  fs/fuse/fuse_i.h |  4 ++++
> >> >  fs/fuse/inode.c  |  4 ++++
> >> >  4 files changed, 40 insertions(+), 15 deletions(-)
> >> >
> >> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> >> > index ca887314aba9..839caebd34f1 100644
> >> > --- a/fs/fuse/dev.c
> >> > +++ b/fs/fuse/dev.c
> >> > @@ -20,6 +20,7 @@
> >> >  #include <linux/swap.h>
> >> >  #include <linux/splice.h>
> >> >  #include <linux/aio.h>
> >> > +#include <linux/sched.h>
> >> >
> >> >  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
> >> >  MODULE_ALIAS("devname:fuse");
> >> > @@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
> >> >     atomic_dec(&req->count);
> >> >  }
> >> >
> >> > -static void fuse_req_init_context(struct fuse_req *req)
> >> > +static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
> >> >  {
> >> >     req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
> >> >     req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> >> > -   req->in.h.pid = current->pid;
> >> > +   req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
> >> >  }
> >> >
> >> >  static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
> >> > @@ -168,7 +169,7 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
> >> >             goto out;
> >> >     }
> >> >
> >> > -   fuse_req_init_context(req);
> >> > +   fuse_req_init_context(fc, req);
> >> >     req->waiting = 1;
> >> >     req->background = for_background;
> >> >     return req;
> >> > @@ -257,7 +258,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
> >> >     if (!req)
> >> >             req = get_reserved_req(fc, file);
> >> >
> >> > -   fuse_req_init_context(req);
> >> > +   fuse_req_init_context(fc, req);
> >> >     req->waiting = 1;
> >> >     req->background = 0;
> >> >     return req;
> >> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> >> > index caa8d95b24e8..cb0e40ecc362 100644
> >> > --- a/fs/fuse/file.c
> >> > +++ b/fs/fuse/file.c
> >> > @@ -2131,7 +2131,8 @@ static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
> >> >     return generic_file_mmap(file, vma);
> >> >  }
> >> >
> >> > -static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
> >> > +static int convert_fuse_file_lock(struct fuse_conn *fc,
> >> > +                             const struct fuse_file_lock *ffl,
> >> >                               struct file_lock *fl)
> >> >  {
> >> >     switch (ffl->type) {
> >> > @@ -2146,7 +2147,11 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
> >> >
> >> >             fl->fl_start = ffl->start;
> >> >             fl->fl_end = ffl->end;
> >> > -           fl->fl_pid = ffl->pid;
> >> > +           rcu_read_lock();
> >> > +           fl->fl_pid = pid_vnr(find_pid_ns(ffl->pid, fc->pid_ns));
> >> > +           rcu_read_unlock();
> >> > +           if (ffl->pid != 0 && fl->fl_pid == 0)
> >> > +                   return -EIO;
> >>
> >> This needs some comments: is this trying to translate the pid backwards?  Why is
> >> it not checking the return of find_pid_ns() then?  The man page documents l_pid
> >> value of -1 but not of 0, so why are we checking for "ffl->pid != 0"?  Or is the
> >> man page incomplete and in practice we get l_pid == 0 values?
> >
> > I'll add comments. It's converting the pid in the fuse_file_lock into
> > the current pid namespace. pid_vnr calls pid_nr_ns, which returns 0 if
> > the pid can't be translated into the namespace, thus we return the
> > error.
> >
> > pid_vnr's return values don't necessarily conform to the expectations of
> > the fcntl syscall in all cases, and as far as I can tell it should never
> > return <0. But if fcntl doesn't expect l_pid == 0 and pid_vnr could
> > return that value then doesn't it makes sense for fuse to return an
> > error in cases where this would happen?
> >
> > Fwiw, this is also an example of a case where it's simpler to have a
> > static namespace. If we were to use the current ns from the /dev/fuse IO
> > path then we either have to process the request there or grab a
> > reference to the ns there and pass it alongside the request (and we
> > have to do it for all requests unless the IO path is going to look at
> > the request type and decide whether or not it requires a reference to
> > the namespace).
> >
> >>
> >>
> >> >             break;
> >> >
> >> >     default:
> >> > @@ -2156,9 +2161,9 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
> >> >     return 0;
> >> >  }
> >> >
> >> > -static void fuse_lk_fill(struct fuse_req *req, struct file *file,
> >> > -                    const struct file_lock *fl, int opcode, pid_t pid,
> >> > -                    int flock)
> >> > +static int fuse_lk_fill(struct fuse_req *req, struct file *file,
> >> > +                    const struct file_lock *fl, int opcode,
> >> > +                    struct pid *pid, int flock)
> >> >  {
> >> >     struct inode *inode = file_inode(file);
> >> >     struct fuse_conn *fc = get_fuse_conn(inode);
> >> > @@ -2170,7 +2175,9 @@ static void fuse_lk_fill(struct fuse_req *req, struct file *file,
> >> >     arg->lk.start = fl->fl_start;
> >> >     arg->lk.end = fl->fl_end;
> >> >     arg->lk.type = fl->fl_type;
> >> > -   arg->lk.pid = pid;
> >> > +   arg->lk.pid = pid_nr_ns(pid, fc->pid_ns);
> >> > +   if (pid && arg->lk.pid == 0)
> >> > +           return -EOVERFLOW;
> >>
> >> Could have done the conversion immediately after getting 'pid' with task_tgid(),
> >> then the changes would have been smaller and more localized.
> >
> > The changes would be very marginally smaller since currently only one
> > caller of fuse_lk_fill which passes a non-zero pid. If additional
> > callers were ever added with non-zero pids then there would be
> > duplication of this code. But I'll do it whichever way you prefer, just
> > let me know.
> >
> >> >     if (flock)
> >> >             arg->lk_flags |= FUSE_LK_FLOCK;
> >> >     req->in.h.opcode = opcode;
> >> > @@ -2178,6 +2185,8 @@ static void fuse_lk_fill(struct fuse_req *req, struct file *file,
> >> >     req->in.numargs = 1;
> >> >     req->in.args[0].size = sizeof(*arg);
> >> >     req->in.args[0].value = arg;
> >> > +
> >> > +   return 0;
> >> >  }
> >> >
> >> >  static int fuse_getlk(struct file *file, struct file_lock *fl)
> >> > @@ -2192,16 +2201,19 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
> >> >     if (IS_ERR(req))
> >> >             return PTR_ERR(req);
> >> >
> >> > -   fuse_lk_fill(req, file, fl, FUSE_GETLK, 0, 0);
> >> > +   err = fuse_lk_fill(req, file, fl, FUSE_GETLK, NULL, 0);
> >> > +   if (err)
> >> > +           goto out;
> >> >     req->out.numargs = 1;
> >> >     req->out.args[0].size = sizeof(outarg);
> >> >     req->out.args[0].value = &outarg;
> >> >     fuse_request_send(fc, req);
> >> >     err = req->out.h.error;
> >> > -   fuse_put_request(fc, req);
> >> >     if (!err)
> >> > -           err = convert_fuse_file_lock(&outarg.lk, fl);
> >> > +           err = convert_fuse_file_lock(fc, &outarg.lk, fl);
> >> >
> >> > +out:
> >> > +   fuse_put_request(fc, req);
> >> >     return err;
> >> >  }
> >> >
> >> > @@ -2211,7 +2223,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
> >> >     struct fuse_conn *fc = get_fuse_conn(inode);
> >> >     struct fuse_req *req;
> >> >     int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
> >> > -   pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
> >> > +   struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
> >> >     int err;
> >> >
> >> >     if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
> >> > @@ -2227,12 +2239,16 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
> >> >     if (IS_ERR(req))
> >> >             return PTR_ERR(req);
> >> >
> >> > -   fuse_lk_fill(req, file, fl, opcode, pid, flock);
> >> > +   err = fuse_lk_fill(req, file, fl, opcode, pid, flock);
> >> > +   if (err)
> >> > +           goto out;
> >> >     fuse_request_send(fc, req);
> >> >     err = req->out.h.error;
> >> >     /* locking is restartable */
> >> >     if (err == -EINTR)
> >> >             err = -ERESTARTSYS;
> >> > +
> >> > +out:
> >> >     fuse_put_request(fc, req);
> >> >     return err;
> >> >  }
> >> > diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> >> > index e8e47a6ab518..a3ded071e2c6 100644
> >> > --- a/fs/fuse/fuse_i.h
> >> > +++ b/fs/fuse/fuse_i.h
> >> > @@ -22,6 +22,7 @@
> >> >  #include <linux/rbtree.h>
> >> >  #include <linux/poll.h>
> >> >  #include <linux/workqueue.h>
> >> > +#include <linux/pid_namespace.h>
> >> >
> >> >  /** Max number of pages that can be used in a single read request */
> >> >  #define FUSE_MAX_PAGES_PER_REQ 32
> >> > @@ -386,6 +387,9 @@ struct fuse_conn {
> >> >     /** The group id for this mount */
> >> >     kgid_t group_id;
> >> >
> >> > +   /** The pid namespace for this mount */
> >> > +   struct pid_namespace *pid_ns;
> >> > +
> >> >     /** The fuse mount flags for this mount */
> >> >     unsigned flags;
> >> >
> >> > diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> >> > index 03246cd9d47a..e137969815a3 100644
> >> > --- a/fs/fuse/inode.c
> >> > +++ b/fs/fuse/inode.c
> >> > @@ -20,6 +20,7 @@
> >> >  #include <linux/random.h>
> >> >  #include <linux/sched.h>
> >> >  #include <linux/exportfs.h>
> >> > +#include <linux/pid_namespace.h>
> >> >
> >> >  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
> >> >  MODULE_DESCRIPTION("Filesystem in Userspace");
> >> > @@ -616,6 +617,7 @@ void fuse_conn_init(struct fuse_conn *fc)
> >> >     fc->initialized = 0;
> >> >     fc->attr_version = 1;
> >> >     get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
> >> > +   fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
> >> >  }
> >> >  EXPORT_SYMBOL_GPL(fuse_conn_init);
> >> >
> >> > @@ -624,6 +626,8 @@ void fuse_conn_put(struct fuse_conn *fc)
> >> >     if (atomic_dec_and_test(&fc->count)) {
> >> >             if (fc->destroy_req)
> >> >                     fuse_request_free(fc->destroy_req);
> >> > +           put_pid_ns(fc->pid_ns);
> >> > +           fc->pid_ns = NULL;
> >>
> >> We don't usually zero out fields before freeing.  There are debugging config
> >> options to do that for us.
> >
> > Okay, I'll remove that line.
> >
> > Thanks,
> > Seth
> >
> >>
> >> >             fc->release(fc);
> >> >     }
> >> >  }
> >> > --
> >> > 1.9.1
> >> >
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
