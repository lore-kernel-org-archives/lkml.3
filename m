Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEUCzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:55:49 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40733 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaEUCzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:55:47 -0400
Message-ID: <537C15B1.3020006@gmail.com>
Date: Tue, 20 May 2014 19:55:45 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org> <1399993115-21552-3-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1399993115-21552-3-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 7:58 AM, Grant Likely wrote:

> Make of_find_node_by_path() handle aliases as prefixes. To make this

> work the name search is refactored to search by path component instead

> of by full string. This should be a more efficient search, and it makes

> it possible to start a search at a subnode of a tree.

> 

> Signed-off-by: David Daney <david.daney@cavium.com>

> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

> [grant.likely: Rework to not require allocating at runtime]

> Acked-by: Rob Herring <robh@kernel.org>

> Signed-off-by: Grant Likely <grant.likely@linaro.org>

> ---

>  drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----

>  1 file changed, 56 insertions(+), 4 deletions(-)



Was this patch created against a tree that has modifications to device tree

locking?
  I get a hang due to deadlock when I apply it.  Patch to verify the
cause is below.




From: Frank Rowand <frank.rowand@sonymobile.com>

Do not apply this patch -- it is not a valid fix.  The point of this patch
is to confirm the cause of a bug.

Problem seen on 3.15-rc1 with dragonboard platform patches added.

The dragonboard hangs on boot the very first time that of_find_node_by_path()
is called:

   of_find_node_by_path()
      raw_spin_lock_irqsave(&devtree_lock, flags)
      np = __of_find_node_by_path(np, path)
         for_each_child_of_node(parent, child) {

            // This is a define:
	    #define for_each_child_of_node(parent, child) \
	       for (child = of_get_next_child(parent, NULL); child != NULL; \

	          // Resulting in a deadlock when of_get_next_child()
		  // attempts to lock the same lock:
	          raw_spin_lock_irqsave(&devtree_lock, flags)

When this patch is applied, the first lock is commented out so the
deadlock does not occur and the boot completes.

Not-signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 drivers/of/base.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/of/base.c
===================================================================
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -835,13 +835,17 @@ struct device_node *of_find_node_by_path
 	}
 
 	/* Step down the tree matching path components */
+#if 0
 	raw_spin_lock_irqsave(&devtree_lock, flags);
+#endif
 	while (np && *path == '/') {
 		path++; /* Increment past '/' delimiter */
 		np = __of_find_node_by_path(np, path);
 		path = strchrnul(path, '/');
 	}
+#if 0
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+#endif
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_path);
