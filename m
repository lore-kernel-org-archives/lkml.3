Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaC3Xll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:41:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ralf Baechle" <ralf@linux-mips.org>,
        "James Rodriguez" <jamesr@juniper.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.542911354@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 114/200] MIPS: Fix potencial corruption
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit a16dad7763420a3b46cff1e703a9070827796cfc upstream.

Normally r4k_dma_cache_inv should only ever be called with cacheline
aligned addresses.  If however, it isn't there is the theoretical
possibility of data corruption.  There is no correct way of handling this
and anyway, it should only happen if the DMA API is used incorrectly
so drop

There is a different corruption scenario with these CACHE instructions
removed but again there is no way of handling this correctly and it can
be triggered only through incorrect use of the DMA API.

So just get rid of the complexity.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reported-by: James Rodriguez <jamesr@juniper.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/c-r4k.c | 11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -633,9 +633,6 @@ static void r4k_dma_cache_inv(unsigned l
 		if (size >= scache_size)
 			r4k_blast_scache();
 		else {
-			unsigned long lsize = cpu_scache_line_size();
-			unsigned long almask = ~(lsize - 1);
-
 			/*
 			 * There is no clearly documented alignment requirement
 			 * for the cache instruction on MIPS processors and
@@ -644,9 +641,6 @@ static void r4k_dma_cache_inv(unsigned l
 			 * hit ops with insufficient alignment.  Solved by
 			 * aligning the address to cache line size.
 			 */
-			cache_op(Hit_Writeback_Inv_SD, addr & almask);
-			cache_op(Hit_Writeback_Inv_SD,
-				 (addr + size - 1) & almask);
 			blast_inv_scache_range(addr, addr + size);
 		}
 		__sync();
@@ -656,12 +650,7 @@ static void r4k_dma_cache_inv(unsigned l
 	if (cpu_has_safe_index_cacheops && size >= dcache_size) {
 		r4k_blast_dcache();
 	} else {
-		unsigned long lsize = cpu_dcache_line_size();
-		unsigned long almask = ~(lsize - 1);
-
 		R4600_HIT_CACHEOP_WAR_IMPL;
-		cache_op(Hit_Writeback_Inv_D, addr & almask);
-		cache_op(Hit_Writeback_Inv_D, (addr + size - 1)  & almask);
 		blast_inv_dcache_range(addr, addr + size);
 	}
 

