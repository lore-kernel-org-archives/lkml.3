Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3L2Cne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:43:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55165 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab3L2CKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:30 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marek Vasut" <marex@denx.de>,
        "Olof Johansson" <olof@lixom.net>,
        "Sergei Ianovich" <ynvich@gmail.com>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.795629417@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 137/185] ARM: pxa: prevent PXA270 occasional reboot
 freezes
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-pxa/reset.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -12,6 +12,7 @@
 
 #include <mach/regs-ost.h>
 #include <mach/reset.h>
+#include <mach/smemc.h>
 
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
@@ -79,6 +80,12 @@ static void do_hw_reset(void)
 	OWER = OWER_WME;
 	OSSR = OSSR_M3;
 	OSMR3 = OSCR + 368640;	/* ... in 100 ms */
+	/*
+	 * SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71)
+	 * we put SDRAM into self-refresh to prevent that
+	 */
+	while (1)
+		writel_relaxed(MDREFR_SLFRSH, MDREFR);
 }
 
 void arch_reset(char mode, const char *cmd)
@@ -99,4 +106,3 @@ void arch_reset(char mode, const char *c
 		break;
 	}
 }
-

