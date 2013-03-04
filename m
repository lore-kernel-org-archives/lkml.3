Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab3CDDq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:46:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33196 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452Ab3CDDoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:55 -0500
Message-Id: <20130304033710.028488258@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Adam Thomas <adamthomas1111@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 025/153] UBIFS: fix double free of ubifs_orphan objects
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomas <adamthomas1111@gmail.com>

commit 8afd500cb52a5d00bab4525dd5a560d199f979b9 upstream.

The last orphan in the dnext list has its dnext set to NULL. Because
of that, ubifs_delete_orphan assumes that it is not on the dnext list
and frees it immediately instead ignoring it as a second delete. The
orphan is later freed again by erase_deleted.

This change adds an explicit flag to ubifs_orphan indicating whether
it is pending delete.

Signed-off-by: Adam Thomas <adamthomas1111@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/orphan.c |    5 ++++-
 fs/ubifs/ubifs.h  |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -130,13 +130,14 @@ void ubifs_delete_orphan(struct ubifs_in
 		else if (inum > o->inum)
 			p = p->rb_right;
 		else {
-			if (o->dnext) {
+			if (o->del) {
 				spin_unlock(&c->orphan_lock);
 				dbg_gen("deleted twice ino %lu",
 					(unsigned long)inum);
 				return;
 			}
 			if (o->cnext) {
+				o->del = 1;
 				o->dnext = c->orph_dnext;
 				c->orph_dnext = o;
 				spin_unlock(&c->orphan_lock);
@@ -447,6 +448,7 @@ static void erase_deleted(struct ubifs_i
 		orphan = dnext;
 		dnext = orphan->dnext;
 		ubifs_assert(!orphan->new);
+		ubifs_assert(orphan->del);
 		rb_erase(&orphan->rb, &c->orph_tree);
 		list_del(&orphan->list);
 		c->tot_orphans -= 1;
@@ -536,6 +538,7 @@ static int insert_dead_orphan(struct ubi
 	rb_link_node(&orphan->rb, parent, p);
 	rb_insert_color(&orphan->rb, &c->orph_tree);
 	list_add_tail(&orphan->list, &c->orph_list);
+	orphan->del = 1;
 	orphan->dnext = c->orph_dnext;
 	c->orph_dnext = orphan;
 	dbg_mnt("ino %lu, new %d, tot %d", (unsigned long)inum,
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -908,6 +908,7 @@ struct ubifs_budget_req {
  * @dnext: next orphan to delete
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
+ * @del: %1 => delete pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -917,6 +918,7 @@ struct ubifs_orphan {
 	struct ubifs_orphan *dnext;
 	ino_t inum;
 	int new;
+	unsigned del:1;
 };
 
 /**


