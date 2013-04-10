Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3DJGbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:31:13 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53653 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3DJGbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:31:11 -0400
MIME-Version: 1.0
In-Reply-To: <1365424372.25498.6.camel@gandalf.local.home>
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
	<1365424372.25498.6.camel@gandalf.local.home>
Date: Wed, 10 Apr 2013 09:31:10 +0300
X-Google-Sender-Auth: hgEFh34h7Nl8BF7vteMlFct0Z0g
Message-ID: <CAOJsxLH2axjptbMj9caH0Wo_OqPZRVB20q7uT6f9dVtPZZxb_w@mail.gmail.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 3:32 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > Index: linux/mm/slub.c
>> > ===================================================================
>> > --- linux.orig/mm/slub.c    2013-03-28 12:14:26.958358688 -0500
>> > +++ linux/mm/slub.c 2013-04-01 10:23:24.677584499 -0500
>> > @@ -1498,6 +1498,7 @@ static inline void *acquire_slab(struct
>> >     void *freelist;
>> >     unsigned long counters;
>> >     struct page new;
>> > +   unsigned long objects;
>> >
>> >     /*
>> >      * Zap the freelist and set the frozen bit.
>> > @@ -1507,6 +1508,7 @@ static inline void *acquire_slab(struct
>> >     freelist = page->freelist;
>> >     counters = page->counters;
>> >     new.counters = counters;
>> > +   objects = page->inuse;
>> >     if (mode) {
>> >             new.inuse = page->objects;
>> >             new.freelist = NULL;
>> > @@ -1524,6 +1526,7 @@ static inline void *acquire_slab(struct
>> >             return NULL;
>> >
>> >     remove_partial(n, page);
>> > +   page->lru.next = (void *)objects;
>> >     WARN_ON(!freelist);
>> >     return freelist;
>> >  }
>>
>> Good. I like your method which use lru.next in order to hand over
>> number of objects.
>
> I hate it ;-)
>
> It just seems to be something that's not very robust and can cause hours
> of debugging in the future. I mean, there's not even a comment
> explaining what is happening. The lru is a union with other slub
> partials structs that is not very obvious. If something is out of order,
> it can easily break, and there's nothing here that points to why.
>
> Just pass the damn objects pointer by reference and use that. It's easy
> to understand, read and is robust.

Christoph, Joonsoo, comments?

                                Pekka
