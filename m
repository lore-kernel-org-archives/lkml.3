Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3FRMI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:08:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3FRLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/93] USB: mos7720: fix DMA to stack
Date: Tue, 18 Jun 2013 12:42:21 +0100
Message-Id: <1371555821-12820-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 72ea18a558ed7a63a50bb121ba60d73b5b38ae30 upstream.

The read_mos_reg function is called with stack-allocated buffers, which
must not be used for control messages.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7720.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index a07dd3c..52b3342 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -234,11 +234,22 @@ static int read_mos_reg(struct usb_serial *serial, unsigned int serial_portnum,
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

