Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161778Ab3LFNDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161753Ab3LFND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 177/272] [media] stb0899_drv: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:46 +0000
Message-Id: <1386334761-25517-178-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/stb0899_drv.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 3dd5714..07cd5ea 100644
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
@@ -507,6 +510,13 @@ int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data,
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
-- 
1.8.3.2

