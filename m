Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaGWBgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:36:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54589 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaGWBfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:35:14 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv4 2/5] lib/genalloc.c: Add genpool range check function
Date: Tue, 22 Jul 2014 18:35:05 -0700
Message-Id: <1406079308-5232-3-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After allocating an address from a particular genpool,
there is no good way to verify if that address actually
belongs to a genpool. Introduce addr_in_gen_pool which
will return if an address plus size falls completely
within the genpool range.

Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 include/linux/genalloc.h |  3 +++
 lib/genalloc.c           | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 3cd0934..1ccaab4 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -121,6 +121,9 @@ extern struct gen_pool *devm_gen_pool_create(struct device *dev,
 		int min_alloc_order, int nid);
 extern struct gen_pool *dev_get_gen_pool(struct device *dev);
 
+bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+			size_t size);
+
 #ifdef CONFIG_OF
 extern struct gen_pool *of_get_named_gen_pool(struct device_node *np,
 	const char *propname, int index);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 9758529..66edf93 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -403,6 +403,35 @@ void gen_pool_for_each_chunk(struct gen_pool *pool,
 EXPORT_SYMBOL(gen_pool_for_each_chunk);
 
 /**
+ * addr_in_gen_pool - checks if an address falls within the range of a pool
+ * @pool:	the generic memory pool
+ * @start:	start address
+ * @size:	size of the region
+ *
+ * Check if the range of addresses falls within the specified pool. Takes
+ * the rcu_read_lock for the duration of the check.
+ */
+bool addr_in_gen_pool(struct gen_pool *pool, unsigned long start,
+			size_t size)
+{
+	bool found = false;
+	unsigned long end = start + size;
+	struct gen_pool_chunk *chunk;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk) {
+		if (start >= chunk->start_addr && start <= chunk->end_addr) {
+			if (end <= chunk->end_addr) {
+				found = true;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+	return found;
+}
+
+/**
  * gen_pool_avail - get available free space of the pool
  * @pool: pool to get available free space
  *
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

