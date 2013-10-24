Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab3JXJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36746 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JXJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:22 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/11] percpu_ida: add an API to return free tags
Date: Thu, 24 Oct 2013 10:26:02 +0100
Message-Id: <1382606764-8309-10-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shli@kernel.org>

Add an API to return free tags, blk-mq-tag will use it.

Note, this just returns a snapshot of free tags number. blk-mq-tag has
two usages of it. One is for info output for diagnosis. The other is to
quickly check if there are free tags for request dispatch checking.
Neither requires very precise.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/percpu_ida.h |  1 +
 lib/percpu_ida.c           | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 63510ae..1900bd0 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -77,4 +77,5 @@ typedef int (*percpu_ida_cb)(unsigned, void *);
 int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
 	void *data);
 
+unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu);
 #endif /* __PERCPU_IDA_H__ */
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 0f51c1b..b0698ea 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
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
-- 
1.8.1.2

