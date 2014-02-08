Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaBHDBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:01:25 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36111 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaBHDBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:01:24 -0500
Date: Sat, 8 Feb 2014 08:30:56 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Gautham R Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, penberg@kernel.org
Subject: Re: [PATCH] slub: Hold list_lock unconditionally before the call to
 add_full.
Message-ID: <20140208030056.GA9533@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140207184653.GA5799@in.ibm.com>
 <alpine.DEB.2.02.1402071245350.4212@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402071245350.4212@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020803-1344-0000-0000-00000587055E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 12:46:19PM -0800, David Rientjes wrote:
> On Sat, 8 Feb 2014, Gautham R Shenoy wrote:
> 
> > Hi,
> > 
> > From the lockdep annotation and the comment that existed before the
> > lockdep annotations were introduced, 
> > mm/slub.c:add_full(s, n, page) expects to be called with n->list_lock
> > held.
> > 
> > However, there's a call path in deactivate_slab() when
> > 
> > 	 (new.inuse || n->nr_partial <= s->min_partial) &&
> > 	 !(new.freelist) &&
> >          !(kmem_cache_debug(s))
> > 
> > which ends up calling add_full() without holding
> > n->list_lock.
> > 
> > This was discovered while onlining/offlining cpus in 3.14-rc1 due to
> > the lockdep annotations added by commit
> > c65c1877bd6826ce0d9713d76e30a7bed8e49f38.
> > 
> > Fix this by unconditionally taking the lock
> > irrespective of the state of kmem_cache_debug(s).
> > 
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> 
> No, it's not needed unless kmem_cache_debug(s) is actually set, 
> specifically s->flags & SLAB_STORE_USER.
> 
> You want the patch at http://marc.info/?l=linux-kernel&m=139147105027693 
> instead which is already in -mm and linux-next.
>

Ah, thanks! Wasn't aware of this fix. Shall apply this one.

--
Thanks and Regards
gautham. 

