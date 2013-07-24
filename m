Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3GXWJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:09:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3GXWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 36/36] pwm: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:39 -0700
Message-Id: <1374703539-9705-37-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the pwm class code to use the
correct field.

Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Thierry, feel free to take this through your tree, or ACK it and I can
take it through mine.

 drivers/pwm/sysfs.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index 8ca5de31..8c20332d 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -268,6 +268,7 @@ static ssize_t pwm_export_store(struct device *parent,
 
 	return ret ? : len;
 }
+static DEVICE_ATTR(export, 0200, NULL, pwm_export_store);
 
 static ssize_t pwm_unexport_store(struct device *parent,
 				  struct device_attribute *attr,
@@ -288,27 +289,29 @@ static ssize_t pwm_unexport_store(struct device *parent,
 
 	return ret ? : len;
 }
+static DEVICE_ATTR(unexport, 0200, NULL, pwm_unexport_store);
 
-static ssize_t pwm_npwm_show(struct device *parent,
-			     struct device_attribute *attr,
-			     char *buf)
+static ssize_t npwm_show(struct device *parent, struct device_attribute *attr,
+			 char *buf)
 {
 	const struct pwm_chip *chip = dev_get_drvdata(parent);
 
 	return sprintf(buf, "%u\n", chip->npwm);
 }
+static DEVICE_ATTR_RO(npwm);
 
-static struct device_attribute pwm_chip_attrs[] = {
-	__ATTR(export, 0200, NULL, pwm_export_store),
-	__ATTR(unexport, 0200, NULL, pwm_unexport_store),
-	__ATTR(npwm, 0444, pwm_npwm_show, NULL),
-	__ATTR_NULL,
+static struct attribute *pwm_chip_attrs[] = {
+	&dev_attr_export.attr,
+	&dev_attr_unexport.attr,
+	&dev_attr_npwm.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(pwm_chip);
 
 static struct class pwm_class = {
 	.name		= "pwm",
 	.owner		= THIS_MODULE,
-	.dev_attrs	= pwm_chip_attrs,
+	.dev_groups	= pwm_chip_groups,
 };
 
 static int pwmchip_sysfs_match(struct device *parent, const void *data)
-- 
1.8.3.rc0.20.gb99dd2e

