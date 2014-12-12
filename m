Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967546AbaLLHBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:01:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51700 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Artem Bityutskiy" <artem.bityutskiy@linux.intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.317246939@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 002/164] UBIFS: remove mst_mutex
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 07e19dff63e3d5d6500d831e36554ac9b1b0560e upstream.

The 'mst_mutex' is not needed since because 'ubifs_write_master()' is only
called on the mount path and commit path. The mount path is sequential and
there is no parallelism, and the commit path is also serialized - there is only
one commit going on at a time.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/commit.c | 2 --
 fs/ubifs/master.c | 7 +++----
 fs/ubifs/super.c  | 1 -
 fs/ubifs/ubifs.h  | 2 --
 4 files changed, 3 insertions(+), 9 deletions(-)

--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -174,7 +174,6 @@ static int do_commit(struct ubifs_info *
 	if (err)
 		goto out;
 
-	mutex_lock(&c->mst_mutex);
 	c->mst_node->cmt_no      = cpu_to_le64(c->cmt_no);
 	c->mst_node->log_lnum    = cpu_to_le32(new_ltail_lnum);
 	c->mst_node->root_lnum   = cpu_to_le32(zroot.lnum);
@@ -204,7 +203,6 @@ static int do_commit(struct ubifs_info *
 	else
 		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_NO_ORPHS);
 	err = ubifs_write_master(c);
-	mutex_unlock(&c->mst_mutex);
 	if (err)
 		goto out;
 
--- a/fs/ubifs/master.c
+++ b/fs/ubifs/master.c
@@ -352,10 +352,9 @@ int ubifs_read_master(struct ubifs_info
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
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1985,7 +1985,6 @@ static struct ubifs_info *alloc_ubifs_in
 		mutex_init(&c->lp_mutex);
 		mutex_init(&c->tnc_mutex);
 		mutex_init(&c->log_mutex);
-		mutex_init(&c->mst_mutex);
 		mutex_init(&c->umount_mutex);
 		mutex_init(&c->bu_mutex);
 		mutex_init(&c->write_reserve_mutex);
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1044,7 +1044,6 @@ struct ubifs_debug_info;
  *
  * @mst_node: master node
  * @mst_offs: offset of valid master node
- * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
  *
  * @max_bu_buf_len: maximum bulk-read buffer length
  * @bu_mutex: protects the pre-allocated bulk-read buffer and @c->bu
@@ -1284,7 +1283,6 @@ struct ubifs_info {
 
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
-	struct mutex mst_mutex;
 
 	int max_bu_buf_len;
 	struct mutex bu_mutex;

