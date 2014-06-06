Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaFFPyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:54:04 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51425 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaFFPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:53:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/9] of/device: Allow I2C devices to OF match without supplying an OF node
Date: Fri,  6 Jun 2014 16:52:30 +0100
Message-Id: <1402069952-28022-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
References: <1402069952-28022-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C framework supplies a means for devices to be registered without
the requirement for platform_data, DT or ACPI.  The current solution is
that every single I2C device in the kernel is forced to supply a
normally empty/sparse I2C ID table so the I2C subsystem can match to.
In an effort to rid the kernel of these tables we need to provide some
temporary work arounds until we can straighten out the blocking factors.

This change is meant to be temporary and will be stripped out once
we've converted all I2C device drivers from of_match_device() over
to the new I2C generic i2c_of_match_device().

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/of/device.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index dafb973..3b1c8f9 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -1,6 +1,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
+#include <linux/i2c.h>
 #include <linux/of_device.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -21,9 +22,25 @@
 const struct of_device_id *of_match_device(const struct of_device_id *matches,
 					   const struct device *dev)
 {
+	const struct of_device_id *match;
+
 	if ((!matches) || (!dev->of_node))
 		return NULL;
-	return of_match_node(matches, dev->of_node);
+
+	match = of_match_node(matches, dev->of_node);
+	if (match)
+		return match;
+
+	/*
+	 * Low impact workaround, until we can convert all I2C compatible
+	 * strings over to the correctly specified <vendor>,<device> format.
+	 */
+	match = i2c_of_match_device_strip_vendor(matches, (struct device *)dev);
+	if (match)
+		dev_warn(dev,
+			 "WARNING: Vendor ID missing from compatible string\n");
+
+	return match;
 }
 EXPORT_SYMBOL(of_match_device);
 
-- 
1.8.3.2

