Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3CYBPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33883 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629Ab3CYBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:25 -0400
Message-Id: <20130325010534.116563310@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:07:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [ 099/104] i2c: tegra: check the clk_prepare_enable() return value
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Keep calling clk_enable() directly]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-tegra.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -341,7 +341,11 @@ static int tegra_i2c_init(struct tegra_i
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
@@ -536,7 +540,12 @@ static int tegra_i2c_xfer(struct i2c_ada
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


