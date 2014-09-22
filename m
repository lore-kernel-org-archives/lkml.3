Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaIVHYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:24:49 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46998 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaIVHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:24:47 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, max.schwarz@online.de
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, Wolfram Sang <wsa@the-dreams.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-rk3x: move setup to the earlier subsys initcall
Date: Mon, 22 Sep 2014 15:24:35 +0800
Message-Id: <1411370675-27866-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device using this bus, such as regulators, they should register
as early as possible, so the I2C bus master needs to be loaded early.
Therefore initialize via subsys_initcall() is better.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 drivers/i2c/busses/i2c-rk3x.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index e637c32..5b91901 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -760,7 +760,18 @@ static struct platform_driver rk3x_i2c_driver = {
 	},
 };
 
-module_platform_driver(rk3x_i2c_driver);
+static int __init rk3x_i2c_init_driver(void)
+{
+	return platform_driver_register(&rk3x_i2c_driver);
+}
+
+static void __exit rk3x_i2c_exit_driver(void)
+{
+	platform_driver_unregister(&rk3x_i2c_driver);
+}
+
+subsys_initcall(rk3x_i2c_init_driver);
+module_exit(rk3x_i2c_exit_driver);
 
 MODULE_DESCRIPTION("Rockchip RK3xxx I2C Bus driver");
 MODULE_AUTHOR("Max Schwarz <max.schwarz@online.de>");
-- 
1.7.9.5

