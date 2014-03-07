Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaCGJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:47:13 -0500
Received: from smtprelay.synopsys.com ([198.182.44.111]:36703 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaCGJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:47:10 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <torvalds@linux-foundation.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-kernel@vger.kernel.org>,
        <arc-linux-dev@synopsys.com>
Subject: 
Date: Fri, 7 Mar 2014 15:16:15 +0530
Message-ID: <1394185596-29471-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch fixes a subtle issue with cache flush which could potentially
cause random userspace crashes because of stale icache lines.

Please apply for 3.14, it's marked for stable as well.

Thx,
-Vineet

-------------->8------------
>From 036837642ed6df39f6a063ad10327787b60d4a0f Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Fri, 7 Mar 2014 13:22:22 +0530
Subject: [PATCH] ARC: Use correct PTAG register for icache flush

This error crept in when consolidating the cache flush code

Fixes: bd12976c3664 (ARC: cacheflush refactor #3: Unify the {d,i}cache)
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org  # 3.13
Cc: arc-linux-dev@synopsys.com
---
 arch/arc/mm/cache_arc700.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 6b58c1de7577..400c663b21c2 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -282,7 +282,7 @@ static inline void __cache_line_loop(unsigned long paddr, unsigned long vaddr,
 #else
 	/* if V-P const for loop, PTAG can be written once outside loop */
 	if (full_page_op)
-		write_aux_reg(ARC_REG_DC_PTAG, paddr);
+		write_aux_reg(aux_tag, paddr);
 #endif
 
 	while (num_lines-- > 0) {
@@ -296,7 +296,7 @@ static inline void __cache_line_loop(unsigned long paddr, unsigned long vaddr,
 		write_aux_reg(aux_cmd, vaddr);
 		vaddr += L1_CACHE_BYTES;
 #else
-		write_aux_reg(aux, paddr);
+		write_aux_reg(aux_cmd, paddr);
 		paddr += L1_CACHE_BYTES;
 #endif
 	}
-- 
1.8.3.2

