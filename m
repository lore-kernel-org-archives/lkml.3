Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaLZOkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:40:39 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11534 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaLZOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:40:31 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d3-549d735c79b1
From: "Stefan I. Strogin" <s.strogin@partner.samsung.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>,
        s.strogin@partner.samsung.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: [PATCH 3/3] cma: add functions to get region pages counters
Date: Fri, 26 Dec 2014 17:39:04 +0300
Message-id: <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <cover.1419602920.git.s.strogin@partner.samsung.com>
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
In-reply-to: <cover.1419602920.git.s.strogin@partner.samsung.com>
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xK7oxxXNDDG7/MLSYs34Nm8Xj1/NY
	LD6tfMpmsbK7mc1ie+cMdovOiUvYLS7vmsNmcW/Nf1aLtUfuslssON7CarHs63t2i77vh9kt
	Js+Wsvh2cg6zxbUd/UwWU2f8YLc4ueEsq8WGZi4HIY/Lfb1MHjtn3WX3mN0xk9Vj06pONo9N
	nyaxe3S9vcLkcWLGbxaPB4c2s3is+/OKyePguz1MHn1bVjF6fN4k59G18RdrAG8Ul01Kak5m
	WWqRvl0CV8bR08vYCzYLV6z4dIq9gfEbfxcjJ4eEgInE8wsfmSBsMYkL99azdTFycQgJLGWU
	+HH6F5TTyyRx6PwrVpAqNgFLiWPzmsA6RIC6dzfPZQSxmQWaWSVuLeAEsYUFXCT2XP7GDGKz
	CKhK7LrXAWbzCqRKTPizlBFim5zEht3/wWxOAUeJJ0/Wgc0UEnCQ6Lz4hhWX+ARG/gWMDKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQiLoyw7GxcesDjEKcDAq8fAmrJsTIsSaWFZcmXuI
	UYKDWUmEt8psbogQb0piZVVqUX58UWlOavEhRiYOTqkGxv5ddzI/W1d9vfavu6nB4uTtPUcC
	7y+csDXuYRX764Idiww+r9wUdZQx1UZIf0eUz8JFHkoaRj9SxZ+v4wmPefjmXOTHZqHdrfPL
	tpYvX2p/tGx70JZNPqmlU+o5U0xMHi1f+9svKCH11zbHy5vnTTN7eHDBtf3fAx5f/HLaQlt8
	+cspvC92HmJRYinOSDTUYi4qTgQABv9yzX4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Safonov <d.safonov@partner.samsung.com>

Here are two functions that provide interface to compute/get used size
and size of biggest free chunk in cma region.
Added that information in cmainfo.

Signed-off-by: Dmitry Safonov <d.safonov@partner.samsung.com>
---
 include/linux/cma.h |  2 ++
 mm/cma.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 9384ba6..855e6f2 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -18,6 +18,8 @@ struct cma;
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(struct cma *cma);
 extern unsigned long cma_get_size(struct cma *cma);
+extern unsigned long cma_get_used(struct cma *cma);
+extern unsigned long cma_get_maxchunk(struct cma *cma);
 
 extern int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
diff --git a/mm/cma.c b/mm/cma.c
index ffaea26..5e560ed 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -78,6 +78,36 @@ unsigned long cma_get_size(struct cma *cma)
 	return cma->count << PAGE_SHIFT;
 }
 
+unsigned long cma_get_used(struct cma *cma)
+{
+	unsigned long ret = 0;
+
+	mutex_lock(&cma->lock);
+	/* pages counter is smaller than sizeof(int) */
+	ret = bitmap_weight(cma->bitmap, (int)cma->count);
+	mutex_unlock(&cma->lock);
+
+	return ret << (PAGE_SHIFT + cma->order_per_bit);
+}
+
+unsigned long cma_get_maxchunk(struct cma *cma)
+{
+	unsigned long maxchunk = 0;
+	unsigned long start, end = 0;
+
+	mutex_lock(&cma->lock);
+	for (;;) {
+		start = find_next_zero_bit(cma->bitmap, cma->count, end);
+		if (start >= cma->count)
+			break;
+		end = find_next_bit(cma->bitmap, cma->count, start);
+		maxchunk = max(end - start, maxchunk);
+	}
+	mutex_unlock(&cma->lock);
+
+	return maxchunk << (PAGE_SHIFT + cma->order_per_bit);
+}
+
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
 	if (align_order <= cma->order_per_bit)
@@ -591,6 +621,10 @@ static int s_show(struct seq_file *m, void *p)
 	struct cma_buffer *cmabuf;
 	struct stack_trace trace;
 
+	seq_printf(m, "CMARegion stat: %8lu kB total, %8lu kB used, %8lu kB max contiguous chunk\n\n",
+		   cma_get_size(cma) >> 10,
+		   cma_get_used(cma) >> 10,
+		   cma_get_maxchunk(cma) >> 10);
 	mutex_lock(&cma->list_lock);
 
 	list_for_each_entry(cmabuf, &cma->buffers_list, list) {
-- 
2.1.0

