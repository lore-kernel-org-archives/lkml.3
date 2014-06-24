Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaFXKHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:07:10 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47280 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaFXKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:07:03 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 3/4] lib: list_sort_test(): Simplify and harden cleanup
Date: Tue, 24 Jun 2014 12:06:30 +0200
Message-Id: <1403604392-23259-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to maintain the list structure while freeing the
debug elements. Aside from the redundant pointer manipulations, it is
also inefficient from a locality-of-reference viewpoint, since they
are visited in a random order (wrt. the order they were
allocated). Furthermore, if we jumped to exit: after detecting list
corruption, it is actually dangerous.

So just free the elements in the order they were allocated, using the
backing array elts. Allocate that using kcalloc(), so that if
allocation of one of the debug element fails, we just end up calling
kfree(NULL) for the trailing elements.

Minor details: Use sizeof(*elts) instead of sizeof(void *), and return
err immediately when allocation of elts fails, to avoid introducing
another label just before the final return statement.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/list_sort.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index fbdbc86..a34c78c 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -209,16 +209,16 @@ static int __init list_sort_test(void)
 {
 	int i, count = 1, err = -ENOMEM;
 	struct debug_el *el;
-	struct list_head *cur, *tmp;
+	struct list_head *cur;
 	LIST_HEAD(head);
 
 	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
 
-	elts = kmalloc(sizeof(void *) * TEST_LIST_LEN, GFP_KERNEL);
+	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
 	if (!elts) {
 		printk(KERN_ERR "list_sort_test: error: cannot allocate "
 				"memory\n");
-		goto exit;
+		return err;
 	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
@@ -286,11 +286,9 @@ static int __init list_sort_test(void)
 
 	err = 0;
 exit:
+	for (i = 0; i < TEST_LIST_LEN; i++)
+		kfree(elts[i]);
 	kfree(elts);
-	list_for_each_safe(cur, tmp, &head) {
-		list_del(cur);
-		kfree(container_of(cur, struct debug_el, list));
-	}
 	return err;
 }
 module_init(list_sort_test);
-- 
1.9.2

