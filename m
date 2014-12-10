Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaLJLpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:45:42 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:61757 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaLJLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:45:40 -0500
From: Harini Katakam <harinik@xilinx.com>
To: wsa@the-dreams.de, mark.rutland@arm.com
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
        harinik@xilinx.com, Vishnu Motghare <vishnum@xilinx.com>
Subject: [PATCH v4 2/2] i2c: cadence: Check for errata condition involving master receive
Date: Wed, 10 Dec 2014 17:14:44 +0530
Message-Id: <1418211884-5329-3-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418211884-5329-1-git-send-email-harinik@xilinx.com>
References: <1418211884-5329-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cadence I2C controller has the following bugs:
- completion indication is not given to the driver at the end of
a read/receive transfer with HOLD bit set.
- Invalid read transaction are generated on the bus when HW timeout
condition occurs with HOLD bit set.

As a result of the above, if a set of messages to be transferred with
repeated start includes any transfer following a read transfer,
completion is never indicated and timeout occurs.
Hence a check is implemented to return -EOPNOTSUPP for such sequences.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
---

v4:
Use single dev_warn and make message grep-able.

v3:
Add warning in case of unsupported transfer.

v2:
Dont defeteature repeated start. Just check for unsupported conditions in the
driver and return error.

---
 drivers/i2c/busses/i2c-cadence.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 5f5d4fa..f9269a6 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -541,6 +541,20 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	 * processed with a repeated start.
 	 */
 	if (num > 1) {
+		/*
+		 * This controller does not give completion interrupt after a
+		 * master receive transfer if HOLD bit is set (repeated start),
+		 * resulting in SW timeout. Hence, if a receive transfer is
+		 * followed by any other transfer, an error is returned
+		 * indicating that this sequence is not supported.
+		 */
+		for (count = 0; count < num-1; count++) {
+			if (msgs[count].flags & I2C_M_RD)
+				dev_warn(adap->dev.parent, "No support for "
+					 "repeated start when receive is "
+					 "followed by a transfer\n");
+				return -EOPNOTSUPP;
+		}
 		id->bus_hold_flag = 1;
 		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
 		reg |= CDNS_I2C_CR_HOLD;
-- 
1.7.9.5

