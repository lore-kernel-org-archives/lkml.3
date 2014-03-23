Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaCWTLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:11:12 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43280 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaCWTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:11:09 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: akpm@linux-foundation.org, jlayton@redhat.com, tj@kernel.org,
        jdelvare@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: Use RCU_INIT_POINTER(x, NULL) in idr.c
Date: Mon, 24 Mar 2014 00:40:08 +0530
Message-Id: <1395601808-12365-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 lib/idr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4..f804fbe 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -548,7 +548,7 @@ static void sub_remove(struct idr *idp, int shift, int id)
 	n = id & IDR_MASK;
 	if (likely(p != NULL && test_bit(n, p->bitmap))) {
 		__clear_bit(n, p->bitmap);
-		rcu_assign_pointer(p->ary[n], NULL);
+		RCU_INIT_POINTER(p->ary[n], NULL);
 		to_free = NULL;
 		while(*paa && ! --((**paa)->count)){
 			if (to_free)
@@ -617,7 +617,7 @@ void __idr_remove_all(struct idr *idp)
 
 	n = idp->layers * IDR_BITS;
 	p = idp->top;
-	rcu_assign_pointer(idp->top, NULL);
+	RCU_INIT_POINTER(idp->top, NULL);
 	max = idr_max(idp->layers);
 
 	id = 0;
-- 
1.7.9.5

