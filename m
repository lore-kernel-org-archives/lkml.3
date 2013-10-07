Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3JGTQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:16:45 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3616 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab3JGTPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:15:23 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/4] i2c: i2c-bcm-kona: Add support for high-speed mode
Date: Mon, 7 Oct 2013 12:14:59 -0700
Message-ID: <1381173301-23830-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
References: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E4DD7C80UO14841593-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for I2C high-speed mode (3.4 MHz).

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/i2c/busses/i2c-bcm-kona.c | 116 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index 2936acf..458714f 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -77,6 +77,9 @@
 
 #define HSTIM_OFFSET				0x00000058
 #define HSTIM_HS_MODE_MASK			0x00008000
+#define HSTIM_HS_HOLD_SHIFT			10
+#define HSTIM_HS_HIGH_PHASE_SHIFT		5
+#define HSTIM_HS_SETUP_SHIFT			0
 
 #define PADCTL_OFFSET				0x0000005c
 #define PADCTL_PAD_OUT_EN_MASK			0x00000004
@@ -91,6 +94,9 @@
 #define MAX_TX_FIFO_SIZE		64U /* bytes */
 
 #define STD_EXT_CLK_FREQ		13000000UL
+#define HS_EXT_CLK_FREQ			104000000UL
+
+#define MASTERCODE			0x08 /* Mastercodes are 0000_1xxxb */
 
 #define I2C_TIMEOUT			100 /* msecs */
 
@@ -108,6 +114,10 @@ enum bus_speed_index {
 	BCM_SPD_1MHZ,
 };
 
