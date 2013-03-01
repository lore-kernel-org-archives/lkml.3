Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3CAUXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:23:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3CATpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Thomas <adamthomas1111@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 18/77] UBIFS: fix double free of ubifs_orphan objects
Date: Fri,  1 Mar 2013 11:44:03 -0800
Message-Id: <20130301194353.917962440@linuxfoundation.org>
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

commit 8afd500cb52a5d00bab4525dd5a560d199f979b9 upstream.

The last orphan in the dnext list has its dnext set to NULL. Because
of that, ubifs_delete_orphan assumes that it is not on the dnext list
and frees it immediately instead ignoring it as a second delete. The
orphan is later freed again by erase_deleted.

This change adds an explicit flag to ubifs_orphan indicating whether
it is pending delete.

Signed-off-by: Adam Thomas <adamthomas1111@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/orphan.c |    5 ++++-
 fs/ubifs/ubifs.h  |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -126,13 +126,14 @@ void ubifs_delete_orphan(struct ubifs_in
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
 			if (o->cmt) {
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
@@ -905,6 +905,7 @@ struct ubifs_budget_req {
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
  * @cmt: %1 => commit pending, otherwise %0
+ * @del: %1 => delete pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -915,6 +916,7 @@ struct ubifs_orphan {
 	ino_t inum;
 	unsigned new:1;
 	unsigned cmt:1;
+	unsigned del:1;
 };
 
 /**


