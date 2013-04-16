Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965234Ab3DPS1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 19/28] drm: proc: Use remove_proc_subtree() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        dri-devel@lists.freedesktop.org
Date: Tue, 16 Apr 2013 19:27:03 +0100
Message-ID: <20130416182703.27773.52825.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use remove_proc_subtree() rather than remove_proc_entry() to remove a
minor-specific drm proc directory and all its children.

Things could theoretically be improved by storing the drm_minor pointer in the
minor-specific dir proc_dir_entry struct data and then scrapping the list of
proc files - but that's shared with the debugfs interface where you can't do
that, so I don't see an easy way of doing it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: dri-devel@lists.freedesktop.org
---

 drivers/gpu/drm/drm_proc.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index 0646a46..d7f2324 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -95,7 +95,7 @@ static int drm_proc_create_files(const struct drm_info_list *files, int count,
 	struct drm_device *dev = minor->dev;
 	struct proc_dir_entry *ent;
 	struct drm_info_node *tmp;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < count; i++) {
 		u32 features = files[i].driver_features;
@@ -105,10 +105,9 @@ static int drm_proc_create_files(const struct drm_info_list *files, int count,
 			continue;
 
 		tmp = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
-		if (tmp == NULL) {
-			ret = -1;
-			goto fail;
-		}
+		if (!tmp)
+			return -1;
+
 		tmp->minor = minor;
 		tmp->info_ent = &files[i];
 		list_add(&tmp->list, &minor->proc_nodes.list);
@@ -120,16 +119,10 @@ static int drm_proc_create_files(const struct drm_info_list *files, int count,
 				  minor->index, files[i].name);
 			list_del(&tmp->list);
 			kfree(tmp);
-			ret = -1;
-			goto fail;
+			return -1;
 		}
 	}
 	return 0;
-
-fail:
-	for (i = 0; i < count; i++)
-		remove_proc_entry(drm_proc_list[i].name, minor->proc_root);
-	return ret;
 }
 
 /**
@@ -160,7 +153,7 @@ int drm_proc_init(struct drm_minor *minor, struct proc_dir_entry *root)
 	ret = drm_proc_create_files(drm_proc_list, DRM_PROC_ENTRIES,
 				    minor->proc_root, minor);
 	if (ret) {
-		remove_proc_entry(name, root);
+		remove_proc_subtree(name, root);
 		minor->proc_root = NULL;
 		DRM_ERROR("Failed to create core drm proc files\n");
 		return ret;
@@ -210,8 +203,7 @@ int drm_proc_cleanup(struct drm_minor *minor, struct proc_dir_entry *root)
 	drm_proc_remove_files(drm_proc_list, DRM_PROC_ENTRIES, minor);
 
 	sprintf(name, "%d", minor->index);
-	remove_proc_entry(name, root);
-
+	remove_proc_subtree(name, root);
 	return 0;
 }
 

