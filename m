Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3FGIwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:52:42 -0400
Received: from mail.abilis.ch ([195.70.19.74]:24002 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3FGIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:52:38 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] i2c: designware: fix race between subsequent xfers
Date: Fri,  7 Jun 2013 10:51:23 +0200
Message-Id: <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The designware block is not always properly disabled in the case of
transfer errors. Interrupts from aborted transfers might be handled
after the data structures for the following transfer are initialised but
before the hardware is set up. This can corrupt the data structures to
the point that the system is stuck in an infinite interrupt loop (where
FIFOs are never emptied because dev->msg_read_idx == dev->msgs_num).

This patch cleanly disables the designware-i2c hardware at the end of
every transfer, be it successful or not.

This patch requires https://patchwork.kernel.org/patch/2601241/ to be
applied first.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index b75d292..55a9991 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -588,11 +588,19 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
+		/* i2c_dw_init implicitly disables the adapter */
 		i2c_dw_init(dev);
 		ret = -ETIMEDOUT;
 		goto done;
 	}
 
+	/*
+	 * We must disable the adapter before unlocking the &dev->lock mutex
+	 * below. Otherwise the hardware might continue generating interrupts
+	 * which in turn causes a race condition with the following transfer.
+	 */
+	__i2c_dw_enable(dev, false);
+
 	if (dev->msg_err) {
 		ret = dev->msg_err;
 		goto done;
@@ -600,8 +608,6 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 
 	/* no error */
 	if (likely(!dev->cmd_err)) {
-		/* Disable the adapter */
-		__i2c_dw_enable(dev, false);
 		ret = num;
 		goto done;
 	}
-- 
1.7.1

