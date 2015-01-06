Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbbAFBEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:04:44 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56360 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbAFBEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:04:43 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 6 Jan 2015 10:04:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 6/6] mm/slab: allocation fastpath without disabling irq
Message-ID: <20150106010442.GA17222@js1304-P5Q-DELUXE>
References: <1420421851-3281-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1420421851-3281-7-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1501050859520.24213@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501050859520.24213@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 09:28:14AM -0600, Christoph Lameter wrote:
> On Mon, 5 Jan 2015, Joonsoo Kim wrote:
> 
> > index 449fc6b..54656f0 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -168,6 +168,41 @@ typedef unsigned short freelist_idx_t;
> >
> >  #define SLAB_OBJ_MAX_NUM ((1 << sizeof(freelist_idx_t) * BITS_PER_BYTE) - 1)
> >
> > +#ifdef CONFIG_PREEMPT
> > +/*
> > + * Calculate the next globally unique transaction for disambiguiation
> > + * during cmpxchg. The transactions start with the cpu number and are then
> > + * incremented by CONFIG_NR_CPUS.
> > + */
> > +#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
> > +#else
> > +/*
> > + * No preemption supported therefore also no need to check for
> > + * different cpus.
> > + */
> > +#define TID_STEP 1
> > +#endif
> > +
> > +static inline unsigned long next_tid(unsigned long tid)
> > +{
> > +	return tid + TID_STEP;
> > +}
> > +
> > +static inline unsigned int tid_to_cpu(unsigned long tid)
> > +{
> > +	return tid % TID_STEP;
> > +}
> > +
> > +static inline unsigned long tid_to_event(unsigned long tid)
> > +{
> > +	return tid / TID_STEP;
> > +}
> > +
> > +static inline unsigned int init_tid(int cpu)
> > +{
> > +	return cpu;
> > +}
> > +
> 
> Ok the above stuff needs to go into the common code. Maybe in mm/slab.h?
> And its a significant feature contributed by me so I'd like to have an
> attribution here.

Okay. I will try!

> 
> >  /*
> >   * true if a page was allocated from pfmemalloc reserves for network-based
> >   * swap
> > @@ -187,7 +222,8 @@ static bool pfmemalloc_active __read_mostly;
> >   *
> >   */
> >  struct array_cache {
> > -	unsigned int avail;
> > +	unsigned long avail;
> > +	unsigned long tid;
> >  	unsigned int limit;
> >  	unsigned int batchcount;
> >  	unsigned int touched;
> > @@ -657,7 +693,8 @@ static void start_cpu_timer(int cpu)
> >  	}
> >  }
> 
> This increases the per cpu struct size and should lead to a small
> performance penalty.

Yes, but, it's marginal than improvement of this patchset.
> 
> > -	 */
> > -	if (likely(objp)) {
> > -		STATS_INC_ALLOCHIT(cachep);
> > -		goto out;
> > +	objp = ac->entry[avail - 1];
> > +	if (unlikely(!this_cpu_cmpxchg_double(
> > +		cachep->cpu_cache->avail, cachep->cpu_cache->tid,
> > +		avail, tid,
> > +		avail - 1, next_tid(tid))))
> > +		goto redo;
> 
> 
> Hmm... Ok that looks good.

Thanks.
