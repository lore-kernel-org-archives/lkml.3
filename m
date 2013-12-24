Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3LXKVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 05:21:24 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:16034
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641Ab3LXKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 05:21:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Anson Huang <b20788@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] ARM: imx: improve the comment of CCM lpm SW workaround
Date: Tue, 24 Dec 2013 17:19:21 -0500
Message-ID: <1387923561-8724-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the comment of SW workaround for CCM lpm issue using
hardware errata description to avoid confusion.

ERR007265:
CCM: When improper low-power sequence is used, the SoC enters
     low power mode before the ARM core executes WFI.

Software workaround:
1) Software should trigger IRQ #32 (IOMUX) to be always pending
   by setting IOMUX_GPR1_GINT.
2) Software should then unmask IRQ #32 in GPC before setting CCM
   Low-Power mode.
3) Software should mask IRQ #32 right after CCM Low-Power mode is
   set (set bits 0-1 of CCM_CLPCR).

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 arch/arm/mach-imx/pm-imx6q.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index aecd9f8..31cb9d6 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -156,10 +156,13 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 	}
 
 	/*
-	 * Unmask the always pending IOMUXC interrupt #32 as wakeup source to
-	 * deassert dsm_request signal, so that we can ensure dsm_request
-	 * is not asserted when we're going to write CLPCR register to set LPM.
-	 * After setting up LPM bits, we need to mask this wakeup source.
+	 * ERR007265:
+	 * CCM: When improper low-power sequence is used, the SoC enters low power mode before the ARM core executes WFI.
+	 *
+	 * Software workaround:
+	 * 1) Software should trigger IRQ #32 (IOMUX) to be always pending by setting IOMUX_GPR1_GINT.
+	 * 2) Software should then unmask IRQ #32 in GPC before setting CCM Low-Power mode.
+	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode is set (set bits 0-1 of CCM_CLPCR).
 	 */
 	iomuxc_irq_desc = irq_to_desc(32);
 	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
@@ -219,6 +222,8 @@ void __init imx6q_pm_init(void)
 	WARN_ON(!ccm_base);
 
 	/*
+	 * This is for SW workaround step #1 of ERR007265, see comments
+	 * in imx6q_set_lpm for details of this errata.
 	 * Force IOMUXC irq pending, so that the interrupt to GPC can be
 	 * used to deassert dsm_request signal when the signal gets
 	 * asserted unexpectedly.
-- 
1.7.9.5


