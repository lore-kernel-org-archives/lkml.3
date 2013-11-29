Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3K2VOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:14:17 -0500
Received: from mail.ispras.ru ([83.149.199.45]:39673 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3K2VOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:14:16 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] jffs2: make jffs2_do_read_inode_internal() consistent regarding f->sem handling
Date: Sat, 30 Nov 2013 01:13:49 +0400
Message-Id: <1385759629-31176-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2_do_read_inode_internal() does unlock of f->sem mutex
on several failure paths, while its users expect
f->sem is still held. As a result double unlock of the mutex
can happen.

The patch makes jffs2_do_read_inode_internal() consistent
regarding f->sem handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/jffs2/readinode.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index ae81b01e6fd7..a1c9ed65b502 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -1223,18 +1223,17 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 		JFFS2_ERROR("failed to read from flash: error %d, %zd of %zd bytes read\n",
 			ret, retlen, sizeof(*latest_node));
 		/* FIXME: If this fails, there seems to be a memory leak. Find it. */
-		mutex_unlock(&f->sem);
-		jffs2_do_clear_inode(c, f);
-		return ret?ret:-EIO;
+		if (!ret)
+			ret = -EIO;
+		goto clear_inode;
 	}
 
 	crc = crc32(0, latest_node, sizeof(*latest_node)-8);
 	if (crc != je32_to_cpu(latest_node->node_crc)) {
 		JFFS2_ERROR("CRC failed for read_inode of inode %u at physical location 0x%x\n",
 			f->inocache->ino, ref_offset(rii.latest_ref));
-		mutex_unlock(&f->sem);
-		jffs2_do_clear_inode(c, f);
-		return -EIO;
+		ret = -EIO;
+		goto clear_inode;
 	}
 
 	switch(jemode_to_cpu(latest_node->mode) & S_IFMT) {
@@ -1271,16 +1270,14 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 			 * operation. */
 			uint32_t csize = je32_to_cpu(latest_node->csize);
 			if (csize > JFFS2_MAX_NAME_LEN) {
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return -ENAMETOOLONG;
+				ret = -ENAMETOOLONG;
+				goto clear_inode;
 			}
 			f->target = kmalloc(csize + 1, GFP_KERNEL);
 			if (!f->target) {
 				JFFS2_ERROR("can't allocate %u bytes of memory for the symlink target path cache\n", csize);
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto clear_inode;
 			}
 
 			ret = jffs2_flash_read(c, ref_offset(rii.latest_ref) + sizeof(*latest_node),
@@ -1291,9 +1288,7 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 					ret = -EIO;
 				kfree(f->target);
 				f->target = NULL;
-				mutex_unlock(&f->sem);
-				jffs2_do_clear_inode(c, f);
-				return ret;
+				goto clear_inode;
 			}
 
 			f->target[csize] = '\0';
@@ -1309,25 +1304,22 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 		if (f->metadata) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0%o had metadata node\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto clear_inode;
 		}
 		if (!frag_first(&f->fragtree)) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0%o has no fragments\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto clear_inode;
 		}
 		/* ASSERT: f->fraglist != NULL */
 		if (frag_next(frag_first(&f->fragtree))) {
 			JFFS2_ERROR("Argh. Special inode #%u with mode 0x%x had more than one node\n",
 			       f->inocache->ino, jemode_to_cpu(latest_node->mode));
 			/* FIXME: Deal with it - check crc32, check for duplicate node, check times and discard the older one */
-			mutex_unlock(&f->sem);
-			jffs2_do_clear_inode(c, f);
-			return -EIO;
+			ret = -EIO;
+			goto clear_inode;
 		}
 		/* OK. We're happy */
 		f->metadata = frag_first(&f->fragtree)->node;
@@ -1339,6 +1331,12 @@ static int jffs2_do_read_inode_internal(struct jffs2_sb_info *c,
 		jffs2_set_inocache_state(c, f->inocache, INO_STATE_PRESENT);
 
 	return 0;
+
+clear_inode:
+	mutex_unlock(&f->sem);
+	jffs2_do_clear_inode(c, f);
+	mutex_lock(&f->sem);
+	return ret;
 }
 
 /* Scan the list of all nodes present for this ino, build map of versions, etc. */
-- 
1.8.3.2

