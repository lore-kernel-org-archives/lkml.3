Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3LBUfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:35:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3LBTO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 153/173] media: stv0367: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:16 -0800
Message-Id: <20131202191200.897965049@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/stv0367.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

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
 
@@ -767,7 +770,7 @@ static struct st_register def0367cab[STV
 static
 int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 {
-	u8 buf[len + 2];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr = state->config->demod_address,
 		.flags = 0,
@@ -776,6 +779,14 @@ int stv0367_writeregs(struct stv0367_sta
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


