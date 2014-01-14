Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaANRdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:33:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:4228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaANRdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:33:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="438737295"
Message-ID: <52D5746F.2040604@intel.com>
Date: Tue, 14 Jan 2014 09:31:27 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 0 PID: 0 at mm/slub.c:1511 __kmem_cache_create()
References: <20140114131915.GA26942@localhost>
In-Reply-To: <20140114131915.GA26942@localhost>
Content-Type: multipart/mixed;
 boundary="------------030204070704050609000201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030204070704050609000201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=c65c1877bd6826ce0d9713d76e30a7bed8e49f38

I think the assert is just bogus at least in the early case.
early_kmem_cache_node_alloc() says:
 * No kmalloc_node yet so do it by hand. We know that this is the first
 * slab on the node for this slabcache. There are no concurrent accesses
 * possible.

Should we do something like the attached patch?  (very lightly tested)

--------------030204070704050609000201
Content-Type: text/x-patch;
 name="slub-lockdep-workaround.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="slub-lockdep-workaround.patch"



---

 b/mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/slub.c~slub-lockdep-workaround mm/slub.c
--- a/mm/slub.c~slub-lockdep-workaround	2014-01-14 09:19:22.418942641 -0800
+++ b/mm/slub.c	2014-01-14 09:29:55.441297460 -0800
@@ -2890,7 +2890,13 @@ static void early_kmem_cache_node_alloc(
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
+	/*
+	 * the lock is for lockdep's sake, not for any actual
+	 * race protection
+	 */
+	spin_lock(&n->list_lock);
 	add_partial(n, page, DEACTIVATE_TO_HEAD);
+	spin_unlock(&n->list_lock);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
_

--------------030204070704050609000201--
