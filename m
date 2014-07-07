Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaGGXzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:55:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaGGXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Steve Capper <steve.capper@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.14 56/94] arm64: mm: Make icache synchronisation logic huge page aware
Date: Mon,  7 Jul 2014 16:57:46 -0700
Message-Id: <20140707235758.442350765@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/flush.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -79,7 +79,8 @@ void __sync_icache_dcache(pte_t pte, uns
 		return;
 
 	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
-		__flush_dcache_area(page_address(page), PAGE_SIZE);
+		__flush_dcache_area(page_address(page),
+				PAGE_SIZE << compound_order(page));
 		__flush_icache_all();
 	} else if (icache_is_aivivt()) {
 		__flush_icache_all();


