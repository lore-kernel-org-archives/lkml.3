Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231AbaGOXYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:24:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934172AbaGOXO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Theodore Tso <tytso@mit.edu>,
        Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3.15 54/84] ext4: fix a potential deadlock in __ext4_es_shrink()
Date: Tue, 15 Jul 2014 16:17:51 -0700
Message-Id: <20140715231714.823006965@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3f1f9b851311a76226140b55b1ea22111234a7c2 upstream.

This fixes the following lockdep complaint:

[ INFO: possible circular locking dependency detected ]
3.16.0-rc2-mm1+ #7 Tainted: G           O
-------------------------------------------------------
kworker/u24:0/4356 is trying to acquire lock:
 (&(&sbi->s_es_lru_lock)->rlock){+.+.-.}, at: [<ffffffff81285fff>] __ext4_es_shrink+0x4f/0x2e0

but task is already holding lock:
 (&ei->i_es_lock){++++-.}, at: [<ffffffff81286961>] ext4_es_insert_extent+0x71/0x180

which lock already depends on the new lock.

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ei->i_es_lock);
                               lock(&(&sbi->s_es_lru_lock)->rlock);
                               lock(&ei->i_es_lock);
  lock(&(&sbi->s_es_lru_lock)->rlock);

 *** DEADLOCK ***

6 locks held by kworker/u24:0/4356:
 #0:  ("writeback"){.+.+.+}, at: [<ffffffff81071d00>] process_one_work+0x180/0x560
 #1:  ((&(&wb->dwork)->work)){+.+.+.}, at: [<ffffffff81071d00>] process_one_work+0x180/0x560
 #2:  (&type->s_umount_key#22){++++++}, at: [<ffffffff811a9c74>] grab_super_passive+0x44/0x90
 #3:  (jbd2_handle){+.+...}, at: [<ffffffff812979f9>] start_this_handle+0x189/0x5f0
 #4:  (&ei->i_data_sem){++++..}, at: [<ffffffff81247062>] ext4_map_blocks+0x132/0x550
 #5:  (&ei->i_es_lock){++++-.}, at: [<ffffffff81286961>] ext4_es_insert_extent+0x71/0x180

stack backtrace:
CPU: 0 PID: 4356 Comm: kworker/u24:0 Tainted: G           O   3.16.0-rc2-mm1+ #7
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: writeback bdi_writeback_workfn (flush-253:0)
 ffffffff8213dce0 ffff880014b07538 ffffffff815df0bb 0000000000000007
 ffffffff8213e040 ffff880014b07588 ffffffff815db3dd ffff880014b07568
 ffff880014b07610 ffff88003b868930 ffff88003b868908 ffff88003b868930
Call Trace:
 [<ffffffff815df0bb>] dump_stack+0x4e/0x68
 [<ffffffff815db3dd>] print_circular_bug+0x1fb/0x20c
 [<ffffffff810a7a3e>] __lock_acquire+0x163e/0x1d00
 [<ffffffff815e89dc>] ? retint_restore_args+0xe/0xe
 [<ffffffff815ddc7b>] ? __slab_alloc+0x4a8/0x4ce
 [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
 [<ffffffff810a8707>] lock_acquire+0x87/0x120
 [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
 [<ffffffff8128592d>] ? ext4_es_free_extent+0x5d/0x70
 [<ffffffff815e6f09>] _raw_spin_lock+0x39/0x50
 [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
 [<ffffffff8119760b>] ? kmem_cache_alloc+0x18b/0x1a0
 [<ffffffff81285fff>] __ext4_es_shrink+0x4f/0x2e0
 [<ffffffff812869b8>] ext4_es_insert_extent+0xc8/0x180
 [<ffffffff812470f4>] ext4_map_blocks+0x1c4/0x550
 [<ffffffff8124c4c4>] ext4_writepages+0x6d4/0xd00
	...

Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents_status.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -960,10 +960,10 @@ retry:
 			continue;
 		}
 
-		if (ei->i_es_lru_nr == 0 || ei == locked_ei)
+		if (ei->i_es_lru_nr == 0 || ei == locked_ei ||
+		    !write_trylock(&ei->i_es_lock))
 			continue;
 
-		write_lock(&ei->i_es_lock);
 		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
 		if (ei->i_es_lru_nr == 0)
 			list_del_init(&ei->i_es_lru);


