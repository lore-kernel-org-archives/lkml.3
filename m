Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KPADw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:03:52 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46337 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3KPAB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:57 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 19/23] ARM: OMAP: counter-32k: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:22 +0200
Message-Id: <1384560086-11994-20-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/plat-omap/counter_32k.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index d9bc98e..21ca329 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -40,7 +40,7 @@ static void __iomem *sync32k_cnt_reg;
 
 static u32 notrace omap_32k_read_sched_clock(void)
 {
-	return sync32k_cnt_reg ? __raw_readl(sync32k_cnt_reg) : 0;
+	return sync32k_cnt_reg ? readl_relaxed(sync32k_cnt_reg) : 0;
 }
 
 /**
@@ -64,7 +64,7 @@ static void omap_read_persistent_clock(struct timespec *ts)
 	spin_lock_irqsave(&read_persistent_clock_lock, flags);
 
 	last_cycles = cycles;
-	cycles = sync32k_cnt_reg ? __raw_readl(sync32k_cnt_reg) : 0;
+	cycles = sync32k_cnt_reg ? readl_relaxed(sync32k_cnt_reg) : 0;
 
 	nsecs = clocksource_cyc2ns(cycles - last_cycles,
 					persistent_mult, persistent_shift);
@@ -95,7 +95,7 @@ int __init omap_init_clocksource_32k(void __iomem *vbase)
 	 * The 'SCHEME' bits(30-31) of the revision register is used
 	 * to identify the version.
 	 */
-	if (__raw_readl(vbase + OMAP2_32KSYNCNT_REV_OFF) &
+	if (readl_relaxed(vbase + OMAP2_32KSYNCNT_REV_OFF) &
 						OMAP2_32KSYNCNT_REV_SCHEME)
 		sync32k_cnt_reg = vbase + OMAP2_32KSYNCNT_CR_OFF_HIGH;
 	else
-- 
1.7.9.5

