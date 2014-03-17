Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaCQRdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:33:33 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:26344 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbaCQRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:27 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 16/22] Input: atmel_mxt_ts - improve bootloader progress output
Date: Mon, 17 Mar 2014 17:26:49 +0000
Message-Id: <1395077215-10922-17-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By implementing a frame counter, print out fewer debug messages (the
firmware may contain hundreds of frames).

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 049d48a..b263ec3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1432,6 +1432,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	unsigned int frame_size;
 	unsigned int pos = 0;
 	unsigned int retry = 0;
+	unsigned int frame = 0;
 	int ret;
 
 	ret = request_firmware(&fw, fn, dev);
@@ -1491,9 +1492,12 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		} else {
 			retry = 0;
 			pos += frame_size;
+			frame++;
 		}
 
-		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
+		if (frame % 50 == 0)
+			dev_dbg(dev, "Sent %d frames, %d/%zd bytes\n",
+				frame, pos, fw->size);
 	}
 
 	/* Wait for flash. */
@@ -1502,6 +1506,8 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto disable_irq;
 
+	dev_dbg(dev, "Sent %d frames, %d bytes\n", frame, pos);
+
 	/*
 	 * Wait for device to reset. Some bootloader versions do not assert
 	 * the CHG line after bootloading has finished, so ignore potential
-- 
1.8.3.2

