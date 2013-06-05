Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3FESCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:02:30 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:26939 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757042Ab3FERsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:48:09 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 19/53] Input: atmel_mxt_ts - Improve bootloader progress output
Date: Wed,  5 Jun 2013 18:37:12 +0100
Message-Id: <1370453866-16534-20-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By implementing a frame counter, print out fewer debug messages (the
firmware may contain hundreds of frames).

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2cd8ead..e8f410c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1465,6 +1465,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	unsigned int frame_size;
 	unsigned int pos = 0;
 	unsigned int retry = 0;
+	unsigned int frame = 0;
 	int ret;
 
 	ret = request_firmware(&fw, fn, dev);
@@ -1524,9 +1525,12 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		} else {
 			retry = 0;
 			pos += frame_size;
+			frame++;
 		}
 
-		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
+		if (frame % 50 == 0)
+			dev_info(dev, "Sent %d frames, %d/%zd bytes\n",
+				 frame, pos, fw->size);
 	}
 
 	/* Wait for flash. */
@@ -1535,6 +1539,8 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto disable_irq;
 
+	dev_info(dev, "Sent %d frames, %zd bytes\n", frame, pos);
+
 	/* Wait for device to reset. Some bootloader versions do not assert
 	 * the CHG line after bootloading has finished, so ignore error */
 	mxt_wait_for_completion(data, &data->bl_completion,
-- 
1.7.10.4

