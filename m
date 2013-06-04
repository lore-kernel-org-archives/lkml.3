Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3FDWVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:21:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62342 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FDWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <0000013f0b7b993c-35844ed2-81be-4146-ab3c-6c803006576b-000000@email.amazonses.com>
References: <1364010673.6345.156.camel@gandalf.local.home>
	<1364227073.6345.182.camel@gandalf.local.home>
	<1364228039.6345.183.camel@gandalf.local.home>
	<0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com>
	<1364234613.6345.184.camel@gandalf.local.home>
	<0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
	<1364236355.6345.185.camel@gandalf.local.home>
	<20130327025957.GA17125@lge.com>
	<1364355032.6345.200.camel@gandalf.local.home>
	<20130327061351.GB17125@lge.com>
	<alpine.DEB.2.02.1303281227520.16200@gentwo.org>
	<0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
	<1369751967.15552.12.camel@gandalf.local.home>
	<alpine.DEB.2.02.1305281121420.1627@gentwo.org>
	<0000013eec62261a-77052f34-f1cb-41b2-ae90-7575a2d0472c-000000@email.amazonses.com>
	<CAAmzW4M8rX9WGo_FYeyBQ8=Ht-mRnQz1TGhLfbFuKhm3r8grGA@mail.gmail.com>
	<0000013f0b7b993c-35844ed2-81be-4146-ab3c-6c803006576b-000000@email.amazonses.com>
Date: Wed, 5 Jun 2013 07:21:14 +0900
Message-ID: <CAAmzW4MakOx_SA6eA=BYP4rq76np4yOS6RANpNObQP6dDDqYQg@mail.gmail.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/4 Christoph Lameter <cl@linux.com>:
> On Tue, 4 Jun 2013, JoonSoo Kim wrote:
>
>> And I re-read Steven initial problem report in RT kernel and find that
>> unfreeze_partial() do lock and unlock several times. This means that
>> each page in cpu partial list doesn't come from same node. Why do we
>> add other node's slab to this cpu partial list? This is also not good
>> for general case. How about considering node affinity in __slab_free()?
>> IMHO, if we implement this, Steven's problem can be solved.
>
> We may need the other nodes pages if we consistently allocate from there.
> __slab_alloc() ensures that only pages from the correct node are used. It
> will drop pages that do not come from the proper nodes.
>
> Filtering in __slab_free would mean that we cannot improve performance on
> remote frees.
>

Sorry for poor explanation.
I knew that we need the other nodes pages if we consistently allocate
from there.
In allocation path, it is reasonable.
But, in free path, it is not reasonable that we put other nodes' page
to cpu partial list.
In this case, we don't need other nodes pages, because there is
no allocation request for other nodes. Putting other node's page to
cpu partial list and
using this other node's page for normal allocation request(it doesn't
specify node affinity)
makes system performance degradation. Below is quick implementation of
this idea.

---------------------->8-------------------
diff --git a/mm/slub.c b/mm/slub.c
index 57707f0..7f614f4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2495,7 +2495,8 @@ static void __slab_free(struct kmem_cache *s,
struct page *page,
                new.inuse--;
                if ((!new.inuse || !prior) && !was_frozen) {

-                       if (!kmem_cache_debug(s) && !prior)
+                       if (!kmem_cache_debug(s) && !prior &&
+                               node_match(page,
cpu_to_node(smp_processor_id())))

                                /*
                                 * Slab was on no list before and will
be partially empty
@@ -2550,8 +2551,9 @@ static void __slab_free(struct kmem_cache *s,
struct page *page,
         * Objects left in the slab. If it was not on the partial list before
         * then add it.
         */
-       if (kmem_cache_debug(s) && unlikely(!prior)) {
-               remove_full(s, page);
+       if (!prior) {
+               if (kmem_cache_debug(s))
+                       remove_full(s, page);
                add_partial(n, page, DEACTIVATE_TO_TAIL);
                stat(s, FREE_ADD_PARTIAL);
        }
