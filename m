Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161727Ab3LFNDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161698Ab3LFNDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 167/272] [media] dibusb-common: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:36 +0000
Message-Id: <1386334761-25517-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index c2dded9..6d68af0 100644
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
 
-- 
1.8.3.2

