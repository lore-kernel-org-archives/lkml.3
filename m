Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaHIJeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:34:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaHIJeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:34:22 -0400
Date: Sat, 9 Aug 2014 10:34:12 +0100
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
Message-ID: <20140809093412.GA23108@ZenIV.linux.org.uk>
References: <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140420054108.GQ18016@ZenIV.linux.org.uk>
 <20140511164530.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511164530.GB18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 05:45:30PM +0100, Al Viro wrote:
> Sigh...  It's really messy.
> 	All versions since lazy fput introduction have acct_auto_close()
> doing the wrong thing on r/o remount of superblock; we want the damn file
> closed *before* we go further than acct_auto_close().  Worse, we are
> holding ->s_umount there, so any kind of waiting would have to be very
> careful to avoid deadlocks.  What's more, prevention of open for write
> hits acct_auto_close(), so even if we wait there, we still have a window
> when new acct file could be opened and not auto-closed.
> 	All versions have problems with acct_process() in the middle of
> umount(); originally it was a blatant call of ->write() happening without
> any regard for file getting closed, then it was file getting written to
> and closed in the middle of fs shutdown, then - write/close capable of
> pushing fs shutdown past the return from umount(2).
> 	All versions have problems with acct(NULL) vs. umount - the latter
> does not wait for the former.  Eric's patches plug that one, but there's
> a serious deadlock potential.

OK, I think I've sorted that one out.  Eric, could you take a look at
vfs.git#for-eric?  That's for-next + fix that ought to go into -stable +
delayed-mntput() thing.  The real PITA had been kernel/acct.c mess;
that's dealt with in -next.

I think it solves the problem with "mntput in deep call chain" cases
added in your series.  Final mntput() does fs shutdown, etc. on a shallow
stack, via task_work_add() if at all possible.  MNT_INTERNAL vfsmounts
are dealt with synchronously, which solves the problem of failure exits
halfway through module_init needing to tear down an internal vfsmount, etc.
But those call sites are all on fairly shallow stack anyway.  And such
vfsmounts are not mounted on anything, so it's not something your changes
could possibly step into.  No extra context switches per syscall, at that...

I hadn't added mntput_sync() - no visible use cases.  If one shows up,
it wouldn't be hard to add such primitive.  And unlike fput() we do not
try to support mntput() from interrupt, etc. - too much PITA with no
obvious use cases.  We'd need to decide whether we want to disable IRQs
on lock_mount_hash(), etc.  It's doable, but let's leave that until we
get a serious reason to mess with all that.
