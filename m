Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3LBUja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:39:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3LBTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 147/173] media: cimax2: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:10 -0800
Message-Id: <20131202191200.236922911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 278ba83a3a1932805be726bdd7dfb3156286d33a upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
        drivers/media/pci/cx23885/cimax2.c:149:1: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 64 bytes for the control URBs.
So, it seem safe to use 64 bytes as the hard limit for all those devices.
On most cases, the limit is a way lower than that, but this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx23885/cimax2.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -26,6 +26,10 @@
 #include "cx23885.h"
 #include "cimax2.h"
 #include "dvb_ca_en50221.h"
+
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /**** Bit definitions for MC417_RWD and MC417_OEN registers  ***
   bits 31-16
 +-----------+
@@ -125,7 +129,7 @@ static int netup_write_i2c(struct i2c_ad
 						u8 *buf, int len)
 {
 	int ret;
-	u8 buffer[len + 1];
+	u8 buffer[MAX_XFER_SIZE];
 
 	struct i2c_msg msg = {
 		.addr	= addr,
@@ -134,6 +138,13 @@ static int netup_write_i2c(struct i2c_ad
 		.len	= len + 1
 	};
 
+	if (1 + len > sizeof(buffer)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buffer[0] = reg;
 	memcpy(&buffer[1], buf, len);
 


