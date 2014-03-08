Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaCHBOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:14:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCHBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Thomas <adamthomas1111@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 61/99] UBIFS: fix double free of ubifs_orphan objects
Date: Fri,  7 Mar 2014 17:07:57 -0800
Message-Id: <20140308010613.551644740@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -905,6 +905,7 @@ struct ubifs_budget_req {
  * @dnext: next orphan to delete
  * @inum: inode number
  * @new: %1 => added since the last commit, otherwise %0
+ * @del: %1 => delete pending, otherwise %0
  */
 struct ubifs_orphan {
 	struct rb_node rb;
@@ -914,6 +915,7 @@ struct ubifs_orphan {
 	struct ubifs_orphan *dnext;
 	ino_t inum;
 	int new;
+	unsigned del:1;
 };
 
 /**


