Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3FCHhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:37:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3FCHhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:37:25 -0400
From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
To: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5] i2c: omap: correct usage of the interrupt enable register
Date: Mon, 3 Jun 2013 10:37:20 +0300
Message-ID: <1370245040-14753-1-git-send-email-oleksandr.dmytryshyn@ti.com>
X-Mailer: git-send-email 1.8.2.rc2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been lucky not to have any interrupts fire during the suspend
path, otherwise we would have unpredictable behaviour in the kernel.

Based on the logic of the kernel code interrupts from i2c should be
prohibited during suspend. Kernel writes 0 to the I2C_IE register in
the omap_i2c_runtime_suspend() function. In the other side kernel
writes saved interrupt flags to the I2C_IE register in
omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
during suspend.

This works for chips with version1 registers scheme. Interrupts are
disabled during suspend. For chips with version2 scheme registers
writting 0 to the I2C_IE register does nothing (because now the
I2C_IRQENABLE_SET register is located at this address). This register
is used to enable interrupts. For disabling interrupts
I2C_IRQENABLE_CLR register should be used.

Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
addresses, the interrupt enabling procedure is unchanged.

I've checked that interrupts in the i2c controller are still enabled
after writting 0 to the I2C_IRQENABLE_SET register. With this patch
interrupts are disabled in the omap_i2c_runtime_suspend() function.

Patch is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
tag: v3.10-rc2

Verified on OMAP4430.

Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
---
 drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e02f9e3..64c26f9 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -180,6 +180,8 @@ enum {
 #define I2C_OMAP_ERRATA_I207		(1 << 0)
 #define I2C_OMAP_ERRATA_I462		(1 << 1)
 
+#define OMAP_I2C_IP_V2_INTERRUPTS_MASK	0x6FFF
+
 struct omap_i2c_dev {
 	spinlock_t		lock;		/* IRQ synchronization */
 	struct device		*dev;
@@ -193,6 +195,7 @@ struct omap_i2c_dev {
 						    long latency);
 	u32			speed;		/* Speed of bus in kHz */
 	u32			flags;
+	u16			scheme;
 	u16			cmd_err;
 	u8			*buf;
 	u8			*regs;
@@ -1082,7 +1085,7 @@ omap_i2c_probe(struct platform_device *pdev)
 	int irq;
 	int r;
 	u32 rev;
-	u16 minor, major, scheme;
+	u16 minor, major;
 
 	/* NOTE: driver uses the static register mapping */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1159,8 +1162,8 @@ omap_i2c_probe(struct platform_device *pdev)
 	 */
 	rev = __raw_readw(dev->base + 0x04);
 
-	scheme = OMAP_I2C_SCHEME(rev);
-	switch (scheme) {
+	dev->scheme = OMAP_I2C_SCHEME(rev);
+	switch (dev->scheme) {
 	case OMAP_I2C_SCHEME_0:
 		dev->regs = (u8 *)reg_map_ip_v1;
 		dev->rev = omap_i2c_read_reg(dev, OMAP_I2C_REV_REG);
@@ -1289,7 +1292,11 @@ static int omap_i2c_runtime_suspend(struct device *dev)
 
 	_dev->iestate = omap_i2c_read_reg(_dev, OMAP_I2C_IE_REG);
 
-	omap_i2c_write_reg(_dev, OMAP_I2C_IE_REG, 0);
+	if (_dev->scheme == OMAP_I2C_SCHEME_0)
+		omap_i2c_write_reg(_dev, OMAP_I2C_IE_REG, 0);
+	else
+		omap_i2c_write_reg(_dev, OMAP_I2C_IP_V2_IRQENABLE_CLR,
+				   OMAP_I2C_IP_V2_INTERRUPTS_MASK);
 
 	if (_dev->rev < OMAP_I2C_OMAP1_REV_2) {
 		omap_i2c_read_reg(_dev, OMAP_I2C_IV_REG); /* Read clears */
-- 
1.8.2.rc2

