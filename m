Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3GFWSD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:18:03 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:48302 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3GFWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:17:45 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/3] vhost/scsi: Add pre-allocation for tv_cmd SGL + upages memory
Date: Sat,  6 Jul 2013 22:03:23 +0000
Message-Id: <1373148203-7150-4-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373148203-7150-1-git-send-email-nab@linux-iscsi.org>
References: <1373148203-7150-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for pre-allocation of per tv_cmd descriptor
scatterlist + user-space page pointer memory using se_sess->sess_cmd_map
within tcm_vhost_make_nexus() code.

This includes sanity checks within vhost_scsi_map_to_sgl()
to reject I/O that exceeds these initial hardcoded values, and
the necessary cleanup in tcm_vhost_make_nexus() failure path +
tcm_vhost_drop_nexus().

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Asias He <asias@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   97 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 6224434..f200b17 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -57,6 +57,8 @@
 #define TCM_VHOST_NAMELEN 256
 #define TCM_VHOST_MAX_CDB_SIZE 32
 #define TCM_VHOST_DEFAULT_TAGS 256
+#define TCM_VHOST_PREALLOC_SGLS 2048
+#define TCM_VHOST_PREALLOC_PAGES 2048
 
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
@@ -82,6 +84,7 @@ struct tcm_vhost_cmd {
 	u32 tvc_lun;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
+	struct page **tvc_upages;
 	/* Pointer to response */
 	struct virtio_scsi_cmd_resp __user *tvc_resp;
 	/* Pointer to vhost_scsi for our device */
@@ -456,8 +459,6 @@ static void tcm_vhost_release_cmd(struct se_cmd *se_cmd)
 		u32 i;
 		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
 			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
-
-		kfree(tv_cmd->tvc_sgl);
         }
 
 	tcm_vhost_put_inflight(tv_cmd->inflight);
