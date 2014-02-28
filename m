Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaB1VXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:23:23 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:53313 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbaB1VXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:23:09 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 3/3] media/drx39xyj: fix boot failure due to null pointer dereference
Date: Fri, 28 Feb 2014 14:23:02 -0700
Message-Id: <d3568a908a443ba07681636452c79a070cf05118.1393621530.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DJH_DEBUG only code path in drxbsp_i2c_write_read() dereferences
w_dev_addr and subsequently w_dev_addr->user_data->i2c which results
in failure during boot. This patch fixes the null pointer derefence
bug as well as the following compile errors:

  LD      arch/x86/built-in.o
  CC      drivers/media/dvb-frontends/drx39xyj/drxj.o
drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘drxbsp_i2c_write_read’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:1558:25: error: redeclaration of ‘state’ with no linkage
  struct drx39xxj_state *state = w_dev_addr->user_data;
                         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1512:25: note: previous declaration of ‘state’ was here
  struct drx39xxj_state *state;
                         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1558:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
  struct drx39xxj_state *state = w_dev_addr->user_data;
  ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1560:17: error: redeclaration of ‘msg’ with no linkage
  struct i2c_msg msg[2] = {
                 ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1513:17: note: previous declaration of ‘msg’ was here
  struct i2c_msg msg[2];
                 ^

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 72c541a..585d891 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1551,14 +1551,23 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 	}
 
 #ifdef DJH_DEBUG
-	struct drx39xxj_state *state = w_dev_addr->user_data;
+	if (w_dev_addr == NULL || r_dev_addr == NULL)
+		return 0;
 
-	struct i2c_msg msg[2] = {
-		{.addr = w_dev_addr->i2c_addr,
-		 .flags = 0, .buf = wData, .len = w_count},
-		{.addr = r_dev_addr->i2c_addr,
-		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
-	};
+	state = w_dev_addr->user_data;
+
+	if (state->i2c == NULL)
+		return 0;
+
+	msg[0].addr = w_dev_addr->i2c_addr;
+	msg[0].flags = 0;
+	msg[0].buf = wData;
+	msg[0].len = w_count;
+	msg[1].addr = r_dev_addr->i2c_addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = r_data;
+	msg[1].len = r_count;
+	num_msgs = 2;
 
 	pr_debug("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
 	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
-- 
1.8.3.2

