Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaEWT5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:57:41 -0400
Received: from mx2.parallels.com ([199.115.105.18]:53482 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEWT5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:57:39 -0400
Date: Fri, 23 May 2014 23:57:30 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
Message-ID: <20140523195728.GA21344@esperanza>
References: <20140519152437.GB25889@esperanza>
 <alpine.DEB.2.10.1405191056580.22956@gentwo.org>
 <537A4D27.1050909@parallels.com>
 <alpine.DEB.2.10.1405210937440.8038@gentwo.org>
 <20140521150408.GB23193@esperanza>
 <alpine.DEB.2.10.1405211912400.4433@gentwo.org>
 <20140522134726.GA3147@esperanza>
 <alpine.DEB.2.10.1405221422390.15766@gentwo.org>
 <20140523152642.GD3147@esperanza>
 <alpine.DEB.2.10.1405231241250.22913@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405231241250.22913@gentwo.org>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:45:48PM -0500, Christoph Lameter wrote:
> On Fri, 23 May 2014, Vladimir Davydov wrote:
> 
> > On Thu, May 22, 2014 at 02:25:30PM -0500, Christoph Lameter wrote:
> > > slab_free calls __slab_free which can release slabs via
> > > put_cpu_partial()/unfreeze_partials()/discard_slab() to the page
> > > allocator. I'd rather have preemption enabled there.
> >
> > Hmm, why? IMO, calling __free_pages with preempt disabled won't hurt
> > latency, because it proceeds really fast. BTW, we already call it for a
> > bunch of pages from __slab_free() -> put_cpu_partial() ->
> > unfreeze_partials() with irqs disabled, which is harder. FWIW, SLAB has
> > the whole obj free path executed under local_irq_save/restore, and it
> > doesn't bother enabling irqs for freeing pages.
> >
> > IMO, the latency improvement we can achieve by enabling preemption while
> > calling __free_pages is rather minor, and it isn't worth complicating
> > the code.
> 
> If you look at the end of unfreeze_partials() you see that we release
> locks and therefore enable preempt before calling into the page allocator.

Yes, we release the node's list_lock before calling discard_slab(), but
we don't enable irqs, which are disabled in put_cpu_partial(), just
before calling it, so we call the page allocator with irqs off and
therefore preemption disabled.

> You never know what other new features they are going to be adding to the
> page allocator. I'd rather be safe than sorry on this one. We have had
> some trouble in the past with some debugging logic triggering.

I guess by "some troubles in the past with some debugging logic
triggering" you mean the issue that was fixed by commit 9ada19342b244 ?

    From: Shaohua Li <shaohua.li@intel.com>

    slub: move discard_slab out of node lock
    
    Lockdep reports there is potential deadlock for slub node list_lock.
    discard_slab() is called with the lock hold in unfreeze_partials(),
    which could trigger a slab allocation, which could hold the lock again.
    
    discard_slab() doesn't need hold the lock actually, if the slab is
    already removed from partial list.

If so - nothing to worry about, because I'm not going to make calls to
the page allocator under an internal slab lock. What I propose is
calling __free_pages with preempt disabled, which already happens here
and there and can't result in deadlocks or lockdep warns.

Thanks.
