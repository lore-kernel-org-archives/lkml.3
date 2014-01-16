Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaAPKjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:39:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbaAPKji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:39:38 -0500
Date: Thu, 16 Jan 2014 11:39:34 +0100
From: Jan Kara <jack@suse.cz>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: next-20140114 - BUG: spinlock wrong CPU on CPU#3, mount/597
Message-ID: <20140116103934.GA30291@quack.suse.cz>
References: <14473.1389810012@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14473.1389810012@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-01-14 13:20:12, Valdis Kletnieks wrote:
> Am seeing this at boot on next-20140114, but I hit this same exact stack trace
> at least once on next-20131218.  v3.13-rc7 doesn't have the problem, so it's
> not a 3.13 release showstopper.  I may not be able to bisect this, as there's 2
> or 3 other now-fixed bugs that cause lots of 'bisect skips' because the system
> won't boot far enough to hit this issue.
> 
> I'm not sure who to blame - Jan beat up on fs/notify/notification.c pretty
> heavily a few days ago, but I hit this at least once last month and that file
> hasn't been touched since 2012, so the root cause is probably elsewhere.
  Hum, the complaint is for group->notification_waitq->lock which
is an internal lock for the wait queue. Actually the corruption seems to be
only a single bit flip - the whole spinlock structure looks correct, only
owner_cpu got flipped from 0x3 to 0x23. Ah, do you have patch from Hugh:

fanotify: fix corruption preventing startup

The corruption would match that very well and Andrew queued it just
recently...

								Honza


> I'm reasonably sure that rebuilding with CONFIG_DEBUG_SPINLOCK=n will "fix"
> my issue, but that's just papering it over...
> 
> [   93.724597] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
> [   93.759851] BUG: spinlock wrong CPU on CPU#3, mount/597
> [   93.759854]  lock: 0xffff8800b87f04a8, .magic: dead4ead, .owner: mount/597, .owner_cpu: 35
> [   93.759857] CPU: 3 PID: 597 Comm: mount Not tainted 3.13.0-rc8-next-20140114 #151
> [   93.759858] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
> [   93.759863]  0000000000000000 ffff8800b87e7cd8 ffffffff8164e7e7 ffff8800b8194590
> [   93.759867]  ffff8800b87e7cf8 ffffffff8107c42c ffff8800b87f04a8 0000000000000001
> [   93.759871]  ffff8800b87e7d18 ffffffff8107c457 ffff8800b87f04a8 ffffffff81aa8b43
> [   93.759872] Call Trace:
> [   93.759879]  [<ffffffff8164e7e7>] dump_stack+0x4f/0xa2
> [   93.759883]  [<ffffffff8107c42c>] spin_dump+0x8c/0x91
> [   93.759886]  [<ffffffff8107c457>] spin_bug+0x26/0x28
> [   93.759889]  [<ffffffff8107c75e>] do_raw_spin_unlock+0xdc/0xf3
> [   93.759892]  [<ffffffff816586b0>] _raw_spin_unlock_irqrestore+0x27/0x83
> [   93.759895]  [<ffffffff81073b76>] __wake_up+0x3f/0x46
> [   93.759899]  [<ffffffff811630c6>] fsnotify_add_notify_event+0xba/0xdf
> [   93.759902]  [<ffffffff81166058>] ? SyS_inotify_rm_watch+0xf3/0xf3
> [   93.759905]  [<ffffffff81166265>] fanotify_handle_event+0x16f/0x256
> [   93.759910]  [<ffffffff8112069b>] ? ac_get_obj.constprop.61+0x39/0x1be
> [   93.759913]  [<ffffffff8116293b>] send_to_group.isra.1+0x114/0x123
> [   93.759915]  [<ffffffff81162c49>] fsnotify+0x2dd/0x41d
> [   93.759918]  [<ffffffff8165864a>] ? _raw_spin_unlock+0x5b/0x67
> [   93.759922]  [<ffffffff8112a73d>] do_sys_open+0x109/0x12e
> [   93.759925]  [<ffffffff8112a77b>] SyS_open+0x19/0x1b
> [   93.759928]  [<ffffffff8165f7a2>] system_call_fastpath+0x16/0x1b
> [   93.994336] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
> 
> Any brilliant ideas?


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
