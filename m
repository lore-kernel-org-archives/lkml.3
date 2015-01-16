Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbbAPIHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:07:35 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:51606 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbAPIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:07:29 -0500
Date: Fri, 16 Jan 2015 00:07:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: do not try to load modules for of-registered devices
Message-ID: <20150116080722.GA7813@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to register an I2C device asynchronously (via async_schedule() call)
results in an ugly warning from request_module() warning about potential
deadlock (because request_module tries to wait for async works to
complete). While we could try to switch to request_module_nowait(), other
buses, as well as I2C itself when not using device tree, do not try to load
modules, but rather rely on the standard infrastructure (udev) to execute
module loading, and we should be doing the same.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/i2c/i2c-core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 39d25a8..706caea 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1419,8 +1419,6 @@ static struct i2c_client *of_i2c_register_device(struct i2c_adapter *adap,
 	if (of_get_property(node, "wakeup-source", NULL))
 		info.flags |= I2C_CLIENT_WAKE;
 
-	request_module("%s%s", I2C_MODULE_PREFIX, info.type);
-
 	result = i2c_new_device(adap, &info);
 	if (result == NULL) {
 		dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
