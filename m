Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaAOWLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:11:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaAOV7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 045/166] ARM: pxa: prevent PXA270 occasional reboot freezes
Date: Wed, 15 Jan 2014 13:50:59 -0800
Message-Id: <1389822780-4729-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Ianovich <ynvich@gmail.com>

commit ff88b4724fde18056a4c539f7327389aec0f4c2d upstream.

Erratum 71 of PXA270M Processor Family Specification Update
(April 19, 2010) explains that watchdog reset time is just
8us insead of 10ms in EMTS.

If SDRAM is not reset, it causes memory bus congestion and
the device hangs. We put SDRAM in selfresh mode before watchdog
reset, removing potential freezes.

Without this patch PXA270-based ICP DAS LP-8x4x hangs after up to 40
reboots. With this patch it has successfully rebooted 500 times.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
Tested-by: Marek Vasut <marex@denx.de>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-pxa/reset.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
index 3fab583..0616390 100644
--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -13,6 +13,7 @@
 
 #include <mach/regs-ost.h>
 #include <mach/reset.h>
+#include <mach/smemc.h>
 
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
@@ -81,6 +82,12 @@ static void do_hw_reset(void)
 	writel_relaxed(OSSR_M3, OSSR);
 	/* ... in 100 ms */
 	writel_relaxed(readl_relaxed(OSCR) + 368640, OSMR3);
+	/*
+	 * SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71)
+	 * we put SDRAM into self-refresh to prevent that
+	 */
+	while (1)
+		writel_relaxed(MDREFR_SLFRSH, MDREFR);
 }
 
 void pxa_restart(char mode, const char *cmd)
@@ -104,4 +111,3 @@ void pxa_restart(char mode, const char *cmd)
 		break;
 	}
 }
-
-- 
1.8.3.2

