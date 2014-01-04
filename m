Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaADCnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:22 -0500
Received: from mout.gmx.net ([212.227.15.15]:55920 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaADCmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:42:51 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 03/15] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
Date: Sat,  4 Jan 2014 03:44:37 +0100
Message-Id: <1388803489-13258-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:qo6AuHPTnDxugOQtHgETgCyBCxtVxmqF40pHHCzMVm7md6N68hc
 yUecMhYpx68W/62Z3aC3qPgu3aKDQJgHnksCVAXQcXmywpOlGs6ZzxFtBVB9O+Yvrw5CJ0n
 UqSpdkmU4J1A0ID0yXwrSIQ0kfgkFG6yoz7nTBhms2xGlTmYufSEIGFbkhrAm1XFIAyFjET
 aa9EMNdon6EPm8S1JqjSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

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
Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index a0d6ceb5..cf68403 100644
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
1.8.1.5

