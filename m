Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaLOPSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:18:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaLOO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 013/168] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Mon, 15 Dec 2014 14:24:27 +0000
Message-Id: <1418653622-21105-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vhost/scsi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 69906cacd04f..a17f11850669 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1312,6 +1312,7 @@ static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_tpg **vs_tpg;
@@ -1359,6 +1360,21 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
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
@@ -1401,6 +1417,7 @@ static int
 vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			  struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct vhost_virtqueue *vq;
@@ -1449,6 +1466,13 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
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

