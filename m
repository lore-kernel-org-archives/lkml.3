Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaBGLtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaBGLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 066/233] [media] dib8000: make 32 bits read atomic
Date: Fri,  7 Feb 2014 11:44:45 +0000
Message-Id: <1391773652-25214-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 5ac64ba12aca3bef18e61c866583155a3bbf81c4 upstream.

As the dvb-frontend kthread can be called anytime, it can race
with some get status ioctl. So, it seems better to avoid one to
race with the other while reading a 32 bits register.
I can't see any other reason for having a mutex there at I2C, except
to provide such kind of protection, as the I2C core already has a
mutex to protect I2C transfers.

Note: instead of this approach, it could eventually remove the dib8000
specific mutex for it, and either group the 4 ops into one xfer or
to manually control the I2C mutex. The main advantage of the current
approach is that the changes are smaller and more puntual.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-frontends/dib8000.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 487c253..ccac846 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -157,15 +157,10 @@ static u16 dib8000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	return ret;
 }
 
-static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+static u16 __dib8000_read_word(struct dib8000_state *state, u16 reg)
 {
 	u16 ret;
 
-	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
-		return 0;
-	}
-
 	state->i2c_write_buffer[0] = reg >> 8;
 	state->i2c_write_buffer[1] = reg & 0xff;
 
@@ -183,6 +178,21 @@ static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
 		dprintk("i2c read error on %d", reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
+
+	return ret;
+}
+
+static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+{
+	u16 ret;
+
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	ret = __dib8000_read_word(state, reg);
+
 	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ret;
@@ -192,8 +202,15 @@ static u32 dib8000_read32(struct dib8000_state *state, u16 reg)
 {
 	u16 rw[2];
 
-	rw[0] = dib8000_read_word(state, reg + 0);
-	rw[1] = dib8000_read_word(state, reg + 1);
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	rw[0] = __dib8000_read_word(state, reg + 0);
+	rw[1] = __dib8000_read_word(state, reg + 1);
+
+	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ((rw[0] << 16) | (rw[1]));
 }
-- 
1.8.3.2

