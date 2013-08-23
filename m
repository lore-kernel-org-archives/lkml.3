Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3HWV1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:27:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60435 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3HWVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:24:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 07/15] Input: gameport: convert bus code to use drv_groups
Date: Fri, 23 Aug 2013 14:24:33 -0700
Message-Id: <1377293081-10957-7-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drv_attrs field of struct bus_type is going away soon, drv_groups
should be used instead.  This converts the gameport bus code to use the
correct field.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/gameport/gameport.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index da739d9d..922a7fea 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -639,16 +639,18 @@ EXPORT_SYMBOL(gameport_unregister_port);
  * Gameport driver operations
  */
 
-static ssize_t gameport_driver_show_description(struct device_driver *drv, char *buf)
+static ssize_t description_show(struct device_driver *drv, char *buf)
 {
 	struct gameport_driver *driver = to_gameport_driver(drv);
 	return sprintf(buf, "%s\n", driver->description ? driver->description : "(none)");
 }
+static DRIVER_ATTR_RO(description);
 
-static struct driver_attribute gameport_driver_attrs[] = {
-	__ATTR(description, S_IRUGO, gameport_driver_show_description, NULL),
-	__ATTR_NULL
+static struct attribute *gameport_driver_attrs[] = {
+	&driver_attr_description.attr,
+	NULL
 };
+ATTRIBUTE_GROUPS(gameport_driver);
 
 static int gameport_driver_probe(struct device *dev)
 {
@@ -749,7 +751,7 @@ static int gameport_bus_match(struct device *dev, struct device_driver *drv)
 static struct bus_type gameport_bus = {
 	.name		= "gameport",
 	.dev_attrs	= gameport_device_attrs,
-	.drv_attrs	= gameport_driver_attrs,
+	.drv_groups	= gameport_driver_groups,
 	.match		= gameport_bus_match,
 	.probe		= gameport_driver_probe,
 	.remove		= gameport_driver_remove,
-- 
1.8.3.rc0.20.gb99dd2e

