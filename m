Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab3B1Oth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3B1Ot2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Thomas <adamthomas1111@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/139] UBIFS: fix use of freed ubifs_orphan objects
Date: Thu, 28 Feb 2013 14:43:58 +0000
Message-Id: <1362062689-2567-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomas <adamthomas1111@gmail.com>

commit 2928f0d0c5ebd6c9605c0d98207a44376387c298 upstream.

The last orphan in the cnext list has its cnext set to NULL. Because
of that, ubifs_delete_orphan assumes that it is not on the cnext list
and frees it immediately instead of adding it to the dnext list. The
freed orphan is later modified by write_orph_node.

This can cause various inconsistencies including directory entries
that cannot be removed and this error:

UBIFS error (pid 20685): layout_cnodes: LPT out of space at LEB 14:129009 needing 17, done_ltab 1, done_lsave 1

This is a regression introduced by
"7074e5eb UBIFS: remove invalid reference to list iterator variable".

This change adds an explicit flag to ubifs_orphan indicating whether
it is pending commit.

Signed-off-by: Adam Thomas <adamthomas1111@gmail.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ubifs/orphan.c | 7 ++++++-
 fs/ubifs/ubifs.h  | 4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index b02734d..bd516f1 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -132,7 +132,7 @@ void ubifs_delete_orphan(struct ubifs_info *c, ino_t inum)
 					(unsigned long)inum);
 				return;
 			}
-			if (o->cnext) {
+			if (o->cmt) {
 				o->dnext = c->orph_dnext;
 				c->orph_dnext = o;
 				spin_unlock(&c->orphan_lock);
@@ -172,7 +172,9 @@ int ubifs_orphan_start_commit(struct ubifs_info *c)
 	last = &c->orph_cnext;
 	list_for_each_entry(orphan, &c->orph_new, new_list) {
 		ubifs_assert(orphan->new);
+		ubifs_assert(!orphan->cmt);
 		orphan->new = 0;
+		orphan->cmt = 1;
 		*last = orphan;
 		last = &orphan->cnext;
 	}
@@ -299,7 +301,9 @@ static int write_orph_node(struct ubifs_info *c, int atomic)
 	cnext = c->orph_cnext;
 	for (i = 0; i < cnt; i++) {
 		orphan = cnext;
+		ubifs_assert(orphan->cmt);
 		orph->inos[i] = cpu_to_le64(orphan->inum);
+		orphan->cmt = 0;
 		cnext = orphan->cnext;
 		orphan->cnext = NULL;
 	}
@@ -378,6 +382,7 @@ static int consolidate(struct ubifs_info *c)
 		list_for_each_entry(orphan, &c->orph_list, list) {
 			if (orphan->new)
 				continue;
+			orphan->cmt = 1;
 			*last = orphan;
 			last = &orphan->cnext;
 			cnt += 1;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 51ac3e6..fb89c54 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -905,6 +905,7 @@ struct ubifs_budget_req {
  * @dnext: next orphan to delete
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
+ * @cmt: %1 => commit pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -913,7 +914,8 @@ struct ubifs_orphan {
 	struct ubifs_orphan *cnext;
 	struct ubifs_orphan *dnext;
 	ino_t inum;
-	int new;
+	unsigned new:1;
+	unsigned cmt:1;
 };
 
 /**
-- 
1.8.1.2

