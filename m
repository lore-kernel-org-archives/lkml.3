Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaFYVxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:53:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaFYVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:53:15 -0400
Date: Wed, 25 Jun 2014 14:53:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] lib: list_sort: Various minor improvements
Message-Id: <20140625145314.3e16af6998765b7aad860bf7@linux-foundation.org>
In-Reply-To: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 12:06:27 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Reading the source of lib/list_sort.c, I came up with a few possible
> improvements. I think 4/4 may be a bit controversial, but 1/4, 2/4 and
> 3/4 should be straightforward.
> 

All looks OK to me.

We may as well do the pr_foo() conversion as well.  As often happens,
the results are quite pleasing.

--- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo
+++ a/lib/list_sort.c
@@ -1,3 +1,6 @@
+
+#define pr_fmt(fmt) "list_sort_test: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/list_sort.h>
@@ -125,9 +128,8 @@ void list_sort(void *priv, struct list_h
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				printk_once(KERN_DEBUG "list passed to"
-					" list_sort() too long for"
-					" efficiency\n");
+				pr_debug_once("list passed to list_sort() too "
+					      "long for efficiency\n");
 				lev--;
 			}
 			max_lev = lev;
@@ -170,27 +172,25 @@ static struct debug_el **elts __initdata
 static int __init check(struct debug_el *ela, struct debug_el *elb)
 {
 	if (ela->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				ela->serial);
+		pr_err("error: incorrect serial %d\n", ela->serial);
 		return -EINVAL;
 	}
 	if (elb->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				elb->serial);
+		pr_err("error: incorrect serial %d\n", elb->serial);
 		return -EINVAL;
 	}
 	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
-		printk(KERN_ERR "list_sort_test: error: phantom element\n");
+		pr_err("error: phantom element\n");
 		return -EINVAL;
 	}
 	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				ela->poison1, ela->poison2);
+		pr_err("error: bad poison: %#x/%#x\n",
+			ela->poison1, ela->poison2);
 		return -EINVAL;
 	}
 	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				elb->poison1, elb->poison2);
+		pr_err("error: bad poison: %#x/%#x\n",
+			elb->poison1, elb->poison2);
 		return -EINVAL;
 	}
 	return 0;
@@ -214,20 +214,18 @@ static int __init list_sort_test(void)
 	struct list_head *cur;
 	LIST_HEAD(head);
 
-	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
+	pr_debug("start testing list_sort()\n");
 
 	elts = kcalloc(TEST_LIST_LEN, sizeof(*elts), GFP_KERNEL);
 	if (!elts) {
-		printk(KERN_ERR "list_sort_test: error: cannot allocate "
-				"memory\n");
+		pr_err("error: cannot allocate memory\n");
 		return err;
 	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
 		if (!el) {
-			printk(KERN_ERR "list_sort_test: error: cannot "
-					"allocate memory\n");
+			pr_err("error: cannot allocate memory\n");
 			goto exit;
 		}
 		 /* force some equivalencies */
@@ -247,42 +245,38 @@ static int __init list_sort_test(void)
 		int cmp_result;
 
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort_test: error: list is "
-					"corrupted\n");
+			pr_err("error: list is corrupted\n");
 			goto exit;
 		}
 
 		cmp_result = cmp(NULL, cur, cur->next);
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort_test: error: list is not "
-					"sorted\n");
+			pr_err("error: list is not sorted\n");
 			goto exit;
 		}
 
 		el = container_of(cur, struct debug_el, list);
 		el1 = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el1->serial) {
-			printk(KERN_ERR "list_sort_test: error: order of "
-					"equivalent elements not preserved\n");
+			pr_err("error: order of equivalent elements not "
+				"preserved\n");
 			goto exit;
 		}
 
 		if (check(el, el1)) {
-			printk(KERN_ERR "list_sort_test: error: element check "
-					"failed\n");
+			pr_err("error: element check failed\n");
 			goto exit;
 		}
 		count++;
 	}
 	if (head.prev != cur) {
-		printk(KERN_ERR "list_sort_test: error: list is corrupted\n");
+		pr_err("error: list is corrupted\n");
 		goto exit;
 	}
 
 
 	if (count != TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: bad list length %d",
-				count);
+		pr_err("error: bad list length %d", count);
 		goto exit;
 	}
 
_


