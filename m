Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbaIOWdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:33:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaIOWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 129/187] netlabel: fix the catmap walking functions
Date: Mon, 15 Sep 2014 15:08:59 -0700
Message-Id: <1410818997-9432-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit d960a6184a92c8da70d26355bfcb5bd8ad637743 upstream.

The two NetLabel LSM secattr catmap walk functions didn't handle
certain edge conditions correctly, causing incorrect security labels
to be generated in some cases.  This patch corrects these problems and
converts the functions to use the new _netlbl_secattr_catmap_getnode()
function in order to reduce the amount of repeated code.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Tested-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netlabel/netlabel_kapi.c | 102 +++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 21af4b9..929bfc6 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -408,6 +408,7 @@ out_entry:
 
 #define _CM_F_NONE	0x00000000
 #define _CM_F_ALLOC	0x00000001
+#define _CM_F_WALK	0x00000002
 
 /**
  * _netlbl_secattr_catmap_getnode - Get a individual node from a catmap
@@ -417,10 +418,11 @@ out_entry:
  * @gfp_flags: memory allocation flags
  *
  * Description:
- * Iterate through the catmap looking for the node associated with @offset; if
- * the _CM_F_ALLOC flag is set in @cm_flags and there is no associated node,
- * one will be created and inserted into the catmap.  Returns a pointer to the
- * node on success, NULL on failure.
+ * Iterate through the catmap looking for the node associated with @offset.
+ * If the _CM_F_ALLOC flag is set in @cm_flags and there is no associated node,
+ * one will be created and inserted into the catmap.  If the _CM_F_WALK flag is
+ * set in @cm_flags and there is no associated node, the next highest node will
+ * be returned.  Returns a pointer to the node on success, NULL on failure.
  *
  */
 static struct netlbl_lsm_secattr_catmap *_netlbl_secattr_catmap_getnode(
@@ -432,17 +434,22 @@ static struct netlbl_lsm_secattr_catmap *_netlbl_secattr_catmap_getnode(
 	struct netlbl_lsm_secattr_catmap *iter = *catmap;
 	struct netlbl_lsm_secattr_catmap *prev = NULL;
 
-	if (iter == NULL || offset < iter->startbit)
+	if (iter == NULL)
 		goto secattr_catmap_getnode_alloc;
+	if (offset < iter->startbit)
+		goto secattr_catmap_getnode_walk;
 	while (iter && offset >= (iter->startbit + NETLBL_CATMAP_SIZE)) {
 		prev = iter;
 		iter = iter->next;
 	}
 	if (iter == NULL || offset < iter->startbit)
-		goto secattr_catmap_getnode_alloc;
+		goto secattr_catmap_getnode_walk;
 
 	return iter;
 
+secattr_catmap_getnode_walk:
+	if (cm_flags & _CM_F_WALK)
+		return iter;
 secattr_catmap_getnode_alloc:
 	if (!(cm_flags & _CM_F_ALLOC))
 		return NULL;
@@ -477,43 +484,41 @@ int netlbl_secattr_catmap_walk(struct netlbl_lsm_secattr_catmap *catmap,
 			       u32 offset)
 {
 	struct netlbl_lsm_secattr_catmap *iter = catmap;
-	u32 node_idx;
-	u32 node_bit;
+	u32 idx;
+	u32 bit;
 	NETLBL_CATMAP_MAPTYPE bitmap;
 
+	iter = _netlbl_secattr_catmap_getnode(&catmap, offset, _CM_F_WALK, 0);
+	if (iter == NULL)
+		return -ENOENT;
 	if (offset > iter->startbit) {
-		while (offset >= (iter->startbit + NETLBL_CATMAP_SIZE)) {
-			iter = iter->next;
-			if (iter == NULL)
-				return -ENOENT;
-		}
-		node_idx = (offset - iter->startbit) / NETLBL_CATMAP_MAPSIZE;
-		node_bit = offset - iter->startbit -
-			   (NETLBL_CATMAP_MAPSIZE * node_idx);
+		offset -= iter->startbit;
+		idx = offset / NETLBL_CATMAP_MAPSIZE;
+		bit = offset % NETLBL_CATMAP_MAPSIZE;
 	} else {
-		node_idx = 0;
-		node_bit = 0;
+		idx = 0;
+		bit = 0;
 	}
-	bitmap = iter->bitmap[node_idx] >> node_bit;
+	bitmap = iter->bitmap[idx] >> bit;
 
 	for (;;) {
 		if (bitmap != 0) {
 			while ((bitmap & NETLBL_CATMAP_BIT) == 0) {
 				bitmap >>= 1;
-				node_bit++;
+				bit++;
 			}
 			return iter->startbit +
-				(NETLBL_CATMAP_MAPSIZE * node_idx) + node_bit;
+			       (NETLBL_CATMAP_MAPSIZE * idx) + bit;
 		}
-		if (++node_idx >= NETLBL_CATMAP_MAPCNT) {
+		if (++idx >= NETLBL_CATMAP_MAPCNT) {
 			if (iter->next != NULL) {
 				iter = iter->next;
-				node_idx = 0;
+				idx = 0;
 			} else
 				return -ENOENT;
 		}
-		bitmap = iter->bitmap[node_idx];
-		node_bit = 0;
+		bitmap = iter->bitmap[idx];
+		bit = 0;
 	}
 
 	return -ENOENT;
@@ -533,46 +538,47 @@ int netlbl_secattr_catmap_walk(struct netlbl_lsm_secattr_catmap *catmap,
 int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_secattr_catmap *catmap,
 				   u32 offset)
 {
-	struct netlbl_lsm_secattr_catmap *iter = catmap;
-	u32 node_idx;
-	u32 node_bit;
+	struct netlbl_lsm_secattr_catmap *iter;
+	struct netlbl_lsm_secattr_catmap *prev = NULL;
+	u32 idx;
+	u32 bit;
 	NETLBL_CATMAP_MAPTYPE bitmask;
 	NETLBL_CATMAP_MAPTYPE bitmap;
 
+	iter = _netlbl_secattr_catmap_getnode(&catmap, offset, _CM_F_WALK, 0);
+	if (iter == NULL)
+		return -ENOENT;
 	if (offset > iter->startbit) {
-		while (offset >= (iter->startbit + NETLBL_CATMAP_SIZE)) {
-			iter = iter->next;
-			if (iter == NULL)
-				return -ENOENT;
-		}
-		node_idx = (offset - iter->startbit) / NETLBL_CATMAP_MAPSIZE;
-		node_bit = offset - iter->startbit -
-			   (NETLBL_CATMAP_MAPSIZE * node_idx);
+		offset -= iter->startbit;
+		idx = offset / NETLBL_CATMAP_MAPSIZE;
+		bit = offset % NETLBL_CATMAP_MAPSIZE;
 	} else {
-		node_idx = 0;
-		node_bit = 0;
+		idx = 0;
+		bit = 0;
 	}
-	bitmask = NETLBL_CATMAP_BIT << node_bit;
+	bitmask = NETLBL_CATMAP_BIT << bit;
 
 	for (;;) {
-		bitmap = iter->bitmap[node_idx];
+		bitmap = iter->bitmap[idx];
 		while (bitmask != 0 && (bitmap & bitmask) != 0) {
 			bitmask <<= 1;
-			node_bit++;
+			bit++;
 		}
 
-		if (bitmask != 0)
+		if (prev && idx == 0 && bit == 0)
+			return prev->startbit + NETLBL_CATMAP_SIZE - 1;
+		else if (bitmask != 0)
 			return iter->startbit +
-				(NETLBL_CATMAP_MAPSIZE * node_idx) +
-				node_bit - 1;
-		else if (++node_idx >= NETLBL_CATMAP_MAPCNT) {
+				(NETLBL_CATMAP_MAPSIZE * idx) + bit - 1;
+		else if (++idx >= NETLBL_CATMAP_MAPCNT) {
 			if (iter->next == NULL)
-				return iter->startbit +	NETLBL_CATMAP_SIZE - 1;
+				return iter->startbit + NETLBL_CATMAP_SIZE - 1;
+			prev = iter;
 			iter = iter->next;
-			node_idx = 0;
+			idx = 0;
 		}
 		bitmask = NETLBL_CATMAP_BIT;
-		node_bit = 0;
+		bit = 0;
 	}
 
 	return -ENOENT;
-- 
1.9.1

