Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3BFUIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:08:22 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56020 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab3BFTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:52 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/77] idr: refactor idr_get_new_above()
Date: Wed,  6 Feb 2013 11:39:51 -0800
Message-Id: <1360179649-22465-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
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

