Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3FGPtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:49:23 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50216 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3FGPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:49:21 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>
Subject: [PATCH 1/2] i2c-mv64xxx: Fix timing issue on Armada XP (errata FE-8471889)
Date: Fri,  7 Jun 2013 17:48:59 +0200
Message-Id: <1370620140-17177-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
References: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zbigniew Bodek <zbb@semihalf.com>

All the Armada XP (mv78230, mv78260 and mv78460) have a silicon issue
in the I2C controller which violate the i2c repeated start
timing. The I2C standard requires a minimum of 4.7us for the repeated
start condition whereas the I2C controller of the Armada XP this time
is 2.9us.

So this patch adds a 5us delay for the start case only if the
mv64xxx_i2c_errata_delay flag is set.

[gregory.clement@free-electrons.com: Merge the incoming commits into
this single one]
[gregory.clement@free-electrons.com: Reword the commit log]

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Zbigniew Bodek <zbb@semihalf.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 1a3abd6..60cac9f 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -23,6 +23,7 @@
 #include <linux/of_i2c.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/delay.h>
 
 /* Register defines */
 #define	MV64XXX_I2C_REG_SLAVE_ADDR			0x00
@@ -59,6 +60,12 @@
 #define	MV64XXX_I2C_STATUS_MAST_RD_ADDR_2_NO_ACK	0xe8
 #define	MV64XXX_I2C_STATUS_NO_STATUS			0xf8
 
+/*
+ * 5us delay in order to avoid repeated start
+ * timing violation on Armada XP SoC.
+ */
+static int mv64xxx_i2c_errata_delay;
+
 /* Driver states */
 enum {
 	MV64XXX_I2C_STATE_INVALID,
@@ -252,6 +259,9 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c_data *drv_data)
 		writel(drv_data->cntl_bits,
 			drv_data->reg_base + MV64XXX_I2C_REG_CONTROL);
 		drv_data->block = 0;
+		if (mv64xxx_i2c_errata_delay)
+			udelay(5);
+
 		wake_up(&drv_data->waitq);
 		break;
 
@@ -300,6 +310,9 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c_data *drv_data)
 		writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_STOP,
 			drv_data->reg_base + MV64XXX_I2C_REG_CONTROL);
 		drv_data->block = 0;
+		if (mv64xxx_i2c_errata_delay)
+			udelay(5);
+
 		wake_up(&drv_data->waitq);
 		break;
 
@@ -592,6 +605,10 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	 * So hard code the value to 1 second.
 	 */
 	drv_data->adapter.timeout = HZ;
+
+	if (!mv64xxx_i2c_errata_delay &&
+	    of_machine_is_compatible("marvell,armadaxp"))
+		mv64xxx_i2c_errata_delay = 1;
 out:
 	return rc;
 #endif
-- 
1.8.1.2

