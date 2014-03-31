Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaCaLwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaCaLv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:51:56 -0400
Date: Mon, 31 Mar 2014 07:51:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andy Lutomirski <luto@amacapital.net>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Subject: Re: Thoughts on credential switching
Message-ID: <20140331075145.4bd76872@tlielax.poochiereds.net>
In-Reply-To: <20140330130328.GB7172@thunk.org>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
	<20140326194847.0e994d0b@ipyr.poochiereds.net>
	<CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com>
	<20140326202535.7d9b6f78@ipyr.poochiereds.net>
	<20140327070802.124fb34c@ipyr.poochiereds.net>
	<20140330130328.GB7172@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2014 09:03:29 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Thu, Mar 27, 2014 at 07:08:02AM -0700, Jeff Layton wrote:
> > I had some time to think about this last night...
> > 
> > While using a fd to pass around credentials is convenient, the danger
> > is that it's pretty opaque. You have a fd that you know has creds
> > attached to it, but it's hard to be certain what is going to change.
> 
> I don't think that's a particularly tough problem.  In general, the fd
> isn't something that you would want to pass around, and so the process
> which generated it will know exactly what it contained.
> 

I think there's a bit more of a use-case for passing around such an fd
via socket...

Part of the problem is that the traditional uid/gid switching glibc
wrappers are per-process. If we're proposing doing something like:

seteuid()
setegid()
setgroups()
fd = open()
(...and then revert the creds using same syscalls)

...during the time that you're doing all of that, you can't really
allow any thread in the process to be doing something that requires
_other_ creds until you've completed the above.

So, I could envision a program like ganesha firing up a separate
process to handle the credential switching and fd creation and then
handing those back to the main process via a unix domain socket.

> > Perhaps we can use the flags field for that. So, assuming we have a fd
> > with the creds attached, we could do something like:
> > 
> >     err = switch_creds(fd, SC_FSUID|SC_FSGID|SC_GROUPS);
> > 
> > ...then the switch_creds syscall could be set up to fail if the new
> > credentials had other fields that didn't match those in the current
> > task credentials. So if (for instance) the cred->euid were
> > different between the two, the above could fail with -EINVAL or
> > something.
> 
> Huh?  The whole *point* is that the creds value will be different, of
> course they won't match!  I would think this would be over
> complicating the interface.
> 

You know that *some* of the credentials won't match, but presumably
some of them (e.g. the real uid/gid) should match. Using a flags field
could act as a mask of what creds are allowed to change.

> 
> A couple of other things.  What I would suggest is that we create a
> few new fd flags, to join FD_CLOEXEC:
> 
> FD_NOPROCFS	disallow being able to open the inode via /proc/<pid>/fd
> 		(but in the case of a creds fd, for bonus points, the
> 		target of the pseudo-symlink could be something like:
> 		"uid: 15806 gid: 100: grps: 27, 50" to aid in debugging
> 		a userspace file server).  This also answers Jeff's concern
> 		if for some reason --- I don't know how --- a process
> 		doesn't know what the contents of the creds fd that
> 		it created itself.
> 
> FD_NOPASSFD	disallow being able to pass the fd via a unix domain socket
> 
> FD_LOCKFLAGS	if this bit is set, disallow any further changes of FD_CLOEXEC,
> 		FD_NOPROCFS, FD_NOPASSFD, and FD_LOCKFLAGS flags.
> 
> Some of the functionality requested by the folks suggesting the "SEAL"
> API would also be covered by these fd flags.
> 
> In order to solve some potential race concerns, a credsfd must be
> created with FD_CLOEXEC and FD_NOPROCFS enabled.
> 
> Why is this important even if the anon_inode is owned by root with a
> mode of 0?  Because if the system is set up to use SELinux or full
> Posix capabilities, merely having the a uid of 0 is not special, and
> we don't want to allow a process with uid of 0 to be able modify the
> mode with the /proc/<pid>/fd/<FD> and then proceed to open the inode
> using open.  This way, instead of adding special case code to prevent
> this from happening, we can add a more general facility which can be
> used to solve a few other problems.
> 



-- 
Jeff Layton <jlayton@redhat.com>
