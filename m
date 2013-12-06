Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161763Ab3LFNDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161742Ab3LFND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 175/272] [media] stv090x: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:44 +0000
Message-Id: <1386334761-25517-176-git-send-email-luis.henriques@canonical.com>
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

commit f7a35df15b1f7de7823946aebc9164854e66ea07 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
       drivers/media/dvb-frontends/stv090x.c:750:1: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]
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
 drivers/media/dvb-frontends/stv090x.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 56d470a..23e872f 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -35,6 +35,9 @@
 #include "stv090x.h"
 #include "stv090x_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 
@@ -722,9 +725,16 @@ static int stv090x_write_regs(struct stv090x_state *state, unsigned int reg, u8
 {
 	const struct stv090x_config *config = state->config;
 	int ret;
-	u8 buf[2 + count];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg i2c_msg = { .addr = config->address, .flags = 0, .buf = buf, .len = 2 + count };
 
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

