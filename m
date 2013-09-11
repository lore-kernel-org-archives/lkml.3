Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3IKE6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3IKE5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:02 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=HnpjeIG9iMoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AgcXswPzOokA:10 a=pGLkceISAAAA:8 a=zhIU3WiJokgflZVzbYIA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.609924177@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jianpeng Ma <majianpeng@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [195/251] elevator: Fix a race in elevator switching
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0195-elevator-Fix-a-race-in-elevator-switching.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jianpeng Ma <majianpeng@gmail.com>

[ Upstream commit d50235b7bc3ee0a0427984d763ea7534149531b4 ]

There's a race between elevator switching and normal io operation.
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 block/cfq-iosched.c      |   17 ++++++++++++++---
 block/deadline-iosched.c |   16 +++++++++++++---
 block/elevator.c         |   25 +++++--------------------
 block/noop-iosched.c     |   17 ++++++++++++++---
 include/linux/elevator.h |    6 +++++-
 5 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..1bde45f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3959,18 +3959,28 @@ static void cfq_exit_queue(struct elevator_queue *e)
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
@@ -4044,6 +4054,7 @@ static int cfq_init_queue(struct request_queue *q)
 
 out_free:
 	kfree(cfqd);
+	kobject_put(&eq->kobj);
 	return ret;
 }
 
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 599b12e..20a1efc 100644
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
index 6a55d41..ac6316c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -138,7 +138,7 @@ __setup("elevator=", elevator_setup);
 
 static struct kobj_type elv_ktype;
 
-static struct elevator_queue *elevator_alloc(struct request_queue *q,
+struct elevator_queue *elevator_alloc(struct request_queue *q,
 				  struct elevator_type *e)
 {
 	struct elevator_queue *eq;
@@ -166,6 +166,7 @@ err:
 	elevator_put(e);
 	return NULL;
 }
+EXPORT_SYMBOL(elevator_alloc);
 
 static void elevator_release(struct kobject *kobj)
 {
@@ -213,16 +214,7 @@ int elevator_init(struct request_queue *q, char *name)
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
@@ -897,16 +889,9 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
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
index c03af76..20ae95b 100644
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
@@ -151,6 +153,8 @@ extern int elevator_init(struct request_queue *, char *);
 extern void elevator_exit(struct elevator_queue *);
 extern int elevator_change(struct request_queue *, const char *);
 extern bool elv_rq_merge_ok(struct request *, struct bio *);
+extern struct elevator_queue *elevator_alloc(struct request_queue *,
+					struct elevator_type *);
 
 /*
  * Helper functions.
-- 
1.7.10.4


