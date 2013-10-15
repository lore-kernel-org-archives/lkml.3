Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3JOBIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:08:21 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61298 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3JOBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:08:18 -0400
Message-Id: <20131015010802.638033741@kernel.org>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 09:05:02 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 2/4 v2] percpu_ida: add percpu_ida_for_each_free
References: <20131015010500.435964635@kernel.org>
Content-Disposition: inline; filename=0002-percpu_ida-add-percpu_ida_for_each_free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new API to iterate free ids. blk-mq-tag will use it.

Note, this doesn't guarantee to iterate all free ids restrictly. Caller should
be aware of this. blk-mq uses it to do sanity check for request timedout, so
can tolerate the limitation.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 include/linux/percpu_ida.h |    4 ++++
 lib/percpu_ida.c           |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

Index: master/include/linux/percpu_ida.h
===================================================================
--- master.orig/include/linux/percpu_ida.h	2013-10-15 08:28:36.198031207 +0800
+++ master/include/linux/percpu_ida.h	2013-10-15 08:30:19.996733244 +0800
@@ -73,4 +73,8 @@ static inline int percpu_ida_init(struct
 		IDA_DEFAULT_PCPU_BATCH_MOVE);
 }
 
+typedef int (*percpu_ida_cb)(unsigned, void *);
+int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
+	void *data);
+
 #endif /* __PERCPU_IDA_H__ */
Index: master/lib/percpu_ida.c
===================================================================
--- master.orig/lib/percpu_ida.c	2013-10-15 08:28:36.198031207 +0800
+++ master/lib/percpu_ida.c	2013-10-15 08:40:06.937353699 +0800
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

