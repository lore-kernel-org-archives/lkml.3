Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3IRM7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:59:25 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:51873 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3IRM7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:59:23 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: mv64xxx: Fix some build warnings
Date: Wed, 18 Sep 2013 14:50:52 +0200
Message-Id: <1379508652-30348-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions and variables are only used if the configuration selects
HAVE_CLK. Protect them with a corresponding #ifdef CONFIG_HAVE_CLK block
to avoid compiler warnings.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 5aead74..bfd870c 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -697,6 +697,7 @@ static const struct of_device_id mv64xxx_i2c_of_match_table[] = {
 MODULE_DEVICE_TABLE(of, mv64xxx_i2c_of_match_table);
 
 #ifdef CONFIG_OF
+#ifdef CONFIG_HAVE_CLK
 static int
 mv64xxx_calc_freq(const int tclk, const int n, const int m)
 {
@@ -726,16 +727,12 @@ mv64xxx_find_baud_factors(const u32 req_freq, const u32 tclk, u32 *best_n,
 		return false;
 	return true;
 }
+#endif
 
 static int
 mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 		  struct device *dev)
 {
-	const struct of_device_id *device;
-	struct device_node *np = dev->of_node;
-	u32 bus_freq, tclk;
-	int rc = 0;
-
 	/* CLK is mandatory when using DT to describe the i2c bus. We
 	 * need to know tclk in order to calculate bus clock
 	 * factors.
@@ -744,6 +741,11 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	/* Have OF but no CLK */
 	return -ENODEV;
 #else
+	const struct of_device_id *device;
+	struct device_node *np = dev->of_node;
+	u32 bus_freq, tclk;
+	int rc = 0;
+
 	if (IS_ERR(drv_data->clk)) {
 		rc = -ENODEV;
 		goto out;
-- 
1.8.4

