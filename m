Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaHKXlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:41:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaHKXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:40:40 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv7 1/5] lib/genalloc.c: Add power aligned algorithm
Date: Mon, 11 Aug 2014 16:40:27 -0700
Message-Id: <1407800431-21566-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1407800431-21566-1-git-send-email-lauraa@codeaurora.org>
References: <1407800431-21566-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of the more common algorithms used for allocation
is to align the start address of the allocation to
the order of size requested. Add this as an algorithm
option for genalloc.

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Olof Johansson <olof@lixom.net>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 include/linux/genalloc.h |  4 ++++
 lib/genalloc.c           | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 1c2fdaa..3cd0934 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -110,6 +110,10 @@ extern void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo,
 extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
+extern unsigned long gen_pool_first_fit_order_align(unsigned long *map,
+		unsigned long size, unsigned long start, unsigned int nr,
+		void *data);
+
 extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data);
 
diff --git a/lib/genalloc.c b/lib/genalloc.c
index bdb9a45..c2b3ad7 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -481,6 +481,26 @@ unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 EXPORT_SYMBOL(gen_pool_first_fit);
 
 /**
+ * gen_pool_first_fit_order_align - find the first available region
+ * of memory matching the size requirement. The region will be aligned
+ * to the order of the size specified.
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @data: additional data - unused
+ */
+unsigned long gen_pool_first_fit_order_align(unsigned long *map,
+		unsigned long size, unsigned long start,
+		unsigned int nr, void *data)
+{
+	unsigned long align_mask = roundup_pow_of_two(nr) - 1;
+
+	return bitmap_find_next_zero_area(map, size, start, nr, align_mask);
+}
+EXPORT_SYMBOL(gen_pool_first_fit_order_align);
+
+/**
  * gen_pool_best_fit - find the best fitting region of memory
  * macthing the size requirement (no alignment constraint)
  * @map: The address to base the search on
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

