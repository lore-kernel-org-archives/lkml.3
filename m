Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaFJQLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:11:22 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50023 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaFJQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:11:21 -0400
Date: Tue, 10 Jun 2014 21:41:14 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH] i2o/memory.c : Use kstrdup
Message-ID: <20140610161113.GA3989@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
To send to: linux-kernel@vger.kernel.org
 drivers/message/i2o/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
index 292b41e..1741a59 100644
--- a/drivers/message/i2o/memory.c
+++ b/drivers/message/i2o/memory.c
@@ -270,10 +270,9 @@ EXPORT_SYMBOL_GPL(i2o_dma_realloc);
 int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
 				 size_t size, int min_nr)
 {
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto exit;
-	strcpy(pool->name, name);
 
 	pool->slab =
 	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);
-- 
1.9.1

