Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3GFWS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:18:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:48281 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3GFWRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:17:43 -0400
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
Subject: [PATCH-v2 1/3] target: Add transport_init_session_tags using per-cpu ida
Date: Sat,  6 Jul 2013 22:03:21 +0000
Message-Id: <1373148203-7150-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373148203-7150-1-git-send-email-nab@linux-iscsi.org>
References: <1373148203-7150-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds lib/idr.c based transport_init_session_tags() logic
that allows fabric drivers to setup a per-cpu se_sess->sess_tag_pool
and associated se_sess->sess_cmd_map for basic tagged pre-allocation
of fabric descriptor sized memory.

v3: Update to percpu-ida usage

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Asias He <asias@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   33 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    5 ++++
 include/target/target_core_fabric.h    |    1 +
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7172d00..64ceb51 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -232,6 +232,35 @@ struct se_session *transport_init_session(void)
 }
 EXPORT_SYMBOL(transport_init_session);
 
+struct se_session *transport_init_session_tags(unsigned int tag_num,
+					       unsigned int tag_size)
+{
+	struct se_session *se_sess;
+	int rc;
+
+	se_sess = transport_init_session();
+	if (IS_ERR(se_sess))
+		return se_sess;
+
+	se_sess->sess_cmd_map = kzalloc(tag_num * tag_size, GFP_KERNEL);
+	if (!se_sess->sess_cmd_map) {
+		pr_err("Unable to allocate se_sess->sess_cmd_map\n");
+		transport_free_session(se_sess);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rc = percpu_ida_init(&se_sess->sess_tag_pool, tag_num);
+	if (rc < 0) {
+		pr_err("Unable to init se_sess->sess_tag_pool,"
+			" tag_num: %u\n", tag_num);
+		transport_free_session(se_sess);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return se_sess;
+}
+EXPORT_SYMBOL(transport_init_session_tags);
+
 /*
  * Called with spin_lock_irqsave(&struct se_portal_group->session_lock called.
  */
@@ -367,6 +396,10 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 
 void transport_free_session(struct se_session *se_sess)
 {
+	if (se_sess->sess_cmd_map) {
+		percpu_ida_destroy(&se_sess->sess_tag_pool);
+		kfree(se_sess->sess_cmd_map);
+	}
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d92ec67..a842884 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -5,6 +5,7 @@
 #include <linux/configfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/idr.h>
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -418,6 +419,8 @@ struct se_cmd {
 	enum dma_data_direction	data_direction;
 	/* For SAM Task Attribute */
 	int			sam_task_attr;
+	/* Used for se_sess->sess_tag_pool */
+	unsigned int		map_tag;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
 	unsigned		cmd_wait_set:1;
@@ -539,6 +542,8 @@ struct se_session {
 	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
+	void			*sess_cmd_map;
+	struct percpu_ida	sess_tag_pool;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 1dcce9c..d34f2ce 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -84,6 +84,7 @@ struct target_core_fabric_ops {
 };
 
 struct se_session *transport_init_session(void);
+struct se_session *transport_init_session_tags(unsigned int, unsigned int);
 void	__transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	transport_register_session(struct se_portal_group *,
-- 
1.7.2.5

