Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3BVSQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:16:55 -0500
Received: from [89.21.227.133] ([89.21.227.133]:18360 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759006Ab3BVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:32 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 27/40] Input: atmel_mxt_ts - Add check for incorrect firmware file format
Date: Fri, 22 Feb 2013 17:58:14 +0000
Message-Id: <1361555907-19840-28-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel supplies firmware files in ASCII HEX format (.enc) which must be
converted before they can be loaded by kernel driver. Try to detect the error
and print a friendly error message rather than feeding junk to the bootloader.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 3aac912..a1f196b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1724,6 +1724,27 @@ done:
 	return error ?: count;
 }
 
+static int mxt_check_firmware_format(struct device *dev, const struct firmware *fw)
+{
+	unsigned int pos = 0;
+	char c;
+
+	while (pos < fw->size) {
+		c = *(fw->data + pos);
+
+		if (c < '0' || (c > '9' && c < 'A') || c > 'F')
+			return 0;
+
+		pos++;
+	}
+
+	/* To convert file try
+	 * xxd -r -p mXTXXX__APP_VX-X-XX.enc > maxtouch.fw */
+	dev_err(dev, "Aborting: firmware file must be in binary format\n");
+
+	return -1;
+}
+
 static int mxt_load_fw(struct device *dev, const char *fn)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
@@ -1740,6 +1761,11 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		return ret;
 	}
 
+	/* Check for incorrect enc file */
+	ret = mxt_check_firmware_format(dev, fw);
+	if (ret)
+		goto release_firmware;
+
 	if (data->state != BOOTLOADER) {
 		/* Change to the bootloader mode */
 		ret = mxt_soft_reset(data, MXT_BOOT_VALUE);
-- 
1.7.10.4

