Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab3GCTDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:03:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043Ab3GCTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:32 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GPhLnbWtZGMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GbiZm08Ugi0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184058.691681127@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [083/141] USB: mos7720: fix DMA to stack
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0083-USB-mos7720-fix-DMA-to-stack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 72ea18a558ed7a63a50bb121ba60d73b5b38ae30 ]

The read_mos_reg function is called with stack-allocated buffers, which
must not be used for control messages.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7720.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index eb84767..5b824d9 100644
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
1.7.10.4


