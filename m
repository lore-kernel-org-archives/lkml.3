Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbaGQOtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:49:22 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65263 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064AbaGQOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:49:18 -0400
From: Bastian Hecht <hechtb@gmail.com>
To: linux-i2c@vger.kernel.org
Cc: Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        Bastian Hecht <hechtb@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org (open list:TEGRA ARCHITECTUR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 5/5] i2c: tegra: Remove suspension check
Date: Thu, 17 Jul 2014 16:48:40 +0200
Message-Id: <1405608520-5644-5-git-send-email-hechtb@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now take care of suspension in the i2c core code. So we can remove this
check here.

Signed-off-by: Bastian Hecht <hechtb@gmail.com>
---
same as v1

 drivers/i2c/busses/i2c-tegra.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index f1bb2fc..c279d85 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -172,7 +172,6 @@ struct tegra_i2c_dev {
 	size_t msg_buf_remaining;
 	int msg_read;
 	u32 bus_clk_rate;
-	bool is_suspended;
 };
 
 static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned long reg)
@@ -628,9 +627,6 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	int i;
 	int ret = 0;
 
-	if (i2c_dev->is_suspended)
-		return -EBUSY;
-
 	ret = tegra_i2c_clock_enable(i2c_dev);
 	if (ret < 0) {
 		dev_err(i2c_dev->dev, "Clock enable failed %d\n", ret);
@@ -817,17 +813,6 @@ static int tegra_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int tegra_i2c_suspend(struct device *dev)
-{
-	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
-
-	i2c_lock_adapter(&i2c_dev->adapter);
-	i2c_dev->is_suspended = true;
-	i2c_unlock_adapter(&i2c_dev->adapter);
-
-	return 0;
-}
-
 static int tegra_i2c_resume(struct device *dev)
 {
 	struct tegra_i2c_dev *i2c_dev = dev_get_drvdata(dev);
@@ -842,14 +827,12 @@ static int tegra_i2c_resume(struct device *dev)
 		return ret;
 	}
 
-	i2c_dev->is_suspended = false;
-
 	i2c_unlock_adapter(&i2c_dev->adapter);
 
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_suspend, tegra_i2c_resume);
+static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_resume);
 #define TEGRA_I2C_PM	(&tegra_i2c_pm)
 #else
 #define TEGRA_I2C_PM	NULL
-- 
1.9.1

