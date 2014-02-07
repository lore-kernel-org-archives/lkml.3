Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBGRoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:44:25 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58591 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbaBGRoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:44:21 -0500
Date: Fri, 7 Feb 2014 12:44:17 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2014-02-05 list_lru_add lockdep splat
Message-ID: <20140207174417.GF6963@cmpxchg.org>
References: <alpine.LSU.2.11.1402051944210.27326@eggly.anvils>
 <20140206164136.GC6963@cmpxchg.org>
 <alpine.LSU.2.11.1402061413330.27968@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061413330.27968@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:18:24PM -0800, Hugh Dickins wrote:
> On Thu, 6 Feb 2014, Johannes Weiner wrote:
> > On Wed, Feb 05, 2014 at 07:50:10PM -0800, Hugh Dickins wrote:
> > > ======================================================
> > > [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> > > 3.14.0-rc1-mm1 #1 Not tainted
> > > ------------------------------------------------------
> > > kswapd0/48 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> > >  (&(&lru->node[i].lock)->rlock){+.+.-.}, at: [<ffffffff81117064>] list_lru_add+0x80/0xf4
> > > 
> > > s already holding:
> > >  (&(&mapping->tree_lock)->rlock){..-.-.}, at: [<ffffffff81108c63>] __remove_mapping+0x3b/0x12d
> > > which would create a new lock dependency:
> > >  (&(&mapping->tree_lock)->rlock){..-.-.} -> (&(&lru->node[i].lock)->rlock){+.+.-.}
> > 
> > Thanks for the report.  The first time I saw this on my own machine, I
> > misinterpreted it as a false positive (could have sworn the "possible
> > unsafe scenario" section looked different, too).
> > 
> > Looking at it again, there really is a deadlock scenario when the
> > shadow shrinker races with a page cache insertion or deletion and is
> > interrupted by the IO completion handler while holding the list_lru
> > lock:
> > 
> > >  Possible interrupt unsafe locking scenario:
> > > 
> > >        CPU0                    CPU1
> > >        ----                    ----
> > >   lock(&(&lru->node[i].lock)->rlock);
> > >                                local_irq_disable();
> > >                                lock(&(&mapping->tree_lock)->rlock);
> > >                                lock(&(&lru->node[i].lock)->rlock);
> > >   <Interrupt>
> > >     lock(&(&mapping->tree_lock)->rlock);
> > 
> > Could you please try with the following patch?
> 
> Sure, that fixes it for me (with one trivial correction appended), thanks.
> But don't imagine I've given it anything as demanding as thought!
>
> --- hannes/mm/list_lru.c	2014-02-06 08:50:25.104032277 -0800
> +++ hughd/mm/list_lru.c	2014-02-06 08:58:36.884043965 -0800
> @@ -143,7 +143,7 @@ int list_lru_init_key(struct list_lru *l
>  	}
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(list_lru_init);
> +EXPORT_SYMBOL_GPL(list_lru_init_key);
>  
>  void list_lru_destroy(struct list_lru *lru)
>  {

Oops, yes, I usually do non-modular builds.  Thanks, will merge this
into the above patch unless Andrew beats me to it.
