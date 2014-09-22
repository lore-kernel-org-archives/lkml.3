Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaIVUVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:21:13 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:48416 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIVUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:21:11 -0400
Date: Mon, 22 Sep 2014 20:20:17 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
cc: Daniel Mack <daniel@caiaq.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: core: downgrade log severity to info when descriptor
 missing
Message-ID: <alpine.DEB.2.11.1409222012230.1839@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
    USB: fix LANGID=0 regression

usb devices are not required to report string descriptors. Since they are
optional, log an info message instead of an error message. In addition,
use a higher level info message while moving the details to a debug message.

Tested with USB device 0930:021c.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/usb/core/message.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 0c8a7fc..6b95de7 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -766,7 +766,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)

 	/* If the string was reported but is malformed, default to english
 	 * (0x0409) */
-	if (err == -ENODATA || (err > 0 && err < 4)) {
+	if (err > 0 && err < 4) {
 		dev->string_langid = 0x0409;
 		dev->have_langid = 1;
 		dev_err(&dev->dev,
@@ -776,6 +776,18 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
 		return 0;
 	}

+	/* If the string was unavailable, default to english (0x0409) */
+	if (err == -ENODATA) {
+		dev->string_langid = 0x0409;
+		dev->have_langid = 1;
+		dev_info(&dev->dev,
+			"no string descriptor language, defaulting to English");
+		dev_dbg(&dev->dev,
+			"string descriptor 0 unavailable (err = -ENODATA), "
+			"defaulting to 0x%04x\n", dev->string_langid);
+		return 0;
+	}
+
 	/* In case of all other errors, we assume the device is not able to
 	 * deal with strings at all. Set string_langid to -1 in order to
 	 * prevent any string to be retrieved from the device */
-- 
2.1.0

