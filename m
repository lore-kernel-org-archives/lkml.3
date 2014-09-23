Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaIWVnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:43:23 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64203 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIWVnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:43:22 -0400
Date: Tue, 23 Sep 2014 14:43:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, a.elovikov@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, slab: initialize object alignment on cache creation
In-Reply-To: <20140923141940.e2d3840f31d0f8850b925cf6@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1409231439190.22630@chino.kir.corp.google.com>
References: <20140923141940.e2d3840f31d0f8850b925cf6@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 4590685546a3 ("mm/sl[aou]b: Common alignment code"), the "ralign" 
automatic variable in __kmem_cache_create() may be used as uninitialized.

The proper alignment defaults to BYTES_PER_WORD and can be overridden by 
SLAB_RED_ZONE or the alignment specified by the caller.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=85031

Reported-by: Andrei Elovikov <a.elovikov@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 a.elovikov: If you respond to this email with your full name, Andrew can 
 give proper credit for reporting this issue.

 mm/slab.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2128,7 +2128,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 int
 __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 {
-	size_t left_over, freelist_size, ralign;
+	size_t left_over, freelist_size;
+	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
 	int err;
 	size_t size = cachep->size;
@@ -2161,14 +2162,6 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 		size &= ~(BYTES_PER_WORD - 1);
 	}
 
-	/*
-	 * Redzoning and user store require word alignment or possibly larger.
-	 * Note this will be overridden by architecture or caller mandated
-	 * alignment if either is greater than BYTES_PER_WORD.
-	 */
-	if (flags & SLAB_STORE_USER)
-		ralign = BYTES_PER_WORD;
-
 	if (flags & SLAB_RED_ZONE) {
 		ralign = REDZONE_ALIGN;
 		/* If redzoning, ensure that the second redzone is suitably
