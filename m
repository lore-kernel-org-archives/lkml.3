Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaEVDiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 23:38:20 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47172 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaEVDiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 23:38:18 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
To: frowand.list@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <537C137B.2000007@gmail.com>
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
	<1399993115-21552-3-git-send-email-grant.likely@linaro.org>
	<53757D25.1060005@gmail.com>
	<20140516105444.C1DB7C42277@trevor.secretlab.ca>
	<20140518092730.109AAC40B8A@trevor.secretlab.ca>
	<537C1252.3090900@gmail.com> <537C137B.2000007@gmail.com>
Date: Thu, 22 May 2014 12:13:06 +0900
Message-Id: <20140522031306.DD6B7C41847@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 19:46:19 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
> On 5/20/2014 7:41 PM, Frank Rowand wrote:
> < snip >
> > I will reply to this email with an additional patch that restores the
> > original behavior.
> < snip >
> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> If __of_find_node_by_path() returns parent when the remaining portion of the
> path is "/" then the behavior of of_find_node_by_path() has changed.
> 
> Previously, adding an extraneous "/" on the end of a path would result
> in of_find_node_by_path() not finding a match.
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
>  drivers/of/base.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/of/base.c
> ===================================================================
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -778,7 +778,7 @@ static struct device_node *__of_find_nod
>  	int len = strchrnul(path, '/') - path;
>  
>  	if (!len)
> -		return parent;
> +		return NULL;
>  
>  	for_each_child_of_node(parent, child) {
>  		const char *name = strrchr(child->full_name, '/');
> @@ -813,6 +813,17 @@ struct device_node *of_find_node_by_path
>  	struct property *pp;
>  	unsigned long flags;
>  
> +	if (strcmp(path, "/") == 0) {
> +		raw_spin_lock_irqsave(&devtree_lock, flags);
> +		for (; np; np = np->allnext) {
> +			if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
> +			    && of_node_get(np))
> +				break;
> +		}
> +		raw_spin_unlock_irqrestore(&devtree_lock, flags);
> +		return np;
> +	}
> +

Special case for the root node? Could use a comment, and of_allnodes
will already point to the root node so this could simply be:

	if (strcmp(path, "/") == 0)
		return of_node_get(np);

Here's a complete patch:

commit adc96db6c39ef7b895e75d30dbc69781f6443f1d
Author: Grant Likely <grant.likely@linaro.org>
Date:   Thu May 22 11:55:31 2014 +0900

    fix trailing '/' case

diff --git a/drivers/of/base.c b/drivers/of/base.c
index c05a143b6a70..45ac44c8dfea 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -790,7 +790,7 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 	int len = strchrnul(path, '/') - path;
 
 	if (!len)
-		return parent;
+		return NULL;
 
 	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
@@ -820,10 +820,13 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
  */
 struct device_node *of_find_node_by_path(const char *path)
 {
-	struct device_node *np = of_allnodes;
+	struct device_node *np = NULL;
 	struct property *pp;
 	unsigned long flags;
 
+	if (strcmp(path, "/") == 0)
+		return of_node_get(of_allnodes);
+
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		char *p = strchrnul(path, '/');
@@ -833,7 +836,6 @@ struct device_node *of_find_node_by_path(const char *path)
 		if (!of_aliases)
 			return NULL;
 
-		np = NULL;
 		for_each_property_of_node(of_aliases, pp) {
 			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
 				np = of_find_node_by_path(pp->value);
@@ -847,6 +849,8 @@ struct device_node *of_find_node_by_path(const char *path)
 
 	/* Step down the tree matching path components */
 	raw_spin_lock_irqsave(&devtree_lock, flags);
+	if (!np)
+		np = of_node_get(of_allnodes);
 	while (np && *path == '/') {
 		path++; /* Increment past '/' delimiter */
 		np = __of_find_node_by_path(np, path);
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index 10900b18fc06..aeb0b5c8b21d 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -42,9 +42,7 @@ static void __init of_selftest_find_node_by_name(void)
 
 	/* Test if trailing '/' works */
 	np = of_find_node_by_path("/testcase-data/");
-	selftest(np && !strcmp("/testcase-data", np->full_name),
-		"find /testcase-data/ failed\n");
-	of_node_put(np);
+	selftest(!np, "trailing '/' on /testcase-data/ should fail\n");
 
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
@@ -58,9 +56,7 @@ static void __init of_selftest_find_node_by_name(void)
 
 	/* Test if trailing '/' works on aliases */
 	np = of_find_node_by_path("testcase-alias/");
-	selftest(np && !strcmp("/testcase-data", np->full_name),
-		"find testcase-alias/ failed\n");
-	of_node_put(np);
+	selftest(!np, "trailing '/' on testcase-alias/ should fail\n");
 
 	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
 	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),

