Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbaGRNm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:42:26 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17623 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934880AbaGRNMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/170] arm64: mm: Make icache synchronisation logic huge page aware
Date: Fri, 18 Jul 2014 14:11:47 +0200
Message-Id: <9bc36a69453aa869f5a9ef444b9c194e7408bde7.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Capper <steve.capper@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 923b8f5044da753e4985ab15c1374ced2cdf616c upstream.

The __sync_icache_dcache routine will only flush the dcache for the
first page of a compound page, potentially leading to stale icache
data residing further on in a hugetlb page.

This patch addresses this issue by taking into consideration the
order of the page when flushing the dcache.

Reported-by: Mark Brown <broonie@linaro.org>
Tested-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Steve Capper <steve.capper@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/mm/flush.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
index e4193e3adc7f..0d64089d28b5 100644
--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -79,7 +79,8 @@ void __sync_icache_dcache(pte_t pte, unsigned long addr)
 		return;
 
 	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
-		__flush_dcache_area(page_address(page), PAGE_SIZE);
+		__flush_dcache_area(page_address(page),
+				PAGE_SIZE << compound_order(page));
 		__flush_icache_all();
 	} else if (icache_is_aivivt()) {
 		__flush_icache_all();
-- 
2.0.0

