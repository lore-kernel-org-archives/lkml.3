Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3GAKwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:52:10 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33822 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3GAKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:52:08 -0400
Date: Mon, 1 Jul 2013 18:52:04 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jens Axboe" <jaxboe@fusionio.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH V1] elevator: Fix a race about elevator switching.
X-Priority: 3
X-GUID: A926625F-D679-46F2-9B69-649936A7A52D
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307011851511379161@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r61AqKkb032132

Thare's a race between elevator switching and normal io operation.
    Because the allocation of struct elevator_queue and struct elevator_data
    don't in a atomic operation.So there are have chance to use NULL
    ->elevator_data.
    For example:
        Thread A:                               Thread B
        blk_queu_bio                            elevator_switch
        spin_lock_irq(q->queue_block)           elevator_alloc
        elv_merge                               elevator_init_fn
    
    Because call elevator_alloc, it can't hold queue_lock and the
    ->elevator_data is NULL.So at the same time, threadA call elv_merge and
    nedd some info of elevator_data.So the crash happened.
    
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
