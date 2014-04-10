Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbaDJDXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934668AbaDJDV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Ianovich <ynvich@gmail.com>, Marek Vasut <marex@denx.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Olof Johansson <olof@lixom.net>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 035/134] ARM: pxa: prevent PXA270 occasional reboot freezes
Date: Wed,  9 Apr 2014 20:22:31 -0700
Message-Id: <20140410032304.480910775@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-pxa/reset.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -13,6 +13,7 @@
 
 #include <mach/regs-ost.h>
 #include <mach/reset.h>
+#include <mach/smemc.h>
 
 unsigned int reset_status;
 EXPORT_SYMBOL(reset_status);
@@ -80,6 +81,12 @@ static void do_hw_reset(void)
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
 
 void pxa_restart(char mode, const char *cmd)
@@ -103,4 +110,3 @@ void pxa_restart(char mode, const char *
 		break;
 	}
 }
-


