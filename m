Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3DBAmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:42:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65236 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab3DBAmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:42:10 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-72-515a295cae06
Date: Tue, 2 Apr 2013 09:42:18 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
Message-ID: <20130402004217.GA16699@lge.com>
References: <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
 <1364236355.6345.185.camel@gandalf.local.home>
 <20130327025957.GA17125@lge.com>
 <1364355032.6345.200.camel@gandalf.local.home>
 <20130327061351.GB17125@lge.com>
 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com>
 <alpine.DEB.2.02.1304011025550.12690@gentwo.org>
 <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Mon, Apr 01, 2013 at 03:33:23PM +0000, Christoph Lameter wrote:
> Subject: slub: Fix object counts in acquire_slab V2
> 
> It seems that we were overallocating objects from the slab queues
> since get_partial_node() assumed that page->inuse was undisturbed by
> acquire_slab(). Save the # of objects in page->lru.next in acquire_slab()
> and pass it to get_partial_node() that way.
> 
> I have a vague memory that Joonsoo also ran into this issue awhile back.

Yes. I sent a patch for this two month ago. :)

> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c	2013-03-28 12:14:26.958358688 -0500
> +++ linux/mm/slub.c	2013-04-01 10:23:24.677584499 -0500
> @@ -1498,6 +1498,7 @@ static inline void *acquire_slab(struct
>  	void *freelist;
>  	unsigned long counters;
>  	struct page new;
> +	unsigned long objects;
> 
>  	/*
>  	 * Zap the freelist and set the frozen bit.
> @@ -1507,6 +1508,7 @@ static inline void *acquire_slab(struct
>  	freelist = page->freelist;
>  	counters = page->counters;
>  	new.counters = counters;
> +	objects = page->inuse;
>  	if (mode) {
>  		new.inuse = page->objects;
>  		new.freelist = NULL;
> @@ -1524,6 +1526,7 @@ static inline void *acquire_slab(struct
>  		return NULL;
> 
>  	remove_partial(n, page);
> +	page->lru.next = (void *)objects;
>  	WARN_ON(!freelist);
>  	return freelist;
>  }

Good. I like your method which use lru.next in order to hand over
number of objects.

> @@ -1565,7 +1568,7 @@ static void *get_partial_node(struct kme
>  			c->page = page;
>  			stat(s, ALLOC_FROM_PARTIAL);
>  			object = t;
> -			available =  page->objects - page->inuse;
> +			available =  page->objects - (unsigned long)page->lru.next;
>  		} else {
>  			available = put_cpu_partial(s, page, 0);
>  			stat(s, CPU_PARTIAL_NODE);

We need one more fix for correctness.
When available is assigned by put_cpu_partial, it doesn't count cpu slab's objects.
Please reference my old patch.

https://lkml.org/lkml/2013/1/21/64

Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
