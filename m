Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab3GRVZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:25:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43856 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723Ab3GRVZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:25:51 -0400
Message-ID: <51E85D55.9000501@kernel.dk>
Date: Thu, 18 Jul 2013 15:25:41 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH RFC] lib: Make radix_tree_node_alloc() irq safe
References: <1373994390-5479-1-git-send-email-jack@suse.cz> <20130717161200.40a97074623be2685beb8156@linux-foundation.org>
In-Reply-To: <20130717161200.40a97074623be2685beb8156@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 05:12 PM, Andrew Morton wrote:
> On Tue, 16 Jul 2013 19:06:30 +0200 Jan Kara <jack@suse.cz> wrote:
> 
>> With users of radix_tree_preload() run from interrupt (CFQ is one such
>> possible user), the following race can happen:
>>
>> radix_tree_preload()
>> ...
>> radix_tree_insert()
>>   radix_tree_node_alloc()
>>     if (rtp->nr) {
>>       ret = rtp->nodes[rtp->nr - 1];
>> <interrupt>
>> ...
>> radix_tree_preload()
>> ...
>> radix_tree_insert()
>>   radix_tree_node_alloc()
>>     if (rtp->nr) {
>>       ret = rtp->nodes[rtp->nr - 1];
>>
>> And we give out one radix tree node twice. That clearly results in radix
>> tree corruption with different results (usually OOPS) depending on which
>> two users of radix tree race.
>>
>> Fix the problem by disabling interrupts when working with rtp variable.
>> In-interrupt user can still deplete our preloaded nodes but at least we
>> won't corrupt radix trees.
>>
>> ...
>>
>>   There are some questions regarding this patch:
>> Do we really want to allow in-interrupt users of radix_tree_preload()?  CFQ
>> could certainly do this in older kernels but that particular call site where I
>> saw the bug hit isn't there anymore so I'm not sure this can really happen with
>> recent kernels.
> 
> Well, it was never anticipated that interrupt-time code would run
> radix_tree_preload().  The whole point in the preloading was to be able
> to perform GFP_KERNEL allocations before entering the spinlocked region
> which needs to allocate memory.
> 
> Doing all that from within an interrupt is daft, because the interrupt code
> can't use GFP_KERNEL anyway.
> 
>> Also it is actually harmful to do preloading if you are in interrupt context
>> anyway. The disadvantage of disallowing radix_tree_preload() in interrupt is
>> that we would need to tweak radix_tree_node_alloc() to somehow recognize
>> whether the caller wants it to use preloaded nodes or not and that callers
>> would have to get it right (although maybe some magic in radix_tree_preload()
>> could handle that).
>>
>> Opinions?
> 
> BUG_ON(in_interrupt()) :)

Good point Andrew, it'd be better to "document" the restriction (since
the use is non-sensical). It's actually not CFQ code that does this,
it's the io context management.

Excuse the crappy mailer, but something ala:

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 9c4bb82..bcb9b17 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -366,7 +366,7 @@ struct io_cq *ioc_create_icq(struct io_context *ioc,
struct
        if (!icq)
                return NULL;

-       if (radix_tree_preload(gfp_mask) < 0) {
+       if ((gfp_mask & __GFP_WAIT) && radix_tree_preload(gfp_mask) < 0) {
                kmem_cache_free(et->icq_cache, icq);
                return NULL;
        }
@@ -394,7 +394,10 @@ struct io_cq *ioc_create_icq(struct io_context
*ioc, struct

        spin_unlock(&ioc->lock);
        spin_unlock_irq(q->queue_lock);
-       radix_tree_preload_end();
+
+       if (gfp_mask & __GFP_WAIT)
+               radix_tree_preload_end();
+
        return icq;
 }



-- 
Jens Axboe

