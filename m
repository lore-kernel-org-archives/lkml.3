Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3H0Amw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:42:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3H0Amv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:42:51 -0400
Date: Tue, 27 Aug 2013 01:42:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between the fget() and close()
Message-ID: <20130827004247.GG27005@ZenIV.linux.org.uk>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:56:43PM +0000, Liu, Chuansheng wrote:

> Yes, the fix is really insane, I realized it after sent it.
> But I think the race is there, right?

Yes, in userland code.  Depending on the timing, T3 might
	* issue ioctl() on old file if called before close() in T1
	* fail with EBADF if called between the close() by T1 and reopen by T2
	* fail with EBADF if open() in T2 happens before the file gets closed
by T1 and ioctl() happens after close() - in that case new descriptor will
be different from the old one
	* issue ioctl() on new file if reopen happens after close() and
ioctl() happens after open().
	* issue ioctl() on a completely unrelated file, if some other
thread calls open()/pipe()/whatnot between close() in T1 and open() in T2

IOW, userland code doing that kind of things is very, very broken - it
can't depend on which file (if any) ioctl() will be applied to.  The
kernel should *not* panic/oops/whatnot on that, of course.  And there
we have four cases:
	1) fget/fget_light picks old pointer to file and atomic increment of
->f_count succeeds.  In that case close() is irrelevant - we have pinned
struct file down and the final fput() won't happen until we are done.
open() is even more irrelevant in that case, of course, since we don't
even look at new struct file.
	2) fget/fget_light picks old pointer to file just as close() had
been replacing it with NULL and dropping the final reference to old struct
file; by the time we do atomic increment of f_count, it has already reached
0 and atomic_long_inc_not_zero fails.  Since we are under rcu_read_lock(),
struct file memory couldn't have been reused yet, so looking at f_count is
safe.  We act as if we'd been called just *after* close() removing the
pointer to file from the table (instead of just as it was clearing that
pointer) and fail with EBADF.
	3) fget/fget_light picks NULL; nothing to do, EBADF time for us.
	4) fget/fget_light picks pointer to *new* struct file.  In that
case close() (and all earlier history of that descriptor) is irrelevant -
it's the same as if ioctl() had been done right after open().

> The whole panic stack is below, and my kernel code is:
> int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>              unsigned long arg)
> {
>         int error = 0;
>         int __user *argp = (int __user *)arg;
>         struct inode *inode = filp->f_path.dentry->d_inode;
> === > Panic here, due to filp->f_path.dentry == NULL, then accessing 0x20 failed.
> 
> Could you share some scenario for this case? Thanks.

*shrug*

Might be buggered refcounting on struct file somewhere (i.e. extra fput() done,
getting the file freed *before* close(), leaving a dangling pointer in
descriptor table).  Might be memory corruption of some kind, slapping junk
pointer into descriptor table.  Might be buggered refcounting on struct
dentry - if extra dput() is done somewhere, dentry might get freed under
us or become negative.

Hell, might be buggered refcounting on descriptor table - binder is playing
interesting games there.  Try to reproduce that with CONFIG_DEBUG_KMEMLEAK
and slab debugging turned on, see if you hit anything from those; if it's
more or less readily reproducible, I would start with that - too many
scenarios involve broken refcounting of one sort or another.
