Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaLEXE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:04:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaLEW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 57/73] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Fri,  5 Dec 2014 14:45:03 -0800
Message-Id: <20141205224435.639781525@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/scsi.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1200,6 +1200,7 @@ static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_tpg **vs_tpg;
@@ -1247,6 +1248,21 @@ vhost_scsi_set_endpoint(struct vhost_scs
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
@@ -1289,6 +1305,7 @@ static int
 vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			  struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct vhost_virtqueue *vq;
@@ -1337,6 +1354,13 @@ vhost_scsi_clear_endpoint(struct vhost_s
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


