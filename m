Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3JGG4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:56:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3JGG4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:56:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, <linux-mmc@vger.kernel.org>
Subject: [PATCH 04/11] MMC: convert bus code to use dev_groups
Date: Sun,  6 Oct 2013 23:55:43 -0700
Message-Id: <1381128950-28125-5-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the MMC bus code to use the
correct field.

Cc: Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Konstantin Dorfman <kdorfman@codeaurora.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Chris, I can take this through my driver-core tree if you like, just let
me know what would be the easiest for you.

 drivers/mmc/core/bus.c      | 12 +++++++-----
 drivers/mmc/core/sdio_bus.c | 21 ++++++++++++---------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 704bf66..3e227bd 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -27,7 +27,7 @@
 
 #define to_mmc_driver(d)	container_of(d, struct mmc_driver, drv)
 
-static ssize_t mmc_type_show(struct device *dev,
+static ssize_t type_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct mmc_card *card = mmc_dev_to_card(dev);
@@ -45,11 +45,13 @@ static ssize_t mmc_type_show(struct device *dev,
 		return -EFAULT;
 	}
 }
+static DEVICE_ATTR_RO(type);
 
-static struct device_attribute mmc_dev_attrs[] = {
-	__ATTR(type, S_IRUGO, mmc_type_show, NULL),
-	__ATTR_NULL,
+static struct attribute *mmc_dev_attrs[] = {
+	&dev_attr_type.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(mmc_dev);
 
 /*
  * This currently matches any MMC driver to any MMC card - drivers
@@ -218,7 +220,7 @@ static const struct dev_pm_ops mmc_bus_pm_ops = {
 
 static struct bus_type mmc_bus_type = {
 	.name		= "mmc",
-	.dev_attrs	= mmc_dev_attrs,
+	.dev_groups	= mmc_dev_groups,
 	.match		= mmc_bus_match,
 	.uevent		= mmc_bus_uevent,
 	.probe		= mmc_bus_probe,
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 6d67492..ef89565 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -34,7 +34,8 @@ field##_show(struct device *dev, struct device_attribute *attr, char *buf)				\
 									\
 	func = dev_to_sdio_func (dev);					\
 	return sprintf (buf, format_string, func->field);		\
-}
+}									\
+static DEVICE_ATTR_RO(field)
 
 sdio_config_attr(class, "0x%02x\n");
 sdio_config_attr(vendor, "0x%04x\n");
@@ -47,14 +48,16 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "sdio:c%02Xv%04Xd%04X\n",
 			func->class, func->vendor, func->device);
 }
-
-static struct device_attribute sdio_dev_attrs[] = {
-	__ATTR_RO(class),
-	__ATTR_RO(vendor),
-	__ATTR_RO(device),
-	__ATTR_RO(modalias),
-	__ATTR_NULL,
+static DEVICE_ATTR_RO(modalias);
+
+static struct attribute *sdio_dev_attrs[] = {
+	&dev_attr_class.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
+	&dev_attr_modalias.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(sdio_dev);
 
 static const struct sdio_device_id *sdio_match_one(struct sdio_func *func,
 	const struct sdio_device_id *id)
@@ -225,7 +228,7 @@ static const struct dev_pm_ops sdio_bus_pm_ops = {
 
 static struct bus_type sdio_bus_type = {
 	.name		= "sdio",
-	.dev_attrs	= sdio_dev_attrs,
+	.dev_groups	= sdio_dev_groups,
 	.match		= sdio_bus_match,
 	.uevent		= sdio_bus_uevent,
 	.probe		= sdio_bus_probe,
-- 
1.8.4.6.g82e253f.dirty

