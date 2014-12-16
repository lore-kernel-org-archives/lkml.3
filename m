Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaLPIVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:21:44 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56533 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaLPIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:21:43 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 16 Dec 2014 17:25:56 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
Message-ID: <20141216082555.GA6088@js1304-P5Q-DELUXE>
References: <20141210163017.092096069@linux.com>
 <20141210163033.717707217@linux.com>
 <20141215080338.GE4898@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1412150815210.20101@gentwo.org>
 <20141216024210.GB23270@js1304-P5Q-DELUXE>
 <CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:54:12AM +0400, Andrey Ryabinin wrote:
> 2014-12-16 5:42 GMT+03:00 Joonsoo Kim <iamjoonsoo.kim@lge.com>:
> > On Mon, Dec 15, 2014 at 08:16:00AM -0600, Christoph Lameter wrote:
> >> On Mon, 15 Dec 2014, Joonsoo Kim wrote:
> >>
> >> > > +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
> >> > > +{
> >> > > + long d = p - page->address;
> >> > > +
> >> > > + return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> >> > > +}
> >> > > +
> >> >
> >> > Somtimes, compound_order() induces one more cacheline access, because
> >> > compound_order() access second struct page in order to get order. Is there
> >> > any way to remove this?
> >>
> >> I already have code there to avoid the access if its within a MAX_ORDER
> >> page. We could probably go for a smaller setting there. PAGE_COSTLY_ORDER?
> >
> > That is the solution to avoid compound_order() call when slab of
> > object isn't matched with per cpu slab.
> >
> > What I'm asking is whether there is a way to avoid compound_order() call when slab
> > of object is matched with per cpu slab or not.
> >
> 
> Can we use page->objects for that?
> 
> Like this:
> 
>         return d > 0 && d < page->objects * s->size;
> 

Yes! That's what I'm looking for.
Christoph, how about above change?

Thanks.
