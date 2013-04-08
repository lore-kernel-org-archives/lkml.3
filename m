Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573Ab3DHMc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:32:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935248Ab3DHMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:32:55 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZzSxI7jMevMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mVTtbqeYs4EA:10 a=NufY4J3AAAAA:8 a=u6kJjMrMb9LjD8ngRswA:9 a=QEXdDO2ut3YA:10 a=re9sYKne76oA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365424372.25498.6.camel@gandalf.local.home>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: Steven Rostedt <rostedt@goodmis.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Date: Mon, 08 Apr 2013 08:32:52 -0400
In-Reply-To: <20130402004217.GA16699@lge.com>
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
	 <20130402004217.GA16699@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 09:42 +0900, Joonsoo Kim wrote:

> > 
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> > 
> > Index: linux/mm/slub.c
> > ===================================================================
> > --- linux.orig/mm/slub.c	2013-03-28 12:14:26.958358688 -0500
> > +++ linux/mm/slub.c	2013-04-01 10:23:24.677584499 -0500
> > @@ -1498,6 +1498,7 @@ static inline void *acquire_slab(struct
> >  	void *freelist;
> >  	unsigned long counters;
> >  	struct page new;
> > +	unsigned long objects;
> > 
> >  	/*
> >  	 * Zap the freelist and set the frozen bit.
> > @@ -1507,6 +1508,7 @@ static inline void *acquire_slab(struct
> >  	freelist = page->freelist;
> >  	counters = page->counters;
> >  	new.counters = counters;
> > +	objects = page->inuse;
> >  	if (mode) {
> >  		new.inuse = page->objects;
> >  		new.freelist = NULL;
> > @@ -1524,6 +1526,7 @@ static inline void *acquire_slab(struct
> >  		return NULL;
> > 
> >  	remove_partial(n, page);
> > +	page->lru.next = (void *)objects;
> >  	WARN_ON(!freelist);
> >  	return freelist;
> >  }
> 
> Good. I like your method which use lru.next in order to hand over
> number of objects.

I hate it ;-)

It just seems to be something that's not very robust and can cause hours
of debugging in the future. I mean, there's not even a comment
explaining what is happening. The lru is a union with other slub
partials structs that is not very obvious. If something is out of order,
it can easily break, and there's nothing here that points to why.

Just pass the damn objects pointer by reference and use that. It's easy
to understand, read and is robust.

-- Steve

> 
> > @@ -1565,7 +1568,7 @@ static void *get_partial_node(struct kme
> >  			c->page = page;
> >  			stat(s, ALLOC_FROM_PARTIAL);
> >  			object = t;
> > -			available =  page->objects - page->inuse;
> > +			available =  page->objects - (unsigned long)page->lru.next;
> >  		} else {
> >  			available = put_cpu_partial(s, page, 0);
> >  			stat(s, CPU_PARTIAL_NODE);
> 


