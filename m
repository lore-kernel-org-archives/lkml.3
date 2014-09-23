Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaIWTNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:13:06 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:47038 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWTNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:13:05 -0400
Date: Tue, 23 Sep 2014 19:12:40 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
cc: Daniel Mack <daniel@caiaq.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: core: downgrade log severity to info when descriptor
 unavailable
In-Reply-To: <alpine.DEB.2.11.1409231905460.3223@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1409231909590.7196@localhost.localdomain>
References: <Pine.LNX.4.44L0.1409231021190.1322-100000@iolanthe.rowland.org> <alpine.DEB.2.11.1409231905460.3223@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
    USB: fix LANGID=0 regression

usb devices are not required to report string descriptors. Since they are
optional, log an info message instead of an error message.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/usb/core/message.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 0c8a7fc..da2f1f2 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -780,8 +780,12 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
 	 * deal with strings at all. Set string_langid to -1 in order to
 	 * prevent any string to be retrieved from the device */
 	if (err < 0) {
-		dev_err(&dev->dev, "string descriptor 0 read error: %d\n",
-					err);
+		if (err == -EPIPE)
+			dev_info(&dev->dev,
+				 "string descriptor 0 read error: -EPIPE\n");
+		else
+			dev_err(&dev->dev,
+				"string descriptor 0 read error: %d\n", err);
 		dev->string_langid = -1;
 		return -EPIPE;
 	}
-- 
2.1.0

