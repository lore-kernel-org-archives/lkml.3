Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3IKI7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:59:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47123 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IKI7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:59:19 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-2b-523030e2cc9b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/5] zbud: make freechunks a block local variable
Date: Wed, 11 Sep 2013 10:59:01 +0200
Message-id: <1378889944-23192-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7qPDAyCDGb/s7GYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF6xeGFmeb3rBbXN41h83i3pr/rBZrj9xlt5j87hmjxbKv79ktDu1bxe7A
	47F4z0smj02rOtk8Nn2axO5xYsZvFo8HhzazeHx8eovFo2/LKkaPzaerPT5vkgvgjOKySUnN
	ySxLLdK3S+DKWHl9GlPBIe6KE2t/MDUwzuXsYuTkkBAwkWi8+4AFwhaTuHBvPVsXIxeHkMBS
	RokrCycwQTh9TBJfrm9kBKliEzCW2Lx8CRuILSLQxygx6bIFSBGzwBkmiWtL/rN3MXJwCAu4
	SLS3KoHUsAioSryauAtsA6+Au8S8pQdZQEokBBQk5kyyATE5BTwkTkxTAKkQAqro/HWObQIj
	7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIYH6dQfj0mNWhxgFOBiVeHgNFPWDhFgT
	y4orcw8xSnAwK4nwvhI1CBLiTUmsrEotyo8vKs1JLT7EyMTBKdXAuLd+w9sZp7uUIlOmnrNI
	COBPe6ZTuriMNTMtL/0hX7Ol1buLUqt+XKg4eUIxuGrxnL6TXuqn439F36kw6ll05JWwZs4R
	JRXTnq2t8xsqnG87nHrpaqXDeu5tuPB3qasrXj9ef+X4AtVf77k8NTefbvLo/nrrxi+5nxue
	9sxReBEVsut56oUvdkosxRmJhlrMRcWJAPgkFjUyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move freechunks variable in zbud_free() and zbud_alloc() to block-level
scope (from function scope).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 mm/zbud.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 3f4be72..1d5b26b 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -267,7 +267,7 @@ void zbud_destroy_pool(struct zbud_pool *pool)
 int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 			unsigned long *handle)
 {
-	int chunks, i, freechunks;
+	int chunks, i;
 	struct zbud_header *zhdr = NULL;
 	enum buddy bud;
 	struct page *page;
@@ -317,7 +317,7 @@ found:
 
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0) {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
+		int freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	} else {
 		/* Add to buddied list */
@@ -349,7 +349,6 @@ found:
 void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
 	struct zbud_header *zhdr;
-	int freechunks;
 
 	spin_lock(&pool->lock);
 	zhdr = handle_to_zbud_header(handle);
@@ -368,7 +367,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
+		int freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	}
 
-- 
1.7.9.5

