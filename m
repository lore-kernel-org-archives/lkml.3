Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3J2Xuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:50:54 -0400
Received: from mout.gmx.net ([212.227.17.20]:53439 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3J2Xuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:50:52 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of get_burstcount (fix CID: 986658)
Date: Wed, 30 Oct 2013 00:54:20 +0100
Message-Id: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Provags-ID: V03:K0:iBUnQNmCpQiL4ACz7Q3Rx6M8UEu/X+Lku+6s8BZ7aXsLX2oEAMp
 /7LVV4bzoaNYOwk9mu43JWlpw02b4rINpzt8vH2Oks8FrZmpFvtlbmNTI4PXecBGdytUYBV
 OrhneKT4RRXaMipL2hvjbF9EdHep97bOXYbri+MB6Glfee4nXWMyuR/rs2Fe3QNrARrELej
 CwRmsmVl7+dvqX53RXTvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity complains about
"Improper use of negative value
The negative value may be unexpected by later operations, causing
incorrect computations.
In tpm_stm_i2c_send: Negative value can be returned from function is not
being checked before being used improperly (CWE-394)"

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

CID: 986658
Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

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
1.7.8.6

