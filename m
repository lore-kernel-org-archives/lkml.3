Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaJCXHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:07:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbaJCWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Andrei Elovikov <a.elovikov@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 186/238] mm, slab: initialize object alignment on cache creation
Date: Fri,  3 Oct 2014 14:31:41 -0700
Message-Id: <20141003212919.616711212@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit d4a5fca592b9ab52b90bb261a90af3c8f53be011 upstream.

Since commit 4590685546a3 ("mm/sl[aou]b: Common alignment code"), the
"ralign" automatic variable in __kmem_cache_create() may be used as
uninitialized.

The proper alignment defaults to BYTES_PER_WORD and can be overridden by
SLAB_RED_ZONE or the alignment specified by the caller.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=85031

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Andrei Elovikov <a.elovikov@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2189,7 +2189,8 @@ static int __init_refok setup_cpu_cache(
 int
 __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 {
-	size_t left_over, freelist_size, ralign;
+	size_t left_over, freelist_size;
+	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
 	int err;
 	size_t size = cachep->size;
@@ -2222,14 +2223,6 @@ __kmem_cache_create (struct kmem_cache *
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


