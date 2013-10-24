Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3JXJ1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:27:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36743 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3JXJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:22 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] percpu_ida: add percpu_ida_for_each_free
Date: Thu, 24 Oct 2013 10:26:01 +0100
Message-Id: <1382606764-8309-9-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shli@kernel.org>

Add a new API to iterate free ids. blk-mq-tag will use it.

Note, this doesn't guarantee to iterate all free ids restrictly. Caller
should be aware of this. blk-mq uses it to do sanity check for request
timedout, so can tolerate the limitation.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/percpu_ida.h |  4 ++++
 lib/percpu_ida.c           | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 56c1403..63510ae 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -73,4 +73,8 @@ static inline int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags
 		IDA_DEFAULT_PCPU_BATCH_MOVE);
 }
 
+typedef int (*percpu_ida_cb)(unsigned, void *);
+int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
+	void *data);
+
 #endif /* __PERCPU_IDA_H__ */
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index a601d42..0f51c1b 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -327,3 +327,47 @@ err:
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(__percpu_ida_init);
+
+/**
+ * percpu_ida_for_each_free - iterate free ids of a pool
+ * @pool: pool to iterate
+ * @fn: interate callback function
+ * @data: parameter for @fn
+ *
+ * Note, this doesn't guarantee to iterate all free ids restrictly. Some free
+ * ids might be missed, some might be iterated duplicated, and some might
+ * be iterated and not free soon.
+ */
+int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
+	void *data)
+{
+	unsigned long flags;
+	struct percpu_ida_cpu *remote;
+	unsigned cpu, i, err = 0;
+
+	local_irq_save(flags);
+	for_each_possible_cpu(cpu) {
+		remote = per_cpu_ptr(pool->tag_cpu, cpu);
+		spin_lock(&remote->lock);
+		for (i = 0; i < remote->nr_free; i++) {
+			err = fn(remote->freelist[i], data);
+			if (err)
+				break;
+		}
+		spin_unlock(&remote->lock);
+		if (err)
+			goto out;
+	}
+
+	spin_lock(&pool->lock);
+	for (i = 0; i < pool->nr_free; i++) {
+		err = fn(pool->freelist[i], data);
+		if (err)
+			break;
+	}
+	spin_unlock(&pool->lock);
+out:
+	local_irq_restore(flags);
+	return err;
+}
+EXPORT_SYMBOL_GPL(percpu_ida_for_each_free);
-- 
1.8.1.2

