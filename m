Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbbAERVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:21:43 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37202 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbbAERVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:21:41 -0500
Date: Mon, 5 Jan 2015 18:21:39 +0100
From: Andreas Mohr <andi@lisas.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 6/6] mm/slab: allocation fastpath without disabling irq
Message-ID: <20150105172139.GA11201@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420421851-3281-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Joonsoo Kim wrote:
> + * Calculate the next globally unique transaction for disambiguiation

"disambiguation"


> +	ac->tid = next_tid(ac->tid);
(and all others)

object oriented:
array_cache_next_tid(ac);
(or perhaps rather: array_cache_start_transaction(ac);?).


> +	/*
> +	 * Because we disable irq just now, cpu can be changed
> +	 * and we are on different node with object node. In this rare
> +	 * case, just return pfmemalloc object for simplicity.
> +	 */

"are on a node which is different from object's node"




General thoughts (maybe just rambling, but that's just my feelings vs.
this mechanism, so maybe it's food for thought):
To me, the existing implementation seems too fond of IRQ fumbling
(i.e., affecting of oh so nicely *unrelated*
outer global environment context stuff).
A proper implementation wouldn't need *any* knowledge of this
(i.e., modifying such "IRQ disable" side effects,
to avoid having a scheduler hit and possibly ending up on another node).

Thus to me, the whole handling seems somewhat wrong and split
(since there remains the need to deal with scheduler distortion/disruption).
The bare-metal "inner" algorithm should not need to depend on such shenanigans
but simply be able to carry out its task unaffected,
where IRQs are simply always left enabled
(or at least potentially disabled by other kernel components only)
and the code then elegantly/inherently deals with IRQ complications.

Since the node change is scheduler-driven (I assume),
any (changes of) context attributes
which are relevant to (affect) SLAB-internal operations
ought to be implicitly/automatically re-assigned by the scheduler,
and then the most that should be needed is a *final* check in SLAB
(possibly in an outer user-facing layer of it)
whether the current final calculation result still matches expectations,
i.e. whether there was no disruption
(in which case we'd also do a goto redo: operation or some such :).

These thoughts also mean that I'm unsure (difficult to determine)
of whether this change is good (i.e. a clean step in the right direction),
or whether instead the implementation could easily directly be made
fully independent from IRQ constraints.

Thanks,

Andreas Mohr
