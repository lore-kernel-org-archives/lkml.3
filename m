Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3COPgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:36:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1467 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3COPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:36:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 15 Mar 2013 08:36:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <wsa@the-dreams.de>
CC: <swarren@wwwdotorg.org>, <khali@linux-fr.org>, <linux-i2c@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] i2c: tegra: check the clk_prepare_enable() return value
Date: Fri, 15 Mar 2013 21:04:08 +0530
Message-ID: <1363361648-10326-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra SoC allows read/write of controller register only
if controller clock is enabled. System hangs if read/write happens
to registers without enabling clock.

clk_prepare_enable() can be fail due to unknown reason and hence
adding check for return value of this function. If this function
success then only access register otherwise return to caller with
error.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 36704e3..b714776 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -411,7 +411,11 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	int clk_multiplier = I2C_CLK_MULTIPLIER_STD_FAST_MODE;
 	u32 clk_divisor;
 
-	tegra_i2c_clock_enable(i2c_dev);
+	err = tegra_i2c_clock_enable(i2c_dev);
+	if (err < 0) {
+		dev_err(i2c_dev->dev, "Clock enable failed %d\n", err);
+		return err;
+	}
 
 	tegra_periph_reset_assert(i2c_dev->div_clk);
 	udelay(2);
@@ -628,7 +632,12 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	tegra_i2c_clock_enable(i2c_dev);
+	ret = tegra_i2c_clock_enable(i2c_dev);
+	if (ret < 0) {
+		dev_err(i2c_dev->dev, "Clock enable failed %d\n", ret);
+		return ret;
+	}
+
 	for (i = 0; i < num; i++) {
 		enum msg_end_type end_type = MSG_END_STOP;
 		if (i < (num - 1)) {
-- 
1.7.1.1

