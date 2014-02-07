Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaBGNBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:01:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaBGLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/233] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
Date: Fri,  7 Feb 2014 11:45:01 +0000
Message-Id: <1391773652-25214-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <PeterHuewe@gmx.de>

commit 85c5e0d451125c6ddb78663972e40af810b83644 upstream.

The 'get_burstcount' function can in some circumstances 'return -EBUSY' which
in tpm_stm_i2c_send is stored in an 'u32 burstcnt'
thus converting the signed value into an unsigned value, resulting
in 'burstcnt' being huge.
Changing the type to u32 only does not solve the problem as the signed
value is converted to an unsigned in I2C_WRITE_DATA, resulting in the
same effect.

Thus
-> Change type of burstcnt to u32 (the return type of get_burstcount)
-> Add a check for the return value of 'get_burstcount' and propagate a
potential error.

This makes also sense in the 'I2C_READ_DATA' case, where the there is no
signed/unsigned conversion.

found by coverity
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 5bb8e2d..156bd3c 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -410,6 +410,8 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 			     &chip->vendor.read_queue)
 	       == 0) {
 		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0)
+			return burstcnt;
 		len = min_t(int, burstcnt, count - size);
 		I2C_READ_DATA(client, TPM_DATA_FIFO, buf + size, len);
 		size += len;
@@ -451,7 +453,8 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
 static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
 			    size_t len)
 {
-	u32 status, burstcnt = 0, i, size;
+	u32 status, i, size;
+	int burstcnt = 0;
 	int ret;
 	u8 data;
 	struct i2c_client *client;
@@ -482,6 +485,8 @@ static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
 
 	for (i = 0; i < len - 1;) {
 		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0)
+			return burstcnt;
 		size = min_t(int, len - i - 1, burstcnt);
 		ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf, size);
 		if (ret < 0)
-- 
1.8.3.2

