Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3HQATX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:19:23 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:47971 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3HQATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:19:15 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v3 3/4] vhost/scsi: Convert to per-cpu ida_alloc + ida_free command map
Date: Fri, 16 Aug 2013 23:09:08 +0000
Message-Id: <1376694549-20609-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes vhost/scsi to use transport_init_session_tags()
pre-allocation logic for per-cpu session tag pooling with internal
ida_alloc() + ida_free() calls based upon the saved se_cmd->map_tag id.

FIXME: Make transport_init_session_tags() number of tags setup
configurable per vring client setting via configfs

v3 changes:
 - Update to percpu-ida usage
 - Rebase to v3.11-rc5 code

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Asias He <asias@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0c27c7d..af178b7 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -48,12 +48,14 @@
 #include <linux/virtio_scsi.h>
 #include <linux/llist.h>
 #include <linux/bitmap.h>
+#include <linux/idr.h>
 
 #include "vhost.h"
 
 #define TCM_VHOST_VERSION  "v0.1"
 #define TCM_VHOST_NAMELEN 256
 #define TCM_VHOST_MAX_CDB_SIZE 32
+#define TCM_VHOST_DEFAULT_TAGS 256
 
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
@@ -450,6 +452,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_vhost_cmd *tv_cmd = container_of(se_cmd,
 				struct tcm_vhost_cmd, tvc_se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 
 	if (tv_cmd->tvc_sgl_count) {
 		u32 i;
@@ -460,7 +463,7 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
         }
 
 	tcm_vhost_put_inflight(tv_cmd->inflight);
-	kfree(tv_cmd);
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
 }
 
 static int tcm_vhost_shutdown_session(struct se_session *se_sess)
@@ -704,7 +707,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 }
 
 static struct tcm_vhost_cmd *
-vhost_scsi_allocate_cmd(struct vhost_virtqueue *vq,
+vhost_scsi_get_tag(struct vhost_virtqueue *vq,
 			struct tcm_vhost_tpg *tpg,
 			struct virtio_scsi_cmd_req *v_req,
 			u32 exp_data_len,
@@ -712,18 +715,21 @@ vhost_scsi_allocate_cmd(struct vhost_virtqueue *vq,
 {
 	struct tcm_vhost_cmd *cmd;
 	struct tcm_vhost_nexus *tv_nexus;
+	struct se_session *se_sess;
+	int tag;
 
 	tv_nexus = tpg->tpg_nexus;
 	if (!tv_nexus) {
 		pr_err("Unable to locate active struct tcm_vhost_nexus\n");
 		return ERR_PTR(-EIO);
 	}
+	se_sess = tv_nexus->tvn_se_sess;
 
-	cmd = kzalloc(sizeof(struct tcm_vhost_cmd), GFP_ATOMIC);
-	if (!cmd) {
-		pr_err("Unable to allocate struct tcm_vhost_cmd\n");
-		return ERR_PTR(-ENOMEM);
-	}
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_KERNEL);
+	cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[tag];
+	memset(cmd, 0, sizeof(struct tcm_vhost_cmd));
+
+	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->tvc_tag = v_req->tag;
 	cmd->tvc_task_attr = v_req->task_attr;
 	cmd->tvc_exp_data_len = exp_data_len;
@@ -989,10 +995,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		for (i = 0; i < data_num; i++)
 			exp_data_len += vq->iov[data_first + i].iov_len;
 
-		cmd = vhost_scsi_allocate_cmd(vq, tpg, &v_req,
-					exp_data_len, data_direction);
+		cmd = vhost_scsi_get_tag(vq, tpg, &v_req,
+					 exp_data_len, data_direction);
 		if (IS_ERR(cmd)) {
-			vq_err(vq, "vhost_scsi_allocate_cmd failed %ld\n",
+			vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
 					PTR_ERR(cmd));
 			goto err_cmd;
 		}
@@ -1675,9 +1681,12 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tpg,
 		return -ENOMEM;
 	}
 	/*
-	 *  Initialize the struct se_session pointer
+	 *  Initialize the struct se_session pointer and setup tagpool
+	 *  for struct tcm_vhost_cmd descriptors
 	 */
-	tv_nexus->tvn_se_sess = transport_init_session();
+	tv_nexus->tvn_se_sess = transport_init_session_tags(
+					TCM_VHOST_DEFAULT_TAGS,
+					sizeof(struct tcm_vhost_cmd));
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		kfree(tv_nexus);
-- 
1.7.10.4

