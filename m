Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaDYJdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:33:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaDYJdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:33:00 -0400
Date: Fri, 25 Apr 2014 02:32:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: respect rq_affinity
Message-ID: <20140425093253.GA18345@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402956EDDA26@G9W0745.americas.hpqcorp.net>
 <53592665.8050406@kernel.dk>
 <20140425053018.GA30957@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402956EDE0D8@G9W0745.americas.hpqcorp.net>
 <20140425071659.GA15384@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425071659.GA15384@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The blk-mq code is using it's own version of the I/O completion affinity
tunables, which causes a few issues:

 - the rq_affinity sysfs file doesn't work for blk-mq devices, even if it
   still is present, thus breaking existing tuning setups.
 - the rq_affinity = 1 mode, which is the defauly for legacy request based
   drivers isn't implemented at all.
 - blk-mq drivers don't implement any completion affinity with the default
   flag settings.

This patches removes the blk-mq ipi_redirect flag and sysfs file, as well
as the internal BLK_MQ_F_SHOULD_IPI flag and replaces it with code that
respects the queue-wide rq_affinity flags and also implements the
rq_affinity = 1 mode.

This means I/O completion affinity can now only be tuned block-queue wide
instead of per context, which seems more sensible to me anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-sysfs.c   |   42 ------------------------------------------
 block/blk-mq.c         |    8 ++++++--
 block/blk-mq.h         |    1 -
 include/linux/blk-mq.h |    1 -
 4 files changed, 6 insertions(+), 46 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 9176a69..8145b5b 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -203,42 +203,6 @@ static ssize_t blk_mq_hw_sysfs_rq_list_show(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
-static ssize_t blk_mq_hw_sysfs_ipi_show(struct blk_mq_hw_ctx *hctx, char *page)
-{
-	ssize_t ret;
-
-	spin_lock(&hctx->lock);
-	ret = sprintf(page, "%u\n", !!(hctx->flags & BLK_MQ_F_SHOULD_IPI));
-	spin_unlock(&hctx->lock);
-
-	return ret;
-}
-
-static ssize_t blk_mq_hw_sysfs_ipi_store(struct blk_mq_hw_ctx *hctx,
-					 const char *page, size_t len)
-{
-	struct blk_mq_ctx *ctx;
-	unsigned long ret;
-	unsigned int i;
-
-	if (kstrtoul(page, 10, &ret)) {
-		pr_err("blk-mq-sysfs: invalid input '%s'\n", page);
-		return -EINVAL;
-	}
-
-	spin_lock(&hctx->lock);
-	if (ret)
-		hctx->flags |= BLK_MQ_F_SHOULD_IPI;
-	else
-		hctx->flags &= ~BLK_MQ_F_SHOULD_IPI;
-	spin_unlock(&hctx->lock);
-
-	hctx_for_each_ctx(hctx, ctx, i)
-		ctx->ipi_redirect = !!ret;
-
-	return len;
-}
-
 static ssize_t blk_mq_hw_sysfs_tags_show(struct blk_mq_hw_ctx *hctx, char *page)
 {
 	return blk_mq_tag_sysfs_show(hctx->tags, page);
@@ -307,11 +271,6 @@ static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_pending = {
 	.attr = {.name = "pending", .mode = S_IRUGO },
 	.show = blk_mq_hw_sysfs_rq_list_show,
 };
-static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_ipi = {
-	.attr = {.name = "ipi_redirect", .mode = S_IRUGO | S_IWUSR},
-	.show = blk_mq_hw_sysfs_ipi_show,
-	.store = blk_mq_hw_sysfs_ipi_store,
-};
 static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_tags = {
 	.attr = {.name = "tags", .mode = S_IRUGO },
 	.show = blk_mq_hw_sysfs_tags_show,
@@ -326,7 +285,6 @@ static struct attribute *default_hw_ctx_attrs[] = {
 	&blk_mq_hw_sysfs_run.attr,
 	&blk_mq_hw_sysfs_dispatched.attr,
 	&blk_mq_hw_sysfs_pending.attr,
-	&blk_mq_hw_sysfs_ipi.attr,
 	&blk_mq_hw_sysfs_tags.attr,
 	&blk_mq_hw_sysfs_cpus.attr,
 	NULL,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index af358b6..7c92d7d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -326,15 +326,19 @@ static void __blk_mq_complete_request_remote(void *data)
 void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	bool shared = false;
 	int cpu;
 
-	if (!ctx->ipi_redirect) {
+	if (!test_bit(QUEUE_FLAG_SAME_COMP, &rq->q->queue_flags)) {
 		rq->q->softirq_done_fn(rq);
 		return;
 	}
 
 	cpu = get_cpu();
-	if (cpu != ctx->cpu && cpu_online(ctx->cpu)) {
+	if (!test_bit(QUEUE_FLAG_SAME_FORCE, &rq->q->queue_flags))
+		shared = cpus_share_cache(cpu, ctx->cpu);
+
+	if (cpu != ctx->cpu && !shared && cpu_online(ctx->cpu)) {
 		rq->csd.func = __blk_mq_complete_request_remote;
 		rq->csd.info = rq;
 		rq->csd.flags = 0;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index b41a784..1ae364c 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -11,7 +11,6 @@ struct blk_mq_ctx {
 
 	unsigned int		cpu;
 	unsigned int		index_hw;
-	unsigned int		ipi_redirect;
 
 	/* incremented at dispatch time */
 	unsigned long		rq_dispatched[2];
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab469d5..3b561d6 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -122,7 +122,6 @@ enum {
 
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_SHOULD_SORT	= 1 << 1,
-	BLK_MQ_F_SHOULD_IPI	= 1 << 2,
 
 	BLK_MQ_S_STOPPED	= 0,
 
-- 
1.7.10.4

