Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaLPHyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 02:54:14 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59667 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLPHyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 02:54:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141216024210.GB23270@js1304-P5Q-DELUXE>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<20141215080338.GE4898@js1304-P5Q-DELUXE>
	<alpine.DEB.2.11.1412150815210.20101@gentwo.org>
	<20141216024210.GB23270@js1304-P5Q-DELUXE>
Date: Tue, 16 Dec 2014 11:54:12 +0400
Message-ID: <CAPAsAGyGXSP-2eY1CQS1jDpJq89kwpCuJm4ZBa3cYDGkv_oTxA@mail.gmail.com>
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-16 5:42 GMT+03:00 Joonsoo Kim <iamjoonsoo.kim@lge.com>:
> On Mon, Dec 15, 2014 at 08:16:00AM -0600, Christoph Lameter wrote:
>> On Mon, 15 Dec 2014, Joonsoo Kim wrote:
>>
>> > > +static bool same_slab_page(struct kmem_cache *s, struct page *page, void *p)
>> > > +{
>> > > + long d = p - page->address;
>> > > +
>> > > + return d > 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
>> > > +}
>> > > +
>> >
>> > Somtimes, compound_order() induces one more cacheline access, because
>> > compound_order() access second struct page in order to get order. Is there
>> > any way to remove this?
>>
>> I already have code there to avoid the access if its within a MAX_ORDER
>> page. We could probably go for a smaller setting there. PAGE_COSTLY_ORDER?
>
> That is the solution to avoid compound_order() call when slab of
> object isn't matched with per cpu slab.
>
> What I'm asking is whether there is a way to avoid compound_order() call when slab
> of object is matched with per cpu slab or not.
>

Can we use page->objects for that?

Like this:

        return d > 0 && d < page->objects * s->size;
