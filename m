Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaEWAuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:50:00 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60691 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaEWAt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:49:58 -0400
X-IronPort-AV: E=Sophos;i="4.98,890,1392192000"; 
   d="scan'208";a="30537839"
Message-ID: <537E9B34.3060007@broadcom.com>
Date: Thu, 22 May 2014 17:49:56 -0700
From: Madhu Rajakumar Nallathamby <madhuraj@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.5-rc2 1/1] fs: Fix a false lock inversion dependency warning
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The false positive lockdep warning is as follows:
 =========================================================
 [ INFO: possible irq lock inversion dependency detected ]
 3.10.10+ #1 Not tainted
 ---------------------------------------------------------
 kswapd0/627 just changed the state of lock:
(sb_writers#3){.+.+.?}, at: [<c01327a0>] do_fallocate+0xf4/0x174
 but this lock took another, RECLAIM_FS-unsafe lock in the past:
  (&sb->s_type->i_mutex_key#8/1){+.+.+.}

 and interrupts could create inverse lock ordering between them.

 other info that might help us debug this:
  Possible interrupt unsafe locking scenario:

        CPU0                  CPU1
         ----                       ----
   lock(&sb->s_type->i_mutex_key#8/1);
                              local_irq_disable();
                              lock(sb_writers#3);
                              lock(&sb->s_type->i_mutex_key#8/1);
   <Interrupt>
     lock(sb_writers#3);

  *** DEADLOCK ***

 the shortest dependencies between 2nd lock and 1st lock:
  -> (&sb->s_type->i_mutex_key#8/1){+.+.+.} ops: 633 {
  ................

  ... key      at: [<c0b07f7d>] shmem_fs_type+0x55/0x98
  ... acquired at:
    [<c008f258>] check_prevs_add+0x704/0x874
    [<c008f9a8>] validate_chain.isra.24+0x5e0/0x9b0
    [<c00923c8>] __lock_acquire+0x3fc/0xbcc
    [<c0093244>] lock_acquire+0xa4/0x208
    [<c0761260>] mutex_lock_nested+0x74/0x3f8
    [<c014131c>] kern_path_create+0x7c/0x12c
    [<c0141414>] user_path_create+0x48/0x60
    [<c0143a10>] SyS_mkdirat+0x3c/0xc0
    [<c0143ab8>] SyS_mkdir+0x24/0x28
    [<c000efa0>] ret_fast_syscall+0x0/0x48

 -> (sb_writers#3){.+.+.?} ops: 2054 {
  ..........
  ... key      at: [<c0b07f5c>] shmem_fs_type+0x34/0x98
  ... acquired at:
    [<c008e214>] print_irq_inversion_bug+0x184/0x20c
    [<c008e34c>] check_usage_forwards+0xb0/0x11c
    [<c0090218>] mark_lock+0x1c8/0x71c
    [<c0092524>] __lock_acquire+0x558/0xbcc
    [<c0093244>] lock_acquire+0xa4/0x208
    [<c0135c04>] __sb_start_write+0xb4/0x184
    [<c01327a0>] do_fallocate+0xf4/0x174
    [<c04d2610>] ashmem_shrink+0xc8/0x150
    [<c0105300>] shrink_slab+0x1d8/0x540
    [<c0107ad0>] kswapd+0x494/0xaec
    [<c00513f4>] kthread+0xb4/0xc0
    [<c000f068>] ret_from_fork+0x14/0x20

sb_writers lock is treated as a rw semaphore, and it can be taken
recursively, when multiple threads are modifying data or metadata
of the same filesystem. Since this lock is taken with interrupts
enabled, the above lock inverse order scenario could happen. But,
this will not really cause a deadlock, as sb_writers is always
taken only as a reader. So, disable lockdep checks around this
lock.

Signed-off-by: Madhu Rajakumar <madhuraj@broadcom.com>
---
 fs/super.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index e5f6c2c..cc328ec 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1137,7 +1137,14 @@ void __sb_end_write(struct super_block *sb, int level)
 	smp_mb();
 	if (waitqueue_active(&sb->s_writers.wait))
 		wake_up(&sb->s_writers.wait);
+
+	/*
+	 * s_writers was taken with lockdep checks disabled, so turn off
+	 * lockdep checks here too
+	 */
+	lockdep_off();
 	rwsem_release(&sb->s_writers.lock_map[level-1], 1, _RET_IP_);
+	lockdep_on();
 }
 EXPORT_SYMBOL(__sb_end_write);
 
@@ -1163,7 +1170,20 @@ static void acquire_freeze_lock(struct super_block *sb, int level, bool trylock,
 				break;
 			}
 	}
+
+	/*
+	 * s_writers lock sometimes triggers the lockdep warning 'possible irq
+	 * lock inversion dependency detected'. s_writers is treated as a rw
+	 * semaphore, always taken only as a reader. It can be taken
+	 * recursively, when multiple threads are modifying data or metadata of
+	 * the same filesystem. Since this lock is taken with irqs enabled, it
+	 * is not always possible to guarantee an ordering between s_writers
+	 * and other locks. Since this will not actually cause a deadlock, turn
+	 * off lockdep checks for this case.
+	 */
+	lockdep_off();
 	rwsem_acquire_read(&sb->s_writers.lock_map[level-1], 0, trylock, ip);
+	lockdep_on();
 }
 #endif
 
-- 
1.8.4.4

