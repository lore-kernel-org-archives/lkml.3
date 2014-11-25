Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbaKYLk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:40:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaKYKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 086/254] UBIFS: remove mst_mutex
Date: Tue, 25 Nov 2014 10:37:16 +0000
Message-Id: <1416912004-5928-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 07e19dff63e3d5d6500d831e36554ac9b1b0560e upstream.

The 'mst_mutex' is not needed since because 'ubifs_write_master()' is only
called on the mount path and commit path. The mount path is sequential and
there is no parallelism, and the commit path is also serialized - there is only
one commit going on at a time.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/commit.c | 2 --
 fs/ubifs/master.c | 7 +++----
 fs/ubifs/super.c  | 1 -
 fs/ubifs/ubifs.h  | 2 --
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index ff8229340cd5..aa13ad053b14 100644
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
index ab83ace9910a..1a4bb9e8b3b8 100644
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
index 3904c8574ef9..eb25aa9d7710 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1963,7 +1963,6 @@ static struct ubifs_info *alloc_ubifs_info(struct ubi_volume_desc *ubi)
 		mutex_init(&c->lp_mutex);
 		mutex_init(&c->tnc_mutex);
 		mutex_init(&c->log_mutex);
-		mutex_init(&c->mst_mutex);
 		mutex_init(&c->umount_mutex);
 		mutex_init(&c->bu_mutex);
 		mutex_init(&c->write_reserve_mutex);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index c1f71fe17cc0..2a18270b02c0 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1051,7 +1051,6 @@ struct ubifs_debug_info;
  *
  * @mst_node: master node
  * @mst_offs: offset of valid master node
- * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
  *
  * @max_bu_buf_len: maximum bulk-read buffer length
  * @bu_mutex: protects the pre-allocated bulk-read buffer and @c->bu
@@ -1292,7 +1291,6 @@ struct ubifs_info {
 
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
-	struct mutex mst_mutex;
 
 	int max_bu_buf_len;
 	struct mutex bu_mutex;
-- 
2.1.0

