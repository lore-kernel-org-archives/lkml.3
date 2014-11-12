Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaKLMHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:07:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47976 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaKLMHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:07:42 -0500
Date: Wed, 12 Nov 2014 13:07:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] fuse: Add support for pid namespaces
Message-ID: <20141112120742.GF333@tucsk>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-2-git-send-email-seth.forshee@canonical.com>
 <20141111132734.GC333@tucsk>
 <20141111152429.GA7906@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111152429.GA7906@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:24:29AM -0600, Seth Forshee wrote:
> > What happens when the server does indeed change pid namespace after mounting?
> > Will just receive bogus pid values?  Shouldn't it receive an error instead?
> 
> Yeah, I suppose it does receive bogus pids and userid values. About all
> we could do to prevent this is make the /dev/fuse read/write paths
> return an error if the current namespace isn't the same as the one at
> mount time. But then requests could get stuck in the queue forever, so
> maybe we should also fail all requests in the queue when this happens.
> Unless you have a better idea?

In fuse_dev_do_read() just after dequeuing the request check if the namespaces
match, and if not, reject with EIO.

> > > @@ -2146,7 +2147,11 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
> > >  
> > >  		fl->fl_start = ffl->start;
> > >  		fl->fl_end = ffl->end;
> > > -		fl->fl_pid = ffl->pid;
> > > +		rcu_read_lock();
> > > +		fl->fl_pid = pid_vnr(find_pid_ns(ffl->pid, fc->pid_ns));
> > > +		rcu_read_unlock();
> > > +		if (ffl->pid != 0 && fl->fl_pid == 0)
> > > +			return -EIO;
> > 
> > This needs some comments: is this trying to translate the pid backwards?
> > Why is it not checking the return of find_pid_ns() then?  The man page
> > documents l_pid value of -1 but not of 0, so why are we checking for
> > "ffl->pid != 0"?  Or is the man page incomplete and in practice we get l_pid
> > == 0 values?
> 
> I'll add comments. It's converting the pid in the fuse_file_lock into
> the current pid namespace. pid_vnr calls pid_nr_ns, which returns 0 if
> the pid can't be translated into the namespace, thus we return the
> error.
> 
> pid_vnr's return values don't necessarily conform to the expectations of
> the fcntl syscall in all cases, and as far as I can tell it should never
> return <0. But if fcntl doesn't expect l_pid == 0 and pid_vnr could
> return that value then doesn't it makes sense for fuse to return an
> error in cases where this would happen?

Not necessarily.  The conflicting lock might be held by a process whose pid is
not visible from the client's namespace.  That doesn't mean that the GETLK
should fail, it just means that l_pid can't be filled in (same as in NFS when a
lock held on a different client).  AFAICS, NFS fills l_pid with zero in that
case.  Makes sense, not sure why the man page doesn't document that.

> > > @@ -2170,7 +2175,9 @@ static void fuse_lk_fill(struct fuse_req *req, struct file *file,
> > >  	arg->lk.start = fl->fl_start;
> > >  	arg->lk.end = fl->fl_end;
> > >  	arg->lk.type = fl->fl_type;
> > > -	arg->lk.pid = pid;
> > > +	arg->lk.pid = pid_nr_ns(pid, fc->pid_ns);
> > > +	if (pid && arg->lk.pid == 0)
> > > +		return -EOVERFLOW;
> > 
> > Could have done the conversion immediately after getting 'pid' with task_tgid(),
> > then the changes would have been smaller and more localized.
> 
> The changes would be very marginally smaller since currently only one
> caller of fuse_lk_fill which passes a non-zero pid. If additional
> callers were ever added with non-zero pids then there would be
> duplication of this code. But I'll do it whichever way you prefer, just
> let me know.

I prefer the simpler (even if only marginally) one.

Thanks,
Miklos