+enum hs_bus_speed_index {
+	BCM_SPD_3P4MHZ = 0,
+};
+
 /* Internal divider settings for standard mode, fast mode and fast mode plus */
 struct bus_speed_cfg {
 	uint8_t time_m;		/* Number of cycles for setup time */
@@ -118,12 +128,30 @@ struct bus_speed_cfg {
 	uint8_t time_div;	/* Post-prescale divider */
 };
 
+/* Internal divider settings for high-speed mode */
+struct hs_bus_speed_cfg {
+	uint8_t hs_hold;	/* Number of clock cycles SCL stays low until
+				   the end of bit period */
+	uint8_t hs_high_phase;	/* Number of clock cycles SCL stays high
+				   before it falls */
+	uint8_t hs_setup;	/* Number of clock cycles SCL stays low
+				   before it rises  */
+	uint8_t prescale;	/* Prescale divider */
+	uint8_t time_p;		/* Timing coefficient */
+	uint8_t no_div;		/* Disable clock divider */
+	uint8_t time_div;	/* Post-prescale divider */
+};
+
 static const struct bus_speed_cfg std_cfg_table[] = {
 	[BCM_SPD_100K] = {0x01, 0x01, 0x03, 0x06, 0x00, 0x02},
 	[BCM_SPD_400K] = {0x05, 0x01, 0x03, 0x05, 0x01, 0x02},
 	[BCM_SPD_1MHZ] = {0x01, 0x01, 0x03, 0x01, 0x01, 0x03},
 };
 
+static const struct hs_bus_speed_cfg hs_cfg_table[] = {
+	[BCM_SPD_3P4MHZ] = {0x01, 0x08, 0x14, 0x00, 0x06, 0x01, 0x00},
+};
+
 struct bcm_kona_i2c_dev {
 	/* Pointer to linux device struct */
 	struct device *device;
@@ -137,6 +165,9 @@ struct bcm_kona_i2c_dev {
 	/* Standard Speed configuration */
 	const struct bus_speed_cfg *std_cfg;
 
+	/* High Speed configuration (if applicable) */
+	const struct hs_bus_speed_cfg *hs_cfg;
+
 	/* Linux I2C adapter struct */
 	struct i2c_adapter adapter;
 
@@ -520,6 +551,72 @@ static void bcm_kona_i2c_config_timing(struct bcm_kona_i2c_dev *dev)
 	       dev->base + CLKEN_OFFSET);
 }
 
+static void bcm_kona_i2c_config_timing_hs(struct bcm_kona_i2c_dev *dev)
+{
+	writel((dev->hs_cfg->prescale << TIM_PRESCALE_SHIFT) |
+	       (dev->hs_cfg->time_p << TIM_P_SHIFT) |
+	       (dev->hs_cfg->no_div << TIM_NO_DIV_SHIFT) |
+	       (dev->hs_cfg->time_div << TIM_DIV_SHIFT),
+	       dev->base + TIM_OFFSET);
+
+	writel((dev->hs_cfg->hs_hold << HSTIM_HS_HOLD_SHIFT) |
+	       (dev->hs_cfg->hs_high_phase << HSTIM_HS_HIGH_PHASE_SHIFT) |
+	       (dev->hs_cfg->hs_setup << HSTIM_HS_SETUP_SHIFT),
+	       dev->base + HSTIM_OFFSET);
+
+	writel(readl(dev->base + HSTIM_OFFSET) | HSTIM_HS_MODE_MASK,
+	       dev->base + HSTIM_OFFSET);
+}
+
+static int bcm_kona_i2c_switch_to_hs(struct bcm_kona_i2c_dev *dev)
+{
+	int rc;
+
+	/* Send mastercode at standard speed */
+	rc = bcm_kona_i2c_write_byte(dev, MASTERCODE, 1);
+	if (rc < 0) {
+		pr_err("High speed handshake failed\n");
+		return rc;
+	}
+
+	/* Configure external clock to higher frequency */
+	rc = clk_set_rate(dev->external_clk, HS_EXT_CLK_FREQ);
+	if (rc) {
+		dev_err(dev->device, "%s: clk_set_rate returned %d\n",
+			__func__, rc);
+		return rc;
+	}
+
+	/* Reconfigure internal dividers */
+	bcm_kona_i2c_config_timing_hs(dev);
+
+	/* Send a restart command */
+	rc = bcm_kona_send_i2c_cmd(dev, BCM_CMD_RESTART);
+	if (rc < 0) {
+		dev_err(dev->device,
+		"High speed restart command failed rc = %d\n", rc);
+	}
+
+	return rc;
+}
+
+static int bcm_kona_i2c_switch_to_std(struct bcm_kona_i2c_dev *dev)
+{
+	int rc;
+
+	/* Reconfigure internal dividers */
+	bcm_kona_i2c_config_timing(dev);
+
+	/* Configure external clock to lower frequency */
+	rc = clk_set_rate(dev->external_clk, STD_EXT_CLK_FREQ);
+	if (rc) {
+		dev_err(dev->device, "%s: clk_set_rate returned %d\n",
+			__func__, rc);
+	}
+
+	return rc;
+}
+
 /* Master transfer function */
 static int bcm_kona_i2c_xfer(struct i2c_adapter *adapter,
 			     struct i2c_msg msgs[], int num)
@@ -551,6 +648,13 @@ static int bcm_kona_i2c_xfer(struct i2c_adapter *adapter,
 		goto xfer_disable_pad;
 	}
 
+	/* Switch to high speed if applicable */
+	if (dev->hs_cfg) {
+		rc = bcm_kona_i2c_switch_to_hs(dev);
+		if (rc < 0)
+			goto xfer_send_stop;
+	}
+
 	/* Loop through all messages */
 	for (i = 0; i < num; i++) {
 		pmsg = &msgs[i];
@@ -598,6 +702,13 @@ xfer_send_stop:
 	/* Send a STOP command */
 	bcm_kona_send_i2c_cmd(dev, BCM_CMD_STOP);
 
+	/* Return from high speed if applicable */
+	if (dev->hs_cfg) {
+		int hs_rc = bcm_kona_i2c_switch_to_std(dev);
+		if (hs_rc)
+			rc = hs_rc;
+	}
+
 xfer_disable_pad:
 	/* Disable pad output */
 	writel(PADCTL_PAD_OUT_EN_MASK, dev->base + PADCTL_OFFSET);
@@ -642,6 +753,11 @@ static int bcm_kona_i2c_assign_bus_speed(struct bcm_kona_i2c_dev *dev)
 	case 1000000:
 		dev->std_cfg = &std_cfg_table[BCM_SPD_1MHZ];
 		break;
+	case 3400000:
+		/* Send mastercode at 100k */
+		dev->std_cfg = &std_cfg_table[BCM_SPD_100K];
+		dev->hs_cfg = &hs_cfg_table[BCM_SPD_3P4MHZ];
+		break;
 	default:
 		pr_err("%d hz bus speed not supported\n", bus_speed);
 		return -EINVAL;
-- 
1.8.0.1


