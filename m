Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3EVKAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:00:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:6211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab3EVKAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="306162491"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] i2c: designware: prevent signals from aborting I2C transfers
Date: Wed, 22 May 2013 13:03:11 +0300
Message-Id: <1369216991-13334-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process receives signal while it is waiting for I2C transfer to
complete, an error is returned to the caller and the transfer is aborted.
This can cause the driver to fail subsequent transfers. Also according to
commit d295a86eab2 (i2c: mv64xxx: work around signals causing I2C
transactions to be aborted) I2C drivers aren't supposed to abort
transactions on signals.

To prevent this switch to use wait_for_completion_timeout() instead of
wait_for_completion_interruptible_timeout() in the designware I2C driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index c41ca63..db20a28 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -580,14 +580,13 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	i2c_dw_xfer_init(dev);
 
 	/* wait for tx to complete */
-	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete, HZ);
+	ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		i2c_dw_init(dev);
 		ret = -ETIMEDOUT;
 		goto done;
-	} else if (ret < 0)
-		goto done;
+	}
 
 	if (dev->msg_err) {
 		ret = dev->msg_err;
-- 
1.7.10.4

