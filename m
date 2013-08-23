Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3HWV1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:27:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3HWVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 08/15] Input: serio: convert bus code to use drv_groups
Date: Fri, 23 Aug 2013 14:24:34 -0700
Message-Id: <1377293081-10957-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drv_attrs field of struct bus_type is going away soon, drv_groups
should be used instead.  This converts the serio bus code to use the
correct field.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/serio.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 25fc5971..2b56855c 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -732,19 +732,20 @@ EXPORT_SYMBOL(serio_unregister_child_port);
  * Serio driver operations
  */
 
-static ssize_t serio_driver_show_description(struct device_driver *drv, char *buf)
+static ssize_t description_show(struct device_driver *drv, char *buf)
 {
 	struct serio_driver *driver = to_serio_driver(drv);
 	return sprintf(buf, "%s\n", driver->description ? driver->description : "(none)");
 }
+static DRIVER_ATTR_RO(description);
 
-static ssize_t serio_driver_show_bind_mode(struct device_driver *drv, char *buf)
+static ssize_t bind_mode_show(struct device_driver *drv, char *buf)
 {
 	struct serio_driver *serio_drv = to_serio_driver(drv);
 	return sprintf(buf, "%s\n", serio_drv->manual_bind ? "manual" : "auto");
 }
 
-static ssize_t serio_driver_set_bind_mode(struct device_driver *drv, const char *buf, size_t count)
+static ssize_t bind_mode_store(struct device_driver *drv, const char *buf, size_t count)
 {
 	struct serio_driver *serio_drv = to_serio_driver(drv);
 	int retval;
@@ -760,14 +761,14 @@ static ssize_t serio_driver_set_bind_mode(struct device_driver *drv, const char
 
 	return retval;
 }
+static DRIVER_ATTR_RW(bind_mode);
 
-
-static struct driver_attribute serio_driver_attrs[] = {
-	__ATTR(description, S_IRUGO, serio_driver_show_description, NULL),
-	__ATTR(bind_mode, S_IWUSR | S_IRUGO,
-		serio_driver_show_bind_mode, serio_driver_set_bind_mode),
-	__ATTR_NULL
+static struct attribute *serio_driver_attrs[] = {
+	&driver_attr_description.attr,
+	&driver_attr_bind_mode.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(serio_driver);
 
 static int serio_driver_probe(struct device *dev)
 {
@@ -996,7 +997,7 @@ EXPORT_SYMBOL(serio_interrupt);
 static struct bus_type serio_bus = {
 	.name		= "serio",
 	.dev_attrs	= serio_device_attrs,
-	.drv_attrs	= serio_driver_attrs,
+	.drv_groups	= serio_driver_groups,
 	.match		= serio_bus_match,
 	.uevent		= serio_uevent,
 	.probe		= serio_driver_probe,
-- 
1.8.3.rc0.20.gb99dd2e

