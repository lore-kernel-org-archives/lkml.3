Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3LBTTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:19:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3LBTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.12 191/212] media: dibusb-common: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:22 -0800
Message-Id: <20131202191310.180548843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 1d7fa359d4c0fbb2756fa01cc47212908d90b7b0 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/dibusb-common.c:124:1: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/dibusb-common.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -12,6 +12,9 @@
 #include <linux/kconfig.h>
 #include "dibusb.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (|-able))." DVB_USB_DEBUG_STATUS);
@@ -105,11 +108,16 @@ EXPORT_SYMBOL(dibusb2_0_power_ctrl);
 static int dibusb_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
-	u8 sndbuf[wlen+4]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
+	u8 sndbuf[MAX_XFER_SIZE]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
 	/* write only ? */
 	int wo = (rbuf == NULL || rlen == 0),
 		len = 2 + wlen + (wo ? 0 : 2);
 
+	if (4 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n", wlen);
+		return -EOPNOTSUPP;
+	}
+
 	sndbuf[0] = wo ? DIBUSB_REQ_I2C_WRITE : DIBUSB_REQ_I2C_READ;
 	sndbuf[1] = (addr << 1) | (wo ? 0 : 1);
 


