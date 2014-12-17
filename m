Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaLQHNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:13:51 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53173 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQHNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:13:50 -0500
MIME-Version: 1.0
In-Reply-To: <20141215075933.GD4898@js1304-P5Q-DELUXE>
References: <20141210163017.092096069@linux.com>
	<20141215075933.GD4898@js1304-P5Q-DELUXE>
Date: Wed, 17 Dec 2014 16:13:49 +0900
Message-ID: <CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
From: Joonsoo Kim <js1304@gmail.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-15 16:59 GMT+09:00 Joonsoo Kim <iamjoonsoo.kim@lge.com>:
> On Wed, Dec 10, 2014 at 10:30:17AM -0600, Christoph Lameter wrote:
>> We had to insert a preempt enable/disable in the fastpath a while ago. This
>> was mainly due to a lot of state that is kept to be allocating from the per
>> cpu freelist. In particular the page field is not covered by
>> this_cpu_cmpxchg used in the fastpath to do the necessary atomic state
>> change for fast path allocation and freeing.
>>
>> This patch removes the need for the page field to describe the state of the
>> per cpu list. The freelist pointer can be used to determine the page struct
>> address if necessary.
>>
>> However, currently this does not work for the termination value of a list
>> which is NULL and the same for all slab pages. If we use a valid pointer
>> into the page as well as set the last bit then all freelist pointers can
>> always be used to determine the address of the page struct and we will not
>> need the page field anymore in the per cpu are for a slab. Testing for the
>> end of the list is a test if the first bit is set.
>>
>> So the first patch changes the termination pointer for freelists to do just
>> that. The second removes the page field and then third can then remove the
>> preempt enable/disable.
>>
>> Removing the ->page field reduces the cache footprint of the fastpath so hopefully overall
>> allocator effectiveness will increase further. Also RT uses full preemption which means
>> that currently pretty expensive code has to be inserted into the fastpath. This approach
>> allows the removal of that code and a corresponding performance increase.
>>
>> For V1 a number of changes were made to avoid the overhead of virt_to_page
>> and page_address from the RFC.
>>
>> Slab Benchmarks on a kernel with CONFIG_PREEMPT show an improvement of
>> 20%-50% of fastpath latency:
>>
>> Before:
>>
>> Single thread testing
>> 1. Kmalloc: Repeatedly allocate then free test
>> 10000 times kmalloc(8) -> 68 cycles kfree -> 107 cycles
>> 10000 times kmalloc(16) -> 69 cycles kfree -> 108 cycles
>> 10000 times kmalloc(32) -> 78 cycles kfree -> 112 cycles
>> 10000 times kmalloc(64) -> 97 cycles kfree -> 112 cycles
>> 10000 times kmalloc(128) -> 111 cycles kfree -> 119 cycles
>> 10000 times kmalloc(256) -> 114 cycles kfree -> 139 cycles
>> 10000 times kmalloc(512) -> 110 cycles kfree -> 142 cycles
>> 10000 times kmalloc(1024) -> 114 cycles kfree -> 156 cycles
>> 10000 times kmalloc(2048) -> 155 cycles kfree -> 174 cycles
>> 10000 times kmalloc(4096) -> 203 cycles kfree -> 209 cycles
>> 10000 times kmalloc(8192) -> 361 cycles kfree -> 265 cycles
>> 10000 times kmalloc(16384) -> 597 cycles kfree -> 286 cycles
>>
>> 2. Kmalloc: alloc/free test
>> 10000 times kmalloc(8)/kfree -> 114 cycles
>> 10000 times kmalloc(16)/kfree -> 115 cycles
>> 10000 times kmalloc(32)/kfree -> 117 cycles
>> 10000 times kmalloc(64)/kfree -> 115 cycles
>> 10000 times kmalloc(128)/kfree -> 111 cycles
>> 10000 times kmalloc(256)/kfree -> 116 cycles
>> 10000 times kmalloc(512)/kfree -> 110 cycles
>> 10000 times kmalloc(1024)/kfree -> 114 cycles
>> 10000 times kmalloc(2048)/kfree -> 110 cycles
>> 10000 times kmalloc(4096)/kfree -> 107 cycles
>> 10000 times kmalloc(8192)/kfree -> 108 cycles
>> 10000 times kmalloc(16384)/kfree -> 706 cycles
>>
>>
>> After:
>>
>>
>> Single thread testing
>> 1. Kmalloc: Repeatedly allocate then free test
>> 10000 times kmalloc(8) -> 41 cycles kfree -> 81 cycles
>> 10000 times kmalloc(16) -> 47 cycles kfree -> 88 cycles
>> 10000 times kmalloc(32) -> 48 cycles kfree -> 93 cycles
>> 10000 times kmalloc(64) -> 58 cycles kfree -> 89 cycles
>> 10000 times kmalloc(128) -> 84 cycles kfree -> 104 cycles
>> 10000 times kmalloc(256) -> 92 cycles kfree -> 125 cycles
>> 10000 times kmalloc(512) -> 86 cycles kfree -> 129 cycles
>> 10000 times kmalloc(1024) -> 88 cycles kfree -> 125 cycles
>> 10000 times kmalloc(2048) -> 120 cycles kfree -> 159 cycles
>> 10000 times kmalloc(4096) -> 176 cycles kfree -> 183 cycles
>> 10000 times kmalloc(8192) -> 294 cycles kfree -> 233 cycles
>> 10000 times kmalloc(16384) -> 585 cycles kfree -> 291 cycles
>>
>> 2. Kmalloc: alloc/free test
>> 10000 times kmalloc(8)/kfree -> 100 cycles
>> 10000 times kmalloc(16)/kfree -> 108 cycles
>> 10000 times kmalloc(32)/kfree -> 101 cycles
>> 10000 times kmalloc(64)/kfree -> 109 cycles
>> 10000 times kmalloc(128)/kfree -> 125 cycles
>> 10000 times kmalloc(256)/kfree -> 60 cycles
>> 10000 times kmalloc(512)/kfree -> 60 cycles
>> 10000 times kmalloc(1024)/kfree -> 67 cycles
>> 10000 times kmalloc(2048)/kfree -> 60 cycles
>> 10000 times kmalloc(4096)/kfree -> 65 cycles
>> 10000 times kmalloc(8192)/kfree -> 60 cycles
>
> Hello, Christoph.
>
> I don't review in detail, but, at a glance, overall patchset looks good.
> But, above result looks odd. Improvement is beyond what we can expect.
> Do you have any idea why allocating object more than 256 bytes is so
> fast?

