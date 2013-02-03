Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3BCBVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:21:39 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:64381 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3BCBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:19 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/62] idr: refactor idr_get_new_above()
Date: Sat,  2 Feb 2013 17:20:05 -0800
Message-Id: <1359854463-2538-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move slot filling to idr_fill_slot() from idr_get_new_above_int() and
make idr_get_new_above() directly call it.  idr_get_new_above_int() is
no longer needed and removed.

This will be used to implement a new ID allocation interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/idr.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index bde6eec..b13aae5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -278,24 +278,15 @@ build_up:
 	return(v);
 }
 
-static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
+/*
+ * @id and @pa are from a successful allocation from idr_get_empty_slot().
+ * Install the user pointer @ptr and mark the slot full.
+ */
+static void idr_fill_slot(void *ptr, int id, struct idr_layer **pa)
 {
-	struct idr_layer *pa[MAX_IDR_LEVEL];
-	int id;
-
-	id = idr_get_empty_slot(idp, starting_id, pa);
-	if (id >= 0) {
-		/*
-		 * Successfully found an empty slot.  Install the user
-		 * pointer and mark the slot full.
-		 */
-		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
-				(struct idr_layer *)ptr);
-		pa[0]->count++;
-		idr_mark_full(pa, id);
-	}
-
-	return id;
+	rcu_assign_pointer(pa[0]->ary[id & IDR_MASK], (struct idr_layer *)ptr);
+	pa[0]->count++;
+	idr_mark_full(pa, id);
 }
 
 /**
@@ -318,11 +309,14 @@ static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
  */
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id)
 {
+	struct idr_layer *pa[MAX_IDR_LEVEL];
 	int rv;
 
-	rv = idr_get_new_above_int(idp, ptr, starting_id);
+	rv = idr_get_empty_slot(idp, starting_id, pa);
 	if (rv < 0)
 		return rv == -ENOMEM ? -EAGAIN : rv;
+
+	idr_fill_slot(ptr, rv, pa);
 	*id = rv;
 	return 0;
 }
-- 
1.8.1

