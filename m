Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbaJDA2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:28:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbaJCVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: [PATCH 3.16 179/357] ARM: dts: imx53-qsrb: Fix suspend/resume
Date: Fri,  3 Oct 2014 14:29:25 -0700
Message-Id: <20141003212938.859345303@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 090727b880ff3c56e333f267cc24ab076f3bc096 upstream.

The following error is seen after a suspend/resume cycle on a mx53qsb with a
MC34708 PMIC:

root@freescale /$ echo mem > /sys/power/state
[   32.630592] PM: Syncing filesystems ... done.
[   32.643924] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   32.652384] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   32.679156] PM: suspend of devices complete after 13.113 msecs
[   32.685128] PM: suspend devices took 0.030 seconds
[   32.696109] PM: late suspend of devices complete after 6.133 msecs
[   33.313032] mc13xxx 0-0008: Failed to read IRQ status: -110
[   33.322009] PM: noirq suspend of devices complete after 619.667 msecs
[   33.328544] Disabling non-boot CPUs ...
[   33.335031] PM: noirq resume of devices complete after 2.352 msecs
[   33.842940] mc13xxx 0-0008: Failed to read IRQ status: -110
[   33.976095] [sched_delayed] sched: RT throttling activated
[   33.984804] PM: early resume of devices complete after 642.642 msecs
[   34.352954] mc13xxx 0-0008: Failed to read IRQ status: -110
[   34.862910] mc13xxx 0-0008: Failed to read IRQ status: -110
[   34.996595] PM: resume of devices complete after 1005.367 msecs
[   35.372925] mc13xxx 0-0008: Failed to read IRQ status: -110
[   35.882911] mc13xxx 0-0008: Failed to read IRQ status: -110
[   35.955707] PM: resume devices took 1.970 seconds
[   35.960445] Restarting tasks ... done.
[   35.993386] fec 63fec000.ethernet eth0: Link is Down
[   36.392980] mc13xxx 0-0008: Failed to read IRQ status: -110
[   36.902908] mc13xxx 0-0008: Failed to read IRQ status: -110
[   36.953036] ata1: SATA link down (SStatus 0 SControl 300)
[   37.412922] mc13xxx 0-0008: Failed to read IRQ status: -110
[   37.922906] mc13xxx 0-0008: Failed to read IRQ status: -110
[   37.993379] fec 63fec000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
[   38.432938] mc13xxx 0-0008: Failed to read IRQ status: -110
[   38.942920] mc13xxx 0-0008: Failed to read IRQ status: -110
[   39.452933] mc13xxx 0-0008: Failed to read IRQ status: -110

(flood of this error message continues forever)

Commit 5169df8be0a432ee ("ARM: dts: i.MX53: add support for MCIMX53-START-R")
missed to configure the IOMUX for the PMIC IRQ pin.

Configure the PMIC IRQ pin so that the suspend/resume sequence behaves cleanly
as expected.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx53-qsrb.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/boot/dts/imx53-qsrb.dts
+++ b/arch/arm/boot/dts/imx53-qsrb.dts
@@ -28,6 +28,12 @@
 				MX53_PAD_CSI0_DAT9__I2C1_SCL      0x400001ec
 			>;
 		};
+
+		pinctrl_pmic: pmicgrp {
+			fsl,pins = <
+				MX53_PAD_CSI0_DAT5__GPIO5_23	0x1e4 /* IRQ */
+			>;
+		};
 	};
 };
 
@@ -38,6 +44,8 @@
 
 	pmic: mc34708@8 {
 		compatible = "fsl,mc34708";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x08>;
 		interrupt-parent = <&gpio5>;
 		interrupts = <23 0x8>;


