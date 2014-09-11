Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaIKVvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbaIKVvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:51:03 -0400
Date: Thu, 11 Sep 2014 17:50:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@iki.fi>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix for_each_kmem_cache_node
In-Reply-To: <20140911143357.43ece13ce88eec413c3004b1@linux-foundation.org>
Message-ID: <alpine.LRH.2.02.1409111746320.14676@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409051155001.5269@file01.intranet.prod.int.rdu2.redhat.com> <540AD4B4.3010403@iki.fi> <alpine.DEB.2.11.1409080916230.20388@gentwo.org> <20140911143357.43ece13ce88eec413c3004b1@linux-foundation.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Sep 2014, Andrew Morton wrote:

> On Mon, 8 Sep 2014 09:16:34 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:
> 
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>
> 
> I suspect the original patch got eaten by the linux-foundation.org DNS
> outage, and whoever started this thread didn't cc any mailing lists. 
> So I have no patch and no way of finding it.
> 
> Full resend with appropriate cc's please, after adding all the
> acked-bys and reviewed-bys.

This patch fixes a bug (discovered with kmemcheck) in
for_each_kmem_cache_node. The for loop reads the array "node" before
verifying that the index is within the range. This results in kmemcheck
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>

---
 mm/slab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slab.h
===================================================================
--- linux-2.6.orig/mm/slab.h	2014-09-04 23:04:31.000000000 +0200
+++ linux-2.6/mm/slab.h	2014-09-04 23:23:37.000000000 +0200
@@ -303,8 +303,8 @@ static inline struct kmem_cache_node *ge
  * a kmem_cache_node structure allocated (which is true for all online nodes)
  */
 #define for_each_kmem_cache_node(__s, __node, __n) \
-	for (__node = 0; __n = get_node(__s, __node), __node < nr_node_ids; __node++) \
-		 if (__n)
+	for (__node = 0; __node < nr_node_ids; __node++) \
+		 if ((__n = get_node(__s, __node)))
 
 #endif
 
