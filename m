Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaC0OIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbaC0OIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:08:12 -0400
Date: Thu, 27 Mar 2014 07:08:02 -0700
From: Jeff Layton <jlayton@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jim Lieb <jlieb@panasas.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
Message-ID: <20140327070802.124fb34c@ipyr.poochiereds.net>
In-Reply-To: <20140326202535.7d9b6f78@ipyr.poochiereds.net>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
	<20140326194847.0e994d0b@ipyr.poochiereds.net>
	<CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com>
	<20140326202535.7d9b6f78@ipyr.poochiereds.net>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 20:25:35 -0700
Jeff Layton <jlayton@redhat.com> wrote:

> On Wed, 26 Mar 2014 20:05:16 -0700
> Andy Lutomirski <luto@amacapital.net> wrote:
> 
> > On Wed, Mar 26, 2014 at 7:48 PM, Jeff Layton <jlayton@redhat.com>
> > wrote:
> > > On Wed, 26 Mar 2014 17:23:24 -0700
> > > Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > >> Hi various people who care about user-space NFS servers and/or
> > >> security-relevant APIs.
> > >>
> > >> I propose the following set of new syscalls:
> > >>
> > >> int credfd_create(unsigned int flags): returns a new credfd that
> > >> corresponds to current's creds.
> > >>
> > >> int credfd_activate(int fd, unsigned int flags): Change current's
> > >> creds to match the creds stored in fd.  To be clear, this changes
> > >> both the "subjective" and "objective" (aka real_cred and cred)
> > >> because there aren't any real semantics for what happens when
> > >> userspace code runs with real_cred != cred.
> > >>
> > >> Rules:
> > >>
> > >>  - credfd_activate fails (-EINVAL) if fd is not a credfd.
> > >>  - credfd_activate fails (-EPERM) if the fd's userns doesn't
> > >> match current's userns.  credfd_activate is not intended to be a
> > >> substitute for setns.
> > >>  - credfd_activate will fail (-EPERM) if LSM does not allow the
> > >> switch.  This probably needs to be a new selinux action --
> > >> dyntransition is too restrictive.
> > >>
> > >>
> > >> Optional:
> > >>  - credfd_create always sets cloexec, because the alternative is
> > >> silly.
> > >>  - credfd_activate fails (-EINVAL) if dumpable.  This is because
> > >> we don't want a privileged daemon to be ptraced while
> > >> impersonating someone else.
> > >>  - optional: both credfd_create and credfd_activate fail if
> > >> !ns_capable(CAP_SYS_ADMIN) or perhaps !capable(CAP_SETUID).
> > >>
> > >> The first question: does this solve Ganesha's problem?
> > >>
> > >> The second question: is this safe?  I can see two major concerns.
> > >> The bigger concern is that having these syscalls available will
> > >> allow users to exploit things that were previously secure.  For
> > >> example, maybe some configuration assumes that a task running as
> > >> uid==1 can't switch to uid==2, even with uid 2's consent.
> > >> Similar issues happen with capabilities.  If CAP_SYS_ADMIN is not
> > >> required, then this is no longer really true.
> > >>
> > >> Alternatively, something running as uid == 0 with heavy
> > >> capability restrictions in a mount namespace (but not a uid
> > >> namespace) could pass a credfd out of the namespace.  This could
> > >> break things like Docker pretty badly.  CAP_SYS_ADMIN guards
> > >> against this to some extent.  But I think that Docker is already
> > >> totally screwed if a Docker root task can receive an O_DIRECTORY
> > >> or O_PATH fd out of the container, so it's not entirely clear
> > >> that the situation is any worse, even without requiring
> > >> CAP_SYS_ADMIN.
> > >>
> > >> The second concern is that it may be difficult to use this
> > >> correctly. There's a reason that real_cred and cred exist, but
> > >> it's not really well set up for being used.
> > >>
> > >> As a simple way to stay safe, Ganesha could only use credfds that
> > >> have real_uid == 0.
> > >>
> > >> --Andy
> > >
> > >
> > > I still don't quite grok why having this special credfd_create
> > > call buys you anything over simply doing what Al had originally
> > > suggested -- switch creds using all of the different syscalls and
> > > then simply caching that in a "normal" fd:
> > >
> > >     fd = open("/dev/null", O_PATH...);
> > >
> > > ...it seems to me that the credfd_activate call will still need to
> > > do the same permission checking that all of the individual
> > > set*id() calls require (and all of the other stuff like changing
> > > selinux contexts, etc).
> > >
> > > IOW, this fd is just a "handle" for passing around a struct cred,
> > > but I don't see why having access to that handle would allow you
> > > to do something you couldn't already do anyway.
> > >
> > > Am I missing something obvious here?
> > 
> > Not really.  I think I didn't adequately explain a piece of this.
> > 
> > I think that what you're suggesting is for an fd to encode a set of
> > credentials but not to grant permission to use those credentials.
> > So switch_creds(fd) is more or less the same thing as
> > switch_creds(ruid, euid, suid, rgid, egid, sgid, groups, mac
> > label, ...).  switch_creds needs to verify that the caller can
> > dyntransition to the label, set all the ids, etc., but it avoids
> > allocating anything and running RCU callbacks.
> > 
> > The trouble with this is that the verification needed is complicated
> > and expensive.  And I think that my proposal is potentially more
> > useful.
> > 
> 
> Is it really though? My understanding of the problem was that it was
> the syscall (context switching) overhead + having to do a bunch of RCU
> critical stuff that was the problem. If we can do all of this in the
> context of a single RCU critical section, isn't that still a win?
> 
> As to the complicated part...maybe but it doesn't seem like it would
> have to be. We could simply return -EINVAL or something if the old
> struct cred doesn't have fields that match the ones we're replacing
> and that we don't expect to see changed.
> 
> > A credfd is like a struct cred, but possession of a credfd carries
> > the permission to use those credentials.  So, for example,
> > credfd_activate to switch to a given uid might work even if
> > setresuid to that uid would be disallowed.  But, for this to be
> > secure, the act of giving someone a credfd needs to be explicit.
> > Programs implicitly send other programs their credentials by means
> > of f_cred all the time, and they don't expect to allow the receiver
> > to impersonate them.
> > 
> 
> Eek!
> 
> Passing around permission to use the credential in conjunction with
> the credentials themselves sounds a lot more dangerous to me.
> 
> My preference would be that we don't add anything that potentially
> gives you privileges to do something you couldn't do already with
> existing syscalls. That doesn't seem to be necessary for the intended
> use case anyway. When it comes to security, I think we need to err on
> the side of caution than try to shortcut it for performance.
> 
> > credfd has other uses.  A file server, for example, could actually
> > delegate creation of the credfds to a separate process, and that
> > process could validate that the request is for a credfd that the
> > file server really should be able to obtain.  This would enable that
> > process to make sure that the user in question has actually
> > authenticated itself, so a file server compromise could only attack
> > users who connect instead of attacking any user on the system.  This
> > is an argument against requiring CAP_SYS_ADMIN to use
> > credfd_activate.
> > 
> > I'm less confident in whether capabilities should be needed to use
> > credfd_create.
> > 
> > Is that clearer and/or more convincing?
> > 
> 
> My worry would be that you could then compromise the process doing
> this credfd creation and trick it into passing around credentials that
> aren't what are expected.
> 
> Another possibility could some kernel bug allow you to frob the creds
> that are attached to an existing fd after they've been "vetted" for
> use.
> 
> So yeah, I think I better understand what you're proposing (and thanks
> for explaining it), but I'm not convinced that it's really a safe
> idea.
> 

I had some time to think about this last night...

While using a fd to pass around credentials is convenient, the danger
is that it's pretty opaque. You have a fd that you know has creds
attached to it, but it's hard to be certain what is going to change.

Perhaps we can use the flags field for that. So, assuming we have a fd
with the creds attached, we could do something like:

    err = switch_creds(fd, SC_FSUID|SC_FSGID|SC_GROUPS);

...then the switch_creds syscall could be set up to fail if the new
credentials had other fields that didn't match those in the current
task credentials. So if (for instance) the cred->euid were
different between the two, the above could fail with -EINVAL or
something.

Yes, that means that we need to check this stuff on every switch_creds
call, but I don't think it'll be that expensive.

-- 
Jeff Layton <jlayton@redhat.com>
