Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab3CZPXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965311Ab3CZPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 115/150] i2c: tegra: check the clk_prepare_enable() return value
Date: Tue, 26 Mar 2013 15:20:14 +0000
Message-Id: <1364311249-14454-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Dewangan <ldewangan@nvidia.com>

commit 132c803f7b70b17322579f6f4f3f65cf68e55135 upstream.

NVIDIA's Tegra SoC allows read/write of controller register only
if controller clock is enabled. System hangs if read/write happens
to registers without enabling clock.

clk_prepare_enable() can be fail due to unknown reason and hence
adding check for return value of this function. If this function
success then only access register otherwise return to caller with
error.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[ luis: backport to 3.5: keep calling clk_enable ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-tegra.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8b2e555..12776b3 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -341,7 +341,11 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	u32 val;
 	int err = 0;
 
-	clk_enable(i2c_dev->clk);
+	err = clk_enable(i2c_dev->clk);
+	if (err < 0) {
+		dev_err(i2c_dev->dev, "Clock enable failed %d\n", err);
+		return err;
+	}
 
 	tegra_periph_reset_assert(i2c_dev->clk);
 	udelay(2);
@@ -546,7 +550,12 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 	if (i2c_dev->is_suspended)
 		return -EBUSY;
 
-	clk_enable(i2c_dev->clk);
+	ret = clk_enable(i2c_dev->clk);
+	if (ret < 0) {
+		dev_err(i2c_dev->dev, "Clock enable failed %d\n", ret);
+		return ret;
+	}
+
 	for (i = 0; i < num; i++) {
 		int stop = (i == (num - 1)) ? 1  : 0;
 		ret = tegra_i2c_xfer_msg(i2c_dev, &msgs[i], stop);
-- 
1.8.1.2

