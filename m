Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaKMVQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:16:41 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:45970 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaKMVQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:16:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartmann <gregkh@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] devcoredump: provide a one-way disable function
Date: Thu, 13 Nov 2014 22:16:29 +0100
Message-Id: <1415913389-17734-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since device/firmware coredumps can contain private data, it can
be desirable to turn them off unconditionally to be certain that
no such data will be collected by the system.

To achieve this, provide a "disabled" sysfs class attribute that
can only be changed from 0 to 1 and not back. Upon disabling,
discard existing coredumps and stop storing new ones.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/base/devcoredump.c | 56 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
index 96614b04544c..1bd120a0b084 100644
--- a/drivers/base/devcoredump.c
+++ b/drivers/base/devcoredump.c
@@ -31,6 +31,11 @@
 #include <linux/fs.h>
 #include <linux/workqueue.h>
 
+static struct class devcd_class;
+
+/* global disable flag, for security purposes */
+static bool devcd_disabled;
+
 /* if data isn't read by userspace after 5 minutes then delete it */
 #define DEVCD_TIMEOUT	(HZ * 60 * 5)
 
@@ -121,11 +126,51 @@ static const struct attribute_group *devcd_dev_groups[] = {
 	&devcd_dev_group, NULL,
 };
 
+static int devcd_free(struct device *dev, void *data)
+{
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	flush_delayed_work(&devcd->del_wk);
+	return 0;
+}
+
+static ssize_t disabled_show(struct class *class, struct class_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", devcd_disabled);
+}
+
+static ssize_t disabled_store(struct class *class, struct class_attribute *attr,
+			      const char *buf, size_t count)
+{
+	long tmp = simple_strtol(buf, NULL, 10);
+
+	/*
+	 * This essentially makes the attribute write-once, since you can't
+	 * go back to not having it disabled. This is intentional, it serves
+	 * as a system lockdown feature.
+	 */
+	if (tmp != 1)
+		return -EINVAL;
+
+	devcd_disabled = true;
+
+	class_for_each_device(&devcd_class, NULL, NULL, devcd_free);
+
+	return count;
+}
+
+static struct class_attribute devcd_class_attrs[] = {
+	__ATTR_RW(disabled),
+	__ATTR_NULL
+};
+
 static struct class devcd_class = {
 	.name		= "devcoredump",
 	.owner		= THIS_MODULE,
 	.dev_release	= devcd_dev_release,
 	.dev_groups	= devcd_dev_groups,
+	.class_attrs	= devcd_class_attrs,
 };
 
 static ssize_t devcd_readv(char *buffer, loff_t offset, size_t count,
@@ -192,6 +237,9 @@ void dev_coredumpm(struct device *dev, struct module *owner,
 	struct devcd_entry *devcd;
 	struct device *existing;
 
+	if (devcd_disabled)
+		goto free;
+
 	existing = class_find_device(&devcd_class, NULL, dev,
 				     devcd_match_failing);
 	if (existing) {
@@ -249,14 +297,6 @@ static int __init devcoredump_init(void)
 }
 __initcall(devcoredump_init);
 
-static int devcd_free(struct device *dev, void *data)
-{
-	struct devcd_entry *devcd = dev_to_devcd(dev);
-
-	flush_delayed_work(&devcd->del_wk);
-	return 0;
-}
-
 static void __exit devcoredump_exit(void)
 {
 	class_for_each_device(&devcd_class, NULL, NULL, devcd_free);
-- 
2.1.1

