Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaHHE1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaHHE1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:27:09 -0400
Date: Fri, 8 Aug 2014 00:26:59 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: btrfs BUG() in __set_extent_bit on GFP_ATOMIC failure.
Message-ID: <20140808042659.GA28040@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing with fault injection, I hit this quite easily.

kernel BUG at fs/btrfs/extent_io.c:990!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 1 PID: 1270 Comm: fsx Not tainted 3.16.0+ #41
task: ffff88023fe46d60 ti: ffff8802405a8000 task.ti: ffff8802405a8000
RIP: 0010:[<ffffffffc0319af4>]  [<ffffffffc0319af4>] __set_extent_bit+0x574/0x660 [btrfs]
...
 [<ffffffff851be7fc>] ? set_track+0x9c/0x140
 [<ffffffffc031aa94>] lock_extent_bits+0x94/0x310 [btrfs]
 [<ffffffff85166454>] ? pagecache_get_page+0xb4/0x210
 [<ffffffffc030d4de>] lock_and_cleanup_extent_if_need+0xee/0x1f0 [btrfs]
 [<ffffffffc030e6e1>] __btrfs_buffered_write+0x1b1/0x680 [btrfs]
 [<ffffffff850a258b>] ? preempt_count_sub+0xab/0x100
 [<ffffffffc030ed2e>] btrfs_file_write_iter+0x17e/0x570 [btrfs]
 [<ffffffff851d78ce>] new_sync_write+0x8e/0xd0
 [<ffffffff851d8127>] vfs_write+0xb7/0x1f0
 [<ffffffff851d8d68>] SyS_write+0x58/0xd0
 [<ffffffff8576371f>] tracesys+0xdd/0xe2


 989                 prealloc = alloc_extent_state_atomic(prealloc);
 990                 BUG_ON(!prealloc);

 541 static struct extent_state *
 542 alloc_extent_state_atomic(struct extent_state *prealloc)
 543 {
 544         if (!prealloc)
 545                 prealloc = alloc_extent_state(GFP_ATOMIC);
 546 
 547         return prealloc;
 548 }


Going BUG() on a GFP_ATOMIC allocation failure seems a bit excessive.
Surely there's something better we can do here ?

	Dave

