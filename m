Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3H1GQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:16:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53638 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3H1GQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:16:30 -0400
Date: Wed, 28 Aug 2013 07:16:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
Message-ID: <20130828061623.GJ27005@ZenIV.linux.org.uk>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
 <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
 <CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
 <CALCETrVerk6evSngbf1fiD=k6E557KgKNCBF4qYQSCXYrOx0ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVerk6evSngbf1fiD=k6E557KgKNCBF4qYQSCXYrOx0ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 01:28:27PM -0700, Andy Lutomirski wrote:

> It would if it works.  It certainly would for truncate, setxattr, etc.
> 
> There are funny cases, though.  For example, execing an O_WRONLY fd
> should probably fail, as should opening an O_WRONLY fd as O_RDWR.
> O_APPEND is also funny.  flink will (I suspect) always want to be a
> bit special.
> 
> There are also O_PATH fds, and I'm not sure what the semantics of
> O_PATH fds are or should be when they refer to something other than a
> directory.

O_PATH file just points to specific location in the tree, no more and
no less.
 
> The benefit of my approach is that it's really obvious that
> truncate("/proc/self/fd/N") and ftruncate(N) do exactly the same
> thing.  The downside is that the namei code is a bit gross and there
> was more rearranging of ftruncate than I would have liked.  (I also
> lost the benefit of fget_light, but I could fix that by passing a
> struct fd around instead of a struct file *.)

With that thing namei code becomes _really_ gross and we'll have to live
with it afterwards.  No.  Moreover, grabbing references to struct file
is the wrong thing to do - we need far less information than that.

Let's look at that zoo first.

a) linkat() target.  flink(2) doesn't exist, so we can choose whatever we
bloody please for that case.  And frankly, I would gladly go for O_TMPFILE
sans O_EXCL or sufficient caps.  See upthread for proposed solution.

b) chdir().  Checks are identical in chdir() and fchdir(), don't bloody care
how the file had been opened and don't need to care - anything we could've
accessed after such chdir() we could've accessed by slapping a relative
path to the end of the path we'd used to reach that thing.

c) chroot().  fchroot() doesn't exist and realistically anyone who can do
chroot(2) is well past caring about anything.  We really don't care how the
damn thing had been opened.

d) fchownat().  Neither it nor fchown() give a flying fuch about the way
file had been opened.

e) fchmodat().  Same story.

f) faccessat().  IMO we don't care how the damn thing had been opened.

g) name_to_handle_at().  Not sure if we need any capability checks, but
we definitely don't give a damn about the way file had been opened.

h) one case in quotactl().  With CAP_SYS_ADMIN required.  If attacker got
that, it's too fucking late anyway.

i) fstatat() and friends, statfs(), utimes() et.al, {set,get,list,remove}xattr()
- no difference in checks between pathname- and descriptor-based calls
anyway.  Please, note that for fsetxattr() we do *NOT* require the file
to be opened for write; adding such requirement would be a user-visible
API change, and one fairly likely to break stuff, at that.

j) umount() and pivot_root().  We really don't care how the file had been
opened, and attacker capable of playing with that can do a lot more.

k) inotify_add_watch()/fanotify_mark().  No descriptor-based versions,
no permission checks other than "may read whatever we ended up with".
I really doubt that we care about the way fd had been opened in case
of /proc/<pid>/fd/<fd>.

l) truncate() mess.

m) open() mess.

AFAICS, the *only* cases when we might possibly care are linkat() target,
truncate() and open().  Note, BTW, that right now we *do* allow an attempt
to reopen a file via procfs symlink r/w, even when file had been r/o.
It's subject to permissions on the object being opened, but that's it.

I'm not sure we can change that - again, it's a user-visible API, and
the change is very likely to break some scripts.  In fact, it's about
as dangerous as a full-blown switch to dup-style semantics for procfs
opens, and it's a lot less attractive.

For truncate() we would only need to have FMODE_WRITE reported, more or
less the same way as FMODE_FLINK.  And without open() changes it doesn't
buy us anything at all...

I've no problem with unrolling the user_path_at() in do_sys_truncate()
into an explicit loop by trailing symlinks and checking for indication
left by proc_pid_follow_link(), more or less the same way as with
LOOKUP_LINK in lookup_last().  It's _far_ less invasive than playing
with "oh, here we fill a struct path or maybe a struct file" horrors,
pinning struct file for no reason, etc.

AFAICS, the real question is whether we dare to change open() behaviour on
/proc/*/fd/*.  I've played with that a bit and I believe that I can do
the switch to dup-style with very localized changes in fs/namei.c and
fs/proc/{base,fd}.c.  Will be even binary compatible kernel-side -
->atomic_open() returns NULL/ERR_PTR where it used to return 0/-error,
not that we had many instances to convert.  *IF* that variant is not
out of consideration for userland API stability reasons, I would certainly
prefer to go that way; turns out that these days we can pull it off without
black magic in descriptor handling, etc.  Linus?
