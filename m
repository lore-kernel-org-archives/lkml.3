Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162757Ab3DEVOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:14:41 -0400
Received: from mail.ispras.ru ([83.149.199.45]:38105 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162478Ab3DEVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:14:40 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: dgrp: implement error handling in dgrp_create_class_sysfs_files()
Date: Sat,  6 Apr 2013 01:14:23 +0400
Message-Id: <1365196463-29174-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no any error handling in dgrp_create_class_sysfs_files().
The patch adds code to check return values and propagate them to dgrp_init_module().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgrp/dgrp_common.h |    2 +-
 drivers/staging/dgrp/dgrp_driver.c |    6 +++++-
 drivers/staging/dgrp/dgrp_sysfs.c  |   30 +++++++++++++++++++++++++-----
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_common.h b/drivers/staging/dgrp/dgrp_common.h
index 0583fe9..2832b8e 100644
--- a/drivers/staging/dgrp/dgrp_common.h
+++ b/drivers/staging/dgrp/dgrp_common.h
@@ -66,7 +66,7 @@ extern void dgrp_register_dpa_hook(struct proc_dir_entry *de);
 extern void dgrp_dpa_data(struct nd_struct *, int, u8 *, int);
 
 /* from dgrp_sysfs.c */
-extern void dgrp_create_class_sysfs_files(void);
+extern int dgrp_create_class_sysfs_files(void);
 extern void dgrp_remove_class_sysfs_files(void);
 
 extern void dgrp_create_node_class_sysfs_files(struct nd_struct *nd);
diff --git a/drivers/staging/dgrp/dgrp_driver.c b/drivers/staging/dgrp/dgrp_driver.c
index aa26258..e456dc6c 100644
--- a/drivers/staging/dgrp/dgrp_driver.c
+++ b/drivers/staging/dgrp/dgrp_driver.c
@@ -66,6 +66,8 @@ module_exit(dgrp_cleanup_module);
  */
 static int dgrp_init_module(void)
 {
+	int ret;
+
 	INIT_LIST_HEAD(&nd_struct_list);
 
 	spin_lock_init(&dgrp_poll_data.poll_lock);
@@ -74,7 +76,9 @@ static int dgrp_init_module(void)
 	dgrp_poll_data.timer.function = dgrp_poll_handler;
 	dgrp_poll_data.timer.data = (unsigned long) &dgrp_poll_data;
 
-	dgrp_create_class_sysfs_files();
+	ret = dgrp_create_class_sysfs_files();
+	if (ret)
+		return ret;
 
 	dgrp_register_proc();
 
diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index be179ad..7d1b36d 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -85,30 +85,50 @@ static struct attribute_group dgrp_global_settings_attribute_group = {
 
 
 
-void dgrp_create_class_sysfs_files(void)
+int dgrp_create_class_sysfs_files(void)
 {
 	int ret = 0;
 	int max_majors = 1U << (32 - MINORBITS);
 
 	dgrp_class = class_create(THIS_MODULE, "digi_realport");
+	if (IS_ERR(dgrp_class))
+		return PTR_ERR(dgrp_class);
 	ret = class_create_file(dgrp_class, &class_attr_driver_version);
+	if (ret)
+		goto err_class;
 
 	dgrp_class_global_settings_dev = device_create(dgrp_class, NULL,
 		MKDEV(0, max_majors + 1), NULL, "driver_settings");
-
+	if (IS_ERR(dgrp_class_global_settings_dev)) {
+		ret = PTR_ERR(dgrp_class_global_settings_dev);
+		goto err_file;
+	}
 	ret = sysfs_create_group(&dgrp_class_global_settings_dev->kobj,
 		&dgrp_global_settings_attribute_group);
 	if (ret) {
 		pr_alert("%s: failed to create sysfs global settings device attributes.\n",
 			__func__);
-		sysfs_remove_group(&dgrp_class_global_settings_dev->kobj,
-			&dgrp_global_settings_attribute_group);
-		return;
+		goto err_dev1;
 	}
 
 	dgrp_class_nodes_dev = device_create(dgrp_class, NULL,
 		MKDEV(0, max_majors + 2), NULL, "nodes");
+	if (IS_ERR(dgrp_class_nodes_dev)) {
+		ret = PTR_ERR(dgrp_class_nodes_dev);
+		goto err_group;
+	}
 
+	return 0;
+err_group:
+	sysfs_remove_group(&dgrp_class_global_settings_dev->kobj,
+		&dgrp_global_settings_attribute_group);
+err_dev1:
+	device_destroy(dgrp_class, MKDEV(0, max_majors + 1));
+err_file:
+	class_remove_file(dgrp_class, &class_attr_driver_version);
+err_class:
+	class_destroy(dgrp_class);
+	return ret;
 }
 
 
-- 
1.7.9.5

