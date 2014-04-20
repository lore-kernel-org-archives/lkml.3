Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaDTFlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 01:41:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41762 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaDTFlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 01:41:16 -0400
Date: Sun, 20 Apr 2014 06:41:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
Message-ID: <20140420054108.GQ18016@ZenIV.linux.org.uk>
References: <20140413053956.GM18016@ZenIV.linux.org.uk>
 <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417221203.GC18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:12:03PM +0100, Al Viro wrote:

> I'd probably turn mntput_no_expire() into something like
> static struct mount *__mntput(struct mount *m)
> that would return NULL if nothing needs to be killed and returned m
> if m really needs killing.  Leaving the caller to decide what to do
> with that puppy.  We have, as it is, exactly two callers - exit path
> in sys_umount() and mntput().  So we add two more functions:
> static void kill_mnt_async(struct mount *m)
> and
> static void kill_mnt_sync(struct mount *m)
> both being no-op on NULL.  Then in sys_umount() and mntput() we do
> 	kill_mnt_async(__mntput(mnt));
> and in mntput_sync() - kill_mnt_sync(__mntput(mnt));
> For that matter, kill_mnt_sync() (basically, your variant with completions)
> can be folded into mntput_sync().

Actually, all kern_unmount() callers are doing that from fairly shallow
stack depth and all simple_release_fs() ones are dealing with rather
trivial ->kill_sb().  So mntput_sync() is an overkill; all we need is
	if (mnt->mnt_flags & MNT_INTERNAL) {
		cleanup_mnt(mnt);
		return;
	}
	<do task_work_add or schedule_delayed_work song and dance>
right in the end of mntput_no_expire().  OK, now I have something that
looks like a complete solution.  The last missing bit is to take all
filp_close() of acct->file to kernel thread, and have them done via
__fput_sync() there.  Then auto-close (done from cleanup_mnt()) will
consist of shutting down all affected acct and waiting for that kernel
thread to run through everything currently in its queue.  That'll take
care of waiting until acct(NULL) done by somebody else gets through closing
the file and through corresponding mntput().  And *those* mntput() also
can be synchronous - they are clones of the one we hadn't finished shutting
down yet, so both dput() and deactivate_super() will bugger off immediately.
So we just mark those instead-of-mnt_pin() clones as MNT_INTERNAL.  Voila.
After that ->mnt_pinned crap dies, acct auto-close ought to be race-free
and we get the actual fs shutdown guaranteed to be on shallow stack, without
extra context switches, etc. in the normal case.

	Let's see if that survives testing...
