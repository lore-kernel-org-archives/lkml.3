Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbbAFBbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:31:24 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55909 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbAFBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:31:22 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 6 Jan 2015 10:31:22 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 6/6] mm/slab: allocation fastpath without disabling irq
Message-ID: <20150106013122.GB17222@js1304-P5Q-DELUXE>
References: <1420421851-3281-7-git-send-email-iamjoonsoo.kim@lge.com>
 <20150105172139.GA11201@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105172139.GA11201@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 05, 2015 at 06:21:39PM +0100, Andreas Mohr wrote:
> Hi,
> 
> Joonsoo Kim wrote:
> > + * Calculate the next globally unique transaction for disambiguiation
> 
> "disambiguation"

Okay.

> 
> > +	ac->tid = next_tid(ac->tid);
> (and all others)
> 
> object oriented:
> array_cache_next_tid(ac);
> (or perhaps rather: array_cache_start_transaction(ac);?).

Okay. Christoph request common transaction id management code. If
above object oriented design fit that, I will do it.
> 
> > +	/*
> > +	 * Because we disable irq just now, cpu can be changed
> > +	 * and we are on different node with object node. In this rare
> > +	 * case, just return pfmemalloc object for simplicity.
> > +	 */
> 
> "are on a node which is different from object's node"
> 

Thanks. :)

> 
> 
> General thoughts (maybe just rambling, but that's just my feelings vs.
> this mechanism, so maybe it's food for thought):
> To me, the existing implementation seems too fond of IRQ fumbling
> (i.e., affecting of oh so nicely *unrelated*
> outer global environment context stuff).
> A proper implementation wouldn't need *any* knowledge of this
> (i.e., modifying such "IRQ disable" side effects,
> to avoid having a scheduler hit and possibly ending up on another node).
> 
> Thus to me, the whole handling seems somewhat wrong and split
> (since there remains the need to deal with scheduler distortion/disruption).
> The bare-metal "inner" algorithm should not need to depend on such shenanigans
> but simply be able to carry out its task unaffected,
> where IRQs are simply always left enabled
> (or at least potentially disabled by other kernel components only)
> and the code then elegantly/inherently deals with IRQ complications.

I'm not sure I understand your opinion correctly. If my response is
wrong, please let me know your thought more correctly.

IRQ manipulation is done for synchronization of array cache, not for
freezing allocation context. That is just side-effect. As Christoph
said, slab operation could be executed in interrupt context so we
should protect array cache even if we are in process context.

> Since the node change is scheduler-driven (I assume),
> any (changes of) context attributes
> which are relevant to (affect) SLAB-internal operations
> ought to be implicitly/automatically re-assigned by the scheduler,
> and then the most that should be needed is a *final* check in SLAB
> (possibly in an outer user-facing layer of it)
> whether the current final calculation result still matches expectations,
> i.e. whether there was no disruption
> (in which case we'd also do a goto redo: operation or some such :).

If we can do whole procedure without IRQ manipulation, final check
would be more elegant solution. But, current implementation necessarily
needs IRQ manipulation for synchronization at pretty early phase. In this
situation, doing context check and adjusting context at first step may
be better than final check and redo.

> These thoughts also mean that I'm unsure (difficult to determine)
> of whether this change is good (i.e. a clean step in the right direction),
> or whether instead the implementation could easily directly be made
> fully independent from IRQ constraints.

Is there any issue that this change prevent further improvment?
I think that we can go right direction easily as soon as we find
a better solution even if this change is merged.

Thanks.
