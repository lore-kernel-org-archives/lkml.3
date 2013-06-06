Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3FFNoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:44:09 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27312 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3FFNoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:44:07 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c: designware: fix race between subsequent xfers
Date: Thu,  6 Jun 2013 15:43:35 +0200
Message-Id: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The designware block is not always properly disabled in the case of
transfer errors. Interrupts from aborted transfers might be handled
after the data structures for the following transfer are initialised but
before the hardware is set up. This might corrupt the data structures to
the point that the system is stuck in an infinite interrupt loop (where
FIFOs are never emptied).
This patch cleanly disables the designware-i2c hardware at the end of
every transfer, successful or not.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 6c0e776..65c0c7a 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -588,10 +588,20 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete, HZ);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
+		/* i2c_dw_init implicitly disables the adapter */
 		i2c_dw_init(dev);
 		ret = -ETIMEDOUT;
 		goto done;
-	} else if (ret < 0)
+	}
+
+	/*
+	 * We must disable the adapter before unlocking the &dev->lock mutex
+	 * below. Otherwise the hardware might continue generating interrupts
+	 * which in turn causes a race condition with the following transfer.
+	 */
+	__i2c_dw_enable(dev, false);
+
+	if (ret < 0)
 		goto done;
 
 	if (dev->msg_err) {
@@ -601,8 +611,6 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 
 	/* no error */
 	if (likely(!dev->cmd_err)) {
-		/* Disable the adapter */
-		__i2c_dw_enable(dev, false);
 		ret = num;
 		goto done;
 	}
-- 
1.7.1

