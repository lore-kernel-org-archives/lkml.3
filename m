Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3I0Uik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:38:40 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36059 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab3I0Uij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:38:39 -0400
Message-ID: <5245ECC3.8070200@gmail.com>
Date: Fri, 27 Sep 2013 13:38:27 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>
CC: "Bird, Tim" <Tim.Bird@sonymobile.com>,
        =?ISO-8859-1?Q?=22Andersson=2C?= =?ISO-8859-1?Q?_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Bobniev <roman.bobniev@sonymobile.com>

When kmemleak checking is enabled and CONFIG_SLUB_DEBUG is
disabled, the kmemleak code for small block allocation is
disabled.  This results in false kmemleak errors when memory
is freed.

Move the kmemleak code for small block allocation out from
under CONFIG_SLUB_DEBUG.

Signed-off-by: Roman Bobniev <roman.bobniev@sonymobile.com>
Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 mm/slub.c |    6 	3 +	3 -	0 !
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/mm/slub.c
===================================================================
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -947,13 +947,10 @@ static inline void slab_post_alloc_hook(
 {
 	flags &= gfp_allowed_mask;
 	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
-	kmemleak_free_recursive(x, s->flags);
-
 	/*
 	 * Trouble is that we may no longer disable interupts in the fast path
 	 * So in order to make the debug calls that expect irqs to be
@@ -2418,6 +2415,8 @@ redo:
 		memset(object, 0, s->object_size);
 
 	slab_post_alloc_hook(s, gfpflags, object);
+	kmemleak_alloc_recursive(object, s->objsize, 1, s->flags,
+				 gfpflags & gfp_allowed_mask);
 
 	return object;
 }
@@ -2614,6 +2613,7 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
+	kmemleak_free_recursive(x, s->flags);
 	slab_free_hook(s, x);
 
 redo:
