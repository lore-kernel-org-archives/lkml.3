Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaAaMIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:08:18 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56965 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaAaMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:08:17 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Reserve not DMAable space in front of the kernel
Date: Fri, 31 Jan 2014 13:08:05 +0100
Message-Id: <780bb8c8fd752eeace2fd2fbe1d8ed8572dc0d76.1391170073.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-5350-1391170085-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-5350-1391170085-0001

Reserve space from 0x0 - __pa(swapper_pg_dir),
if kernel is loaded from 0, which is not DMAable.
It is causing problem with MMC driver and others
which want to add dma buffers to this space.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Jason: I don't think it is worth to bring 0x8000 magic
value and count minimum from it and phys_addr of swapper_pg_dir.
Full 512k of memory shouldn't be used by DMA.

---
 arch/arm/mach-zynq/common.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 1db2a5ca..8c09a83 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -25,6 +25,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
+#include <linux/memblock.h>
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic.h>

@@ -41,6 +42,18 @@

 void __iomem *zynq_scu_base;

+/**
+ * zynq_memory_init - Initialize special memory
+ *
+ * We need to stop things allocating the low memory as DMA can't work in
+ * the 1st 512K of memory.
+ */
+static void __init zynq_memory_init(void)
+{
+	if (!__pa(PAGE_OFFSET))
+		memblock_reserve(__pa(PAGE_OFFSET), __pa(swapper_pg_dir));
+}
+
 static struct platform_device zynq_cpuidle_device = {
 	.name = "cpuidle-zynq",
 };
@@ -117,5 +130,6 @@ DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.init_machine	= zynq_init_machine,
 	.init_time	= zynq_timer_init,
 	.dt_compat	= zynq_dt_match,
+	.reserve	= zynq_memory_init,
 	.restart	= zynq_system_reset,
 MACHINE_END
--
1.8.2.3


--=_mimegpg-monstr-desktop-5350-1391170085-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrkiUACgkQykllyylKDCFmcACdFp/WhJW5ubtM5GdDSipvmifn
AXAAn22tNAfRFJqYHvlxaf6FD/AE7Hi7
=lkx/
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-5350-1391170085-0001--