@@ -713,6 +714,8 @@ static struct tcm_vhost_cmd *vhost_scsi_get_tag(
 	struct tcm_vhost_cmd *tv_cmd;
 	struct tcm_vhost_nexus *tv_nexus;
 	struct se_session *se_sess;
+	struct scatterlist *sg;
+	struct page **pages;
 	int tag;
 
 	tv_nexus = tv_tpg->tpg_nexus;
@@ -724,8 +727,12 @@ static struct tcm_vhost_cmd *vhost_scsi_get_tag(
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, GFP_KERNEL);
 	tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[tag];
+	sg = tv_cmd->tvc_sgl;
+	pages = tv_cmd->tvc_upages;
 	memset(tv_cmd, 0, sizeof(struct tcm_vhost_cmd));
 
+	tv_cmd->tvc_sgl = sg;
+	tv_cmd->tvc_upages = pages;
 	tv_cmd->tvc_se_cmd.map_tag = tag;
 	tv_cmd->tvc_tag = v_req->tag;
 	tv_cmd->tvc_task_attr = v_req->task_attr;
@@ -742,7 +749,7 @@ static struct tcm_vhost_cmd *vhost_scsi_get_tag(
  *
  * Returns the number of scatterlist entries used or -errno on error.
  */
-static int vhost_scsi_map_to_sgl(struct scatterlist *sgl,
+static int vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *tv_cmd, struct scatterlist *sgl,
 	unsigned int sgl_count, struct iovec *iov, int write)
 {
 	unsigned int npages = 0, pages_nr, offset, nbytes;
@@ -752,13 +759,25 @@ static int vhost_scsi_map_to_sgl(struct scatterlist *sgl,
 	struct page **pages;
 	int ret, i;
 
+	if (sgl_count > TCM_VHOST_PREALLOC_SGLS) {
+		pr_err("vhost_scsi_map_to_sgl() psgl_count: %u greater than"
+		       " preallocated TCM_VHOST_PREALLOC_SGLS: %u\n",
+			sgl_count, TCM_VHOST_PREALLOC_SGLS);
+		return -ENOBUFS;
+	}
+
 	pages_nr = iov_num_pages(iov);
 	if (pages_nr > sgl_count)
 		return -ENOBUFS;
 
-	pages = kmalloc(pages_nr * sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		return -ENOMEM;
+	if (pages_nr > TCM_VHOST_PREALLOC_PAGES) {
+		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
+		       " preallocated TCM_VHOST_PREALLOC_PAGES: %u\n",
+			pages_nr, TCM_VHOST_PREALLOC_PAGES);
+		return -ENOBUFS;
+	}
+
+	pages = tv_cmd->tvc_upages;
 
 	ret = get_user_pages_fast((unsigned long)ptr, pages_nr, write, pages);
 	/* No pages were pinned */
@@ -783,7 +802,6 @@ static int vhost_scsi_map_to_sgl(struct scatterlist *sgl,
 	}
 
 out:
-	kfree(pages);
 	return ret;
 }
 
@@ -803,25 +821,18 @@ static int vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *tv_cmd,
 		sgl_count += iov_num_pages(&iov[i]);
 
 	/* TODO overflow checking */
-
-	sg = kmalloc(sizeof(tv_cmd->tvc_sgl[0]) * sgl_count, GFP_ATOMIC);
-	if (!sg)
-		return -ENOMEM;
-	pr_debug("%s sg %p sgl_count %u is_err %d\n", __func__,
-	       sg, sgl_count, !sg);
+	sg = tv_cmd->tvc_sgl;
 	sg_init_table(sg, sgl_count);
 
-	tv_cmd->tvc_sgl = sg;
 	tv_cmd->tvc_sgl_count = sgl_count;
 
 	pr_debug("Mapping %u iovecs for %u pages\n", niov, sgl_count);
 	for (i = 0; i < niov; i++) {
-		ret = vhost_scsi_map_to_sgl(sg, sgl_count, &iov[i], write);
+		ret = vhost_scsi_map_to_sgl(tv_cmd, sg, sgl_count, &iov[i], write);
 		if (ret < 0) {
 			for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
 				put_page(sg_page(&tv_cmd->tvc_sgl[i]));
-			kfree(tv_cmd->tvc_sgl);
-			tv_cmd->tvc_sgl = NULL;
+
 			tv_cmd->tvc_sgl_count = 0;
 			return ret;
 		}
@@ -1647,11 +1658,31 @@ static void tcm_vhost_drop_nodeacl(struct se_node_acl *se_acl)
 	kfree(nacl);
 }
 
+static void tcm_vhost_free_cmd_map_res(struct tcm_vhost_nexus *nexus,
+				       struct se_session *se_sess)
+{
+	struct tcm_vhost_cmd *tv_cmd;
+	int i;
+
+	if (!se_sess->sess_cmd_map)
+		return;
+
+	for (i = 0; i < TCM_VHOST_DEFAULT_TAGS; i++) {
+		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
+
+		kfree(tv_cmd->tvc_sgl);
+		kfree(tv_cmd->tvc_upages);
+	}
+}
+
 static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 	const char *name)
 {
 	struct se_portal_group *se_tpg;
+	struct se_session *se_sess;
 	struct tcm_vhost_nexus *tv_nexus;
+	struct tcm_vhost_cmd *tv_cmd;
+	unsigned int i;
 
 	mutex_lock(&tv_tpg->tv_tpg_mutex);
 	if (tv_tpg->tpg_nexus) {
@@ -1679,6 +1710,26 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 		kfree(tv_nexus);
 		return -ENOMEM;
 	}
+	se_sess = tv_nexus->tvn_se_sess;
+	for (i = 0; i < TCM_VHOST_DEFAULT_TAGS; i++) {
+		tv_cmd = &((struct tcm_vhost_cmd *)se_sess->sess_cmd_map)[i];
+
+		tv_cmd->tvc_sgl = kzalloc(sizeof(struct scatterlist) *
+					TCM_VHOST_PREALLOC_SGLS, GFP_KERNEL);
+		if (!tv_cmd->tvc_sgl) {
+			mutex_unlock(&tv_tpg->tv_tpg_mutex);
+			pr_err("Unable to allocate tv_cmd->tvc_sgl\n");
+			goto out;
+		}
+
+		tv_cmd->tvc_upages = kzalloc(sizeof(struct page *) *
+					TCM_VHOST_PREALLOC_PAGES, GFP_KERNEL);
+		if (!tv_cmd->tvc_upages) {
+			mutex_unlock(&tv_tpg->tv_tpg_mutex);
+			pr_err("Unable to allocate tv_cmd->tvc_upages\n");
+			goto out;
+		}
+	}
 	/*
 	 * Since we are running in 'demo mode' this call with generate a
 	 * struct se_node_acl for the tcm_vhost struct se_portal_group with
@@ -1690,9 +1741,7 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 		mutex_unlock(&tv_tpg->tv_tpg_mutex);
 		pr_debug("core_tpg_check_initiator_node_acl() failed"
 				" for %s\n", name);
-		transport_free_session(tv_nexus->tvn_se_sess);
-		kfree(tv_nexus);
-		return -ENOMEM;
+		goto out;
 	}
 	/*
 	 * Now register the TCM vhost virtual I_T Nexus as active with the
@@ -1704,6 +1753,12 @@ static int tcm_vhost_make_nexus(struct tcm_vhost_tpg *tv_tpg,
 
 	mutex_unlock(&tv_tpg->tv_tpg_mutex);
 	return 0;
+
+out:
+	tcm_vhost_free_cmd_map_res(tv_nexus, se_sess);
+	transport_free_session(se_sess);
+	kfree(tv_nexus);
+	return -ENOMEM;
 }
 
 static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
@@ -1743,6 +1798,8 @@ static int tcm_vhost_drop_nexus(struct tcm_vhost_tpg *tpg)
 	pr_debug("TCM_vhost_ConfigFS: Removing I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_vhost_dump_proto_id(tpg->tport),
 		tv_nexus->tvn_se_sess->se_node_acl->initiatorname);
+
+	tcm_vhost_free_cmd_map_res(tv_nexus, se_sess);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-- 
1.7.2.5

