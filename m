Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbaDBU1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:27:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42822 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758860AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/40] pnfs: fix BUG in filelayout_recover_commit_reqs
Date: Wed,  2 Apr 2014 22:13:02 +0200
Message-Id: <9de48201dab36dde64159f6fd7f8f66e3d7384c4.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weston Andros Adamson <dros@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 471252cd8b34b0609973740b25dcd1ff01dc1889 upstream.

cond_resched_lock(cinfo->lock) is called everywhere else while holding
the cinfo->lock spinlock.  Not holding this lock while calling
transfer_commit_list in filelayout_recover_commit_reqs causes the BUG
below.

It's true that we can't hold this lock while calling pnfs_put_lseg,
because that might try to lock the inode lock - which might be the
same lock as cinfo->lock.

To reproduce, mount a 2 DS pynfs server and run an O_DIRECT command
that crosses a stripe boundary and is not page aligned, such as:

 dd if=/dev/zero of=/mnt/f bs=17000 count=1 oflag=direct

BUG: sleeping function called from invalid context at linux/fs/nfs/nfs4filelayout.c:1161
in_atomic(): 0, irqs_disabled(): 0, pid: 27, name: kworker/0:1
2 locks held by kworker/0:1/27:
 #0:  (events){.+.+.+}, at: [<ffffffff810501d7>] process_one_work+0x175/0x3a5
 #1:  ((&dreq->work)){+.+...}, at: [<ffffffff810501d7>] process_one_work+0x175/0x3a5
CPU: 0 PID: 27 Comm: kworker/0:1 Not tainted 3.13.0-rc3-branch-dros_testing+ #21
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
Workqueue: events nfs_direct_write_schedule_work [nfs]
 0000000000000000 ffff88007a39bbb8 ffffffff81491256 ffff88007b87a130  ffff88007a39bbd8 ffffffff8105f103 ffff880079614000 ffff880079617d40  ffff88007a39bc20 ffffffffa011603e ffff880078988b98 0000000000000000
Call Trace:
 [<ffffffff81491256>] dump_stack+0x4d/0x66
 [<ffffffff8105f103>] __might_sleep+0x100/0x105
 [<ffffffffa011603e>] transfer_commit_list+0x94/0xf1 [nfs_layout_nfsv41_files]
 [<ffffffffa01160d6>] filelayout_recover_commit_reqs+0x3b/0x68 [nfs_layout_nfsv41_files]
 [<ffffffffa00ba53a>] nfs_direct_write_reschedule+0x9f/0x1d6 [nfs]
 [<ffffffff810705df>] ? mark_lock+0x1df/0x224
 [<ffffffff8106e617>] ? trace_hardirqs_off_caller+0x37/0xa4
 [<ffffffff8106e691>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa00ba8f8>] nfs_direct_write_schedule_work+0x9d/0xb7 [nfs]
 [<ffffffff810501d7>] ? process_one_work+0x175/0x3a5
 [<ffffffff81050258>] process_one_work+0x1f6/0x3a5
 [<ffffffff810501d7>] ? process_one_work+0x175/0x3a5
 [<ffffffff8105187e>] worker_thread+0x149/0x1f5
 [<ffffffff81051735>] ? rescuer_thread+0x28d/0x28d
 [<ffffffff81056d74>] kthread+0xd2/0xda
 [<ffffffff81056ca2>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8149e66c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81056ca2>] ? __kthread_parkme+0x61/0x61

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/nfs4filelayout.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index b86464ba25e1..6e245d13de10 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -1216,17 +1216,17 @@ static void filelayout_recover_commit_reqs(struct list_head *dst,
 	struct pnfs_commit_bucket *b;
 	int i;
 
-	/* NOTE cinfo->lock is NOT held, relying on fact that this is
-	 * only called on single thread per dreq.
-	 * Can't take the lock because need to do pnfs_put_lseg
-	 */
+	spin_lock(cinfo->lock);
 	for (i = 0, b = cinfo->ds->buckets; i < cinfo->ds->nbuckets; i++, b++) {
 		if (transfer_commit_list(&b->written, dst, cinfo, 0)) {
+			spin_unlock(cinfo->lock);
 			pnfs_put_lseg(b->wlseg);
 			b->wlseg = NULL;
+			spin_lock(cinfo->lock);
 		}
 	}
 	cinfo->ds->nwritten = 0;
+	spin_unlock(cinfo->lock);
 }
 
 static unsigned int
-- 
1.9.1

