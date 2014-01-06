Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaAFOhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:37:50 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57387 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaAFOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:46 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] ARM: zynq: Add and use zynq_slcr_read/write() helper functions
Date: Mon,  6 Jan 2014 15:36:42 +0100
Message-Id: <1dc9cc7353d5999f46fd4bae9bdc9fbc56f0c274.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32374-1389019061-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32374-1389019061-0001

Use zynq_slcr_read/write helper functions for reg access
instead of readl/writel.
Also use regmap when it is ready.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/slcr.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index a679dff..f0f6a69 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -35,6 +35,42 @@ static void __iomem *zynq_slcr_base;
 static struct regmap *zynq_slcr_regmap;

 /**
+ * zynq_slcr_write - Write to a register in SLCR block
+ *
+ * @val:	Value to write to the register
+ * @offset:	Register offset in SLCR block
+ *
+ * return:	a negative value on error, 0 on success
+ */
+static int zynq_slcr_write(u32 val, u32 offset)
+{
+	if (!zynq_slcr_regmap) {
+		writel(val, zynq_slcr_base + offset);
+		return 0;
+	}
+
+	return regmap_write(zynq_slcr_regmap, offset, val);
+}
+
+/**
+ * zynq_slcr_read - Read a register in SLCR block
+ *
+ * @val:	Pointer to value to be read from SLCR
+ * @offset:	Register offset in SLCR block
+ *
+ * return:	a negative value on error, 0 on success
+ */
+static int zynq_slcr_read(u32 *val, u32 offset)
+{
+	if (zynq_slcr_regmap)
+		return regmap_read(zynq_slcr_regmap, offset, val);
+
+	*val = readl(zynq_slcr_base + offset);
+
+	return 0;
+}
+
+/**
  * zynq_slcr_system_reset - Reset the entire system.
  */
 void zynq_slcr_system_reset(void)
@@ -53,9 +89,9 @@ void zynq_slcr_system_reset(void)
 	 * the FSBL not loading the bitstream after soft-reboot
 	 * This is a temporary solution until we know more.
 	 */
-	reboot = readl(zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
-	writel(reboot & 0xF0FFFFFF, zynq_slcr_base + SLCR_REBOOT_STATUS_OFFSET);
-	writel(1, zynq_slcr_base + SLCR_PS_RST_CTRL_OFFSET);
+	zynq_slcr_read(&reboot, SLCR_REBOOT_STATUS_OFFSET);
+	zynq_slcr_write(reboot & 0xF0FFFFFF, SLCR_REBOOT_STATUS_OFFSET);
+	zynq_slcr_write(1, SLCR_PS_RST_CTRL_OFFSET);
 }

 /**
@@ -64,11 +100,13 @@ void zynq_slcr_system_reset(void)
  */
 void zynq_slcr_cpu_start(int cpu)
 {
-	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
+	u32 reg;
+
+	zynq_slcr_read(&reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 	reg &= ~(SLCR_A9_CPU_RST << cpu);
-	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
+	zynq_slcr_write(reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 	reg &= ~(SLCR_A9_CPU_CLKSTOP << cpu);
-	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
+	zynq_slcr_write(reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 }

 /**
@@ -77,9 +115,11 @@ void zynq_slcr_cpu_start(int cpu)
  */
 void zynq_slcr_cpu_stop(int cpu)
 {
-	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
+	u32 reg;
+
+	zynq_slcr_read(&reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 	reg |= (SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu;
-	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
+	zynq_slcr_write(reg, SLCR_A9_CPU_RST_CTRL_OFFSET);
 }

 /**
--
1.8.2.3


--=_mimegpg-monstr-desktop-32374-1389019061-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv7UACgkQykllyylKDCEIfQCgg75RmppmO5f1/mCa3PUVrlTO
hxEAoJ2oCeRgx4y5weq2oVx3iMioSqgY
=VHri
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32374-1389019061-0001--
