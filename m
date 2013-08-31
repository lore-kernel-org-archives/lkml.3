Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3HaDIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 23:08:53 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56719 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3HaDIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 23:08:51 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Asias He <asias@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v5 2/6] target: Add transport_init_session_tags using per-cpu ida
Date: Sat, 31 Aug 2013 02:52:32 +0000
Message-Id: <1377917556-11955-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
References: <1377917556-11955-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds lib/idr.c based transport_init_session_tags() logic
that allows fabric drivers to setup a per-cpu se_sess->sess_tag_pool
and associated se_sess->sess_cmd_map for basic tagged pre-allocation
of fabric descriptor sized memory.

v5 changes:
  - Convert to percpu_ida.h include

v4 changes:
  - Add transport_alloc_session_tags() for fabrics that need early
    transport_init_session()

v3 changes:
  - Update to percpu-ida usage

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Asias He <asias@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   48 ++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    5 +++
 include/target/target_core_fabric.h    |    3 ++
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7172d00..98ec711 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -232,6 +232,50 @@ struct se_session *transport_init_session(void)
 }
 EXPORT_SYMBOL(transport_init_session);
 
+int transport_alloc_session_tags(struct se_session *se_sess,
+			         unsigned int tag_num, unsigned int tag_size)
+{
+	int rc;
+
+	se_sess->sess_cmd_map = kzalloc(tag_num * tag_size, GFP_KERNEL);
+	if (!se_sess->sess_cmd_map) {
+		pr_err("Unable to allocate se_sess->sess_cmd_map\n");
+		return -ENOMEM;
+	}
+
+	rc = percpu_ida_init(&se_sess->sess_tag_pool, tag_num);
+	if (rc < 0) {
+		pr_err("Unable to init se_sess->sess_tag_pool,"
+			" tag_num: %u\n", tag_num);
+		kfree(se_sess->sess_cmd_map);
+		se_sess->sess_cmd_map = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(transport_alloc_session_tags);
+
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
+	rc = transport_alloc_session_tags(se_sess, tag_num, tag_size);
+	if (rc < 0) {
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
@@ -367,6 +411,10 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 
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
index e34fc90..bd55acd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -5,6 +5,7 @@
 #include <linux/configfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
+#include <linux/percpu_ida.h>
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -415,6 +416,8 @@ struct se_cmd {
 	enum dma_data_direction	data_direction;
 	/* For SAM Task Attribute */
 	int			sam_task_attr;
+	/* Used for se_sess->sess_tag_pool */
+	unsigned int		map_tag;
 	/* Transport protocol dependent state, see transport_state_table */
 	enum transport_state_table t_state;
 	unsigned		cmd_wait_set:1;
@@ -536,6 +539,8 @@ struct se_session {
 	struct list_head	sess_wait_list;
 	spinlock_t		sess_cmd_lock;
 	struct kref		sess_kref;
+	void			*sess_cmd_map;
+	struct percpu_ida	sess_tag_pool;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 7a16178..d559c36 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -84,6 +84,9 @@ struct target_core_fabric_ops {
 };
 
 struct se_session *transport_init_session(void);
+int transport_alloc_session_tags(struct se_session *, unsigned int,
+		unsigned int);
+struct se_session *transport_init_session_tags(unsigned int, unsigned int);
 void	__transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	transport_register_session(struct se_portal_group *,
-- 
1.7.2.5

