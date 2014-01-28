Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaA1AqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:46:21 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55231 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaA1AqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:46:18 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/21] pinctrl: mvebu: armada-xp: provide generic mpp callbacks
Date: Tue, 28 Jan 2014 01:39:24 +0100
Message-Id: <1390869573-27624-13-git-send-email-sebastian.hesselbarth@gmail.com>
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
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 786c629af8a8..5cfa00cae490 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -35,6 +35,30 @@
 
 static void __iomem *mpp_base;
 
+static int armada_xp_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
+				  unsigned long *config)
+{
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_xp_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
+				  unsigned long config)
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
 enum armada_xp_variant {
 	V_MV78230	= BIT(0),
 	V_MV78260	= BIT(1),
@@ -368,7 +392,7 @@ static struct of_device_id armada_xp_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78230_mpp_controls[] = {
-	MPP_REG_CTRL(0, 48),
+	MPP_FUNC_CTRL(0, 48, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78230_mpp_gpio_ranges[] = {
@@ -377,7 +401,7 @@ static struct pinctrl_gpio_range mv78230_mpp_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78260_mpp_controls[] = {
-	MPP_REG_CTRL(0, 66),
+	MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78260_mpp_gpio_ranges[] = {
@@ -387,7 +411,7 @@ static struct pinctrl_gpio_range mv78260_mpp_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78460_mpp_controls[] = {
-	MPP_REG_CTRL(0, 66),
+	MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78460_mpp_gpio_ranges[] = {
-- 
1.8.5.2

