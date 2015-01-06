Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbbAFIJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:09:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54714 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbAFIJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:09:47 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 6 Jan 2015 17:09:48 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] mm/slub: optimize alloc/free fastpath by removing
 preemption on/off
Message-ID: <20150106080948.GA18346@js1304-P5Q-DELUXE>
References: <1420421765-3209-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1420513392.24290.2.camel@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420513392.24290.2.camel@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 07:03:12PM -0800, Davidlohr Bueso wrote:
> On Mon, 2015-01-05 at 10:36 +0900, Joonsoo Kim wrote:
> > -	preempt_disable();
> > -	c = this_cpu_ptr(s->cpu_slab);
> > +	do {
> > +		tid = this_cpu_read(s->cpu_slab->tid);
> > +		c = this_cpu_ptr(s->cpu_slab);
> > +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> > +	barrier();
> 
> I don't see the compiler reodering the object/page stores below, since c
> is updated in the loop anyway. Is this really necessary (same goes for
> slab_free)? The generated code by gcc 4.8 looks correct without it.
> Additionally, the implied barriers for preemption control aren't really
> the same semantics used here (if that is actually the reason why you are
> using them).

Hello,

I'd like to use tid as a pivot so it should be fetched before fetching
anything on c. Is it impossible even if !CONFIG_PREEMPT without
barrier()?

Thanks.
