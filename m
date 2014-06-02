Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaFBRoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:44:54 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56295 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaFBRow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:44:52 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@linaro.org>, Olof Johansson <olof@lixom.net>,
        Dongjin Kim <tobetter@gmail.com>, Julius Werner <jwerner@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] usb: usb5303: make use of uninitialized err variable
Date: Mon,  2 Jun 2014 19:45:25 +0200
Message-Id: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable err is not initialized here, this patch uses it
to store an eventual error value from devm_clk_get().

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/usb/misc/usb3503.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index f43c619..c86c3fa 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -191,9 +191,13 @@ static int usb3503_probe(struct usb3503 *hub)
 		hub->port_off_mask = 0;
 
 		clk = devm_clk_get(dev, "refclk");
-		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
-			dev_err(dev, "unable to request refclk (%d)\n", err);
-			return PTR_ERR(clk);
+		if (IS_ERR(clk)) {
+			err = PTR_ERR(clk);
+			if (err != -ENOENT) {
+				dev_err(dev, "unable to request refclk (%d)\n",
+					err);
+				return err;
+			}
 		}
 
 		if (!IS_ERR(clk)) {
-- 
1.7.10.4

