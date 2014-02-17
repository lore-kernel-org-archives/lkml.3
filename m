Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaBQV7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:59:09 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44399 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaBQV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:59:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 08/14] staging: ion: Store a copy of the client name on client creation
Date: Mon, 17 Feb 2014 13:58:36 -0800
Message-Id: <1392674322-9036-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchel Humpherys <mitchelh@codeaurora.org>

Currently, we copy the pointer passed in to ion_client_create without
making a copy of the string itself. This approach is problematic since
it relies on the client keeping the name string in working order.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
[jstultz: Minor commit subject tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 4869420..eac4bce 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -735,19 +735,18 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	task_unlock(current->group_leader);
 
 	client = kzalloc(sizeof(struct ion_client), GFP_KERNEL);
-	if (!client) {
-		if (task)
-			put_task_struct(current->group_leader);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!client)
+		goto err_put_task_struct;
 
 	client->dev = dev;
 	client->handles = RB_ROOT;
 	idr_init(&client->idr);
 	mutex_init(&client->lock);
-	client->name = name;
 	client->task = task;
 	client->pid = pid;
+	client->name = kstrdup(name, GFP_KERNEL);
+	if (!client->name)
+		goto err_free_client;
 
 	down_write(&dev->lock);
 	p = &dev->clients.rb_node;
@@ -776,6 +775,13 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 	up_write(&dev->lock);
 
 	return client;
+
+err_free_client:
+	kfree(client);
+err_put_task_struct:
+	if (task)
+		put_task_struct(current->group_leader);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(ion_client_create);
 
@@ -800,6 +806,7 @@ void ion_client_destroy(struct ion_client *client)
 	debugfs_remove_recursive(client->debug_root);
 	up_write(&dev->lock);
 
+	kfree(client->name);
 	kfree(client);
 }
 EXPORT_SYMBOL(ion_client_destroy);
-- 
1.8.3.2

