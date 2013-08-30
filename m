Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3H3J4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:56:34 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:45946 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3H3J4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:56:32 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>, joe@perches.com,
        linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: Fix __udelay calculation
Date: Fri, 30 Aug 2013 11:56:25 +0200
Message-Id: <1377856585-11078-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cast usecs to u64, to ensure that the (usecs * 4295 * HZ)
multiplication is 64 bit.

Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
multiplication, with the result casted to 64 bit. This led to some bits
falling off, causing a "DMA initialization error" in the stmmac Ethernet
driver, due to a premature timeout.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/include/asm/delay.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
index 442ce5d..43de302 100644
--- a/arch/arc/include/asm/delay.h
+++ b/arch/arc/include/asm/delay.h
@@ -53,11 +53,10 @@ static inline void __udelay(unsigned long usecs)
 {
 	unsigned long loops;
 
-	/* (long long) cast ensures 64 bit MPY - real or emulated
+	/* (u64) cast ensures 64 bit MPY - real or emulated
 	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
 	 */
-	loops = ((long long)(usecs * 4295 * HZ) *
-		 (long long)(loops_per_jiffy)) >> 32;
+	loops = ((u64) usecs * 4295 * HZ * loops_per_jiffy) >> 32;
 
 	__delay(loops);
 }
-- 
1.7.9.5

