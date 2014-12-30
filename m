Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaL3Vyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:54:36 -0500
Received: from mail.ludd.ltu.se ([130.240.16.30]:42731 "EHLO mail.ludd.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaL3Vyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:54:35 -0500
From: Jonas Lundqvist <jonas@gannon.se>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jonas Lundqvist <jonas@gannon.se>
Subject: [PATCH] drm: Move two seq_printf's outside of locked mutex
Date: Tue, 30 Dec 2014 22:54:26 +0100
Message-Id: <1419976466-2113-1-git-send-email-jonas@gannon.se>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drm_info.c: drm_bufs_info() and drm_vm_info() two seq_printf() was
done unnecessarily while locking a mutex. This patch flips the order of
the print and lock/unlock where applicable.

Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
---
 drivers/gpu/drm/drm_info.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
index 51efebd..981afe7 100644
--- a/drivers/gpu/drm/drm_info.c
+++ b/drivers/gpu/drm/drm_info.c
@@ -81,11 +81,10 @@ int drm_vm_info(struct seq_file *m, void *data)
 	   _DRM_SCATTER_GATHER and _DRM_CONSISTENT */
 	const char *types[] = { "FB", "REG", "SHM", "AGP", "SG", "PCI" };
 	const char *type;
-	int i;
+	int i = 0;
 
-	mutex_lock(&dev->struct_mutex);
 	seq_printf(m, "slot	 offset	      size type flags	 address mtrr\n\n");
-	i = 0;
+	mutex_lock(&dev->struct_mutex);
 	list_for_each_entry(r_list, &dev->maplist, head) {
 		map = r_list->map;
 		if (!map)
@@ -147,8 +146,8 @@ int drm_bufs_info(struct seq_file *m, void *data)
 			seq_printf(m, "\n");
 		seq_printf(m, " %d", dma->buflist[i]->list);
 	}
-	seq_printf(m, "\n");
 	mutex_unlock(&dev->struct_mutex);
+	seq_printf(m, "\n");
 	return 0;
 }
 
-- 
2.1.4

