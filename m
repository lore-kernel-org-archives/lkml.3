Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3GNXG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3GNXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/10] sysfs: add more helper macro's for (bin_)attribute(_groups)
Date: Sun, 14 Jul 2013 16:05:59 -0700
Message-Id: <1373843160-3990-10-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

With the recent changes to sysfs there's various helper macro's.
However there's no RW, RO BIN_ helper macro's. This patch adds them.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sysfs.h | 51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2c3b6a30..d907a732 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/kobject_ns.h>
+#include <linux/stat.h>
 #include <linux/atomic.h>
 
 struct kobject;
@@ -94,15 +95,18 @@ struct attribute_group {
 #define __ATTR_IGNORE_LOCKDEP	__ATTR
 #endif
 
-#define ATTRIBUTE_GROUPS(name)					\
-static const struct attribute_group name##_group = {		\
-	.attrs = name##_attrs,					\
-};								\
-static const struct attribute_group *name##_groups[] = {	\
-	&name##_group,						\
+#define __ATTRIBUTE_GROUPS(_name)				\
+static const struct attribute_group *_name##_groups[] = {	\
+	&_name##_group,						\
 	NULL,							\
 }
 
+#define ATTRIBUTE_GROUPS(_name)					\
+static const struct attribute_group _name##_group = {		\
+	.attrs = _name##_attrs,					\
+};								\
+__ATTRIBUTE_GROUPS(_name)
+
 #define attr_name(_attr) (_attr).attr.name
 
 struct file;
@@ -132,15 +136,36 @@ struct bin_attribute {
  */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
 
-/* macro to create static binary attributes easier */
-#define BIN_ATTR(_name, _mode, _read, _write, _size)		\
-struct bin_attribute bin_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.read	= _read,					\
-	.write	= _write,					\
-	.size	= _size,					\
+/* macros to create static binary attributes easier */
+#define __BIN_ATTR(_name, _mode, _read, _write, _size) {		\
+	.attr = { .name = __stringify(_name), .mode = _mode },		\
+	.read	= _read,						\
+	.write	= _write,						\
+	.size	= _size,						\
+}
+
+#define __BIN_ATTR_RO(_name, _size) {					\
+	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
+	.read	= _name##_read,						\
+	.size	= _size,						\
 }
 
+#define __BIN_ATTR_RW(_name, _size) __BIN_ATTR(_name,			\
+				   (S_IWUSR | S_IRUGO), _name##_read,	\
+				   _name##_write)
+
+#define __BIN_ATTR_NULL __ATTR_NULL
+
+#define BIN_ATTR(_name, _mode, _read, _write, _size)			\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR(_name, _mode, _read,	\
+					_write, _size)
+
+#define BIN_ATTR_RO(_name, _size)					\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR_RO(_name, _size)
+
+#define BIN_ATTR_RW(_name, _size)					\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR_RW(_name, _size)
+
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-- 
1.8.3.rc0.20.gb99dd2e

