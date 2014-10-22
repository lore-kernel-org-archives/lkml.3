Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaJVABI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaJVABG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:01:06 -0400
Date: Tue, 21 Oct 2014 20:00:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm/slab_common: don't check for duplicate cache names
Message-ID: <alpine.LRH.2.02.1410211958030.19625@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SLUB cache merges caches with the same size and alignment and there
was long standing bug with this behavior:
* create the cache named "foo"
* create the cache named "bar" (which is merged with "foo")
* delete the cache named "foo" (but it stays allocated because "bar" uses
  it)
* create the cache named "foo" again - it fails because the name "foo" is
  already used

That bug was fixed in commit 694617474e33b8603fc76e090ed7d09376514b1a by
not warning on duplicate cache names when the SLUB subsystem is used.

Recently, cache merging was implemented the with SLAB subsystem too (patch
12220dea07f1ac6ac717707104773d771c3f3077), therefore we need stop checking
for duplicate names even for the SLAB subsystem. This patch fixes the bug
by removing the check.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 mm/slab_common.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux-2.6/mm/slab_common.c
===================================================================
--- linux-2.6.orig/mm/slab_common.c	2014-10-22 01:07:50.000000000 +0200
+++ linux-2.6/mm/slab_common.c	2014-10-22 01:08:02.000000000 +0200
@@ -93,16 +93,6 @@ static int kmem_cache_sanity_check(const
 			       s->object_size);
 			continue;
 		}
-
-#if !defined(CONFIG_SLUB)
-		if (!strcmp(s->name, name)) {
-			pr_err("%s (%s): Cache name already exists.\n",
-			       __func__, name);
-			dump_stack();
-			s = NULL;
-			return -EINVAL;
-		}
-#endif
 	}
 
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
