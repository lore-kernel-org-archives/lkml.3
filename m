Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3GXWGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3GXWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 07/36] extcon: convert extcon_class to use dev_groups
Date: Wed, 24 Jul 2013 15:05:10 -0700
Message-Id: <1374703539-9705-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the extcon_class code to use the
correct field.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
MyungJoo, feel free to apply this to your tree, or ACK it and I can take it
through mine.

 drivers/extcon/extcon-class.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 18ccadef..022ca369 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -148,6 +148,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 
 	return count;
 }
+static DEVICE_ATTR_RW(state);
 
 static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -163,6 +164,7 @@ static ssize_t name_show(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "%s\n", dev_name(edev->dev));
 }
+static DEVICE_ATTR_RO(name);
 
 static ssize_t cable_name_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -527,11 +529,12 @@ int extcon_unregister_notifier(struct extcon_dev *edev,
 }
 EXPORT_SYMBOL_GPL(extcon_unregister_notifier);
 
-static struct device_attribute extcon_attrs[] = {
-	__ATTR(state, S_IRUGO | S_IWUSR, state_show, state_store),
-	__ATTR_RO(name),
-	__ATTR_NULL,
+static struct attribute *extcon_attrs[] = {
+	&dev_attr_state.attr,
+	&dev_attr_name.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(extcon);
 
 static int create_extcon_class(void)
 {
@@ -539,7 +542,7 @@ static int create_extcon_class(void)
 		extcon_class = class_create(THIS_MODULE, "extcon");
 		if (IS_ERR(extcon_class))
 			return PTR_ERR(extcon_class);
-		extcon_class->dev_attrs = extcon_attrs;
+		extcon_class->dev_groups = extcon_groups;
 
 #if defined(CONFIG_ANDROID)
 		switch_class = class_compat_register("switch");
-- 
1.8.3.rc0.20.gb99dd2e

