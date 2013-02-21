Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3BUIm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:42:56 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58498 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3BUImy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:42:54 -0500
Date: Thu, 21 Feb 2013 16:42:45 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jens Axboe" <jaxboe@fusionio.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: elevator: Fix a race about elevator switching.
X-Priority: 3
X-GUID: C88CF224-CB23-4F0B-B546-E0D5FC631DEB
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201302211642417278851@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1L8gwKf008612

Thare's a race between elevator switching and normal io operation.
    Because the allocation of struct elevator_queue and struct elevator_data
    don't in a atomic operation.So there are have chance to use NULL
    ->elevator_data.
    For example:
        Thread A:                               		Thread B
       blk_flush_plug_list                            elevator_switch
      __elv_add_request)           					
      blk_peek_request                              elevator_alloc
      noop_dispatch
															  elevator_init_fn
    Because call elevator_alloc, it can't hold queue_lock and the 
    ->elevator_data is NULL after allocating.So at the same time, threadA call elv_merge and
    nedd some info of elevator_data.So the crash happened.
    [  196.125709] BUG: unable to handle kernel 
[  196.126046] Modules linked in: netconsole configfs nfsd lockd auth_rpcgss sunrpc exportfs raid1 btrfs zlib_deflate libcrc32c
[  196.126046] CPU 2 
[  196.126046] Pid: 6747, comm: dd Not tainted 3.8.0+ #107 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
[  196.126046] RIP: 0010:[<ffffffff812a8c63>]  [<ffffffff812a8c63>] noop_dispatch+0x13/0x40
[  196.126046] RSP: 0018:ffff8800a6fef838  EFLAGS: 00010046
[  196.126046] RAX: 0000000000000000 RBX: ffff8800b53abf20 RCX: 0000000000000000
[  196.126046] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8800b53abf20
[  196.126046] RBP: ffff8800a6fef838 R08: 0000000000000000 R09: 0000000000000000
[  196.126046] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800b53abf20
[  196.126046] R13: ffff8800a6feffd8 R14: ffff8800a6feffd8 R15: ffff8800b3c68090
[  196.126046] FS:  00007f6ef48d6700(0000) GS:ffff8800ba000000(0000) knlGS:0000000000000000
[  196.126046] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  196.126046] CR2: 0000000000000000 CR3: 00000000a83a1000 CR4: 00000000000407e0
[  196.126046] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  196.126046] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  196.126046] Process dd (pid: 6747, threadinfo ffff8800a6fee000, task ffff88009e2a2840)
[  196.126046] Stack:
[  196.126046]  ffff8800a6fef888 ffffffff81297a54 ffff8800b50de7b0 ffff8800b3c68090
[  196.126046]  ffff8800a6fef888 ffff8800b3c68000 ffff8800b53abf20 0000000000000000
[  196.126046]  ffff8800b50de7b0 ffff8800b3c68090 ffff8800a6fef8f8 ffffffff8140fe5a
[  196.126046] Call Trace:
[  196.126046]  [<ffffffff81297a54>] blk_peek_request+0x194/0x250
[  196.126046]  [<ffffffff8140fe5a>] scsi_request_fn+0x4a/0x4f0
[  196.126046]  [<ffffffff810995ef>] ? __lock_is_held+0x5f/0x80
[  196.126046]  [<ffffffff81290d37>] __blk_run_queue+0x37/0x50
[  196.126046]  [<ffffffff812904cd>] __elv_add_request+0xad/0x2d0
[  196.126046]  [<ffffffff81297ecc>] blk_flush_plug_list+0x1bc/0x260
[  196.126046]  [<ffffffff81297f88>] blk_finish_plug+0x18/0x50
[  196.126046]  [<ffffffff81195f1e>] do_blockdev_direct_IO+0x18be/0x20e0
[  196.126046]  [<ffffffff81077cd8>] ? sched_clock_cpu+0xa8/0x120
[  196.126046]  [<ffffffff811913d0>] ? I_BDEV+0x10/0x10
[  196.126046]  [<ffffffff810d0868>] ? rcu_irq_exit+0x68/0xb0
[  196.126046]  [<ffffffff81196795>] __blockdev_direct_IO+0x55/0x60
[  196.126046]  [<ffffffff811913d0>] ? I_BDEV+0x10/0x10
[  196.126046]  [<ffffffff81191c67>] blkdev_direct_IO+0x57/0x60
[  196.126046]  [<ffffffff811913d0>] ? I_BDEV+0x10/0x10
[  196.126046]  [<ffffffff81106633>] generic_file_aio_read+0x703/0x770
[  196.126046]  [<ffffffff811915c1>] blkdev_aio_read+0x51/0x80
[  196.126046]  [<ffffffff81095d45>] ? lock_release_holdtime.part.23+0x15/0x1a0
[  196.126046]  [<ffffffff81157bb3>] do_sync_read+0xa3/0xe0
[  196.126046]  [<ffffffff81158343>] vfs_read+0xb3/0x180
[  196.126046]  [<ffffffff81158465>] sys_read+0x55/0xa0
[  196.126046]  [<ffffffff816f4242>] system_call_fastpath+0x16/0x1b
[  196.126046] Code: 48 83 c4 08 5b 5d c3 90 b8 10 00 00 00 eb e0 b8 f4 ff ff ff eb ea 66 90 66 66 66 66 90 48 8b 47 18 55 48 89 e5 48 8b 50 08 31 c0 <48> 8b 32 48 39 f2 74 1f 48 8b 46 08 48 8b 16 48 89 42 08 48 89 
[  196.126046] RIP  [<ffffffff812a8c63>] noop_dispatch+0x13/0x40
[  196.126046]  RSP <ffff8800a6fef838>
[  196.126046] CR2: 0000000000000000

    Move the elevator_alloc into func elevator_init_fn, it make the
    operations in a atomic operation.
    
    Using the follow method can easy reproduce this bug
    1:dd if=/dev/sdb of=/dev/null
    2:while true;do echo noop > scheduler;echo deadline > scheduler;done
    
    The test method also use this method.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/cfq-iosched.c      |   17 ++++++++++++++---
 block/deadline-iosched.c |   16 +++++++++++++---
 block/elevator.c         |   25 +++++--------------------
 block/noop-iosched.c     |   17 ++++++++++++++---
 include/linux/elevator.h |    6 +++++-
 5 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e62e920..c7cfa34 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3960,18 +3960,28 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	kfree(cfqd);
 }
 
