Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3LMW0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:52 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37316 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3LMW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 027/115] gpu: ion: Fix race between ion_import and ion_free
Date: Fri, 13 Dec 2013 14:24:01 -0800
Message-Id: <1386973529-4884-28-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

If preemted during ion_free after the refcount is updated but
before the handle can be removed from the rb_tree, import
might find that handle in the tree and try to reuse it
when execution returns to free, the handle will be cleaned
up leaving the caller of import with a corrupt handle.
This patch modifies the locking to protect agains this race.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 84229bd..f7dc821 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -253,8 +253,6 @@ static void ion_handle_destroy(struct kref *kref)
 	struct ion_client *client = handle->client;
 	struct ion_buffer *buffer = handle->buffer;
 
-	mutex_lock(&client->lock);
-
 	mutex_lock(&buffer->lock);
 	while (handle->kmap_cnt)
 		ion_handle_kmap_put(handle);
@@ -262,7 +260,6 @@ static void ion_handle_destroy(struct kref *kref)
 
 	if (!RB_EMPTY_NODE(&handle->node))
 		rb_erase(&handle->node, &client->handles);
-	mutex_unlock(&client->lock);
 
 	ion_buffer_put(buffer);
 	kfree(handle);
@@ -406,13 +403,13 @@ void ion_free(struct ion_client *client, struct ion_handle *handle)
 
 	mutex_lock(&client->lock);
 	valid_handle = ion_handle_validate(client, handle);
-	mutex_unlock(&client->lock);
 
 	if (!valid_handle) {
 		WARN(1, "%s: invalid handle passed to free.\n", __func__);
 		return;
 	}
 	ion_handle_put(handle);
+	mutex_unlock(&client->lock);
 }
 EXPORT_SYMBOL(ion_free);
 
-- 
1.8.3.2

