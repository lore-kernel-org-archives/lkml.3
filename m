Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaLFPQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:16:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47670 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbaLFPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 54/66] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Sat,  6 Dec 2014 16:07:46 +0100
Message-Id: <32d48b3cc855df95001e80b1dc07adc2079d26fd.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ab8edab132829b26dd13db6caca3c242cce35dc1 upstream.

This patch addresses a bug where individual vhost-scsi configfs endpoint
groups can be removed from below while active exports to QEMU userspace
still exist, resulting in an OOPs.

It adds a configfs_depend_item() in vhost_scsi_set_endpoint() to obtain
an explicit dependency on se_tpg->tpg_group in order to prevent individual
vhost-scsi WWPN endpoints from being released via normal configfs methods
while an QEMU ioctl reference still exists.

Also, add matching configfs_undepend_item() in vhost_scsi_clear_endpoint()
to release the dependency, once QEMU's reference to the individual group
at /sys/kernel/config/target/vhost/$WWPN/$TPGT is released.

(Fix up vhost_scsi_clear_endpoint() error path - DanC)

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vhost/scsi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d300fd99a2b8..c5b631cceb4c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1194,6 +1194,7 @@ static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_tpg **vs_tpg;
@@ -1241,6 +1242,21 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 				ret = -EEXIST;
 				goto out;
 			}
+			/*
+			 * In order to ensure individual vhost-scsi configfs
+			 * groups cannot be removed while in use by vhost ioctl,
+			 * go ahead and take an explicit se_tpg->tpg_group.cg_item
+			 * dependency now.
+			 */
+			se_tpg = &tpg->se_tpg;
+			ret = configfs_depend_item(se_tpg->se_tpg_tfo->tf_subsys,
+						   &se_tpg->tpg_group.cg_item);
+			if (ret) {
+				pr_warn("configfs_depend_item() failed: %d\n", ret);
+				kfree(vs_tpg);
+				mutex_unlock(&tpg->tv_tpg_mutex);
+				goto out;
+			}
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
 			vs_tpg[tpg->tport_tpgt] = tpg;
@@ -1283,6 +1299,7 @@ static int
 vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			  struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct vhost_virtqueue *vq;
@@ -1331,6 +1348,13 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 		vs->vs_tpg[target] = NULL;
 		match = true;
 		mutex_unlock(&tpg->tv_tpg_mutex);
+		/*
+		 * Release se_tpg->tpg_group.cg_item configfs dependency now
+		 * to allow vhost-scsi WWPN se_tpg->tpg_group shutdown to occur.
+		 */
+		se_tpg = &tpg->se_tpg;
+		configfs_undepend_item(se_tpg->se_tpg_tfo->tf_subsys,
+				       &se_tpg->tpg_group.cg_item);
 	}
 	if (match) {
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
-- 
2.1.3

