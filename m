Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3CONzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:55:53 -0400
Received: from multi.imgtec.com ([194.200.65.239]:35784 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3CONzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:55:13 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/3] metag: cachepart: take into account small cache bits
Date: Fri, 15 Mar 2013 13:55:02 +0000
Message-ID: <1363355703-23654-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
References: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_55_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CORE_CONFIG2 register has bits to indicate that the data or code
cache is small, i.e. that the size described in the field should be
divided by 64. Take this into account in get_icache_size() and
get_dcache_size().

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/cachepart.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
index 3a589dfb..c737edb 100644
--- a/arch/metag/kernel/cachepart.c
+++ b/arch/metag/kernel/cachepart.c
@@ -24,15 +24,21 @@
 unsigned int get_dcache_size(void)
 {
 	unsigned int config2 = metag_in32(METAC_CORE_CONFIG2);
-	return 0x1000 << ((config2 & METAC_CORECFG2_DCSZ_BITS)
-				>> METAC_CORECFG2_DCSZ_S);
+	unsigned int sz = 0x1000 << ((config2 & METAC_CORECFG2_DCSZ_BITS)
+				     >> METAC_CORECFG2_DCSZ_S);
+	if (config2 & METAC_CORECFG2_DCSMALL_BIT)
+		sz >>= 6;
+	return sz;
 }
 
 unsigned int get_icache_size(void)
 {
 	unsigned int config2 = metag_in32(METAC_CORE_CONFIG2);
-	return 0x1000 << ((config2 & METAC_CORE_C2ICSZ_BITS)
-				>> METAC_CORE_C2ICSZ_S);
+	unsigned int sz = 0x1000 << ((config2 & METAC_CORE_C2ICSZ_BITS)
+				     >> METAC_CORE_C2ICSZ_S);
+	if (config2 & METAC_CORECFG2_ICSMALL_BIT)
+		sz >>= 6;
+	return sz;
 }
 
 unsigned int get_global_dcache_size(void)
-- 
1.8.1.2


