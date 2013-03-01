Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CAUXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:23:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3CATpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Thomas <adamthomas1111@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 17/77] UBIFS: fix use of freed ubifs_orphan objects
Date: Fri,  1 Mar 2013 11:44:02 -0800
Message-Id: <20130301194353.811920726@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/orphan.c |    7 ++++++-
 fs/ubifs/ubifs.h  |    4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -132,7 +132,7 @@ void ubifs_delete_orphan(struct ubifs_in
 					(unsigned long)inum);
 				return;
 			}
-			if (o->cnext) {
+			if (o->cmt) {
 				o->dnext = c->orph_dnext;
 				c->orph_dnext = o;
 				spin_unlock(&c->orphan_lock);
@@ -172,7 +172,9 @@ int ubifs_orphan_start_commit(struct ubi
 	last = &c->orph_cnext;
 	list_for_each_entry(orphan, &c->orph_new, new_list) {
 		ubifs_assert(orphan->new);
+		ubifs_assert(!orphan->cmt);
 		orphan->new = 0;
+		orphan->cmt = 1;
 		*last = orphan;
 		last = &orphan->cnext;
 	}
@@ -299,7 +301,9 @@ static int write_orph_node(struct ubifs_
 	cnext = c->orph_cnext;
 	for (i = 0; i < cnt; i++) {
 		orphan = cnext;
+		ubifs_assert(orphan->cmt);
 		orph->inos[i] = cpu_to_le64(orphan->inum);
+		orphan->cmt = 0;
 		cnext = orphan->cnext;
 		orphan->cnext = NULL;
 	}
@@ -378,6 +382,7 @@ static int consolidate(struct ubifs_info
 		list_for_each_entry(orphan, &c->orph_list, list) {
 			if (orphan->new)
 				continue;
+			orphan->cmt = 1;
 			*last = orphan;
 			last = &orphan->cnext;
 			cnt += 1;
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -904,6 +904,7 @@ struct ubifs_budget_req {
  * @dnext: next orphan to delete
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
+ * @cmt: %1 => commit pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -912,7 +913,8 @@ struct ubifs_orphan {
 	struct ubifs_orphan *cnext;
 	struct ubifs_orphan *dnext;
 	ino_t inum;
-	int new;
+	unsigned new:1;
+	unsigned cmt:1;
 };
 
 /**


