Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaIPHyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:54:22 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaIPHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:54:21 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 03:54:20 EDT
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, <stable@vger.kernel.org>
Subject: [PATCH] UBI: Fix possible deadlock in erase_worker()
Date: Tue, 16 Sep 2014 09:48:22 +0200
Message-Id: <1410853702-11616-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sync_erase() failes with EINTR, ENOMEM, EAGAIN or
EBUSY erase_worker() re-schedules the failed work.
This will lead to a deadlock because erase_worker() is called
with work_sem held in read mode. And schedule_erase() will take
this lock again.

Fix this issue by adding a locked flag to schedule_erase(),
it indicates whether the caller owns work_sem already.

[   16.571519] [ INFO: possible recursive locking detected ]
[   16.571519] 3.17.0-rc4+ #69 Not tainted
[   16.571519] ---------------------------------------------
[   16.571519] ubi_bgt0d/2607 is trying to acquire lock:
[   16.571519]  (&ubi->work_sem){.+.+..}, at: [<ffffffff8154eaee>] schedule_ubi_work+0x1e/0x40
[   16.571519]
[   16.571519] but task is already holding lock:
[   16.571519]  (&ubi->work_sem){.+.+..}, at: [<ffffffff8154e7ec>] do_work+0x3c/0x110
[   16.571519]
[   16.571519] other info that might help us debug this:
[   16.571519]  Possible unsafe locking scenario:
[   16.571519]
[   16.571519]        CPU0
[   16.571519]        ----
[   16.571519]   lock(&ubi->work_sem);
[   16.571519]   lock(&ubi->work_sem);
[   16.571519]
[   16.571519]  *** DEADLOCK ***
[   16.571519]
[   16.571519]  May be due to missing lock nesting notation
[   16.571519]
[   16.571519] 1 lock held by ubi_bgt0d/2607:
[   16.571519]  #0:  (&ubi->work_sem){.+.+..}, at: [<ffffffff8154e7ec>] do_work+0x3c/0x110
[   16.571519]
[   16.571519] stack backtrace:
[   16.571519] CPU: 1 PID: 2607 Comm: ubi_bgt0d Not tainted 3.17.0-rc4+ #69
[   16.571519] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140816_022509-build35 04/01/2014
[   16.571519]  ffffffff829ee740 ffff88003c32fba8 ffffffff818b4693 ffffffff829ee740
[   16.571519]  ffff88003c32fc70 ffffffff8108bb4b ffff88003cc65400 ffff88003c32c000
[   16.571519]  000000003e1d37c0 ffffffff810855f1 ffffffff00000000 0000000000a2c516
[   16.571519] Call Trace:
[   16.571519]  [<ffffffff818b4693>] dump_stack+0x4d/0x66
[   16.571519]  [<ffffffff8108bb4b>] __lock_acquire+0x1b3b/0x1ce0
[   16.571519]  [<ffffffff810855f1>] ? up+0x11/0x50
[   16.571519]  [<ffffffff8109c504>] ? console_unlock+0x1d4/0x4b0
[   16.571519]  [<ffffffff81088f7d>] ? trace_hardirqs_on+0xd/0x10
[   16.571519]  [<ffffffff8108bd98>] lock_acquire+0xa8/0x140
[   16.571519]  [<ffffffff8154eaee>] ? schedule_ubi_work+0x1e/0x40
[   16.571519]  [<ffffffff818bf7bc>] down_read+0x4c/0xa0
[   16.571519]  [<ffffffff8154eaee>] ? schedule_ubi_work+0x1e/0x40
[   16.571519]  [<ffffffff8154eaee>] schedule_ubi_work+0x1e/0x40
[   16.571519]  [<ffffffff8154ebb8>] schedule_erase+0xa8/0x130
[   16.571519]  [<ffffffff8154f42a>] erase_worker+0x40a/0x710
[   16.571519]  [<ffffffff8154e82d>] do_work+0x7d/0x110
[   16.571519]  [<ffffffff81550e78>] ubi_thread+0x128/0x1e0
[   16.571519]  [<ffffffff81550d50>] ? ubi_wl_flush+0x180/0x180
[   16.571519]  [<ffffffff8106871b>] kthread+0xeb/0x110
[   16.571519]  [<ffffffff81068630>] ? kthread_create_on_node+0x210/0x210
[   16.571519]  [<ffffffff818c1e6c>] ret_from_fork+0x7c/0xb0
[   16.571519]  [<ffffffff81068630>] ? kthread_create_on_node+0x210/0x210

Cc: <stable@vger.kernel.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 20f4917..e985f29 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -884,21 +884,20 @@ int ubi_is_erase_work(struct ubi_work *wrk)
  * @vol_id: the volume ID that last used this PEB
  * @lnum: the last used logical eraseblock number for the PEB
  * @torture: if the physical eraseblock has to be tortured
+ * @locked: non-zero if this function is called with @ubi->work_sem held in
+ * read mode. Never call it with @ubi->work_sem held in write mode!
  *
  * This function returns zero in case of success and a %-ENOMEM in case of
  * failure.
  */
 static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
-			  int vol_id, int lnum, int torture)
+			  int vol_id, int lnum, int torture, int locked)
 {
 	struct ubi_work *wl_wrk;
 
 	ubi_assert(e);
 	ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 
-	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
-	       e->pnum, e->ec, torture);
-
 	wl_wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
 	if (!wl_wrk)
 		return -ENOMEM;
@@ -909,7 +908,13 @@ static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	wl_wrk->lnum = lnum;
 	wl_wrk->torture = torture;
 
-	schedule_ubi_work(ubi, wl_wrk);
+	dbg_wl("schedule erasure of PEB %d, EC %d, torture %d",
+	       e->pnum, e->ec, torture);
+
+	if (locked)
+		__schedule_ubi_work(ubi, wl_wrk);
+	else
+		schedule_ubi_work(ubi, wl_wrk);
 	return 0;
 }
 
@@ -982,7 +987,7 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 	spin_unlock(&ubi->wl_lock);
 
 	vol_id = lnum ? UBI_FM_DATA_VOLUME_ID : UBI_FM_SB_VOLUME_ID;
-	return schedule_erase(ubi, e, vol_id, lnum, torture);
+	return schedule_erase(ubi, e, vol_id, lnum, torture, 1);
 }
 #endif
 
@@ -1464,7 +1469,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, 1);
 		if (err1) {
 			err = err1;
 			goto out_ro;
@@ -1620,7 +1625,7 @@ retry:
 	}
 	spin_unlock(&ubi->wl_lock);
 
-	err = schedule_erase(ubi, e, vol_id, lnum, torture);
+	err = schedule_erase(ubi, e, vol_id, lnum, torture, 0);
 	if (err) {
 		spin_lock(&ubi->wl_lock);
 		wl_tree_add(e, &ubi->used);
@@ -1909,7 +1914,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		e->ec = aeb->ec;
 		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
-		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
+		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0, 0)) {
 			kmem_cache_free(ubi_wl_entry_slab, e);
 			goto out_free;
 		}
-- 
1.8.4.5

