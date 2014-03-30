Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbaCaAcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:32:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36231 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Patrick Boettcher" <pboettcher@kernellabs.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.542029060@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 009/200] [media] dib8000: make 32 bits read atomic
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/dib8000.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -114,15 +114,10 @@ static u16 dib8000_i2c_read16(struct i2c
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
 
@@ -140,6 +135,21 @@ static u16 dib8000_read_word(struct dib8
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
@@ -149,8 +159,15 @@ static u32 dib8000_read32(struct dib8000
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

