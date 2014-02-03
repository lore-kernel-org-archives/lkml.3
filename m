Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaBCSQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:16:49 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44814 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaBCSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Laura Abbott <lauraa@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 10/16] staging: ion: Fix debugfs handling of multiple kernel clients
Date: Mon,  3 Feb 2014 10:16:22 -0800
Message-Id: <1391451388-23906-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Abbott <lauraa@codeaurora.org>

Currently, Ion registers all debugfs entries for clients
via pid. If there are multiple kernel clients, this means
the debugfs entry only gets created for the first one. Fix
this by creating debugfs entries by name always. When
creating user clients, specify the name via the pid.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
[jstultz: Minor commit subject tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index df1507c..684f240 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -718,7 +718,6 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct ion_client *entry;
-	char debug_name[64];
 	pid_t pid;
 
 	get_task_struct(current->group_leader);
@@ -763,15 +762,14 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	rb_link_node(&client->node, parent, p);
 	rb_insert_color(&client->node, &dev->clients);
 
-	snprintf(debug_name, 64, "%u", client->pid);
-	client->debug_root = debugfs_create_file(debug_name, 0664,
+	client->debug_root = debugfs_create_file(name, 0664,
 						dev->clients_debug_root,
 						client, &debug_client_fops);
 	if (!client->debug_root) {
 		char buf[256], *path;
 		path = dentry_path(dev->clients_debug_root, buf, 256);
 		pr_err("Failed to create client debugfs at %s/%s\n",
-			path, debug_name);
+			path, name);
 	}
 
 	up_write(&dev->lock);
@@ -1302,9 +1300,11 @@ static int ion_open(struct inode *inode, struct file *file)
 	struct miscdevice *miscdev = file->private_data;
 	struct ion_device *dev = container_of(miscdev, struct ion_device, dev);
 	struct ion_client *client;
+	char debug_name[64];
 
 	pr_debug("%s: %d\n", __func__, __LINE__);
-	client = ion_client_create(dev, "user");
+	snprintf(debug_name, 64, "%u", task_pid_nr(current->group_leader));
+	client = ion_client_create(dev, debug_name);
 	if (IS_ERR(client))
 		return PTR_ERR(client);
 	file->private_data = client;
-- 
1.8.3.2

