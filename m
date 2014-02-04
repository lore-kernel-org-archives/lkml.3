Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935065AbaBDVdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:33:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591AbaBDVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3.13 094/140] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
Date: Tue,  4 Feb 2014 13:11:21 -0800
Message-Id: <20140204211039.662803403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_i2c_stm_st33.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -410,6 +410,8 @@ static int recv_data(struct tpm_chip *ch
 			     &chip->vendor.read_queue)
 	       == 0) {
 		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0)
+			return burstcnt;
 		len = min_t(int, burstcnt, count - size);
 		I2C_READ_DATA(client, TPM_DATA_FIFO, buf + size, len);
 		size += len;
@@ -451,7 +453,8 @@ static irqreturn_t tpm_ioserirq_handler(
 static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
 			    size_t len)
 {
-	u32 status, burstcnt = 0, i, size;
+	u32 status, i, size;
+	int burstcnt = 0;
 	int ret;
 	u8 data;
 	struct i2c_client *client;
@@ -482,6 +485,8 @@ static int tpm_stm_i2c_send(struct tpm_c
 
 	for (i = 0; i < len - 1;) {
 		burstcnt = get_burstcount(chip);
+		if (burstcnt < 0)
+			return burstcnt;
 		size = min_t(int, len - i - 1, burstcnt);
 		ret = I2C_WRITE_DATA(client, TPM_DATA_FIFO, buf, size);
 		if (ret < 0)


