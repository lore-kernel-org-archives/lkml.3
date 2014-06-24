Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaFXVxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:53:25 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54744 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaFXVxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:53:21 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: airlied@linux.ie
Cc: thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 3/3] gpu: drm: vmwgfx: Remove unnecessary parameter from vmw_compat_shader_free()
Date: Tue, 24 Jun 2014 22:52:14 +0100
Message-Id: <1403646734-2838-4-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
References: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm_compat_shader_manager is only used for drm_ht_remove_item() within the function.
As drm_ht_remove_item() does not need a paremeter drm_open_hash(&man-> shaders),
vm_compat_shader_manager(*man) does not have to be passed to this function.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index bbb30c3..2fdbf8e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -532,14 +532,12 @@ int vmw_compat_shader_lookup(struct vmw_compat_shader_manager *man,
 /**
  * vmw_compat_shader_free - Free a compat shader.
  *
- * @man: Pointer to the compat shader manager.
  * @entry: Pointer to a struct vmw_compat_shader.
  *
  * Frees a struct vmw_compat_shder entry and drops its reference to the
  * guest backed shader.
  */
-static void vmw_compat_shader_free(struct vmw_compat_shader_manager *man,
-				   struct vmw_compat_shader *entry)
+static void vmw_compat_shader_free(struct vmw_compat_shader *entry)
 {
 	list_del(&entry->head);
 	WARN_ON(drm_ht_remove_item(&entry->hash));
@@ -602,7 +600,7 @@ void vmw_compat_shaders_revert(struct vmw_compat_shader_manager *man,
 	list_for_each_entry_safe(entry, next, list, head) {
 		switch (entry->state) {
 		case VMW_COMPAT_ADD:
-			vmw_compat_shader_free(man, entry);
+			vmw_compat_shader_free(entry);
 			break;
 		case VMW_COMPAT_DEL:
 			ret = drm_ht_insert_item(&man->shaders, &entry->hash);
@@ -649,7 +647,7 @@ int vmw_compat_shader_remove(struct vmw_compat_shader_manager *man,
 
 	switch (entry->state) {
 	case VMW_COMPAT_ADD:
-		vmw_compat_shader_free(man, entry);
+		vmw_compat_shader_free(entry);
 		break;
 	case VMW_COMPAT_COMMITED:
 		drm_ht_remove_item(&entry->hash);
@@ -804,7 +802,7 @@ void vmw_compat_shader_man_destroy(struct vmw_compat_shader_manager *man)
 
 	mutex_lock(&man->dev_priv->cmdbuf_mutex);
 	list_for_each_entry_safe(entry, next, &man->list, head)
-		vmw_compat_shader_free(man, entry);
+		vmw_compat_shader_free(entry);
 
 	drm_ht_remove(&man->shaders);
 
-- 
1.9.3

