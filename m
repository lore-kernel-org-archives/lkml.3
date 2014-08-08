Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaHHV20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:28:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573AbaHHUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/259] arm64: mm: Make icache synchronisation logic huge page aware
Date: Fri,  8 Aug 2014 13:38:00 -0700
Message-Id: <1407530482-4483-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Capper <steve.capper@linaro.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/mm/flush.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
index e4193e3..0d64089 100644
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
1.9.1

