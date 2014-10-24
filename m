Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbaJXKT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:19:26 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:44723 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbaJXKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:18:49 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Weijie Yang <weijie.yang.kh@gmail.com>
Subject: [PATCH v2 2/4] mm: cma: Always consider a 0 base address reservation as dynamic
Date: Fri, 24 Oct 2014 13:18:40 +0300
Message-Id: <1414145922-26042-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414145922-26042-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixed parameter to cma_declare_contiguous() tells the function
whether the given base address must be honoured or should be considered
as a hint only. The API considers a zero base address as meaning any
base address, which must never be considered as a fixed value.

Part of the implementation correctly checks both fixed and base != 0,
but two locations check the fixed value only. Set fixed to false when
base is 0 to fix that and simplify the code.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 5aa1a6f74dec..62a5dccc3fb8 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -245,6 +245,9 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
 
+	if (!base)
+		fixed = false;
+
 	/* size should be aligned with order_per_bit */
 	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
 		return -EINVAL;
@@ -268,7 +271,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	}
 
 	/* Reserve memory */
-	if (base && fixed) {
+	if (fixed) {
 		if (memblock_is_region_reserved(base, size) ||
 		    memblock_reserve(base, size) < 0) {
 			ret = -EBUSY;
-- 
2.0.4

