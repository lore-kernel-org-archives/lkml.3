Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbbAEIjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:39:22 -0500
Received: from mail113-250.mail.alibaba.com ([205.204.113.250]:48776 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752003AbbAEIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:39:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r46d02011;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=9;RT=9;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Joonsoo Kim'" <iamjoonsoo.kim@lge.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@linux.com>,
        "'Pekka Enberg'" <penberg@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "'Jesper Dangaard Brouer'" <brouer@redhat.com>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing preemption on/off
Date: Mon, 05 Jan 2015 16:37:35 +0800
Message-ID: <023701d028c2$dba2cb30$92e86190$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAowe66EZHWQLj1RhihqunnasgRqA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> We had to insert a preempt enable/disable in the fastpath a while ago
> in order to guarantee that tid and kmem_cache_cpu are retrieved on the
> same cpu. It is the problem only for CONFIG_PREEMPT in which scheduler
> can move the process to other cpu during retrieving data.
> 
> Now, I reach the solution to remove preempt enable/disable in the fastpath.
> If tid is matched with kmem_cache_cpu's tid after tid and kmem_cache_cpu
> are retrieved by separate this_cpu operation, it means that they are
> retrieved on the same cpu. If not matched, we just have to retry it.
> 
> With this guarantee, preemption enable/disable isn't need at all even if
> CONFIG_PREEMPT, so this patch removes it.
> 
> I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
> in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)
> 
> Below is the result of Christoph's slab_test reported by
> Jesper Dangaard Brouer.
> 
> * Before
> 
>  Single thread testing
>  =====================
>  1. Kmalloc: Repeatedly allocate then free test
>  10000 times kmalloc(8) -> 49 cycles kfree -> 62 cycles
>  10000 times kmalloc(16) -> 48 cycles kfree -> 64 cycles
>  10000 times kmalloc(32) -> 53 cycles kfree -> 70 cycles
>  10000 times kmalloc(64) -> 64 cycles kfree -> 77 cycles
>  10000 times kmalloc(128) -> 74 cycles kfree -> 84 cycles
>  10000 times kmalloc(256) -> 84 cycles kfree -> 114 cycles
>  10000 times kmalloc(512) -> 83 cycles kfree -> 116 cycles
>  10000 times kmalloc(1024) -> 81 cycles kfree -> 120 cycles
>  10000 times kmalloc(2048) -> 104 cycles kfree -> 136 cycles
>  10000 times kmalloc(4096) -> 142 cycles kfree -> 165 cycles
>  10000 times kmalloc(8192) -> 238 cycles kfree -> 226 cycles
>  10000 times kmalloc(16384) -> 403 cycles kfree -> 264 cycles
>  2. Kmalloc: alloc/free test
>  10000 times kmalloc(8)/kfree -> 68 cycles
>  10000 times kmalloc(16)/kfree -> 68 cycles
>  10000 times kmalloc(32)/kfree -> 69 cycles
>  10000 times kmalloc(64)/kfree -> 68 cycles
>  10000 times kmalloc(128)/kfree -> 68 cycles
>  10000 times kmalloc(256)/kfree -> 68 cycles
>  10000 times kmalloc(512)/kfree -> 74 cycles
>  10000 times kmalloc(1024)/kfree -> 75 cycles
>  10000 times kmalloc(2048)/kfree -> 74 cycles
>  10000 times kmalloc(4096)/kfree -> 74 cycles
>  10000 times kmalloc(8192)/kfree -> 75 cycles
>  10000 times kmalloc(16384)/kfree -> 510 cycles
> 
> * After
> 
>  Single thread testing
>  =====================
>  1. Kmalloc: Repeatedly allocate then free test
>  10000 times kmalloc(8) -> 46 cycles kfree -> 61 cycles
>  10000 times kmalloc(16) -> 46 cycles kfree -> 63 cycles
>  10000 times kmalloc(32) -> 49 cycles kfree -> 69 cycles
>  10000 times kmalloc(64) -> 57 cycles kfree -> 76 cycles
>  10000 times kmalloc(128) -> 66 cycles kfree -> 83 cycles
>  10000 times kmalloc(256) -> 84 cycles kfree -> 110 cycles
>  10000 times kmalloc(512) -> 77 cycles kfree -> 114 cycles
>  10000 times kmalloc(1024) -> 80 cycles kfree -> 116 cycles
>  10000 times kmalloc(2048) -> 102 cycles kfree -> 131 cycles
>  10000 times kmalloc(4096) -> 135 cycles kfree -> 163 cycles
>  10000 times kmalloc(8192) -> 238 cycles kfree -> 218 cycles
>  10000 times kmalloc(16384) -> 399 cycles kfree -> 262 cycles
>  2. Kmalloc: alloc/free test
>  10000 times kmalloc(8)/kfree -> 65 cycles
>  10000 times kmalloc(16)/kfree -> 66 cycles
>  10000 times kmalloc(32)/kfree -> 65 cycles
>  10000 times kmalloc(64)/kfree -> 66 cycles
>  10000 times kmalloc(128)/kfree -> 66 cycles
>  10000 times kmalloc(256)/kfree -> 71 cycles
>  10000 times kmalloc(512)/kfree -> 72 cycles
>  10000 times kmalloc(1024)/kfree -> 71 cycles
>  10000 times kmalloc(2048)/kfree -> 71 cycles
>  10000 times kmalloc(4096)/kfree -> 71 cycles
>  10000 times kmalloc(8192)/kfree -> 65 cycles
>  10000 times kmalloc(16384)/kfree -> 511 cycles
> 
> Most of the results are better than before.
> 
> Note that this change slightly worses performance in !CONFIG_PREEMPT,
> roughly 0.3%. Implementing each case separately would help performance,
> but, since it's so marginal, I didn't do that. This would help
> maintanance since we have same code for all cases.
> 
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/slub.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fe376fe..0624608 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2398,13 +2398,15 @@ redo:
>  	 * reading from one cpu area. That does not matter as long
>  	 * as we end up on the original cpu again when doing the cmpxchg.
>  	 *
> -	 * Preemption is disabled for the retrieval of the tid because that
> -	 * must occur from the current processor. We cannot allow rescheduling
> -	 * on a different processor between the determination of the pointer
> -	 * and the retrieval of the tid.
> +	 * We should guarantee that tid and kmem_cache are retrieved on
> +	 * the same cpu. It could be different if CONFIG_PREEMPT so we need
> +	 * to check if it is matched or not.
>  	 */
> -	preempt_disable();
> -	c = this_cpu_ptr(s->cpu_slab);
> +	do {
> +		tid = this_cpu_read(s->cpu_slab->tid);
> +		c = this_cpu_ptr(s->cpu_slab);
> +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> +	barrier();

Help maintenance more if barrier is documented in commit message.
> 
>  	/*
>  	 * The transaction ids are globally unique per cpu and per operation on
> @@ -2412,8 +2414,6 @@ redo:
>  	 * occurs on the right processor and that there was no operation on the
>  	 * linked list in between.
>  	 */
> -	tid = c->tid;
> -	preempt_enable();
> 
>  	object = c->freelist;
>  	page = c->page;
> @@ -2659,11 +2659,11 @@ redo:
>  	 * data is retrieved via this pointer. If we are on the same cpu
>  	 * during the cmpxchg then the free will succedd.
>  	 */
> -	preempt_disable();
> -	c = this_cpu_ptr(s->cpu_slab);
> -
> -	tid = c->tid;
> -	preempt_enable();
> +	do {
> +		tid = this_cpu_read(s->cpu_slab->tid);
> +		c = this_cpu_ptr(s->cpu_slab);
> +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> +	barrier();
> 
ditto
>  	if (likely(page == c->page)) {
>  		set_freepointer(s, object, c->freelist);
> --
> 1.7.9.5

