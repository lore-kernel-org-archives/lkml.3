Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbbAVQOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:14:54 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53879 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbAVQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:14:49 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Add missing of_node_put() in of_find_node_by_path()
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
In-Reply-To: <1421250356-16690-1-git-send-email-geert+renesas@glider.be>
References: <1421250356-16690-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 22 Jan 2015 16:14:46 +0000
Message-Id: <20150122161446.101EBC40A80@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 16:45:56 +0100
, Geert Uytterhoeven <geert+renesas@glider.be>
 wrote:
> When traversing all nodes and moving to a new path component, the old
> one must be released by calling of_node_put(). Else the refcounts of the
> parent node(s) will not be decremented.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Background.
> 
> While investigating a reference count imbalance issue with
> CONFIG_OF_DYNAMIC=y, I wrote the debug code below to validate the
> reference counts of the nodes I was interested in.
> During the first call of check_refcnts(), it gathers all reference
> counts. During a subsequent call, it verifies that they are still the
> same.
> 
> Surprisingly, lots of reference counts were wrong, and kept incrementing
> every time check_refcnts() was called.

Yup, reference counting is a mess. We definitely need tests to make sure
the core code does the right things with them.

> I was just wondering whether it would be useful to have a reference
> count test in OF_UNITTEST, but now I see the "select OF_DYNAMIC" will go
> away?

select OF_DYNAMIC is going away, but that only so that unittests work
with both OF_DYNAMIC and !OF_DYANMIC. Instead there will be some
unittests that are only run when OF_DYNAMIC is selected.

> 
> Feel free to (ab)use the code below and derive a unittest from it...
> 
> static struct to_check {
> 	const char *path;
> 	int refcnt;
> } to_check[] = {
> 	{ "/" },
> 	{ "/cpus/cpu@0" },
> 	{ "/cpus/cpu@1" },
> 	/* ... other paths I was interested in ... */
> };
> 
> static void check_refcnts(void)
> {
> 	static bool called;
> 	unsigned int i;
> 	const char *path;
> 	struct device_node *np;
> 	int refcnt;
> 	unsigned int errors = 0;
> 
> 	pr_info("----- %s reference counts -----\n",
> 		called ? "Checking" : "Saving");
> 	for (i = 0; i < ARRAY_SIZE(to_check); i++) {
> 		path = to_check[i].path;
> 		np = of_find_node_by_path(path);
> 		if (!np)
> 			continue;
> 
> 		refcnt = atomic_read(&np->kobj.kref.refcount);
> 		if (!called) {
> 			pr_info("%s %d\n", path, refcnt);
> 			to_check[i].refcnt = refcnt;
> 		} else if (refcnt == to_check[i].refcnt) {
> 			pr_info("%s %d (OK)\n", path, refcnt);
> 		} else {
> 			pr_info("%s %d (should be %d)\n", path, refcnt,
> 				to_check[i].refcnt);
> 			errors++;
> 		}
> 
> 		of_node_put(np);
> 	}
> 
> 	if (called)
> 		pr_info("----- Checking done (%u errors) -----\n", errors);
> 	else
> 		pr_info("----- Saving done -----\n");
> 
> 	called = true;
> }
> ---
>  drivers/of/base.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 36536b6a8834acd2..f3e346e19c69d1f2 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -791,8 +791,10 @@ struct device_node *of_find_node_opts_by_path(const char *path, const char **opt
>  	if (!np)
>  		np = of_node_get(of_root);
>  	while (np && *path == '/') {
> +		struct device_node *parent = np;
>  		path++; /* Increment past '/' delimiter */
> -		np = __of_find_node_by_path(np, path);
> +		np = __of_find_node_by_path(parent, path);
> +		of_node_put(parent);
>  		path = strchrnul(path, '/');
>  	}
>  	raw_spin_unlock_irqrestore(&devtree_lock, flags);

This doesn't look /quite/ the best. __for_each_child_of_node() is
fiddling with refcounts, but the '__' of functions shouldn't need to do
that since they are called under the spinlock (nothing is going to
change while they are called). __of_find_all_nodes() for instance
doesn't do refcounting, but of_find_all_nodes() does.

Does the following also solve the problem?

g.

---

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 36536b6a8834..0357b51a7440 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -626,9 +626,8 @@ static struct device_node *__of_get_next_child(const struct device_node *node,
 
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling)
-		if (of_node_get(next))
+		if (next)
 			break;
-	of_node_put(prev);
 	return next;
 }
 #define __for_each_child_of_node(parent, child) \
@@ -650,7 +649,8 @@ struct device_node *of_get_next_child(const struct device_node *node,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	next = __of_get_next_child(node, prev);
+	next = of_node_get(__of_get_next_child(node, prev));
+	of_node_put(prev);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return next;
 }
@@ -789,12 +789,13 @@ struct device_node *of_find_node_opts_by_path(const char *path, const char **opt
 	/* Step down the tree matching path components */
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	if (!np)
-		np = of_node_get(of_root);
+		np = of_root;
 	while (np && *path == '/') {
 		path++; /* Increment past '/' delimiter */
 		np = __of_find_node_by_path(np, path);
 		path = strchrnul(path, '/');
 	}
+	of_node_get(np);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }


