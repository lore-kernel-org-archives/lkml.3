Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JYOnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:43:18 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50228 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3JYOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:42:49 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 1/2] blk-mq: allow request queues to share tags map
Date: Fri, 25 Oct 2013 16:42:36 +0200
Message-Id: <1382712157-28564-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382712157-28564-1-git-send-email-m@bjorling.me>
References: <1382712157-28564-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices, such as NVMe, initializes a limited number of queues. These are
shared by all the block devices. Allow a driver to tap into the tags
structure and decide if an existing tag structure should be used.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 block/blk-mq-tag.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d64a02f..c7b49d5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/percpu_ida.h>
 
@@ -18,6 +19,8 @@ struct blk_mq_tags {
 
 	struct percpu_ida free_tags;
 	struct percpu_ida reserved_tags;
+
+	struct kref ref_count;
 };
 
 void blk_mq_wait_for_tags(struct blk_mq_tags *tags)
@@ -116,6 +119,12 @@ void blk_mq_tag_busy_iter(struct blk_mq_tags *tags,
 	kfree(tag_map);
 }
 
+void blk_mq_init_tags_shared(struct blk_mq_tags *tags)
+{
+	kref_get(&tags->ref_count);
+}
+EXPORT_SYMBOL_GPL(blk_mq_init_tags_shared);
+
 struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 				     unsigned int reserved_tags, int node)
 {
@@ -145,6 +154,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_max_cache = nr_cache;
 	tags->nr_batch_move = max(1u, nr_cache / 2);
 
+	kref_init(&tags->ref_count);
+
 	ret = __percpu_ida_init(&tags->free_tags, tags->nr_tags -
 				tags->nr_reserved_tags,
 				tags->nr_max_cache,
@@ -171,14 +182,23 @@ err_free_tags:
 	kfree(tags);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(blk_mq_init_tags);
 
-void blk_mq_free_tags(struct blk_mq_tags *tags)
+static void __blk_mq_free_tags(struct kref *kref)
 {
+	struct blk_mq_tags *tags = container_of(kref, struct blk_mq_tags,
+								ref_count);
+
 	percpu_ida_destroy(&tags->free_tags);
 	percpu_ida_destroy(&tags->reserved_tags);
 	kfree(tags);
 }
 
+void blk_mq_free_tags(struct blk_mq_tags *tags)
+{
+	kref_put(&tags->ref_count, __blk_mq_free_tags);
+}
+
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
-- 
1.8.3.2

