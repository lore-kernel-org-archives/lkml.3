Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3HUWp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3HUWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 05/11] w1: slaves: w1_ds2423: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:44:59 -0700
Message-Id: <1377125105-25388-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds2423.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2423.c b/drivers/w1/slaves/w1_ds2423.c
index 7f86aec7..7e41b7d9 100644
--- a/drivers/w1/slaves/w1_ds2423.c
+++ b/drivers/w1/slaves/w1_ds2423.c
@@ -40,14 +40,8 @@
 #define COUNTER_COUNT 4
 #define READ_BYTE_COUNT 42
 
-static ssize_t w1_counter_read(struct device *device,
-	struct device_attribute *attr, char *buf);
-
-static struct device_attribute w1_counter_attr =
-	__ATTR(w1_slave, S_IRUGO, w1_counter_read, NULL);
-
-static ssize_t w1_counter_read(struct device *device,
-	struct device_attribute *attr, char *out_buf)
+static ssize_t w1_slave_show(struct device *device,
+			     struct device_attribute *attr, char *out_buf)
 {
 	struct w1_slave *sl = dev_to_w1_slave(device);
 	struct w1_master *dev = sl->master;
@@ -128,19 +122,16 @@ static ssize_t w1_counter_read(struct device *device,
 	return PAGE_SIZE - c;
 }
 
-static int w1_f1d_add_slave(struct w1_slave *sl)
-{
-	return device_create_file(&sl->dev, &w1_counter_attr);
-}
+static DEVICE_ATTR_RO(w1_slave);
 
-static void w1_f1d_remove_slave(struct w1_slave *sl)
-{
-	device_remove_file(&sl->dev, &w1_counter_attr);
-}
+static struct attribute *w1_f1d_attrs[] = {
+	&dev_attr_w1_slave.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(w1_f1d);
 
 static struct w1_family_ops w1_f1d_fops = {
-	.add_slave      = w1_f1d_add_slave,
-	.remove_slave   = w1_f1d_remove_slave,
+	.groups		= w1_f1d_groups,
 };
 
 static struct w1_family w1_family_1d = {
-- 
1.8.3.rc0.20.gb99dd2e

