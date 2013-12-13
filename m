Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LMHAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:00:49 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48487 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3LMHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:00:48 -0500
X-AuditID: 9c930197-b7cefae000007949-08-52aab09e7557
Date: Fri, 13 Dec 2013 16:03:51 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] slab: make more slab management structure off the
 slab
Message-ID: <20131213070351.GD8845@lge.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
 <00000142b3d18433-eacdc401-434f-42e1-8988-686bd15a3e20-000000@email.amazonses.com>
 <20131203021308.GE31168@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203021308.GE31168@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:13:08AM +0900, Joonsoo Kim wrote:
> On Mon, Dec 02, 2013 at 02:58:41PM +0000, Christoph Lameter wrote:
> > On Mon, 2 Dec 2013, Joonsoo Kim wrote:
> > 
> > > Now, the size of the freelist for the slab management diminish,
> > > so that the on-slab management structure can waste large space
> > > if the object of the slab is large.
> > 
> > Hmmm.. That is confusing to me. "Since the size of the freelist has shrunk
> > significantly we have to adjust the heuristic for making the on/off slab
> > placement decision"?
> > 
> > Make this clearer.
> 
> Yes. your understanding is right.
> I will replace above line with yours.
> 
> Thanks.
> 
> > 
> > Acked-by: Christoph Lameter <cl@linux.com>

Hello, Pekka.

Below is updated patch for 5/5 in this series.
Now I get acks from Christoph to all patches in this series.
So, could you merge this patchset? :)
If you want to resend wholeset with proper ack, I will do it
with pleasure.

Thanks.

--------8<---------------
>From f6790b69b53c421645a4eaaeb45bd98e0a461136 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Thu, 29 Aug 2013 11:35:45 +0900
Subject: [PATCH] slab: make more slab management structure off the slab

Since the size of the freelist has shrunk significantly we have to
adjust the heuristic for making the on/off slab placement decision.

Consider a 128 byte sized slab. If on-slab is used, 31 objects can be
in the slab. The size of the freelist for this case would be 31 bytes
so that 97 bytes, that is, more than 75% of object size, are wasted.

In a 64 byte sized slab case, no space is wasted if we use on-slab.
So set off-slab determining constraint to 128 bytes.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 7fab788..1a7f19d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2264,7 +2264,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
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

