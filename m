Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbbA2HnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:43:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34248 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbbA2HnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:43:20 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 29 Jan 2015 16:44:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, iamjoonsoo@lge.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [RFC 1/3] Slab infrastructure for array operations
Message-ID: <20150129074443.GA19607@js1304-P5Q-DELUXE>
References: <20150123213727.142554068@linux.com>
 <20150123213735.590610697@linux.com>
 <20150127082132.GE11358@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1501271054310.25124@gentwo.org>
 <CAAmzW4MzNfcRucHeTxJtXLks5T-Def=O1sRpQY6fo5ybTzKsBA@mail.gmail.com>
 <alpine.DEB.2.11.1501280923410.31753@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501280923410.31753@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:30:56AM -0600, Christoph Lameter wrote:
> On Wed, 28 Jan 2015, Joonsoo Kim wrote:
> 
> > > GFP_SLAB_ARRAY new is best for large quantities in either allocator since
> > > SLAB also has to construct local metadata structures.
> >
> > In case of SLAB, there is just a little more work to construct local metadata so
> > GFP_SLAB_ARRAY_NEW would not show better performance
> > than GFP_SLAB_ARRAY_LOCAL, because it would cause more overhead due to
> > more page allocations. Because of this characteristic, I said that
> > which option is
> > the best is implementation specific and therefore we should not expose it.
> 
> For large amounts of objects (hundreds or higher) GFP_SLAB_ARRAY_LOCAL
> will never have enough objects. GFP_SLAB_ARRAY_NEW will go to the page
> allocator and bypass free table creation and all the queuing that objects
> go through normally in SLAB. AFAICT its going to be a significant win.
> 
> A similar situation is true for the freeing operation. If the freeing
> operation results in all objects in a page being freed then we can also
> bypass that and put the page directly back into the page allocator (to be
> implemented once we agree on an approach).
> 
> > Even if we narrow down the problem to the SLUB, choosing correct option is
> > difficult enough. User should know how many objects are cached in this
> > kmem_cache
> > in order to choose best option since relative quantity would make
> > performance difference.
> 
> Ok we can add a function call to calculate the number of objects cached
> per cpu and per node? But then that is rather fluid and could change any
> moment.
> 
> > And, how many objects are cached in this kmem_cache could be changed
> > whenever implementation changed.
> 
> The default when no options are specified is to first exhaust the node
> partial objects, then allocate new slabs as long as we have more than
> objects per page left and only then satisfy from cpu local object. I think
> that is satisfactory for the majority of the cases.
> 
> The detailed control options were requested at the meeting in Auckland at
> the LCA. I am fine with dropping those if they do not make sense. Makes
> the API and implementation simpler. Jesper, are you ok with this?

IMHO, it'd be better to choose a proper way of allocation by slab itself
and not to expose options to API user. We could decide the best option
according to current status of kmem_cache and requested object number
and internal implementation.

Is there any obvious example these option are needed for user?

Thanks.
