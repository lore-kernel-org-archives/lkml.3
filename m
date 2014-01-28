Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaA1Ajv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:39:51 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48599 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaA1Ajs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:39:48 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/21] pinctrl: mvebu: armada-370: provide generic mpp callbacks
Date: Tue, 28 Jan 2014 01:39:23 +0100
Message-Id: <1390869573-27624-12-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks for generic mpp pins.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index 7586072e66c6..5e8e83f57b8e 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -25,6 +25,30 @@
 
 static void __iomem *mpp_base;
 
+static int armada_370_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				   unsigned long *config)
+{
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_370_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				   unsigned long config)
+{
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(mpp_base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), mpp_base + off);
+
+	return 0;
+}
+
 static struct mvebu_mpp_mode mv88f6710_mpp_modes[] = {
 	MPP_MODE(0,
 	   MPP_FUNCTION(0x0, "gpio", NULL),
@@ -375,7 +399,7 @@ static struct of_device_id armada_370_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f6710_mpp_controls[] = {
-	MPP_REG_CTRL(0, 65),
+	MPP_FUNC_CTRL(0, 65, NULL, armada_370_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f6710_mpp_gpio_ranges[] = {
-- 
1.8.5.2

