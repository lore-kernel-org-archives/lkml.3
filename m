Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3LDQCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:02:18 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48313 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3LDQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:02:17 -0500
MIME-Version: 1.0
In-Reply-To: <00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
	<1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
	<20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org>
	<20131204015218.GA19709@lge.com>
	<20131203180717.94c013d1.akpm@linux-foundation.org>
	<00000142be2f1de0-764bb035-adbc-4367-b2b4-bf05498510a6-000000@email.amazonses.com>
Date: Thu, 5 Dec 2013 01:02:15 +0900
Message-ID: <CAAmzW4PwLhMd61ksOktdg=rkj0xHsSGt2Wm_za2Adjh4+tss-g@mail.gmail.com>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the allocator
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        azurIt <azurit@pobox.sk>,
        Linux Memory Management List <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/5 Christoph Lameter <cl@linux.com>:
> On Tue, 3 Dec 2013, Andrew Morton wrote:
>
>> >     page = alloc_slab_page(alloc_gfp, node, oo);
>> >     if (unlikely(!page)) {
>> >             oo = s->min;
>>
>> What is the value of s->min?  Please tell me it's zero.
>
> It usually is.
>
>> > @@ -1349,7 +1350,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>> >             && !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>> >             int pages = 1 << oo_order(oo);
>> >
>> > -           kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
>> > +           kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
>>
>> That seems reasonable, assuming kmemcheck can handle the allocation
>> failure.
>>
>>
>> Still I dislike this practice of using unnecessarily large allocations.
>> What does it gain us?  Slightly improved object packing density.
>> Anything else?
>
> The fastpath for slub works only within the bounds of a single slab page.
> Therefore a larger frame increases the number of allocation possible from
> the fastpath without having to use the slowpath and also reduces the
> management overhead in the partial lists.

Hello Christoph.

Now we have cpu partial slabs facility, so I think that slowpath isn't really
slow. And it doesn't much increase the management overhead in the node
partial lists, because of cpu partial slabs.

And larger frame may cause more slab_lock contention or cmpxchg contention
if there are parallel freeings.

But, I don't know which one is better. Is larger frame still better? :)

Thanks.
