Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaIGXP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:15:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53055 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaIGXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:15:25 -0400
Date: Mon, 8 Sep 2014 08:15:20 +0900
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH block/for-3.18] blkcg: remove blkcg->id
Message-ID: <20140907231520.GA5061@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkcg->id is a unique id given to each blkcg; however, the
cgroup_subsys_state which each blkcg embeds already has ->serial_nr
which can be used for the same purpose.  Drop blkcg->id and replace
its uses with blkcg->css.serial_nr.  Rename cfq_cgroup->blkcg_id to
->blkcg_serial_nr and @id in check_blkcg_changed() to @serial_nr for
consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |    2 --
 block/blk-cgroup.h  |    3 ---
 block/cfq-iosched.c |   10 +++++-----
 3 files changed, 5 insertions(+), 10 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -822,7 +822,6 @@ static void blkcg_css_free(struct cgroup
 static struct cgroup_subsys_state *
 blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 {
-	static atomic64_t id_seq = ATOMIC64_INIT(0);
 	struct blkcg *blkcg;
 
 	if (!parent_css) {
@@ -836,7 +835,6 @@ blkcg_css_alloc(struct cgroup_subsys_sta
 
 	blkcg->cfq_weight = CFQ_WEIGHT_DEFAULT;
 	blkcg->cfq_leaf_weight = CFQ_WEIGHT_DEFAULT;
-	blkcg->id = atomic64_inc_return(&id_seq); /* root is 0, start from 1 */
 done:
 	spin_lock_init(&blkcg->lock);
 	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_ATOMIC);
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -50,9 +50,6 @@ struct blkcg {
 	struct blkcg_gq			*blkg_hint;
 	struct hlist_head		blkg_list;
 
-	/* for policies to test whether associated blkcg has changed */
-	uint64_t			id;
-
 	/* TODO: per-policy storage in blkcg */
 	unsigned int			cfq_weight;	/* belongs to cfq */
 	unsigned int			cfq_leaf_weight;
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -299,7 +299,7 @@ struct cfq_io_cq {
 	struct cfq_ttime	ttime;
 	int			ioprio;		/* the current ioprio */
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	uint64_t		blkcg_id;	/* the current blkcg ID */
+	uint64_t		blkcg_serial_nr; /* the current blkcg serial */
 #endif
 };
 
@@ -3534,17 +3534,17 @@ static void check_blkcg_changed(struct c
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
 	struct cfq_queue *sync_cfqq;
-	uint64_t id;
+	uint64_t serial_nr;
 
 	rcu_read_lock();
-	id = bio_blkcg(bio)->id;
+	serial_nr = bio_blkcg(bio)->css.serial_nr;
 	rcu_read_unlock();
 
 	/*
 	 * Check whether blkcg has changed.  The condition may trigger
 	 * spuriously on a newly created cic but there's no harm.
 	 */
-	if (unlikely(!cfqd) || likely(cic->blkcg_id == id))
+	if (unlikely(!cfqd) || likely(cic->blkcg_serial_nr == serial_nr))
 		return;
 
 	sync_cfqq = cic_to_cfqq(cic, 1);
@@ -3558,7 +3558,7 @@ static void check_blkcg_changed(struct c
 		cfq_put_queue(sync_cfqq);
 	}
 
-	cic->blkcg_id = id;
+	cic->blkcg_serial_nr = serial_nr;
 }
 #else
 static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) { }
