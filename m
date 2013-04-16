Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254Ab3DPSbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205Ab3DPS1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 18/28] drm: proc: Use minor->index to label things,
 not PDE->name [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        dri-devel@lists.freedesktop.org
Date: Tue, 16 Apr 2013 19:27:00 +0100
Message-ID: <20130416182700.27773.8970.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use minor->index to label things, not the name field from the proc_dir_entry
of the /proc/dwm/<minor>/ directory.

Also, use "%u" not "%d" to render the value and use a 12-byte buffer in which
to render the integer, not a 16-byte buffer.  The longest string an unsigned
int can give you is 10 chars (4294967295) plus a NUL, so round up to 12 as the
stack is likely to be 4- or 8-byte aligned.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: dri-devel@lists.freedesktop.org
---

 drivers/gpu/drm/drm_proc.c |   13 +++++--------
 drivers/gpu/drm/drm_stub.c |    2 +-
 include/drm/drmP.h         |    3 +--
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index aead653..0646a46 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -116,14 +116,13 @@ static int drm_proc_create_files(const struct drm_info_list *files, int count,
 		ent = proc_create_data(files[i].name, S_IRUGO, root,
 				       &drm_proc_fops, tmp);
 		if (!ent) {
-			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
-				  root->name, files[i].name);
+			DRM_ERROR("Cannot create /proc/dri/%u/%s\n",
+				  minor->index, files[i].name);
 			list_del(&tmp->list);
 			kfree(tmp);
 			ret = -1;
 			goto fail;
 		}
-
 	}
 	return 0;
 
@@ -137,7 +136,6 @@ fail:
  * Initialize the DRI proc filesystem for a device
  *
  * \param dev DRM device
- * \param minor device minor number
  * \param root DRI proc dir entry.
  * \param dev_root resulting DRI device proc dir entry.
  * \return root entry pointer on success, or NULL on failure.
@@ -146,14 +144,13 @@ fail:
  * "/proc/dri/%minor%/", and each entry in proc_list as
  * "/proc/dri/%minor%/%name%".
  */
-int drm_proc_init(struct drm_minor *minor, int minor_id,
-		  struct proc_dir_entry *root)
+int drm_proc_init(struct drm_minor *minor, struct proc_dir_entry *root)
 {
-	char name[64];
+	char name[12];
 	int ret;
 
 	INIT_LIST_HEAD(&minor->proc_nodes.list);
-	sprintf(name, "%d", minor_id);
+	sprintf(name, "%u", minor->index);
 	minor->proc_root = proc_mkdir(name, root);
 	if (!minor->proc_root) {
 		DRM_ERROR("Cannot create /proc/dri/%s\n", name);
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 7d30802..16f3ec5 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -352,7 +352,7 @@ int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int type)
 	idr_replace(&drm_minors_idr, new_minor, minor_id);
 
 	if (type == DRM_MINOR_LEGACY) {
-		ret = drm_proc_init(new_minor, minor_id, drm_proc_root);
+		ret = drm_proc_init(new_minor, drm_proc_root);
 		if (ret) {
 			DRM_ERROR("DRM: Failed to initialize /proc/dri.\n");
 			goto err_mem;
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index af53320..60c33f1 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1546,8 +1546,7 @@ extern struct idr drm_minors_idr;
 extern struct drm_local_map *drm_getsarea(struct drm_device *dev);
 
 				/* Proc support (drm_proc.h) */
-extern int drm_proc_init(struct drm_minor *minor, int minor_id,
-			 struct proc_dir_entry *root);
+extern int drm_proc_init(struct drm_minor *minor, struct proc_dir_entry *root);
 extern int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_entry *root);
 
 				/* Debugfs support */

