Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3FQSBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:01:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 18/84] USB: mos7720: fix DMA to stack
Date: Mon, 17 Jun 2013 10:30:22 -0700
Message-Id: <1371490288-23167-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 72ea18a558ed7a63a50bb121ba60d73b5b38ae30 upstream.

The read_mos_reg function is called with stack-allocated buffers, which
must not be used for control messages.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7720.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index f57a6b1..1b2bcdc 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -228,11 +228,22 @@ static int read_mos_reg(struct usb_serial *serial, unsigned int serial_portnum,
 	__u8 requesttype = (__u8)0xc0;
 	__u16 index = get_reg_index(reg);
 	__u16 value = get_reg_value(reg, serial_portnum);
-	int status = usb_control_msg(usbdev, pipe, request, requesttype, value,
-				     index, data, 1, MOS_WDR_TIMEOUT);
-	if (status < 0)
+	u8 *buf;
+	int status;
+
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	status = usb_control_msg(usbdev, pipe, request, requesttype, value,
+				     index, buf, 1, MOS_WDR_TIMEOUT);
+	if (status == 1)
+		*data = *buf;
+	else if (status < 0)
 		dev_err(&usbdev->dev,
 			"mos7720: usb_control_msg() failed: %d", status);
+	kfree(buf);
+
 	return status;
 }
 
-- 
1.8.1.2

