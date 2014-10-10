Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaJJCR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 22:17:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58456 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaJJCRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 22:17:25 -0400
X-AuditID: cbfee61a-f79c06d000004e71-91-543741ad34b6
From: Weijie Yang <weijie.yang@samsung.com>
To: iamjoonsoo.kim@lge.com
Cc: mina86@mina86.com, aneesh.kumar@linux.vnet.ibm.com,
        m.szyprowski@samsung.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: [PATCH] mm/cma: fix cma bitmap aligned mask computing
Date: Fri, 10 Oct 2014 10:15:53 +0800
Message-id: <000301cfe430$504b0290$f0e107b0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/kMB4KT5mzhpo3SrexnhnNb4/aVg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jQd21juYhBsf6lCzmrF/DZvH49TwW
	i5XdzWwWl3fNYbO4t+Y/q8XaI3fZLRYcb2F1YPfY9GkSu0fX2ytMHidm/GbxeHBoM4vHuj+v
	mDz6tqxi9Pi8SS6APYrLJiU1J7MstUjfLoErY9+Dq6wFHZwVdzYfZGlgXMvexcjJISFgInF3
	ZROULSZx4d56ti5GLg4hgemMEvMu72GEcP4wSpy78JkJpIpNQFvibv9GVhBbREBK4tT3E0BF
	HBzMAhcZJWbmgISFBewkFp06yghiswioSizff5gFxOYFii84dYIVwhaU+DH5HlicWUBdYtK8
	RcwQtrzE5jVvmUFGSgDFH/3VhdikJ3FqYTs7RIm4xMYjt1gmMArMQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Hh4JrWDcWWDxSFGAQ5GJR7eCzLmIUKsiWXF
	lbmHGCU4mJVEePVNgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFk
	mTg4pRoYI9MtnmoHZn4xSr136t+UHvmiEOXYI18nh3xUZej+vp/1eBHH86dav2rbay4pLm5Z
	cyJX+ZzzhN75YeF/2uxrqq2E2gr+yt1wEmhcHc3z1vlQ3d6Dfm9Ngo4a6gs+CHat+/nIg7H3
	Vykvx/WCkxOlRe7ald4M7rsoEr3pyu27mq9tn4kqJtorsRRnJBpqMRcVJwIA7tje+IMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current cma bitmap aligned mask compute way is incorrect, it could
cause an unexpected align when using cma_alloc() if wanted align order
is bigger than cma->order_per_bit.

Take kvm for example (PAGE_SHIFT = 12), kvm_cma->order_per_bit is set to 6,
when kvm_alloc_rma() tries to alloc kvm_rma_pages, it will input 15 as
expected align value, after using current computing, however, we get 0 as
cma bitmap aligned mask other than 511.

This patch fixes the cma bitmap aligned mask compute way.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index c17751c..f6207ef 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -57,7 +57,10 @@ unsigned long cma_get_size(struct cma *cma)
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1UL << (align_order >> cma->order_per_bit)) - 1;
+	if (align_order <= cma->order_per_bit)
+		return 0;
+	else
+		return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)
-- 
1.7.10.4


