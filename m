Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaFXVxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:53:17 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:63405 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaFXVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:53:15 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: airlied@linux.ie
Cc: thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 2/3] gpu: drm: Remove unnecessary parameter from drm_ht_remove_item()
Date: Tue, 24 Jun 2014 22:52:13 +0100
Message-Id: <1403646734-2838-3-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
References: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed drm_open_hash from drm_ht_remove_item() as the parameter is
not used within the function.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
Please review this patch carefully. The reason the parameter is passed
might be some historical one or clarity of which drm_open_hash
we remove an item from.

 drivers/gpu/drm/drm_auth.c              | 2 +-
 drivers/gpu/drm/drm_hashtab.c           | 2 +-
 drivers/gpu/drm/drm_stub.c              | 2 +-
 drivers/gpu/drm/ttm/ttm_object.c        | 8 +++-----
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c  | 4 ++--
 include/drm/drm_hashtab.h               | 2 +-
 7 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 3cedae1..f7ceea0 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -115,7 +115,7 @@ int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
 		return -EINVAL;
 	}
 	pt = drm_hash_entry(hash, struct drm_magic_entry, hash_item);
-	drm_ht_remove_item(&master->magiclist, hash);
+	drm_ht_remove_item(hash);
 	list_del(&pt->head);
 	mutex_unlock(&dev->struct_mutex);
 
diff --git a/drivers/gpu/drm/drm_hashtab.c b/drivers/gpu/drm/drm_hashtab.c
index c3b80fd..a66447f 100644
--- a/drivers/gpu/drm/drm_hashtab.c
+++ b/drivers/gpu/drm/drm_hashtab.c
@@ -188,7 +188,7 @@ int drm_ht_remove_key(struct drm_open_hash *ht, unsigned long key)
 	return -EINVAL;
 }
 
-int drm_ht_remove_item(struct drm_open_hash *ht, struct drm_hash_item *item)
+int drm_ht_remove_item(struct drm_hash_item *item)
 {
 	hlist_del_init_rcu(&item->head);
 	return 0;
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 14d1646..6ffed45 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -166,7 +166,7 @@ static void drm_master_destroy(struct kref *kref)
 
 	list_for_each_entry_safe(pt, next, &master->magicfree, head) {
 		list_del(&pt->head);
-		drm_ht_remove_item(&master->magiclist, &pt->hash_item);
+		drm_ht_remove_item(&pt->hash_item);
 		kfree(pt);
 	}
 
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index d2a0533..42f73a8 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -188,7 +188,7 @@ int ttm_base_object_init(struct ttm_object_file *tfile,
 	return 0;
 out_err1:
 	spin_lock(&tdev->object_lock);
-	(void)drm_ht_remove_item_rcu(&tdev->object_hash, &base->hash);
+	drm_ht_remove_item_rcu(&base->hash);
 	spin_unlock(&tdev->object_lock);
 out_err0:
 	return ret;
@@ -202,7 +202,7 @@ static void ttm_release_base(struct kref *kref)
 	struct ttm_object_device *tdev = base->tfile->tdev;
 
 	spin_lock(&tdev->object_lock);
-	(void)drm_ht_remove_item_rcu(&tdev->object_hash, &base->hash);
+	drm_ht_remove_item_rcu(&base->hash);
 	spin_unlock(&tdev->object_lock);
 
 	/*
@@ -390,11 +390,9 @@ static void ttm_ref_object_release(struct kref *kref)
 	    container_of(kref, struct ttm_ref_object, kref);
 	struct ttm_base_object *base = ref->obj;
 	struct ttm_object_file *tfile = ref->tfile;
-	struct drm_open_hash *ht;
 	struct ttm_mem_global *mem_glob = tfile->tdev->mem_glob;
 
-	ht = &tfile->ref_hash[ref->ref_type];
-	(void)drm_ht_remove_item_rcu(ht, &ref->hash);
+	drm_ht_remove_item_rcu(&ref->hash);
 	list_del(&ref->head);
 	spin_unlock(&tfile->lock);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 87df0b3..1780f5e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -2185,13 +2185,13 @@ static void vmw_clear_validations(struct vmw_sw_context *sw_context)
 				 base.head) {
 		list_del(&entry->base.head);
 		ttm_bo_unref(&entry->base.bo);
-		(void) drm_ht_remove_item(&sw_context->res_ht, &entry->hash);
+		drm_ht_remove_item(&entry->hash);
 		sw_context->cur_val_buf--;
 	}
 	BUG_ON(sw_context->cur_val_buf != 0);
 
 	list_for_each_entry(val, &sw_context->resource_list, head)
-		(void) drm_ht_remove_item(&sw_context->res_ht, &val->hash);
+		drm_ht_remove_item(&val->hash);
 }
 
 static int vmw_validate_single_buffer(struct vmw_private *dev_priv,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index 01cc8ea..bbb30c3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -542,7 +542,7 @@ static void vmw_compat_shader_free(struct vmw_compat_shader_manager *man,
 				   struct vmw_compat_shader *entry)
 {
 	list_del(&entry->head);
-	WARN_ON(drm_ht_remove_item(&man->shaders, &entry->hash));
+	WARN_ON(drm_ht_remove_item(&entry->hash));
 	WARN_ON(ttm_ref_object_base_unref(entry->tfile, entry->handle,
 					  TTM_REF_USAGE));
 	kfree(entry);
@@ -652,7 +652,7 @@ int vmw_compat_shader_remove(struct vmw_compat_shader_manager *man,
 		vmw_compat_shader_free(man, entry);
 		break;
 	case VMW_COMPAT_COMMITED:
-		(void) drm_ht_remove_item(&man->shaders, &entry->hash);
+		drm_ht_remove_item(&entry->hash);
 		list_del(&entry->head);
 		entry->state = VMW_COMPAT_DEL;
 		list_add_tail(&entry->head, list);
diff --git a/include/drm/drm_hashtab.h b/include/drm/drm_hashtab.h
index fce2ef3..ae34607 100644
--- a/include/drm/drm_hashtab.h
+++ b/include/drm/drm_hashtab.h
@@ -58,7 +58,7 @@ extern int drm_ht_find_item(struct drm_open_hash *ht, unsigned long key, struct
 
 extern void drm_ht_verbose_list(struct drm_open_hash *ht, unsigned long key);
 extern int drm_ht_remove_key(struct drm_open_hash *ht, unsigned long key);
-extern int drm_ht_remove_item(struct drm_open_hash *ht, struct drm_hash_item *item);
+extern int drm_ht_remove_item(struct drm_hash_item *item);
 extern void drm_ht_remove(struct drm_open_hash *ht);
 
 /*
-- 
1.9.3

