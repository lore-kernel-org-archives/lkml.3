Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaKZTFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:05:55 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:60467 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKZTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:05:51 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Kochetkov <al.kochet@gmail.com>
Subject: [RFC] i2c: omap: TEST: do IP reset during probe.
Date: Wed, 26 Nov 2014 23:05:22 +0400
Message-Id: <1417028722-29306-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR UPSTREAM

The patch checks if IP reset during probe could bring I2C bus
to a free state on omap2430 - omap3530 boards.

I guess, IP hold one of I2C lines in a low state.
I guess, u-boot haven't sent a stop condition.

The patch is rebased on branch 'i2c/for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
(6e79807443cba7397cd855ed29d6faba51d4c893)

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Reported-by: Kevin Hilman <khilman@kernel.org>
Tested-by: Kevin Hilman <khilman@kernel.org>
---
 drivers/i2c/busses/i2c-omap.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4563200..865c9a1 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -282,6 +282,26 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
+static int omap_i2c_wait_for_bb_valid(struct omap_i2c_dev *dev);
+
+static inline void
+omap_i2c_dump_state(const char *func, int line, struct omap_i2c_dev *dev, const char *msg)
+{
+	u16 systest = omap_i2c_read_reg(dev, OMAP_I2C_SYSTEST_REG);
+	dev_info(dev->dev, "%s: STAT=0x%04x; IE=0x%04x; CON=0x%04x; SYSTEST=0x%04x; SDA=%d%d [OI]; SCL=%d%d [OI] (%s:%d)\n",
+		msg,
+		omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG),
+		omap_i2c_read_reg(dev, OMAP_I2C_IE_REG),
+		omap_i2c_read_reg(dev, OMAP_I2C_CON_REG),
+		systest,
+		(systest & OMAP_I2C_SYSTEST_SDA_O_FUNC) ? 1 : 0,
+		(systest & OMAP_I2C_SYSTEST_SDA_I_FUNC) ? 1 : 0,
+		(systest & OMAP_I2C_SYSTEST_SCL_O_FUNC) ? 1 : 0,
+		(systest & OMAP_I2C_SYSTEST_SCL_I_FUNC) ? 1 : 0,
+		func, line);
+}
+#define OMAP_I2C_DUMP_STATE(dev, msg) omap_i2c_dump_state(__func__, __LINE__, (dev), (msg))
+
 static void __omap_i2c_init(struct omap_i2c_dev *dev)
 {
 
@@ -469,6 +489,23 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 
 	__omap_i2c_init(dev);
 
+	msleep(1);
+	OMAP_I2C_DUMP_STATE(dev, "init0");
+
+	dev->bb_valid = 0;
+	omap_i2c_wait_for_bb_valid(dev);
+	OMAP_I2C_DUMP_STATE(dev, "init1");
+	dev_info(dev->dev, "init1: bb_valid=%d\n", dev->bb_valid);
+
+	omap_i2c_reset(dev);
+	__omap_i2c_init(dev);
+	dev->bb_valid = 0;
+	omap_i2c_wait_for_bb_valid(dev);
+	OMAP_I2C_DUMP_STATE(dev, "init2");
+	dev_info(dev->dev, "init2: bb_valid=%d\n", dev->bb_valid);
+
+	dev->bb_valid = 1;
+
 	return 0;
 }
 
@@ -1367,8 +1404,8 @@ omap_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
-	dev_info(dev->dev, "bus %d rev%d.%d at %d kHz\n", adap->nr,
-		 major, minor, dev->speed);
+	dev_info(dev->dev, "bus %d rev%d.%d at %d kHz (rev %08x)\n", adap->nr,
+		 major, minor, dev->speed, dev->rev);
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
-- 
1.7.9.5

