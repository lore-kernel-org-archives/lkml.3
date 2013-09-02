Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3IBIjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:39:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56048 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3IBIiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:38:17 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-b4-52244e75a589
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/4] slab: make more slab management structure off the slab
Date: Mon,  2 Sep 2013 17:38:58 +0900
Message-Id: <1378111138-30340-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <CAAmzW4N1GXbr18Ws9QDKg7ChN5RVcOW9eEv2RxWhaEoHtw=ctw@mail.gmail.com>
 <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, the size of the freelist for the slab management diminish,
so that the on-slab management structure can waste large space
if the object of the slab is large.

Consider a 128 byte sized slab. If on-slab is used, 31 objects can be
in the slab. The size of the freelist for this case would be 31 bytes
so that 97 bytes, that is, more than 75% of object size, are wasted.

In a 64 byte sized slab case, no space is wasted if we use on-slab.
So set off-slab determining constraint to 128 bytes.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index bd366e5..d01a2f0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2277,7 +2277,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 	 * it too early on. Always use on-slab management when
 	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
 	 */
-	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
+	if ((size >= (PAGE_SIZE >> 5)) && !slab_early_init &&
 	    !(flags & SLAB_NOLEAKTRACE))
 		/*
 		 * Size is large, assume best to place the slab management obj
-- 
1.7.9.5

