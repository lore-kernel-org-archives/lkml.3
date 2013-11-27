Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3K0PT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:19:57 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:38004 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab3K0PTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:19:54 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Rob Herring <rob.herring@calxeda.com>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH v2] ARM: OMAP4/highbank: Flush L2 cache before disabling
Date: Wed, 27 Nov 2013 17:19:44 +0200
Message-Id: <1385565585-28306-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec disables outer cache before jumping to reboot code, but it doesn't
flush it explicitly. Flush is done implicitly inside of l2x0_disable().
But some SoC's override default .disable handler and don't flush cache.
This may lead to a corrupted memory during Kexec reboot on these
platforms.

This patch adds cache flush inside of OMAP4 and Highbank outer_cache.disable()
handlers to make it consistent with default l2x0_disable().

Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
I was not aware about Russell's patch tracker process, so this patch
was not hooked there. Highbank moved to PSCI since then, so patch
has to be slightly modified.

Rob, are you still ok with this patch?

v1..v2: Removed changes in highbank_suspend_finish since after
        commit dd68eb0 "ARM: highbank: adapt to use ARM PSCI calls"
        cache is not explicitly disabled there.

v1: http://www.spinics.net/lists/linux-omap/msg98318.html

RFC v2: https://patchwork.kernel.org/patch/2990231/
        Make the fix specific to platforms that don't use
	l2x0_disable().
RFC v1: https://patchwork.kernel.org/patch/2974431/

Based on v3.13-rc1
---
 arch/arm/mach-highbank/highbank.c  |    1 +
 arch/arm/mach-omap2/omap4-common.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index b3d7e56..ae17150 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -50,6 +50,7 @@ static void __init highbank_scu_map_io(void)
 
 static void highbank_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	highbank_smc1(0x102, 0x0);
 }
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index b39efd4..c0ab9b2 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -162,6 +162,7 @@ void __iomem *omap4_get_l2cache_base(void)
 
 static void omap4_l2x0_disable(void)
 {
+	outer_flush_all();
 	/* Disable PL310 L2 Cache controller */
 	omap_smc1(0x102, 0x0);
 }
-- 
1.7.9.5

