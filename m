Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3JOBIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:08:38 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48358 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab3JOBIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:08:37 -0400
Message-Id: <20131015010819.478281242@kernel.org>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 09:05:03 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 3/4 v2] percpu_ida: add an API to return free tags
References: <20131015010500.435964635@kernel.org>
Content-Disposition: inline; filename=0003-percpu_ida-add-an-API-to-return-free-tags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add an API to return free tags, blk-mq-tag will use it.
Note, this just returns a snapshot of free tags number. blk-mq-tag has two
usages of it. One is for info output for diagnosis. The other is to quickly
check if there are free tags for request dispatch checking. Neither requires
very precise.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 include/linux/percpu_ida.h |    1 +
 lib/percpu_ida.c           |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

Index: master/include/linux/percpu_ida.h
===================================================================
--- master.orig/include/linux/percpu_ida.h	2013-10-15 08:47:40.179650593 +0800
+++ master/include/linux/percpu_ida.h	2013-10-15 08:47:40.175650783 +0800
@@ -77,4 +77,5 @@ typedef int (*percpu_ida_cb)(unsigned, v
 int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
 	void *data);
 
+unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu);
 #endif /* __PERCPU_IDA_H__ */
Index: master/lib/percpu_ida.c
===================================================================
--- master.orig/lib/percpu_ida.c	2013-10-15 08:47:40.179650593 +0800
+++ master/lib/percpu_ida.c	2013-10-15 08:47:40.175650783 +0800
@@ -371,3 +371,20 @@ out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(percpu_ida_for_each_free);
+
+/**
+ * percpu_ida_free_tags - return free tags number of a specific cpu or global pool
+ * @pool: pool related
+ * @cpu: specific cpu or global pool if @cpu == nr_cpu_ids
+ *
+ * Note: this just returns a snapshot of free tags number.
+ */
+unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu)
+{
+	struct percpu_ida_cpu *remote;
+	if (cpu == nr_cpu_ids)
+		return pool->nr_free;
+	remote = per_cpu_ptr(pool->tag_cpu, cpu);
+	return remote->nr_free;
+}
+EXPORT_SYMBOL_GPL(percpu_ida_free_tags);

