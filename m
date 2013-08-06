Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3HFGnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:43:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34479 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3HFGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:43:11 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-da-52009afe30e7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH 3/4] mm: add zbud flag to page flags
Date: Tue, 06 Aug 2013 08:42:40 +0200
Message-id: <1375771361-8388-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Nd1/sxiCDP6v07aYs34Nm8XGGetZ
	LV6/MLQ42/SG3eLyrjlsFvfW/Ge1WHvkLrvF5HfPGC0O7VvF7sDpsenTJHaPEzN+s3g8OLSZ
	xaNvyypGj82nqz0+b5ILYIvisklJzcksSy3St0vgyti68hZjwQLBiu/bDrA1MH7j7WLk5JAQ
	MJFY+aCfHcIWk7hwbz1bFyMXh5DAUkaJwy+eMUI4fUwSRyfcZgapYhMwlti8fAkbiC0i0Mco
	MemyBYjNLPCUUWLXdycQW1jAQuLO5GcsIDaLgKrEr11PWEFsXgE3ieW3bgNt4wDapiAxZ5IN
	SJhTwF1i6d7bYEcIAZX8ujCLZQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIeH2
	ZQfj4mNWhxgFOBiVeHgTrv4PFGJNLCuuzD3EKMHBrCTCy1jFECTEm5JYWZValB9fVJqTWnyI
	kYmDU6qB0fRswSLj9R9TlGY+YDy6P5XRaHr3TTudqr1L7P13bLab5y34eMmb5ZasLB15pRyc
	2j8YH7xZ0sL+Yt97i88a3j+ysiVOrj/kd2LZnAn1kVlmhxoOad/46i4j+rLAqkdB6gn7Eh6H
	vvn6AT+1fzpsdudZb7pQawuj3PuUx+YSq36a7+g9ptxwVomlOCPRUIu5qDgRAK+/NbIVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PageZbud flag to page flags to distinguish pages allocated in zbud.
Currently these pages do not have any flags set.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/page-flags.h |   12 ++++++++++++
 mm/page_alloc.c            |    3 +++
 mm/zbud.c                  |    4 ++++
 3 files changed, 19 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d53675..5b8b61a6 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -109,6 +109,12 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+#ifdef CONFIG_ZBUD
+	/* Allocated by zbud. Flag is necessary to find zbud pages to unuse
+	 * during migration/compaction.
+	 */
+	PG_zbud,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -275,6 +281,12 @@ PAGEFLAG_FALSE(HWPoison)
 #define __PG_HWPOISON 0
 #endif
 
+#ifdef CONFIG_ZBUD
+PAGEFLAG(Zbud, zbud)
+#else
+PAGEFLAG_FALSE(Zbud)
+#endif
+
 u64 stable_page_flags(struct page *page);
 
 static inline int PageUptodate(struct page *page)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b100255..1a120fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6345,6 +6345,9 @@ static const struct trace_print_flags pageflag_names[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+#ifdef CONFIG_ZBUD
+	{1UL << PG_zbud,		"zbud"		},
+#endif
 };
 
 static void dump_page_flags(unsigned long flags)
diff --git a/mm/zbud.c b/mm/zbud.c
index a8e986f..a452949 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -230,7 +230,10 @@ static void get_zbud_page(struct zbud_header *zhdr)
 static int put_zbud_page(struct zbud_pool *pool, struct zbud_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
+	BUG_ON(!PageZbud(page));
+
 	if (put_page_testzero(page)) {
+		ClearPageZbud(page);
 		free_hot_cold_page(page, 0);
 		pool->pages_nr--;
 		return 1;
@@ -341,6 +344,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 	 * don't increase the page count.
 	 */
 	zhdr = init_zbud_page(page);
+	SetPageZbud(page);
 	bud = FIRST;
 
 found:
-- 
1.7.9.5