Ping... and I found another way to remove preempt_disable/enable
without complex changes.

What we want to ensure is getting tid and kmem_cache_cpu
on the same cpu. We can achieve that goal with below condition loop.

I ran Jesper's benchmark and saw 3~5% win in a fast-path loop over
kmem_cache_alloc+free in CONFIG_PREEMPT.

14.5 ns -> 13.8 ns

See following patch.

Thanks.

----------->8-------------
diff --git a/mm/slub.c b/mm/slub.c
index 95d2142..e537af5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2399,8 +2399,10 @@ redo:
         * on a different processor between the determination of the pointer
         * and the retrieval of the tid.
         */
-       preempt_disable();
-       c = this_cpu_ptr(s->cpu_slab);
+       do {
+               tid = this_cpu_read(s->cpu_slab->tid);
+               c = this_cpu_ptr(s->cpu_slab);
+       } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));

        /*
         * The transaction ids are globally unique per cpu and per operation on
@@ -2408,8 +2410,6 @@ redo:
         * occurs on the right processor and that there was no operation on the
         * linked list in between.
         */
-       tid = c->tid;
-       preempt_enable();

        object = c->freelist;
        page = c->page;
@@ -2655,11 +2655,10 @@ redo:
         * data is retrieved via this pointer. If we are on the same cpu
         * during the cmpxchg then the free will succedd.
         */
-       preempt_disable();
-       c = this_cpu_ptr(s->cpu_slab);
-
-       tid = c->tid;
-       preempt_enable();
+       do {
+               tid = this_cpu_read(s->cpu_slab->tid);
+               c = this_cpu_ptr(s->cpu_slab);
+       } while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));

        if (likely(page == c->page)) {
                set_freepointer(s, object, c->freelist);
