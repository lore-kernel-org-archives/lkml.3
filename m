Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaIEL2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:28:06 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:56283 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756478AbaIEL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:28:03 -0400
Message-ID: <1409916481.7832.19.camel@x220>
Subject: [PATCH] [next-20140904] staging: gs_fpgaboot: remove checks for
 CONFIG_B4860G100
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 13:28:01 +0200
In-Reply-To: <20140904232108.GD4030@kroah.com>
References: <20140401184817.GA21855@kroah.com>
	 <1396427043.18431.20.camel@x220> <20140402200428.GE26966@kroah.com>
	 <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
	 <20140402230837.GA24324@kroah.com> <1409872435.5546.135.camel@x220>
	 <20140904232108.GD4030@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 11:28:01.0926 (UTC) FILETIME=[73ED0260:01CFC8FC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for CONFIG_B4860G100 in this driver. But there's no
Kconfig symbol B4860G100. These checks will always evaluate to false.
Remove them and the code they hide.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Build tested only (by building just drivers/staging/gs_fpgaboot/io.o).

Perhaps this enables further cleanups. I didn't check.

 drivers/staging/gs_fpgaboot/io.c | 163 ---------------------------------------
 1 file changed, 163 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/io.c b/drivers/staging/gs_fpgaboot/io.c
index 23c12f47c8f1..d0168bec40b9 100644
--- a/drivers/staging/gs_fpgaboot/io.c
+++ b/drivers/staging/gs_fpgaboot/io.c
@@ -31,10 +31,6 @@
 
 #include "io.h"
 
-#ifdef CONFIG_B4860G100
-static struct gpiobus gbus;
-#endif /* CONFIG_B4860G100 */
-
 static inline void byte0_out(unsigned char data);
 static inline void byte1_out(unsigned char data);
 static inline void xl_cclk_b(int32_t i);
@@ -92,163 +88,6 @@ static inline unsigned char bitswap(unsigned char s)
 	return d;
 }
 
-#ifdef CONFIG_B4860G100
-/*
- * ======================================================================
- * board specific configuration
- */
-
-static inline void mpc85xx_gpio_set_dir(
-			int32_t port,
-			uint32_t mask,
-			uint32_t dir)
-{
-	dir |= (in_be32(gbus.r[port]+GPDIR) & ~mask);
-	out_be32(gbus.r[port]+GPDIR, dir);
-}
-
-static inline void mpc85xx_gpio_set(int32_t port, uint32_t mask, uint32_t val)
-{
-	/* First mask off the unwanted parts of "dir" and "val" */
-	val &= mask;
-
-	/* Now read in the values we're supposed to preserve */
-	val |= (in_be32(gbus.r[port]+GPDAT) & ~mask);
-
-	out_be32(gbus.r[port]+GPDAT, val);
-}
-
-static inline uint32_t mpc85xx_gpio_get(int32_t port, uint32_t mask)
-{
-	/* Read the requested values */
-	return in_be32(gbus.r[port]+GPDAT) & mask;
-}
-
-static inline void mpc85xx_gpio_set_low(int32_t port, uint32_t gpios)
-{
-	mpc85xx_gpio_set(port, gpios, 0x00000000);
-}
-
-static inline void mpc85xx_gpio_set_high(int32_t port, uint32_t gpios)
-{
-	mpc85xx_gpio_set(port, gpios, 0xFFFFFFFF);
-}
-
-static inline void gpio_set_value(int32_t port, uint32_t gpio, uint32_t value)
-{
-	int32_t g;
-
-	g = 31 - gpio;
-	if (value)
-		mpc85xx_gpio_set_high(port, 1U << g);
-	else
-		mpc85xx_gpio_set_low(port, 1U << g);
-}
-
-static inline int gpio_get_value(int32_t port, uint32_t gpio)
-{
-	int32_t g;
-
-	g = 31 - gpio;
-	return !!mpc85xx_gpio_get(port, 1U << g);
-}
-
-static inline void xl_cclk_b(int32_t i)
-{
-	gpio_set_value(XL_CCLK_PORT, XL_CCLK_PIN, i);
-}
-
-void xl_program_b(int32_t i)
-{
-	gpio_set_value(XL_PROGN_PORT, XL_PROGN_PIN, i);
-}
-
-void xl_rdwr_b(int32_t i)
-{
-	gpio_set_value(XL_RDWRN_PORT, XL_RDWRN_PIN, i);
-}
-
-void xl_csi_b(int32_t i)
-{
-	gpio_set_value(XL_CSIN_PORT, XL_CSIN_PIN, i);
-}
-
-int xl_get_init_b(void)
-{
-	return gpio_get_value(XL_INITN_PORT, XL_INITN_PIN);
-}
-
-int xl_get_done_b(void)
-{
-	return gpio_get_value(XL_DONE_PORT, XL_DONE_PIN);
-}
-
-
-/* G100 specific bit swap and remmap (to gpio pins) for byte 0 */
-static inline uint32_t bit_remap_byte0(uint32_t s)
-{
-	uint32_t d;
-
-	d = (((s&0x80)>>7) | ((s&0x40)>>5) | ((s&0x20)>>3) | ((s&0x10)>>1) |
-		((s&0x08)<<1) | ((s&0x04)<<3) | ((s&0x02)<<6) | ((s&0x01)<<9));
-	return d;
-}
-
-/*
- * G100 specific MSB, in this order [byte0 | byte1], out
- */
-static inline void byte0_out(unsigned char data)
-{
-	uint32_t swap32;
-
-	swap32 =  bit_remap_byte0((uint32_t) data) << 8;
-
-	mpc85xx_gpio_set(0, 0x0002BF00, (uint32_t) swap32);
-}
-
-/*
- * G100 specific LSB, in this order [byte0 | byte1], out
- */
-static inline void byte1_out(unsigned char data)
-{
-	mpc85xx_gpio_set(0, 0x000000FF, (uint32_t) bitswap(data));
-}
-
-/*
- * configurable per device type for different I/O config
- */
-int xl_init_io(void)
-{
-	struct device_node *np;
-	const u32 *p_reg;
-	int reg, cnt;
-
-	cnt = 0;
-	memset(&gbus, 0, sizeof(struct gpiobus));
-	for_each_compatible_node(np, NULL, "fsl,qoriq-gpio") {
-		p_reg = of_get_property(np, "reg", NULL);
-		if (p_reg == NULL)
-			break;
-		reg = (int) *p_reg;
-		gbus.r[cnt] = of_iomap(np, 0);
-
-		if (!gbus.r[cnt]) {
-			pr_err("not findding gpio cell-index %d\n", cnt);
-			return -ENODEV;
-		}
-		cnt++;
-	}
-	mpc85xx_gpio_set_dir(0, 0x0002BFFF, 0x0002BFFF);
-	mpc85xx_gpio_set_dir(1, 0x00240060, 0x00240060);
-
-	gbus.ngpio = cnt;
-
-	return 0;
-}
-
-
-#else	/* placeholder for boards with different config */
-
 void xl_program_b(int32_t i)
 {
 	return;
@@ -296,5 +135,3 @@ int xl_init_io(void)
 {
 	return -1;
 }
-
-#endif /* CONFIG_B4860G100 */
-- 
1.9.3

