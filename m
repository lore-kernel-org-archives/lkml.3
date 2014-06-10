Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaFJKJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:09:38 -0400
Received: from mx2.parallels.com ([199.115.105.18]:42914 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbaFJKJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:09:37 -0400
Date: Tue, 10 Jun 2014 14:09:25 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 7/8] slub: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140610100924.GC6293@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <3b53266b76556dd042bbf6147207c70473572a7e.1402060096.git.vdavydov@parallels.com>
 <20140610080935.GG19036@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140610080935.GG19036@js1304-P5Q-DELUXE>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 05:09:35PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 06, 2014 at 05:22:44PM +0400, Vladimir Davydov wrote:
> > @@ -2064,6 +2066,21 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
> >  
> >  	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
> >  								!= oldpage);
> > +
> > +	if (memcg_cache_dead(s)) {
> > +               bool done = false;
> > +               unsigned long flags;
> > +
> > +               local_irq_save(flags);
> > +               if (this_cpu_read(s->cpu_slab->partial) == page) {
> > +                       unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
> > +                       done = true;
> > +               }
> > +               local_irq_restore(flags);
> > +
> > +               if (!done)
> > +                       flush_all(s);
> > +	}
> 
> Now, slab_free() is non-preemptable so flush_all() isn't needed.

Right! Will fix.

Thanks.
