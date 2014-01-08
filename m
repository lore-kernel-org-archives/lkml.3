Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaAHRKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:10:04 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:25677 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbaAHRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:09:58 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-2.tower-180.messagelabs.com!1389200994!28356548!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201401081709.s08H9nMr038265@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 8 Jan 2014 16:58:10 +0000
Subject: [PATCH V1] input: fix memory leak in da9052 touchscreen driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The touchscreen component driver for the da9052/3 Dialog PMICs
leaks memory by not freeing the input device in the remove call.

This patch matches the existing call to input_alloc_device()
in da9052_ts_probe() to a new call to input_free_device() in
da9052_ts_remove()

Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---
This patch is relative to linux-next repository tag next-20140108

Many thanks to Huqiu Liu who found the bug.

 drivers/input/touchscreen/da9052_tsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
index ab64d58..43a69d1 100644
--- a/drivers/input/touchscreen/da9052_tsi.c
+++ b/drivers/input/touchscreen/da9052_tsi.c
@@ -320,6 +320,7 @@ err_free_mem:
 static int  da9052_ts_remove(struct platform_device *pdev)
 {
 	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
+	struct input_dev *input_dev = tsi->dev;
 
 	da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
 
@@ -328,6 +329,7 @@ static int  da9052_ts_remove(struct platform_device *pdev)
 
 	input_unregister_device(tsi->dev);
 	kfree(tsi);
+	input_free_device(input_dev);
 
 	return 0;
 }
-- 
end-of-patch for input: fix memory leak in da9052 touchscreen driver V1

