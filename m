Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3GXWOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:14:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3GXWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/36] backing-dev: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:26 -0700
Message-Id: <1374703539-9705-24-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the backing device class code to
use the correct field.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Andres, feel free to take this through your tree, or ACK it and I can
take it through mine.

 mm/backing-dev.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e04454cd..37d9edcd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -180,7 +180,8 @@ static ssize_t name##_show(struct device *dev,				\
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
 									\
 	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
-}
+}									\
+static DEVICE_ATTR_RW(name);
 
 BDI_SHOW(read_ahead_kb, K(bdi->ra_pages))
 
@@ -231,14 +232,16 @@ static ssize_t stable_pages_required_show(struct device *dev,
 	return snprintf(page, PAGE_SIZE-1, "%d\n",
 			bdi_cap_stable_pages_required(bdi) ? 1 : 0);
 }
+static DEVICE_ATTR_RO(stable_pages_required);
 
-static struct device_attribute bdi_dev_attrs[] = {
-	__ATTR_RW(read_ahead_kb),
-	__ATTR_RW(min_ratio),
-	__ATTR_RW(max_ratio),
-	__ATTR_RO(stable_pages_required),
-	__ATTR_NULL,
+static struct attribute *bdi_dev_attrs[] = {
+	&dev_attr_read_ahead_kb.attr,
+	&dev_attr_min_ratio.attr,
+	&dev_attr_max_ratio.attr,
+	&dev_attr_stable_pages_required.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(bdi_dev);
 
 static __init int bdi_class_init(void)
 {
@@ -246,7 +249,7 @@ static __init int bdi_class_init(void)
 	if (IS_ERR(bdi_class))
 		return PTR_ERR(bdi_class);
 
-	bdi_class->dev_attrs = bdi_dev_attrs;
+	bdi_class->dev_groups = bdi_dev_groups;
 	bdi_debug_init();
 	return 0;
 }
-- 
1.8.3.rc0.20.gb99dd2e

