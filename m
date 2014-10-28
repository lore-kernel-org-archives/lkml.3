Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaJ1DlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:41:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaJ1DlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weijie Yang <weijie.yang@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 108/146] mm/cma: fix cma bitmap aligned mask computing
Date: Tue, 28 Oct 2014 11:34:10 +0800
Message-Id: <20141028033348.134575468@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weijie Yang <weijie.yang@samsung.com>

commit 68faed630fc151a7a1c4853df00fb3dcacf782b4 upstream.

The current cma bitmap aligned mask computation is incorrect.  It could
cause an unexpected alignment when using cma_alloc() if the wanted align
order is larger than cma->order_per_bit.

Take kvm for example (PAGE_SHIFT = 12), kvm_cma->order_per_bit is set to
6.  When kvm_alloc_rma() tries to alloc kvm_rma_pages, it will use 15 as
the expected align value.  After using the current implementation however,
we get 0 as cma bitmap aligned mask other than 511.

This patch fixes the cma bitmap aligned mask calculation.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/cma.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -57,7 +57,9 @@ unsigned long cma_get_size(struct cma *c
 
 static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
 {
-	return (1UL << (align_order >> cma->order_per_bit)) - 1;
+	if (align_order <= cma->order_per_bit)
+		return 0;
+	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
 static unsigned long cma_bitmap_maxno(struct cma *cma)


