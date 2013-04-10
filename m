Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab3DJHbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:31:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43957 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3DJHbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:31:02 -0400
X-AuditID: 9c930197-b7b50ae00000018c-d9-516515325d13
Date: Wed, 10 Apr 2013 16:31:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
Message-ID: <20130410073143.GF5872@lge.com>
References: <1364355032.6345.200.camel@gandalf.local.home>
 <20130327061351.GB17125@lge.com>
 <alpine.DEB.2.02.1303281227520.16200@gentwo.org>
 <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com>
 <alpine.DEB.2.02.1304011025550.12690@gentwo.org>
 <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com>
 <20130402004217.GA16699@lge.com>
 <1365424372.25498.6.camel@gandalf.local.home>
 <CAOJsxLH2axjptbMj9caH0Wo_OqPZRVB20q7uT6f9dVtPZZxb_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLH2axjptbMj9caH0Wo_OqPZRVB20q7uT6f9dVtPZZxb_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:31:10AM +0300, Pekka Enberg wrote:
> On Mon, Apr 8, 2013 at 3:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > Index: linux/mm/slub.c
> >> > ===================================================================
> >> > --- linux.orig/mm/slub.c    2013-03-28 12:14:26.958358688 -0500
> >> > +++ linux/mm/slub.c 2013-04-01 10:23:24.677584499 -0500
> >> > @@ -1498,6 +1498,7 @@ static inline void *acquire_slab(struct
> >> >     void *freelist;
> >> >     unsigned long counters;
> >> >     struct page new;
> >> > +   unsigned long objects;
> >> >
> >> >     /*
> >> >      * Zap the freelist and set the frozen bit.
> >> > @@ -1507,6 +1508,7 @@ static inline void *acquire_slab(struct
> >> >     freelist = page->freelist;
> >> >     counters = page->counters;
> >> >     new.counters = counters;
> >> > +   objects = page->inuse;
> >> >     if (mode) {
> >> >             new.inuse = page->objects;
> >> >             new.freelist = NULL;
> >> > @@ -1524,6 +1526,7 @@ static inline void *acquire_slab(struct
> >> >             return NULL;
> >> >
> >> >     remove_partial(n, page);
> >> > +   page->lru.next = (void *)objects;
> >> >     WARN_ON(!freelist);
> >> >     return freelist;
> >> >  }
> >>
> >> Good. I like your method which use lru.next in order to hand over
> >> number of objects.
> >
> > I hate it ;-)
> >
> > It just seems to be something that's not very robust and can cause hours
> > of debugging in the future. I mean, there's not even a comment
> > explaining what is happening. The lru is a union with other slub
> > partials structs that is not very obvious. If something is out of order,
> > it can easily break, and there's nothing here that points to why.
> >
> > Just pass the damn objects pointer by reference and use that. It's easy
> > to understand, read and is robust.
> 
> Christoph, Joonsoo, comments?

Steven's comment is reasonable to me.

If there is no objection from Christoph,
let's drop a patch in which I implement Christoph's idea.

Thanks.

> 
>                                 Pekka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
