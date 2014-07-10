Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaGJLwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:52:08 -0400
Received: from sauhun.de ([89.238.76.85]:57076 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaGJLqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:46 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] i2c: add debug info when class instantiation was dropped
Date: Thu, 10 Jul 2014 13:46:21 +0200
Message-Id: <1404992799-3705-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a warning already when support for old-fashioned class based
instantiation is about to be dropped somewhen soon from a driver. Let's
have another one when it was actually dropped. This allows to remove the
cruft a little earlier and still let users know what happened in the
rare case they are missing devices after the change. However, there is
enough interest to get rid of class based instantiation rather sooner
than later because it improves boot up time.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/i2c-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 4ccff114b147..a1eeb8a5d3f8 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1915,6 +1915,16 @@ static int i2c_detect(struct i2c_adapter *adapter, struct i2c_driver *driver)
 	if (!driver->detect || !address_list)
 		return 0;
 
+	/* Warn that the adapter lost class based instantiation */
+	if (adapter->class == I2C_CLASS_DEPRECATED) {
+		dev_dbg(&adapter->dev,
+			"This adapter dropped support for I2C classes and "
+			"won't auto-detect %s devices anymore. If you need it, check "
+			"'Documentation/i2c/instantiating-devices' for alternatives.\n",
+			driver->driver.name);
+		return 0;
+	}
+
 	/* Stop here if the classes do not match */
 	if (!(adapter->class & driver->class))
 		return 0;
-- 
2.0.0

