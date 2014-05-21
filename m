Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaEUQJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:09:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50346 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaEUQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:09:40 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
To: frowand.list@gmail.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <537C15B1.3020006@gmail.com>
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org>
	<1399993115-21552-3-git-send-email-grant.likely@linaro.org>
	<537C15B1.3020006@gmail.com>
Date: Thu, 22 May 2014 01:09:31 +0900
Message-Id: <20140521160931.DD7F9C4198A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 19:55:45 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
> On 5/13/2014 7:58 AM, Grant Likely wrote:
> 
> > Make of_find_node_by_path() handle aliases as prefixes. To make this
> 
> > work the name search is refactored to search by path component instead
> 
> > of by full string. This should be a more efficient search, and it makes
> 
> > it possible to start a search at a subnode of a tree.
> 
> > 
> 
> > Signed-off-by: David Daney <david.daney@cavium.com>
> 
> > Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> 
> > [grant.likely: Rework to not require allocating at runtime]
> 
> > Acked-by: Rob Herring <robh@kernel.org>
> 
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> 
> > ---
> 
> >  drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----
> 
> >  1 file changed, 56 insertions(+), 4 deletions(-)
> 
> 
> 
> Was this patch created against a tree that has modifications to device tree
> 
> locking?
>   I get a hang due to deadlock when I apply it.  Patch to verify the
> cause is below.

Ummm... I may have forgotten to enable CONFIG_LOCKDEP when testing. Try
the following fix, and can you please pass me that brown paper bag.

g.

commit 35e9c5ae6c3d0b5eb91579f397d8e1ecb95ee711
Author: Grant Likely <grant.likely@linaro.org>
Date:   Thu May 22 01:04:17 2014 +0900

    dt: Create unlocked version of for_each_child_of_node()
    
    When iterating over nodes, sometimes it needs to be done when the DT
    lock is already held. This patch makes an unlocked version of the
    for_each_child_of_node() macro.
    
    Signed-off-by: Grant Likely <grant.likely@linaro.org>

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8900d378c07e..c05a143b6a70 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -695,6 +695,22 @@ struct device_node *of_get_next_parent(struct device_node *node)
 }
 EXPORT_SYMBOL(of_get_next_parent);
 
+#define __for_each_child_of_node(parent, child) \
+	for (child = __of_get_next_child(parent, NULL); child != NULL; \
+	     child = __of_get_next_child(parent, child))
+static struct device_node *__of_get_next_child(const struct device_node *node,
+						struct device_node *prev)
+{
+	struct device_node *next;
+
+	next = prev ? prev->sibling : node->child;
+	for (; next; next = next->sibling)
+		if (of_node_get(next))
+			break;
+	of_node_put(prev);
+	return next;
+}
+
 /**
  *	of_get_next_child - Iterate a node childs
  *	@node:	parent node
@@ -710,11 +726,7 @@ struct device_node *of_get_next_child(const struct device_node *node,
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	next = prev ? prev->sibling : node->child;
-	for (; next; next = next->sibling)
-		if (of_node_get(next))
-			break;
-	of_node_put(prev);
+	next = __of_get_next_child(node, prev);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return next;
 }
@@ -780,7 +792,7 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 	if (!len)
 		return parent;
 
-	for_each_child_of_node(parent, child) {
+	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
 		if (WARN(!name, "malformed device_node %s\n", child->full_name))
 			continue;

