Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaLCOe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:34:29 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37407 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaLCOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:15 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 5/5] i2c: omap: add trace
Date: Wed,  3 Dec 2014 18:34:02 +0400
Message-Id: <1417617242-16869-6-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
 drivers/i2c/busses/i2c-omap.c |   45 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 66506db..d2dfabe 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -283,6 +283,23 @@ static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
+#ifdef dev_dbg
+#undef dev_dbg
+#endif
+#define dev_dbg dev_info
+
+static inline void omap_i2c_dump_state(const char *func, int line,
+	struct omap_i2c_dev *dev, const char *msg)
+{
+	dev_dbg(dev->dev, "%s: STAT=0x%04x; IE=0x%04x; CON=0x%04x; (%s:%d)\n",
+		msg,
+		omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG),
+		omap_i2c_read_reg(dev, OMAP_I2C_IE_REG),
+		omap_i2c_read_reg(dev, OMAP_I2C_CON_REG),
+		func, line);
+}
+#define OMAP_I2C_DUMP_STATE(dev, msg) omap_i2c_dump_state(__func__, __LINE__, (dev), (msg))
+
 static void __omap_i2c_init(struct omap_i2c_dev *dev)
 {
 
@@ -393,6 +410,8 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 		 */
 		if (fclk_rate > 12000000)
 			psc = fclk_rate / 12000000;
+
+		dev_info(dev->dev, "ARMXOR_CLK: fclk_rate=%lu\n", fclk_rate);
 	}
 
 	if (!(dev->flags & OMAP_I2C_FLAG_SIMPLE_CLOCK)) {
@@ -445,6 +464,8 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 		}
 		scll = (hsscll << OMAP_I2C_SCLL_HSSCLL) | fsscll;
 		sclh = (hssclh << OMAP_I2C_SCLH_HSSCLH) | fssclh;
+
+		dev_info(dev->dev, "!SIMPLE_CLOCK: fclk_rate=%lu; internal_clk=%lu; speed %u\n", fclk_rate, internal_clk, dev->speed);
 	} else {
 		/* Program desired operating rate */
 		fclk_rate /= (psc + 1) * 1000;
@@ -452,6 +473,8 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 			psc = 2;
 		scll = fclk_rate / (dev->speed * 2) - 7 + psc;
 		sclh = fclk_rate / (dev->speed * 2) - 7 + psc;
+
+		dev_info(dev->dev, "SIMPLE_CLOCK: fclk_rate=%lu; speed %u\n", fclk_rate, dev->speed);
 	}
 
 	dev->iestate = (OMAP_I2C_IE_XRDY | OMAP_I2C_IE_RRDY |
@@ -679,7 +702,9 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	 * the bus. IP successfully complete transfer when the bus will be
 	 * free again (BB reset to 0).
 	 */
+	OMAP_I2C_DUMP_STATE(dev, "XFER0");
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
+	OMAP_I2C_DUMP_STATE(dev, "XFER1");
 
 	/*
 	 * REVISIT: We should abort the transfer on signals, but the bus goes
@@ -688,12 +713,16 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	timeout = wait_for_completion_timeout(&dev->cmd_complete,
 						OMAP_I2C_TIMEOUT);
 	if (timeout == 0) {
+		OMAP_I2C_DUMP_STATE(dev, "XFER TIMEOUT");
 		dev_err(dev->dev, "controller timed out\n");
 		omap_i2c_reset(dev);
 		__omap_i2c_init(dev);
 		return -ETIMEDOUT;
 	}
 
+	OMAP_I2C_DUMP_STATE(dev, "XFER DONE");
+	dev_info(dev->dev, "cmd_err=%04x\n", dev->cmd_err);
+
 	if (likely(!dev->cmd_err))
 		return 0;
 
@@ -984,6 +1013,8 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
 		stat &= bits;
 
+		OMAP_I2C_DUMP_STATE(dev, "THR");
+
 		/* If we're in receiver mode, ignore XDR/XRDY */
 		if (dev->receiver)
 			stat &= ~(OMAP_I2C_STAT_XDR | OMAP_I2C_STAT_XRDY);
@@ -998,7 +1029,7 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		dev_dbg(dev->dev, "IRQ (ISR = 0x%04x)\n", stat);
 		if (count++ == 100) {
 			dev_warn(dev->dev, "Too much work in one IRQ\n");
-			break;
+			goto out;
 		}
 
 		if (stat & OMAP_I2C_STAT_NACK) {
@@ -1129,10 +1160,12 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		}
 	} while (stat);
 
+	OMAP_I2C_DUMP_STATE(dev, "COMPLETE");
 	omap_i2c_complete_cmd(dev, err);
 
 out:
 	spin_unlock_irqrestore(&dev->lock, flags);
+	OMAP_I2C_DUMP_STATE(dev, "THR DONE");
 
 	return IRQ_HANDLED;
 }
@@ -1238,6 +1271,9 @@ omap_i2c_probe(struct platform_device *pdev)
 		of_property_read_u32(node, "clock-frequency", &freq);
 		/* convert DT freq value in Hz into kHz for speed */
 		dev->speed = freq / 1000;
+
+		dev_info(&pdev->dev, "of: compatible=%s; speed=%d; flags=%x\n",
+			match->compatible, dev->speed, dev->flags);
 	} else if (pdata != NULL) {
 		dev->speed = pdata->clkrate;
 		dev->flags = pdata->flags;
@@ -1356,8 +1392,8 @@ omap_i2c_probe(struct platform_device *pdev)
 		goto err_unuse_clocks;
 	}
 
-	dev_info(dev->dev, "bus %d rev%d.%d at %d kHz\n", adap->nr,
-		 major, minor, dev->speed);
+	dev_info(dev->dev, "bus %d rev%d.%d at %d kHz (rev %08x)\n", adap->nr,
+		 major, minor, dev->speed, dev->rev);
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
@@ -1396,6 +1432,8 @@ static int omap_i2c_runtime_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_i2c_dev *_dev = platform_get_drvdata(pdev);
 
+	OMAP_I2C_DUMP_STATE(_dev, "SUSPEND");
+
 	_dev->iestate = omap_i2c_read_reg(_dev, OMAP_I2C_IE_REG);
 
 	if (_dev->scheme == OMAP_I2C_SCHEME_0)
@@ -1425,6 +1463,7 @@ static int omap_i2c_runtime_resume(struct device *dev)
 		return 0;
 
 	__omap_i2c_init(_dev);
+	OMAP_I2C_DUMP_STATE(_dev, "RESUME");
 
 	return 0;
 }
-- 
1.7.9.5

