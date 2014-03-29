Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaC2WbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 18:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaC2WbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 18:31:21 -0400
Date: Sat, 29 Mar 2014 18:31:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com
Subject: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140329223109.GA24098@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if I've reported this already (it looks familiar, though I've not managed
to find it in my sent mail folder).  This is rc8 + a diff to fix the stack usage reports
I was seeing (diff at http://paste.fedoraproject.org/89854/13210913/raw)

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.14.0-rc8+ #153 Not tainted
 -------------------------------------------------------
 git/32710 is trying to acquire lock:
  (&(&ip->i_lock)->mr_lock){++++.+}, at: [<ffffffffc03bd782>] xfs_ilock+0x122/0x250 [xfs]
 
but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffffae7b816a>] __do_page_fault+0x14a/0x610

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
        [<ffffffffae0d1951>] lock_acquire+0x91/0x1c0
        [<ffffffffae1a66dc>] might_fault+0x8c/0xb0
        [<ffffffffae2016e1>] filldir+0x91/0x120
        [<ffffffffc0359622>] xfs_dir2_leaf_getdents+0x332/0x450 [xfs]
        [<ffffffffc035993e>] xfs_readdir+0x1fe/0x260 [xfs]
        [<ffffffffc035c2ab>] xfs_file_readdir+0x2b/0x40 [xfs]
        [<ffffffffae201528>] iterate_dir+0xa8/0xe0
        [<ffffffffae2019ea>] SyS_getdents+0x9a/0x130
        [<ffffffffae7bda64>] tracesys+0xdd/0xe2
 
-> #0 (&(&ip->i_lock)->mr_lock){++++.+}:
        [<ffffffffae0d0dee>] __lock_acquire+0x181e/0x1bd0
        [<ffffffffae0d1951>] lock_acquire+0x91/0x1c0
        [<ffffffffae0ca852>] down_read_nested+0x52/0xa0
        [<ffffffffc03bd782>] xfs_ilock+0x122/0x250 [xfs]
        [<ffffffffc03bd8cf>] xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
        [<ffffffffc034dca7>] __xfs_get_blocks+0xc7/0x840 [xfs]
        [<ffffffffc034e431>] xfs_get_blocks+0x11/0x20 [xfs]
        [<ffffffffae2347a8>] do_mpage_readpage+0x4a8/0x6f0
        [<ffffffffae234adb>] mpage_readpages+0xeb/0x160
        [<ffffffffc034b62d>] xfs_vm_readpages+0x1d/0x20 [xfs]
        [<ffffffffae188a6a>] __do_page_cache_readahead+0x2ea/0x390
        [<ffffffffae1891e1>] ra_submit+0x21/0x30
        [<ffffffffae17c085>] filemap_fault+0x395/0x420
        [<ffffffffae1a684f>] __do_fault+0x7f/0x570
        [<ffffffffae1aa6e7>] handle_mm_fault+0x217/0xc40
        [<ffffffffae7b81ce>] __do_page_fault+0x1ae/0x610
        [<ffffffffae7b864e>] do_page_fault+0x1e/0x70
        [<ffffffffae7b4fd2>] page_fault+0x22/0x30
 
other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mm->mmap_sem);
                                lock(&(&ip->i_lock)->mr_lock);
                                lock(&mm->mmap_sem);
   lock(&(&ip->i_lock)->mr_lock);
 
 *** DEADLOCK ***

1 lock held by git/32710:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffffae7b816a>] __do_page_fault+0x14a/0x610

stack backtrace:
CPU: 1 PID: 32710 Comm: git Not tainted 3.14.0-rc8+ #153
 ffffffffaf69e650 000000005bc802c5 ffff88006bc9f768 ffffffffae7a8da2
 ffffffffaf69e650 ffff88006bc9f7a8 ffffffffae7a4e66 ffff88006bc9f800
 ffff880069c3dc30 0000000000000000 ffff880069c3dbf8 ffff880069c3dc30
Call Trace:
 [<ffffffffae7a8da2>] dump_stack+0x4e/0x7a
 [<ffffffffae7a4e66>] print_circular_bug+0x201/0x20f
 [<ffffffffae0d0dee>] __lock_acquire+0x181e/0x1bd0
 [<ffffffffae0d1951>] lock_acquire+0x91/0x1c0
 [<ffffffffc03bd782>] ? xfs_ilock+0x122/0x250 [xfs]
 [<ffffffffc03bd8cf>] ? xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
 [<ffffffffae0ca852>] down_read_nested+0x52/0xa0
 [<ffffffffc03bd782>] ? xfs_ilock+0x122/0x250 [xfs]
 [<ffffffffc03bd782>] xfs_ilock+0x122/0x250 [xfs]
 [<ffffffffc03bd8cf>] xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
 [<ffffffffc034dca7>] __xfs_get_blocks+0xc7/0x840 [xfs]
 [<ffffffffae18481c>] ? __alloc_pages_nodemask+0x1ac/0xbb0
 [<ffffffffc034e431>] xfs_get_blocks+0x11/0x20 [xfs]
 [<ffffffffae2347a8>] do_mpage_readpage+0x4a8/0x6f0
 [<ffffffffc034e420>] ? __xfs_get_blocks+0x840/0x840 [xfs]
 [<ffffffffae0ae61d>] ? get_parent_ip+0xd/0x50
 [<ffffffffae7b8e0b>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffffae18acc5>] ? __lru_cache_add+0x65/0xc0
 [<ffffffffae234adb>] mpage_readpages+0xeb/0x160
 [<ffffffffc034e420>] ? __xfs_get_blocks+0x840/0x840 [xfs]
 [<ffffffffc034e420>] ? __xfs_get_blocks+0x840/0x840 [xfs]
 [<ffffffffae1cb256>] ? alloc_pages_current+0x106/0x1f0
 [<ffffffffc034b62d>] xfs_vm_readpages+0x1d/0x20 [xfs]
 [<ffffffffae188a6a>] __do_page_cache_readahead+0x2ea/0x390
 [<ffffffffae1888a0>] ? __do_page_cache_readahead+0x120/0x390
 [<ffffffffae1891e1>] ra_submit+0x21/0x30
 [<ffffffffae17c085>] filemap_fault+0x395/0x420
 [<ffffffffae1a684f>] __do_fault+0x7f/0x570
 [<ffffffffae1aa6e7>] handle_mm_fault+0x217/0xc40
 [<ffffffffae0cbd27>] ? __lock_is_held+0x57/0x80
 [<ffffffffae7b81ce>] __do_page_fault+0x1ae/0x610
 [<ffffffffae0cbdae>] ? put_lock_stats.isra.28+0xe/0x30
 [<ffffffffae0cc706>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffffae0ae61d>] ? get_parent_ip+0xd/0x50
 [<ffffffffae17880f>] ? context_tracking_user_exit+0x5f/0x190
 [<ffffffffae7b864e>] do_page_fault+0x1e/0x70
 [<ffffffffae7b4fd2>] page_fault+0x22/0x30

