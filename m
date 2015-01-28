Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbbA1ENb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:13:31 -0500
Received: from mail.kernel.org ([198.145.29.136]:36584 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759125AbbA1EN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:26 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 002/177] UBIFS: remove mst_mutex
Date: Wed, 28 Jan 2015 12:06:10 +0800
Message-Id: <1422418236-12852-3-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 07e19dff63e3d5d6500d831e36554ac9b1b0560e upstream.

The 'mst_mutex' is not needed since because 'ubifs_write_master()' is only
called on the mount path and commit path. The mount path is sequential and
there is no parallelism, and the commit path is also serialized - there is only
one commit going on at a time.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ubifs/commit.c | 2 --
 fs/ubifs/master.c | 7 +++----
 fs/ubifs/super.c  | 1 -
 fs/ubifs/ubifs.h  | 2 --
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index fb3b5c8..3920dc1 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -174,7 +174,6 @@ static int do_commit(struct ubifs_info *c)
 	if (err)
 		goto out;
 
-	mutex_lock(&c->mst_mutex);
 	c->mst_node->cmt_no      = cpu_to_le64(c->cmt_no);
 	c->mst_node->log_lnum    = cpu_to_le32(new_ltail_lnum);
 	c->mst_node->root_lnum   = cpu_to_le32(zroot.lnum);
@@ -204,7 +203,6 @@ static int do_commit(struct ubifs_info *c)
 	else
 		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_NO_ORPHS);
 	err = ubifs_write_master(c);
-	mutex_unlock(&c->mst_mutex);
 	if (err)
 		goto out;
 
diff --git a/fs/ubifs/master.c b/fs/ubifs/master.c
index 278c238..bb9f481 100644
--- a/fs/ubifs/master.c
+++ b/fs/ubifs/master.c
@@ -352,10 +352,9 @@ int ubifs_read_master(struct ubifs_info *c)
  * ubifs_write_master - write master node.
  * @c: UBIFS file-system description object
  *
- * This function writes the master node. The caller has to take the
- * @c->mst_mutex lock before calling this function. Returns zero in case of
- * success and a negative error code in case of failure. The master node is
- * written twice to enable recovery.
+ * This function writes the master node. Returns zero in case of success and a
+ * negative error code in case of failure. The master node is written twice to
+ * enable recovery.
  */
 int ubifs_write_master(struct ubifs_info *c)
 {
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index d867bd9..129bb48 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1984,7 +1984,6 @@ static struct ubifs_info *alloc_ubifs_info(struct ubi_volume_desc *ubi)
 		mutex_init(&c->lp_mutex);
 		mutex_init(&c->tnc_mutex);
 		mutex_init(&c->log_mutex);
-		mutex_init(&c->mst_mutex);
 		mutex_init(&c->umount_mutex);
 		mutex_init(&c->bu_mutex);
 		mutex_init(&c->write_reserve_mutex);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 3f96261..cd62067 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1041,7 +1041,6 @@ struct ubifs_debug_info;
  *
  * @mst_node: master node
  * @mst_offs: offset of valid master node
- * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
  *
  * @max_bu_buf_len: maximum bulk-read buffer length
  * @bu_mutex: protects the pre-allocated bulk-read buffer and @c->bu
@@ -1281,7 +1280,6 @@ struct ubifs_info {
 
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
-	struct mutex mst_mutex;
 
 	int max_bu_buf_len;
 	struct mutex bu_mutex;
-- 
1.9.1

