Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3LSMIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:08:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3LSL7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Ianovich <ynvich@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 187/208] ARM: pxa: prevent PXA270 occasional reboot freezes
Date: Thu, 19 Dec 2013 11:54:45 +0000
Message-Id: <1387454106-19326-188-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-pxa/reset.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
index 0d5dd64..263b152 100644
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
 
 void pxa_restart(enum reboot_mode mode, const char *cmd)
@@ -104,4 +111,3 @@ void pxa_restart(enum reboot_mode mode, const char *cmd)
 		break;
 	}
 }
-
-- 
1.8.3.2

