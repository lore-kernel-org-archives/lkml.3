Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaA1A4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:56:17 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42444 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaA1A4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:56:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/21] pinctrl: mvebu: kirkwood: provide generic mpp callbacks
Date: Tue, 28 Jan 2014 01:39:22 +0100
Message-Id: <1390869573-27624-11-git-send-email-sebastian.hesselbarth@gmail.com>
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
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index 842ceb196726..2872f28057fb 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -23,6 +23,30 @@
 
 static void __iomem *mpp_base;
 
+static int kirkwood_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				 unsigned long *config)
+{
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int kirkwood_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				 unsigned long config)
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
 #define V(f6180, f6190, f6192, f6281, f6282, dx4122)	\
 	((f6180 << 0) | (f6190 << 1) | (f6192 << 2) |	\
 	 (f6281 << 3) | (f6282 << 4) | (dx4122 << 5))
@@ -361,7 +385,7 @@ static struct mvebu_mpp_mode mv88f6xxx_mpp_modes[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f6180_mpp_controls[] = {
-	MPP_REG_CTRL(0, 29),
+	MPP_FUNC_CTRL(0, 29, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f6180_gpio_ranges[] = {
@@ -369,7 +393,7 @@ static struct pinctrl_gpio_range mv88f6180_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f619x_mpp_controls[] = {
-	MPP_REG_CTRL(0, 35),
+	MPP_FUNC_CTRL(0, 35, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f619x_gpio_ranges[] = {
@@ -378,7 +402,7 @@ static struct pinctrl_gpio_range mv88f619x_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f628x_mpp_controls[] = {
-	MPP_REG_CTRL(0, 49),
+	MPP_FUNC_CTRL(0, 49, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f628x_gpio_ranges[] = {
-- 
1.8.5.2

