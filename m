Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaCQRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:38:32 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:21489 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756990AbaCQRi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:38:28 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 15/22] Input: atmel_mxt_ts - implement bootloader frame retries
Date: Mon, 17 Mar 2014 17:26:48 +0000
Message-Id: <1395077215-10922-16-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1ed3804..049d48a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -486,8 +486,12 @@ recheck:
 		val &= ~MXT_BOOT_STATUS_MASK;
 		break;
 	case MXT_FRAME_CRC_PASS:
-		if (val == MXT_FRAME_CRC_CHECK)
+		if (val == MXT_FRAME_CRC_CHECK) {
 			goto recheck;
+		} else if (val == MXT_FRAME_CRC_FAIL) {
+			dev_err(dev, "Bootloader CRC fail\n");
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
@@ -1427,6 +1431,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	const struct firmware *fw = NULL;
 	unsigned int frame_size;
 	unsigned int pos = 0;
+	unsigned int retry = 0;
 	int ret;
 
 	ret = request_firmware(&fw, fn, dev);
@@ -1464,9 +1469,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 
 		frame_size = ((*(fw->data + pos) << 8) | *(fw->data + pos + 1));
 
-		/* We should add 2 at frame size as the the firmware data is not
-		 * included the CRC bytes.
-		 */
+		/* Take account of CRC bytes */
 		frame_size += 2;
 
 		/* Write one frame to device */
@@ -1475,10 +1478,20 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 			goto disable_irq;
 
 		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
-		if (ret)
-			goto disable_irq;
+		if (ret) {
+			retry++;
 
-		pos += frame_size;
+			/* Back off by 20ms per retry */
+			msleep(retry * 20);
+
+			if (retry > 20) {
+				dev_err(dev, "Retry count exceeded\n");
+				goto disable_irq;
+			}
+		} else {
+			retry = 0;
+			pos += frame_size;
+		}
 
 		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
 	}
-- 
1.8.3.2

