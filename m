Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3KQI7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 03:59:14 -0500
Received: from mout.gmx.net ([212.227.17.22]:56599 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab3KQI7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 03:59:00 -0500
From: Andreas Werner <wernerandy@gmx.de>
To: wsa@the-dreams.de
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, wernerandy@gmx.de
Subject: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in syslog if no ACK received
Date: Sun, 17 Nov 2013 09:58:51 +0100
Message-Id: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
X-Mailer: git-send-email 1.8.4.2
X-Provags-ID: V03:K0:P5VCAwtHYmfav9VONhwdxSxM3hphsSxCJdn6YPvLPg9Hek9RDq+
 3eUzUkJUPXSRAdk/i6PhwdWYcxTNmEUpYU9g0yVES+OgWe+BhcBFHuCJDCVU151zvHhnwh3
 DoVkVxi4AJTxIxQYtkWlZECt/A8S2HFrDP97nuGd4ZkiceOCk7gnYHayx5rS8htvBZt8Zzg
 J1BlQf7mtyFKV6S92LHvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revision 2:
	- delete the pch_err completly instead of changing to pch_dbg
	  because there is already a pch_dbg at the function who calls
	  pch_i2c_getack.
	- Fixed message line issue

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
calling pch_i2c_getack, and there is already a dbg print if it fails,
so we can delete the pch_err in pch_i2c_getack completly.

Fixed print message to be a one liner so we can grep for the
error message.

Tested on Intel Atom E6xx and Eg20t Chipset.

Signed-off-by: Andreas Werner <wernerandy@gmx.de>
---
 drivers/i2c/busses/i2c-eg20t.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index 0f37529..5c39f90 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -321,10 +321,8 @@ static s32 pch_i2c_getack(struct i2c_algo_pch_data *adap)
 	void __iomem *p = adap->pch_base_address;
 	reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
 
-	if (reg_val != 0) {
-		pch_err(adap, "return%d\n", -EPROTO);
+	if (reg_val != 0)
 		return -EPROTO;
-	}
 
 	return 0;
 }
@@ -367,8 +365,7 @@ static int pch_i2c_wait_for_check_xfer(struct i2c_algo_pch_data *adap)
 	adap->pch_event_flag = 0;
 
 	if (pch_i2c_getack(adap)) {
-		pch_dbg(adap, "Receive NACK for slave address"
-			"setting\n");
+		pch_dbg(adap, "Receive NACK for slave address setting\n");
 		return -EIO;
 	}
 
-- 
1.8.4

