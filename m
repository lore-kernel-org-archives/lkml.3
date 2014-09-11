Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaIKLLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:11:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36220 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaIKLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:11:50 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        nick.dyer@itdev.co.uk, sjoerd.simons@collabora.co.uk,
        lee.jones@linaro.org, dmitry.torokhov@gmail.com,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RFC] i2c: report OF style modalias when probing using DT
Date: Thu, 11 Sep 2014 13:11:41 +0200
Message-Id: <1410433901-30011-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An I2C driver that supports both OF and legacy platforms, will have
both a OF and I2C ID table. This means that when built as a module,
the aliases will be filled from both tables but currently always an
alias of the form i2c:<deviceId> is reported, e.g:

$ cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
i2c:maxtouch

So if a device is probed by matching its compatible string, udev can
get a MODALIAS uevent env var that doesn't match with one of the valid
aliases so the module won't be auto-loaded by libkmod/modprobe.

This patch reports OF related uevent env vars (OF_COMPATIBLE) and also
so the module can be auto-loaded report the correct alias using sysfs:

$ cat /sys/class/i2c-adapter/i2c-8/8-004b/modalias
of:NtrackpadT<NULL>Catmel,maxtouch

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Hello,

I'm posting this patch as an RFC because it will regress module auto
loading for all I2C drivers that were relying on the old behavior of
using the i2c:<deviceId> alias. This means drivers that doesn't have
an OF table of that are not using the MOD_DEVICE_TABLE(of,...) macro.

Best regards,
Javier

 drivers/i2c/i2c-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 632057a..ec13c7e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -122,6 +122,10 @@ static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct i2c_client	*client = to_i2c_client(dev);
 	int rc;
 
+	rc = of_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
 	rc = acpi_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
 		return rc;
@@ -431,6 +435,10 @@ show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 	struct i2c_client *client = to_i2c_client(dev);
 	int len;
 
+	len = of_device_get_modalias(dev, buf, PAGE_SIZE - 1);
+	if (len != -ENODEV)
+		return len;
+
 	len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
 	if (len != -ENODEV)
 		return len;
-- 
2.1.0

