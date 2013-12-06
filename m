Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162637Ab3LFNaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:30:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161772Ab3LFNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 180/272] [media] s5h1420: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:49 +0000
Message-Id: <1386334761-25517-181-git-send-email-luis.henriques@canonical.com>
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

commit 9736a89dafe07359d9c86bf9c3b815a250b354bc upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/dvb-frontends/s5h1420.c:851:1: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer.
In the specific case of this frontend, only ttpci uses it. The maximum
number of messages there is two, on I2C read operations. As the logic
can add an extra operation, change the size to 3.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/s5h1420.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index e2fec9e..93eeaf7 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -836,9 +836,16 @@ static u32 s5h1420_tuner_i2c_func(struct i2c_adapter *adapter)
 static int s5h1420_tuner_i2c_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[], int num)
 {
 	struct s5h1420_state *state = i2c_get_adapdata(i2c_adap);
-	struct i2c_msg m[1 + num];
+	struct i2c_msg m[3];
 	u8 tx_open[2] = { CON_1, state->CON_1_val | 1 }; /* repeater stops once there was a stop condition */
 
+	if (1 + num > ARRAY_SIZE(m)) {
+		printk(KERN_WARNING
+		       "%s: i2c xfer: num=%d is too big!\n",
+		       KBUILD_MODNAME, num);
+		return  -EOPNOTSUPP;
+	}
+
 	memset(m, 0, sizeof(struct i2c_msg) * (1 + num));
 
 	m[0].addr = state->config->demod_address;
@@ -847,7 +854,7 @@ static int s5h1420_tuner_i2c_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c
 
 	memcpy(&m[1], msg, sizeof(struct i2c_msg) * num);
 
-	return i2c_transfer(state->i2c, m, 1+num) == 1 + num ? num : -EIO;
+	return i2c_transfer(state->i2c, m, 1 + num) == 1 + num ? num : -EIO;
 }
 
 static struct i2c_algorithm s5h1420_tuner_i2c_algo = {
-- 
1.8.3.2

