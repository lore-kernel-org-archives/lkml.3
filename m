Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162493Ab3LFNeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:34:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161702Ab3LFNDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 170/272] [media] cimax2: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:39 +0000
Message-Id: <1386334761-25517-171-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/pci/cx23885/cimax2.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 7344849..16fa7ea 100644
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
@@ -125,7 +129,7 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
 {
 	int ret;
-	u8 buffer[len + 1];
+	u8 buffer[MAX_XFER_SIZE];
 
 	struct i2c_msg msg = {
 		.addr	= addr,
@@ -134,6 +138,13 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
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
 
-- 
1.8.3.2

