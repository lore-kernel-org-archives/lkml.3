Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3KQRqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 12:46:38 -0500
Received: from mout.gmx.net ([212.227.15.19]:65452 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab3KQRqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 12:46:30 -0500
From: Andreas Werner <wernerandy@gmx.de>
To: wsa@the-dreams.de
Cc: jacmet@sunsite.dk, khali@linux-fr.org, dianders@chromium.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        wernerandy@gmx.de
Subject: [PATCH v3] I2C: busses: i2c-eg20t Do not print error message in syslog if no ACK received
Date: Sun, 17 Nov 2013 18:46:20 +0100
Message-Id: <1384710380-5976-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.4.2
X-Provags-ID: V03:K0:5jWWqGPxJGgLHtcTwfKJnDnEH0lCOVF/pN33CqqVWtWhog4CVjt
 tJcQsNrDmixtiwJkuUmjutfiTgligJv5HJJRw1r9QYHtEhqKGtWP6RyAEwJOfJrOK/gJd3P
 wH7jB9BCltGS7XD5ws4AZC6UYLvqeAmmEvhBYQwvl8h8DpKdfpFMZ6+NBFfcDA0JxjTm24M
 iYo6j6AaRyhwgiGrwKfvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the i2c-eg20t driver and call i2cdetect or probe on the bus,
the driver will print a lot of error messages if there was no ACK
received.

i2cdetect normally print a table with all the available devices. If there
is no device on the address, the table will be empty.
Currently with the i2c-eg20t driver, the table is not visible because
the error messages destroy the table.

Error message: pch_i2c_getack return -71

This patch prevent the driver to print the messages to syslog.
The pch_i2c_wait_for_check_xfer function is the only one who is
calling pch_i2c_getack, so we can delete the function and add the
read to pch_i2c_wait_for_check_xfer.
If no ACK is received, the Message will be printed as a dbg
message.

Fixed print message to be a one liner so we can grep for the
error message.

Tested on Intel Atom E6xx and Eg20t Chipset.

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
Revision 2:
        - delete the pch_err completly instead of changing to pch_dbg
          because there is already a pch_dbg at the function who calls
          pch_i2c_getack.
        - Fixed message line issue
Revision 3:
        - delete the pch_i2c_getack function and add the ACK read to
          pch_i2c_wait_for_check_xfer.

 drivers/i2c/busses/i2c-eg20t.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 0f37529..ff15ae9 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -312,24 +312,6 @@ static void pch_i2c_start(struct i2c_algo_pch_data *adap)
 }
 
 /**
- * pch_i2c_getack() - to confirm ACK/NACK
- * @adap:	Pointer to struct i2c_algo_pch_data.
- */
-static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
-{
-	u32 reg_val;
-	void __iomem *p = adap->pch_base_address;
-	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
-
-	if (reg_val != 0) {
-		pch_err(adap, "return%d\n", -EPROTO);
-		return -EPROTO;
-	}
-
-	return 0;
-}
-
-/**
  * pch_i2c_stop() - generate stop condition in normal mode.
  * @adap:	Pointer to struct i2c_algo_pch_data.
  */
@@ -344,6 +326,7 @@ static void pch_i2c_stop(struct i2c_algo_pch_data *adap)
 static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
 {
 	long ret;
+	void __iomem *p = adap->pch_base_address;
 
 	ret = wait_event_timeout(pch_event,
 			(adap->pch_event_flag != 0), msecs_to_jiffies(1000));
@@ -366,10 +349,9 @@ static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
 
 	adap->pch_event_flag = 0;
 
-	if (pch_i2c_getack(adap)) {
-		pch_dbg(adap, "Receive NACK for slave address"
-			"setting\n");
-		return -EIO;
+	if (ioread32(p + PCH_I2CSR) & PCH_GETACK) {
+		pch_dbg(adap, "Receive NACK for slave address setting\n");
+		return -ENXIO;
 	}
 
 	return 0;
-- 
1.8.4.2

