Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3JHCQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:16:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3JHCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:16:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>
Subject: [PATCH 3/8] input: gameport: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:37 -0700
Message-Id: <1381195662-28009-4-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the gameport bus code to use the
correct field.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Dmitry, I can take this through my driver-core tree if you don't want to
take it through yours, just let me know what works best for you.

 drivers/input/gameport/gameport.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 922a7fe..24c41ba 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -422,14 +422,15 @@ static struct gameport *gameport_get_pending_child(struct gameport *parent)
  * Gameport port operations
  */
 
-static ssize_t gameport_show_description(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t gameport_description_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct gameport *gameport = to_gameport_port(dev);
 
 	return sprintf(buf, "%s\n", gameport->name);
 }
+static DEVICE_ATTR(description, S_IRUGO, gameport_description_show, NULL);
 
-static ssize_t gameport_rebind_driver(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+static ssize_t drvctl_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct gameport *gameport = to_gameport_port(dev);
 	struct device_driver *drv;
@@ -457,12 +458,14 @@ static ssize_t gameport_rebind_driver(struct device *dev, struct device_attribut
 
 	return error ? error : count;
 }
+static DEVICE_ATTR_WO(drvctl);
 
-static struct device_attribute gameport_device_attrs[] = {
-	__ATTR(description, S_IRUGO, gameport_show_description, NULL),
-	__ATTR(drvctl, S_IWUSR, NULL, gameport_rebind_driver),
-	__ATTR_NULL
+static struct attribute *gameport_device_attrs[] = {
+	&dev_attr_description.attr,
+	&dev_attr_drvctl.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(gameport_device);
 
 static void gameport_release_port(struct device *dev)
 {
@@ -750,7 +753,7 @@ static int gameport_bus_match(struct device *dev, struct device_driver *drv)
 
 static struct bus_type gameport_bus = {
 	.name		= "gameport",
-	.dev_attrs	= gameport_device_attrs,
+	.dev_groups	= gameport_device_groups,
 	.drv_groups	= gameport_driver_groups,
 	.match		= gameport_bus_match,
 	.probe		= gameport_driver_probe,
-- 
1.8.4.6.g82e253f.dirty

