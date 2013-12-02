Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3LBUes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:34:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3LBTO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 154/173] media: stb0899_drv: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:17 -0800
Message-Id: <20131202191201.001333691@linuxfoundation.org>
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

commit ba4746423488aafa435739c32bfe0758f3dd5d77 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/dvb-frontends/stb0899_drv.c:540:1: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 64 bytes for	the control URBs.
So, it seem safe to use 64 bytes as the hard limit for all those devices.
 On most cases, the limit is a way lower than that, but	this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/stb0899_drv.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -32,6 +32,9 @@
 #include "stb0899_priv.h"
 #include "stb0899_reg.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static unsigned int verbose = 0;//1;
 module_param(verbose, int, 0644);
 
@@ -499,7 +502,7 @@ err:
 int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data, u32 count)
 {
 	int ret;
-	u8 buf[2 + count];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg i2c_msg = {
 		.addr	= state->config->demod_address,
 		.flags	= 0,
@@ -507,6 +510,13 @@ int stb0899_write_regs(struct stb0899_st
 		.len	= 2 + count
 	};
 
+	if (2 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, count);
+		return -EINVAL;
+	}
+
 	buf[0] = reg >> 8;
 	buf[1] = reg & 0xff;
 	memcpy(&buf[2], data, count);


