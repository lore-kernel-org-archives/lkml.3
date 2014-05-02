Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaEBPVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:21:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaEBPVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:21:09 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 1/2] arm64: fix unnecessary tlb flushes
Date: Fri,  2 May 2014 11:20:34 -0400
Message-Id: <1399044035-11274-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1399044035-11274-1-git-send-email-msalter@redhat.com>
References: <1399044035-11274-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpu_flush_user_tlb_range() and __cpu_flush_user_tlb_range()
functions loop through an address range by page to flush tlb entries.
However, these functions assume a 4K page size. If the kernel is
configured for 64k page sizes, these functions would execute the
tlbi instruction 16 times per page rather than once. This patch
uses the PAGE_SHIFT definition to ensure one tlb flush for any
given page in the range.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/mm/tlb.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/tlb.S b/arch/arm64/mm/tlb.S
index 19da91e..b818073 100644
--- a/arch/arm64/mm/tlb.S
+++ b/arch/arm64/mm/tlb.S
@@ -42,7 +42,7 @@ ENTRY(__cpu_flush_user_tlb_range)
 	bfi	x0, x3, #48, #16		// start VA and ASID
 	bfi	x1, x3, #48, #16		// end VA and ASID
 1:	tlbi	vae1is, x0			// TLB invalidate by address and ASID
-	add	x0, x0, #1
+	add	x0, x0, #(1 << (PAGE_SHIFT - 12))
 	cmp	x0, x1
 	b.lo	1b
 	dsb	sy
@@ -62,7 +62,7 @@ ENTRY(__cpu_flush_kern_tlb_range)
 	lsr	x0, x0, #12			// align address
 	lsr	x1, x1, #12
 1:	tlbi	vaae1is, x0			// TLB invalidate by address
-	add	x0, x0, #1
+	add	x0, x0, #(1 << (PAGE_SHIFT - 12))
 	cmp	x0, x1
 	b.lo	1b
 	dsb	sy
-- 
1.9.0

