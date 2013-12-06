Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161930Ab3LFNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:32:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161698Ab3LFND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/272] [media] stv0367: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:45 +0000
Message-Id: <1386334761-25517-177-git-send-email-luis.henriques@canonical.com>
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

commit 9aca4fb0571ce9cfef680ceb08d19dd008015307 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/dvb-frontends/stv0367.c:791:1: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]
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
 drivers/media/dvb-frontends/stv0367.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 7b6dba3..4587727 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -33,6 +33,9 @@
 #include "stv0367_regs.h"
 #include "stv0367_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static int stvdebug;
 module_param_named(debug, stvdebug, int, 0644);
 
@@ -767,7 +770,7 @@ static struct st_register def0367cab[STV0367CAB_NBREGS] = {
 static
 int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 {
-	u8 buf[len + 2];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr = state->config->demod_address,
 		.flags = 0,
@@ -776,6 +779,14 @@ int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 	};
 	int ret;
 
+	if (2 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
+
 	buf[0] = MSB(reg);
 	buf[1] = LSB(reg);
 	memcpy(buf + 2, data, len);
-- 
1.8.3.2

