Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaBLSHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:07:51 -0500
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:34550 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752240AbaBLSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:07:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:152:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2198:2199:2393:2551:2553:2559:2562:2731:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4049:4118:4321:4605:5007:6119:7652:8660:9010:9012:10004:10848:11026:11232:11233:11473:11658:11914:12043:12050:12291:12296:12438:12517:12519:12555:12683:12740:13148:13230:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleep01_440dd411df20f
X-Filterd-Recvd-Size: 7125
Message-ID: <1392228466.1868.24.camel@joe-AO722>
Subject: Re: [3.13.2] list passed to list_sort() too long for efficiency.
From: Joe Perches <joe@perches.com>
To: pawel.sikora@agmk.net
Cc: linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 10:07:46 -0800
In-Reply-To: <4850975.2GAlrTXDHt@localhost.localdomain>
References: <1799469.xr2i5c36Hj@localhost.localdomain>
	 <1392227186.1868.20.camel@joe-AO722>
	 <4850975.2GAlrTXDHt@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 18:59 +0100, Paweł Sikora wrote:
> On Wednesday 12 of February 2014 09:46:26 Joe Perches wrote:
> > On Wed, 2014-02-12 at 18:16 +0100, Paweł Sikora wrote:
> > > [16855.582522] list passed to list_sort() too long for efficiency
> > > 
> > > could someone put some light on the last line?
> > 
> > Did you look at the list_sort function in lib/list_sort.c?
> > 
> > (granted the dmesg is harder to find that it should be
> >  because the format is split)
> > 
> > It just means it's slower than it could otherwise be
> 
> thanks,
> so without a stacktrace in dmesg we can't isolate a root of cause :/
> 

Perhaps something like this would help:

Emit the caller of list_sort using %pS when the list is too
long to be efficient.  Also emit the message if necessary
once for each call.

Coalesce formats.
Use a more current logging style with pr_<level> and pr_<fmt>

---
 lib/list_sort.c | 67 +++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 1183fa7..e4e1a95 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/list_sort.h>
@@ -6,6 +8,8 @@
 
 #define MAX_LIST_LENGTH_BITS 20
 
+#define DEBUG
+
 /*
  * Returns a list organized in an intermediate format suited
  * to chaining of merge() calls: null-terminated, no reserved or
@@ -103,6 +107,7 @@ void list_sort(void *priv, struct list_head *head,
 	int lev;  /* index into part[] */
 	int max_lev = 0;
 	struct list_head *list;
+	bool too_big_msg = false;
 
 	if (list_empty(head))
 		return;
@@ -123,9 +128,11 @@ void list_sort(void *priv, struct list_head *head,
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				printk_once(KERN_DEBUG "list passed to"
-					" list_sort() too long for"
-					" efficiency\n");
+				if (!too_big_msg) {
+					too_big_msg = true;
+					pr_debug("list passed from %pS to list_sort() too long for efficiency\n",
+						 __builtin_return_address(0));
+				}
 				lev--;
 			}
 			max_lev = lev;
@@ -165,30 +172,29 @@ struct debug_el {
 /* Array, containing pointers to all elements in the test list */
 static struct debug_el **elts __initdata;
 
-static int __init check(struct debug_el *ela, struct debug_el *elb)
+static int __init check(struct debug_el *ela, struct debug_el *elb,
+			const char *caller)
 {
 	if (ela->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				ela->serial);
+		pr_err("%s: error: incorrect serial %d\n", caller, ela->serial);
 		return -EINVAL;
 	}
 	if (elb->serial >= TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: incorrect serial %d\n",
-				elb->serial);
+		pr_err("%s: error: incorrect serial %d\n", caller, elb->serial);
 		return -EINVAL;
 	}
 	if (elts[ela->serial] != ela || elts[elb->serial] != elb) {
-		printk(KERN_ERR "list_sort_test: error: phantom element\n");
+		pr_err("%s: error: phantom element\n", caller);
 		return -EINVAL;
 	}
 	if (ela->poison1 != TEST_POISON1 || ela->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				ela->poison1, ela->poison2);
+		pr_err("%s: error: bad poison: %#x/%#x\n",
+		       caller, ela->poison1, ela->poison2);
 		return -EINVAL;
 	}
 	if (elb->poison1 != TEST_POISON1 || elb->poison2 != TEST_POISON2) {
-		printk(KERN_ERR "list_sort_test: error: bad poison: %#x/%#x\n",
-				elb->poison1, elb->poison2);
+		pr_err("%s: error: bad poison: %#x/%#x\n",
+		       caller, elb->poison1, elb->poison2);
 		return -EINVAL;
 	}
 	return 0;
@@ -201,7 +207,7 @@ static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
 	ela = container_of(a, struct debug_el, list);
 	elb = container_of(b, struct debug_el, list);
 
-	check(ela, elb);
+	check(ela, elb, "list_sort_test");
 	return ela->value - elb->value;
 }
 
@@ -212,22 +218,17 @@ static int __init list_sort_test(void)
 	struct list_head *cur, *tmp;
 	LIST_HEAD(head);
 
-	printk(KERN_DEBUG "list_sort_test: start testing list_sort()\n");
+	pr_debug("%s: start testing list_sort()\n", __func__);
 
-	elts = kmalloc(sizeof(void *) * TEST_LIST_LEN, GFP_KERNEL);
-	if (!elts) {
-		printk(KERN_ERR "list_sort_test: error: cannot allocate "
-				"memory\n");
+	elts = kmalloc_array(TEST_LIST_LEN, sizeof(void *), GFP_KERNEL);
+	if (!elts)
 		goto exit;
-	}
 
 	for (i = 0; i < TEST_LIST_LEN; i++) {
 		el = kmalloc(sizeof(*el), GFP_KERNEL);
-		if (!el) {
-			printk(KERN_ERR "list_sort_test: error: cannot "
-					"allocate memory\n");
+		if (!el)
 			goto exit;
-		}
+
 		 /* force some equivalencies */
 		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
 		el->serial = i;
@@ -244,37 +245,33 @@ static int __init list_sort_test(void)
 		int cmp_result;
 
 		if (cur->next->prev != cur) {
-			printk(KERN_ERR "list_sort_test: error: list is "
-					"corrupted\n");
+			pr_err("%s: error: list is corrupted\n", __func__);
 			goto exit;
 		}
 
 		cmp_result = cmp(NULL, cur, cur->next);
 		if (cmp_result > 0) {
-			printk(KERN_ERR "list_sort_test: error: list is not "
-					"sorted\n");
+			pr_err("%s: error: list is not sorted\n", __func__);
 			goto exit;
 		}
 
 		el = container_of(cur, struct debug_el, list);
 		el1 = container_of(cur->next, struct debug_el, list);
 		if (cmp_result == 0 && el->serial >= el1->serial) {
-			printk(KERN_ERR "list_sort_test: error: order of "
-					"equivalent elements not preserved\n");
+			pr_err("%s: error: order of equivalent elements not preserved\n",
+			       __func__);
 			goto exit;
 		}
 
-		if (check(el, el1)) {
-			printk(KERN_ERR "list_sort_test: error: element check "
-					"failed\n");
+		if (check(el, el1, __func__)) {
+			pr_err("%s: error: element check failed\n", __func__);
 			goto exit;
 		}
 		count++;
 	}
 
 	if (count != TEST_LIST_LEN) {
-		printk(KERN_ERR "list_sort_test: error: bad list length %d",
-				count);
+		pr_err("%s: error: bad list length %d\n", __func__, count);
 		goto exit;
 	}
 


