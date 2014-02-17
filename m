Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaBQV7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:59:07 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65086 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaBQV7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:59:04 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/14] staging: ion: Make sure all clients are exposed in debugfs
Date: Mon, 17 Feb 2014 13:58:37 -0800
Message-Id: <1392674322-9036-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchel Humpherys <mitchelh@codeaurora.org>

Currently, if multiple Ion clients are created with the same name, only
the first one shows up in debugfs. Rectify this by adding a
monotonically-increasing serial number to the debug names of Ion
clients.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
[jstultz: Minor commit subject tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index eac4bce..5776697 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -72,6 +72,8 @@ struct ion_device {
  * @idr:		an idr space for allocating handle ids
  * @lock:		lock protecting the tree of handles
  * @name:		used for debugging
+ * @display_name:	used for debugging (unique version of @name)
+ * @display_serial:	used for debugging (to make display_name unique)
  * @task:		used for debugging
  *
  * A client represents a list of buffers this client may access.
@@ -85,6 +87,8 @@ struct ion_client {
 	struct idr idr;
 	struct mutex lock;
 	const char *name;
+	char *display_name;
+	int display_serial;
 	struct task_struct *task;
 	pid_t pid;
 	struct dentry *debug_root;
@@ -711,6 +715,21 @@ static const struct file_operations debug_client_fops = {
 	.release = single_release,
 };
 
+static int ion_get_client_serial(const struct rb_root *root,
+					const unsigned char *name)
+{
+	int serial = -1;
+	struct rb_node *node;
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		struct ion_client *client = rb_entry(node, struct ion_client,
+						node);
+		if (strcmp(client->name, name))
+			continue;
+		serial = max(serial, client->display_serial);
+	}
+	return serial + 1;
+}
+
 struct ion_client *ion_client_create(struct ion_device *dev,
 				     const char *name)
 {
@@ -721,6 +740,11 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	struct ion_client *entry;
 	pid_t pid;
 
+	if (!name) {
+		pr_err("%s: Name cannot be null\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
 	get_task_struct(current->group_leader);
 	task_lock(current->group_leader);
 	pid = task_pid_nr(current->group_leader);
@@ -749,6 +773,13 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 		goto err_free_client;
 
 	down_write(&dev->lock);
+	client->display_serial = ion_get_client_serial(&dev->clients, name);
+	client->display_name = kasprintf(
+		GFP_KERNEL, "%s-%d", name, client->display_serial);
+	if (!client->display_name) {
+		up_write(&dev->lock);
+		goto err_free_client_name;
+	}
 	p = &dev->clients.rb_node;
 	while (*p) {
 		parent = *p;
@@ -762,20 +793,22 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	rb_link_node(&client->node, parent, p);
 	rb_insert_color(&client->node, &dev->clients);
 
-	client->debug_root = debugfs_create_file(name, 0664,
+	client->debug_root = debugfs_create_file(client->display_name, 0664,
 						dev->clients_debug_root,
 						client, &debug_client_fops);
 	if (!client->debug_root) {
 		char buf[256], *path;
 		path = dentry_path(dev->clients_debug_root, buf, 256);
 		pr_err("Failed to create client debugfs at %s/%s\n",
-			path, name);
+			path, client->display_name);
 	}
 
 	up_write(&dev->lock);
 
 	return client;
 
+err_free_client_name:
+	kfree(client->name);
 err_free_client:
 	kfree(client);
 err_put_task_struct:
@@ -806,6 +839,7 @@ void ion_client_destroy(struct ion_client *client)
 	debugfs_remove_recursive(client->debug_root);
 	up_write(&dev->lock);
 
+	kfree(client->display_name);
 	kfree(client->name);
 	kfree(client);
 }
-- 
1.8.3.2

