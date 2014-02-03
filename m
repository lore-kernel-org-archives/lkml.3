Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaBCSUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:20:48 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61406 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaBCSQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:46 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 09/16] staging: ion: Create separate heap and client debugfs directories
Date: Mon,  3 Feb 2014 10:16:21 -0800
Message-Id: <1391451388-23906-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchel Humpherys <mitchelh@codeaurora.org>

It can be slightly annoying to figure out which files under the ion
debugfs directory are heap debug files and which ones are client debug
files. Create separate subdirectories under ion to hold the different
types of debug files.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
[jstultz: Minor commit subject tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 57 +++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 574066f..df1507c 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -59,6 +59,8 @@ struct ion_device {
 			      unsigned long arg);
 	struct rb_root clients;
 	struct dentry *debug_root;
+	struct dentry *heaps_debug_root;
+	struct dentry *clients_debug_root;
 };
 
 /**
@@ -763,8 +765,15 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 
 	snprintf(debug_name, 64, "%u", client->pid);
 	client->debug_root = debugfs_create_file(debug_name, 0664,
-						 dev->debug_root, client,
-						 &debug_client_fops);
+						dev->clients_debug_root,
+						client, &debug_client_fops);
+	if (!client->debug_root) {
+		char buf[256], *path;
+		path = dentry_path(dev->clients_debug_root, buf, 256);
+		pr_err("Failed to create client debugfs at %s/%s\n",
+			path, debug_name);
+	}
+
 	up_write(&dev->lock);
 
 	return client;
@@ -1443,6 +1452,8 @@ DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
+	struct dentry *debug_file;
+
 	if (!heap->ops->allocate || !heap->ops->free || !heap->ops->map_dma ||
 	    !heap->ops->unmap_dma)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
@@ -1457,15 +1468,31 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 	   the list later attempt higher id numbers first */
 	plist_node_init(&heap->node, -heap->id);
 	plist_add(&heap->node, &dev->heaps);
-	debugfs_create_file(heap->name, 0664, dev->debug_root, heap,
-			    &debug_heap_fops);
+	debug_file = debugfs_create_file(heap->name, 0664,
+					dev->heaps_debug_root, heap,
+					&debug_heap_fops);
+
+	if (!debug_file) {
+		char buf[256], *path;
+		path = dentry_path(dev->heaps_debug_root, buf, 256);
+		pr_err("Failed to create heap debugfs at %s/%s\n",
+			path, heap->name);
+	}
+
 #ifdef DEBUG_HEAP_SHRINKER
 	if (heap->shrinker.shrink) {
 		char debug_name[64];
 
 		snprintf(debug_name, 64, "%s_shrink", heap->name);
-		debugfs_create_file(debug_name, 0644, dev->debug_root, heap,
-				    &debug_shrink_fops);
+		debug_file = debugfs_create_file(
+			debug_name, 0644, dev->heaps_debug_root, heap,
+			&debug_shrink_fops);
+		if (!debug_file) {
+			char buf[256], *path;
+			path = dentry_path(dev->heaps_debug_root, buf, 256);
+			pr_err("Failed to create heap shrinker debugfs at %s/%s\n",
+				path, debug_name);
+		}
 	}
 #endif
 	up_write(&dev->lock);
@@ -1494,8 +1521,21 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 	}
 
 	idev->debug_root = debugfs_create_dir("ion", NULL);
-	if (!idev->debug_root)
-		pr_err("ion: failed to create debug files.\n");
+	if (!idev->debug_root) {
+		pr_err("ion: failed to create debugfs root directory.\n");
+		goto debugfs_done;
+	}
+	idev->heaps_debug_root = debugfs_create_dir("heaps", idev->debug_root);
+	if (!idev->heaps_debug_root) {
+		pr_err("ion: failed to create debugfs heaps directory.\n");
+		goto debugfs_done;
+	}
+	idev->clients_debug_root = debugfs_create_dir("clients",
+						idev->debug_root);
+	if (!idev->clients_debug_root)
+		pr_err("ion: failed to create debugfs clients directory.\n");
+
+debugfs_done:
 
 	idev->custom_ioctl = custom_ioctl;
 	idev->buffers = RB_ROOT;
@@ -1509,6 +1549,7 @@ struct ion_device *ion_device_create(long (*custom_ioctl)
 void ion_device_destroy(struct ion_device *dev)
 {
 	misc_deregister(&dev->dev);
+	debugfs_remove_recursive(dev->debug_root);
 	/* XXX need to free the heaps and clients ? */
 	kfree(dev);
 }
-- 
1.8.3.2

