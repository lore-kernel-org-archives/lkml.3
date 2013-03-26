Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3CZXdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:33:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3CZWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [ 47/98] i2c: tegra: check the clk_prepare_enable() return value
Date: Tue, 26 Mar 2013 15:42:36 -0700
Message-Id: <20130326224247.418632707@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-tegra.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -392,7 +392,11 @@ static int tegra_i2c_init(struct tegra_i
 	u32 val;
 	int err = 0;
 
-	tegra_i2c_clock_enable(i2c_dev);
+	err = tegra_i2c_clock_enable(i2c_dev);
+	if (err < 0) {
+		dev_err(i2c_dev->dev, "Clock enable failed %d\n", err);
+		return err;
+	}
 
 	tegra_periph_reset_assert(i2c_dev->div_clk);
 	udelay(2);
@@ -599,7 +603,12 @@ static int tegra_i2c_xfer(struct i2c_ada
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


