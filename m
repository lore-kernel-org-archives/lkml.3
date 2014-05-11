Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbaEKQpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 12:45:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 12:45:38 -0400
Date: Sun, 11 May 2014 17:45:30 +0100
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
Message-ID: <20140511164530.GB18016@ZenIV.linux.org.uk>
References: <87zjjp3e7w.fsf@x220.int.ebiederm.org>
 <87ppkl1xb7.fsf@x220.int.ebiederm.org>
 <20140413215242.GP18016@ZenIV.linux.org.uk>
 <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
 <87ppkhc4pp.fsf@x220.int.ebiederm.org>
 <87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
 <20140417202237.GA18016@ZenIV.linux.org.uk>
 <87tx9rwsz4.fsf@x220.int.ebiederm.org>
 <20140417221203.GC18016@ZenIV.linux.org.uk>
 <20140420054108.GQ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140420054108.GQ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 06:41:08AM +0100, Al Viro wrote:
> 	<do task_work_add or schedule_delayed_work song and dance>
> right in the end of mntput_no_expire().  OK, now I have something that
> looks like a complete solution.  The last missing bit is to take all
> filp_close() of acct->file to kernel thread, and have them done via
> __fput_sync() there.  Then auto-close (done from cleanup_mnt()) will
> consist of shutting down all affected acct and waiting for that kernel
> thread to run through everything currently in its queue.  That'll take
> care of waiting until acct(NULL) done by somebody else gets through closing
> the file and through corresponding mntput().  And *those* mntput() also
> can be synchronous - they are clones of the one we hadn't finished shutting
> down yet, so both dput() and deactivate_super() will bugger off immediately.
> So we just mark those instead-of-mnt_pin() clones as MNT_INTERNAL.  Voila.
> After that ->mnt_pinned crap dies, acct auto-close ought to be race-free
> and we get the actual fs shutdown guaranteed to be on shallow stack, without
> extra context switches, etc. in the normal case.

Sigh...  It's really messy.
	All versions since lazy fput introduction have acct_auto_close()
doing the wrong thing on r/o remount of superblock; we want the damn file
closed *before* we go further than acct_auto_close().  Worse, we are
holding ->s_umount there, so any kind of waiting would have to be very
careful to avoid deadlocks.  What's more, prevention of open for write
hits acct_auto_close(), so even if we wait there, we still have a window
when new acct file could be opened and not auto-closed.
	All versions have problems with acct_process() in the middle of
umount(); originally it was a blatant call of ->write() happening without
any regard for file getting closed, then it was file getting written to
and closed in the middle of fs shutdown, then - write/close capable of
pushing fs shutdown past the return from umount(2).
	All versions have problems with acct(NULL) vs. umount - the latter
does not wait for the former.  Eric's patches plug that one, but there's
a serious deadlock potential.

Who the hell had thought that auto-close was a good thing to have?  Neither
BSD (where the whole thing originated) nor original Linux implementation
did that - umount /var while accounting was turned on would simply say
that /var was busy and fail...  And no, simply ripping that idiocy out
won't fly - while Debian has /etc/init.d/acct stop turning the sucker off,
Fedora psacct doesn't do anything of that sort and relies on auto-close
instead, so getting rid of auto-close will lead to such boxen failing to
unmount /var on shutdown ;-/