-static int cfq_init_queue(struct request_queue *q)
+static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 {
 	struct cfq_data *cfqd;
 	struct blkcg_gq *blkg __maybe_unused;
 	int i, ret;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (!cfqd)
+	if (!cfqd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = cfqd;
 
 	cfqd->queue = q;
-	q->elevator->elevator_data = cfqd;
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 
 	/* Init root service tree */
 	cfqd->grp_service_tree = CFQ_RB_ROOT;
@@ -4045,6 +4055,7 @@ static int cfq_init_queue(struct request_queue *q)
 
 out_free:
 	kfree(cfqd);
+	kobject_put(&eq->kobj);
 	return ret;
 }
 
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 90037b5..1cfef5d 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -337,13 +337,21 @@ static void deadline_exit_queue(struct elevator_queue *e)
 /*
  * initialize elevator private data (deadline_data).
  */
-static int deadline_init_queue(struct request_queue *q)
+static int deadline_init_queue(struct request_queue *q, struct elevator_type *e)
 {
 	struct deadline_data *dd;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL | __GFP_ZERO, q->node);
-	if (!dd)
+	if (!dd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = dd;
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
 	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
@@ -355,7 +363,9 @@ static int deadline_init_queue(struct request_queue *q)
 	dd->front_merges = 1;
 	dd->fifo_batch = fifo_batch;
 
-	q->elevator->elevator_data = dd;
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
 
diff --git a/block/elevator.c b/block/elevator.c
index 603b2c1..3e22301 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -154,7 +154,7 @@ void __init load_default_elevator_module(void)
 
 static struct kobj_type elv_ktype;
 
-static struct elevator_queue *elevator_alloc(struct request_queue *q,
+struct elevator_queue *elevator_alloc(struct request_queue *q,
 				  struct elevator_type *e)
 {
 	struct elevator_queue *eq;
@@ -182,6 +182,7 @@ err:
 	elevator_put(e);
 	return NULL;
 }
+EXPORT_SYMBOL(elevator_alloc);
 
 static void elevator_release(struct kobject *kobj)
 {
@@ -234,16 +235,7 @@ int elevator_init(struct request_queue *q, char *name)
 		}
 	}
 
-	q->elevator = elevator_alloc(q, e);
-	if (!q->elevator)
-		return -ENOMEM;
-
-	err = e->ops.elevator_init_fn(q);
-	if (err) {
-		kobject_put(&q->elevator->kobj);
-		return err;
-	}
-
+	err = e->ops.elevator_init_fn(q, e);
 	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
@@ -924,16 +916,9 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	spin_unlock_irq(q->queue_lock);
 
 	/* allocate, init and register new elevator */
-	err = -ENOMEM;
-	q->elevator = elevator_alloc(q, new_e);
-	if (!q->elevator)
-		goto fail_init;
-
-	err = new_e->ops.elevator_init_fn(q);
-	if (err) {
-		kobject_put(&q->elevator->kobj);
+	err = new_e->ops.elevator_init_fn(q, new_e);
+	if (err)
 		goto fail_init;
-	}
 
 	if (registered) {
 		err = elv_register_queue(q);
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 5d1bf70..3de89d4 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -59,16 +59,27 @@ noop_latter_request(struct request_queue *q, struct request *rq)
 	return list_entry(rq->queuelist.next, struct request, queuelist);
 }
 
-static int noop_init_queue(struct request_queue *q)
+static int noop_init_queue(struct request_queue *q, struct elevator_type *e)
 {
 	struct noop_data *nd;
+	struct elevator_queue *eq;
+
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
 
 	nd = kmalloc_node(sizeof(*nd), GFP_KERNEL, q->node);
-	if (!nd)
+	if (!nd) {
+		kobject_put(&eq->kobj);
 		return -ENOMEM;
+	}
+	eq->elevator_data = nd;
 
 	INIT_LIST_HEAD(&nd->queue);
-	q->elevator->elevator_data = nd;
+
+	spin_lock_irq(q->queue_lock);
+	q->elevator = eq;
+	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1866206..c288a2f 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_BLOCK
 
 struct io_cq;
+struct elevator_type;
 
 typedef int (elevator_merge_fn) (struct request_queue *, struct request **,
 				 struct bio *);
@@ -34,7 +35,8 @@ typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
 
-typedef int (elevator_init_fn) (struct request_queue *);
+typedef int (elevator_init_fn) (struct request_queue *,
+				struct elevator_type *e);
 typedef void (elevator_exit_fn) (struct elevator_queue *);
 
 struct elevator_ops
@@ -152,6 +154,8 @@ extern int elevator_init(struct request_queue *, char *);
 extern void elevator_exit(struct elevator_queue *);
 extern int elevator_change(struct request_queue *, const char *);
 extern bool elv_rq_merge_ok(struct request *, struct bio *);
+extern struct elevator_queue *elevator_alloc(struct request_queue *,
+					struct elevator_type *);
 
 /*
  * Helper functions.
-- 
1.7.9.5
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
