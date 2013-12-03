Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3LCP7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:59:16 -0500
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:59414 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647Ab3LCP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:59:15 -0500
X-Greylist: delayed 749 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 10:59:15 EST
Date: Tue, 3 Dec 2013 15:46:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Meelis Roos <mroos@linux.ee>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: Slab BUG with DEBUG_* options
In-Reply-To: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee>
Message-ID: <00000142b923d9de-2c71e0b6-7443-46c0-bbde-93a81b50ed37-000000@email.amazonses.com>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.03-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Nov 2013, Meelis Roos wrote:

On Sat, 30 Nov 2013, Meelis Roos wrote:

> I am debugging a reboot problem on Sun Ultra 5 (sparc64) with 512M RAM
> and turned on DEBUG_PAGEALLOC DEBUG_SLAB and DEBUG_SLAB_LEAK (and most
> other debug options) and got the following BUG and hang on startup. This
> happened originally with 3.11-rc2-00058 where my bisection of
> another problem lead, but I retested 3.12 to have the same BUG in the
> same place.

Hmmm. With CONFIG_DEBUG_PAGEALLOC *and* DEBUG_SLAB you would get a pretty
strange configuration with massive sizes of slabs.

> kernel BUG at mm/slab.c:2391!

Ok so this means that we are trying to create a cache with off slab
management during bootstrap which should not happen.

> __kmem_cache_create: starting, size=248, flags=8192
> __kmem_cache_create: now flags=76800
> __kmem_cache_create: aligned size to 248 because of redzoning
> __kmem_cache_create: pagealloc debug, setting size to 8192
> __kmem_cache_create: aligned size to 8192
> __kmem_cache_create: num=1, slab_size=64
> __kmem_cache_create: starting, size=96, flags=8192
> __kmem_cache_create: now flags=76800
> __kmem_cache_create: aligned size to 96 because of redzoning
> __kmem_cache_create: pagealloc debug, setting size to 8192
> __kmem_cache_create: aligned size to 8192
> __kmem_cache_create: num=1, slab_size=64
> __kmem_cache_create: starting, size=192, flags=8192
> __kmem_cache_create: now flags=76800
> __kmem_cache_create: aligned size to 192 because of redzoning
> __kmem_cache_create: pagealloc debug, setting size to 8192
> __kmem_cache_create: aligned size to 8192
> __kmem_cache_create: num=1, slab_size=64
> __kmem_cache_create: starting, size=32, flags=8192
> __kmem_cache_create: now flags=76800
> __kmem_cache_create: aligned size to 32 because of redzoning
> __kmem_cache_create: aligned size to 32
> __kmem_cache_create: num=226, slab_size=960
> __kmem_cache_create: starting, size=64, flags=8192
> __kmem_cache_create: now flags=76800
> __kmem_cache_create: aligned size to 64 because of redzoning
> __kmem_cache_create: pagealloc debug, setting size to 8192
> __kmem_cache_create: turning on CFLGS_OFF_SLAB, size=8192

We should not be switching on CFLGS_OFF_SLAB here because the
kmalloc array does not contain the necessary entries yet.

Does this fix it? We may need a more sophisticated fix from someone who
knows how handle CONFIG_DEBUG_PAGEALLOC.



Subject: slab: Do not use off slab metadata for CONFIG_DEBUG_PAGEALLOC

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c	2013-12-03 09:44:20.463144282 -0600
+++ linux/mm/slab.c	2013-12-03 09:45:09.321786608 -0600
@@ -2243,13 +2243,15 @@ __kmem_cache_create (struct kmem_cache *
 	 * it too early on. Always use on-slab management when
 	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
 	 */
+#ifndef CONFIG_DEBUG_PAGEALLOC
 	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
-	    !(flags & SLAB_NOLEAKTRACE))
+	    !(flags & SLAB_NOLEAKTRACE) )
 		/*
 		 * Size is large, assume best to place the slab management obj
 		 * off-slab (should allow better packing of objs).
 		 */
 		flags |= CFLGS_OFF_SLAB;
+#endif

 	size = ALIGN(size, cachep->align);

