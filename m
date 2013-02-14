Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159Ab3BNWsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:48:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146Ab3BNWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>, Pavel Machek <pavel@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
Date: Thu, 14 Feb 2013 23:47:50 +0100
Message-Id: <1360882071-4072668-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:V6ldB/2L8w+ngB4V9aDnr5qcSZbLgopqm/mnI30dXr2
 z6OOP44FTJW4EgVLsT2Y3X3hap2YDazJCN9w70V3x+RqSCFMLu
 iGjxTP2ME2WIBAXutyq11/qz2v5qnu7g+poenVVPySZSHwmpQh
 qx5X/CEHjrP1AMEZmzSNGNb2cJF1+RyeWJHq6TotURyp5S94G1
 rM5B8zoBaxFm/tEslhQmOFsP0uPjPkW/LtJFe1Bb9gwjrIYJM2
 D1ggoLE5Epa5ShXmn6qstB0HjQTTOpjfzvdDN455FxCcEmf0mX
 of5WwiUjo+rQG/vBHovSacyspU/1fFK3Ic0TfK5cJZa/0J0pOv
 GCl3/keN/BCFyMTZE1gC8Q84Ofe5N//U5uA4mVbtM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch c08e20d24 "arm: Add v7_invalidate_l1 to cache-v7.S"
moves the v7_invalidate_l1 symbol out of imx/headsmp.S,
which seems to cause a link error because it is now
too far away from v7_cpu_resume when building an
allyesconfig kernel.

If we move the v7_cpu_resume function from the .data
section to .text, that creates another link error
for the reference to phys_l2x0_saved_regs, but we
can move all of the above to .text.

I believe that this is not a correct bug fix but just
a bad workaround, so I'm open to ideas from people
who understand the bigger picture.

Without this patch, building allyesconfig results in:

arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
arch/arm/mach-imx/headsmp.S:55:(.data+0x87f8): relocation truncated to fit: R_ARM_CALL against symbol `v7_invalidate_l1' defined in .text section in arch/arm/mm/built-in.o

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dinh Nguyen <dinguyen@altera.com>
Cc: Pavel Machek <pavel@denx.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-imx/headsmp.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
index 921fc15..0de76cc 100644
--- a/arch/arm/mach-imx/headsmp.S
+++ b/arch/arm/mach-imx/headsmp.S
@@ -30,7 +30,7 @@ ENDPROC(v7_secondary_startup)
  * allow phys_l2x0_saved_regs to be accessed with a relative load
  * as we are running on physical address here.
  */
-	.data
+	.text
 	.align
 
 #ifdef CONFIG_CACHE_L2X0
@@ -51,6 +51,8 @@ phys_l2x0_saved_regs:
 	.endm
 #endif
 
+	.text
+
 ENTRY(v7_cpu_resume)
 	bl	v7_invalidate_l1
 	pl310_resume
-- 
1.8.1.2

