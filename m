Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3JHNbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:31:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22713 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3JHNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:30:06 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-e8-525408db4262
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 2/6] zbud: make freechunks a block local variable
Date: Tue, 08 Oct 2013 15:29:36 +0200
Message-id: <1381238980-2491-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xa7q3OUKCDB6stbKYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF6xeGFmeb3rBbXN41h83i3pr/rBZrj9xlt5j87hmjxbKv79ktDu1bxW4x
	r/0lqwOvx+I9L5k8Nq3qZPPY9GkSu8eJGb9ZPB4c2szi8fHpLRaPvi2rGD02n672+LxJLoAz
	issmJTUnsyy1SN8ugSvj7A2dgkPcFYvut7I1MM7l7GLk4JAQMJG4NMu4i5ETyBSTuHBvPVsX
	IxeHkMBSRon2Sf8YIZw+JokX8+czg1SxCRhLbF6+hA3EFhHoY5SYdNkCpIhZ4B+TxIQdl5lA
	EsICLhLTL95jAdnAIqAqceR6DEiYV8BNovvgN0aIxQoScybZgJicAu4SCw5KgFQIAVX83vqE
	aQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIeH6dQfj0mNWhxgFOBiVeHgFDgcF
	CbEmlhVX5h5ilOBgVhLh5fsfHCTEm5JYWZValB9fVJqTWnyIkYmDU6qB0WjV2k3LmB18Spwc
	t/Zv5ve6fedTaA7bc0Vj1QLlJ4aXy3QePjy74djhwCUVKmEmql0vAiZtU5H3uxJrWbAv/op4
	ddKyezsK82xeha+/N+mO3EWn7as+Pfa/ZHM96OTNp8uPKieFNXxleTFd6nKdyrIyrt47zyNj
	W2rTu52CmloqLhVOY424rMRSnJFoqMVcVJwIACYsiZ81AgAA
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
index 7574289..e19f36a 100644
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

