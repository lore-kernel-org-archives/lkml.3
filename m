Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaJPRMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:12:12 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44275 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaJPRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:12:10 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH RFC v2 4/8] pinctrl: zynq: Support IO standard property
Date: Thu, 16 Oct 2014 10:11:31 -0700
Message-Id: <1413479495-14206-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
In-Reply-To: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/pinctrl/pinctrl-zynq.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
index a32fac61cba0..f3fce76c8390 100644
--- a/drivers/pinctrl/pinctrl-zynq.c
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -883,6 +883,18 @@ static const struct pinmux_ops zynq_pinmux_ops = {
 #define ZYNQ_PINCONF_SPEED	BIT(8)
 #define ZYNQ_PINCONF_PULLUP	BIT(12)
 
+#define ZYNQ_PINCONF_IOTYPE_SHIFT	9
+#define ZYNQ_PINCONF_IOTYPE_MASK	(7 << ZYNQ_PINCONF_IOTYPE_SHIFT)
+
+enum zynq_io_standards {
+	zynq_iostd_min,
+	zynq_iostd_lvcmos18,
+	zynq_iostd_lvcmos25,
+	zynq_iostd_lvcmos33,
+	zynq_iostd_hstl,
+	zynq_iostd_max
+};
+
 static int zynq_pinconf_cfg_get(struct pinctrl_dev *pctldev,
 				unsigned pin,
 				unsigned long *config)
@@ -918,6 +930,10 @@ static int zynq_pinconf_cfg_get(struct pinctrl_dev *pctldev,
 	case PIN_CONFIG_SLEW_RATE:
 		arg = !!(reg & ZYNQ_PINCONF_SPEED);
 		break;
+	case PIN_CONFIG_IOSTANDARD:
+		arg = reg & ZYNQ_PINCONF_IOTYPE_MASK;
+		arg >>= ZYNQ_PINCONF_IOTYPE_SHIFT;
+		break;
 	default:
 		return -ENOTSUPP;
 	}
@@ -969,6 +985,15 @@ static int zynq_pinconf_cfg_set(struct pinctrl_dev *pctldev,
 				reg &= ~ZYNQ_PINCONF_SPEED;
 
 			break;
+		case PIN_CONFIG_IOSTANDARD:
+			if (arg <= zynq_iostd_min || arg >= zynq_iostd_max) {
+				dev_warn(pctldev->dev,
+					 "unsupported IO standard '%u'\n",
+					 param);
+				break;
+			}
+			reg |= arg << ZYNQ_PINCONF_IOTYPE_SHIFT;
+			break;
 		default:
 			dev_warn(pctldev->dev,
 				 "unsupported configuration parameter '%u'\n",
-- 
2.1.2.1.g5e69ed6

