Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab3GRVai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:30:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43900 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab3GRVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:30:37 -0400
Message-ID: <51E85E73.608@kernel.dk>
Date: Thu, 18 Jul 2013 15:30:27 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH RFC] lib: Make radix_tree_node_alloc() irq safe
References: <1373994390-5479-1-git-send-email-jack@suse.cz> <20130717161200.40a97074623be2685beb8156@linux-foundation.org> <20130718130932.GA10419@quack.suse.cz>
In-Reply-To: <20130718130932.GA10419@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 07:09 AM, Jan Kara wrote:
> On Wed 17-07-13 16:12:00, Andrew Morton wrote:
>> On Tue, 16 Jul 2013 19:06:30 +0200 Jan Kara <jack@suse.cz> wrote:
>>
>>> With users of radix_tree_preload() run from interrupt (CFQ is one such
>>> possible user), the following race can happen:
>>>
>>> radix_tree_preload()
>>> ...
>>> radix_tree_insert()
>>>   radix_tree_node_alloc()
>>>     if (rtp->nr) {
>>>       ret = rtp->nodes[rtp->nr - 1];
>>> <interrupt>
>>> ...
>>> radix_tree_preload()
>>> ...
>>> radix_tree_insert()
>>>   radix_tree_node_alloc()
>>>     if (rtp->nr) {
>>>       ret = rtp->nodes[rtp->nr - 1];
>>>
>>> And we give out one radix tree node twice. That clearly results in radix
>>> tree corruption with different results (usually OOPS) depending on which
>>> two users of radix tree race.
>>>
>>> Fix the problem by disabling interrupts when working with rtp variable.
>>> In-interrupt user can still deplete our preloaded nodes but at least we
>>> won't corrupt radix trees.
>>>
>>> ...
>>>
>>>   There are some questions regarding this patch:
>>> Do we really want to allow in-interrupt users of radix_tree_preload()?  CFQ
>>> could certainly do this in older kernels but that particular call site where I
>>> saw the bug hit isn't there anymore so I'm not sure this can really happen with
>>> recent kernels.
>>
>> Well, it was never anticipated that interrupt-time code would run
>> radix_tree_preload().  The whole point in the preloading was to be able
>> to perform GFP_KERNEL allocations before entering the spinlocked region
>> which needs to allocate memory.
>>
>> Doing all that from within an interrupt is daft, because the interrupt code
>> can't use GFP_KERNEL anyway.
>   Fully agreed here.
> 
>>> Also it is actually harmful to do preloading if you are in interrupt context
>>> anyway. The disadvantage of disallowing radix_tree_preload() in interrupt is
>>> that we would need to tweak radix_tree_node_alloc() to somehow recognize
>>> whether the caller wants it to use preloaded nodes or not and that callers
>>> would have to get it right (although maybe some magic in radix_tree_preload()
>>> could handle that).
>>>
>>> Opinions?
>>
>> BUG_ON(in_interrupt()) :)
>   Or maybe WARN_ON()... But it's not so easy :) Currently radix tree code
> assumes that if gfp_mask doesn't have __GFP_WAIT set caller has performed
> radix_tree_preload(). Clearly this will stop working for in-interrupt users
> of radix tree. So how do we propagate the information from the caller of
> radix_tree_insert() down to radix_tree_node_alloc() whether the preload has
> been performed or not? Will we rely on in_interrupt() or use some special
> gfp_mask bit?

Should have read the full thread... in_interrupt() is ugly to base
decisions on, imho. I'd say just use __GFP_WAIT to signal this.

> Secondly, CFQ has this unpleasant property that some functions are
> sometimes called from interrupt context and sometimes not. So these
> functions would have to check in what context they are called and either
> perform preload or not. That's doable but it's going to be a bit ugly and
> has to match the check in radix_tree_node_alloc() whether preload should be
> used or not. So leaving the checking to the users of radix tree looks
> fragile.  So maybe we could just silently exit from radix_tree_preload()
> when we are in_interrupt()?

Which CFQ functions are these? Generally we get callbacks from the
drivers on both queue and complete times that can be done at various
contexts, so it's not something that is easily solvable. I'm assuming
you are referring to the blk-ioc.c functions here, though?

-- 
Jens Axboe

