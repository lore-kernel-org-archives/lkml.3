Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3HUWpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3HUWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        David Stevenson <david@avoncliff.com>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>,
        Michael Arndt <michael@scriptkiller.de>
Subject: [PATCH 02/11] w1: slaves: w1_therm: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:44:56 -0700
Message-Id: <1377125105-25388-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Stevenson <david@avoncliff.com>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Michael Arndt <michael@scriptkiller.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_therm.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 8978360b..8b5ff33f 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -59,25 +59,19 @@ static int w1_strong_pullup = 1;
 module_param_named(strong_pullup, w1_strong_pullup, int, 0);
 
 
-static ssize_t w1_therm_read(struct device *device,
+static ssize_t w1_slave_show(struct device *device,
 	struct device_attribute *attr, char *buf);
 
-static struct device_attribute w1_therm_attr =
-	__ATTR(w1_slave, S_IRUGO, w1_therm_read, NULL);
+static DEVICE_ATTR_RO(w1_slave);
 
-static int w1_therm_add_slave(struct w1_slave *sl)
-{
-	return device_create_file(&sl->dev, &w1_therm_attr);
-}
-
-static void w1_therm_remove_slave(struct w1_slave *sl)
-{
-	device_remove_file(&sl->dev, &w1_therm_attr);
-}
+static struct attribute *w1_therm_attrs[] = {
+	&dev_attr_w1_slave.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(w1_therm);
 
 static struct w1_family_ops w1_therm_fops = {
-	.add_slave	= w1_therm_add_slave,
-	.remove_slave	= w1_therm_remove_slave,
+	.groups		= w1_therm_groups,
 };
 
 static struct w1_family w1_therm_family_DS18S20 = {
@@ -178,7 +172,7 @@ static inline int w1_convert_temp(u8 rom[9], u8 fid)
 }
 
 
-static ssize_t w1_therm_read(struct device *device,
+static ssize_t w1_slave_show(struct device *device,
 	struct device_attribute *attr, char *buf)
 {
 	struct w1_slave *sl = dev_to_w1_slave(device);
-- 
1.8.3.rc0.20.gb99dd2e

