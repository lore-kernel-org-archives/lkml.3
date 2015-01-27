Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbbA0JVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:21:18 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:42599 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbA0JVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <20150127082301.GD28978@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
	<42d95683e3c7f4bb00be4d777e2b334e8981d552.1422275084.git.vdavydov@parallels.com>
	<20150127080009.GB11358@js1304-P5Q-DELUXE>
	<20150127082301.GD28978@esperanza>
Date: Tue, 27 Jan 2015 18:21:14 +0900
Message-ID: <CAAmzW4N+HVEO7_29QpzW9ezask4FZYVVUdm0eMKv4CdUwLWYxQ@mail.gmail.com>
Subject: Re: [PATCH -mm 3/3] slub: make dead caches discard free slabs immediately
From: Joonsoo Kim <js1304@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-27 17:23 GMT+09:00 Vladimir Davydov <vdavydov@parallels.com>:
> Hi Joonsoo,
>
> On Tue, Jan 27, 2015 at 05:00:09PM +0900, Joonsoo Kim wrote:
>> On Mon, Jan 26, 2015 at 03:55:29PM +0300, Vladimir Davydov wrote:
>> > @@ -3381,6 +3390,15 @@ void __kmem_cache_shrink(struct kmem_cache *s)
>> >             kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
>> >     unsigned long flags;
>> >
>> > +   if (deactivate) {
>> > +           /*
>> > +            * Disable empty slabs caching. Used to avoid pinning offline
>> > +            * memory cgroups by freeable kmem pages.
>> > +            */
>> > +           s->cpu_partial = 0;
>> > +           s->min_partial = 0;
>> > +   }
>> > +
>>
>> Maybe, kick_all_cpus_sync() is needed here since object would
>> be freed asynchronously so they can't see this updated value.
>
> I thought flush_all() should do the trick, no?

Unfortunately, it doesn't.

flush_all() sends IPI to not all cpus. It only sends IPI to cpus where
some conditions
are met and freeing could occur on the other ones.

Thanks.
