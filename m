Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaIHRTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:19:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbaIHRS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:18:58 -0400
Date: Mon, 8 Sep 2014 18:18:53 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
Message-ID: <20140908171853.GN17501@suse.de>
References: <53DD5F20.8010507@oracle.com>
 <alpine.LSU.2.11.1408040418500.3406@eggly.anvils>
 <20140805144439.GW10819@suse.de>
 <alpine.LSU.2.11.1408051649330.6591@eggly.anvils>
 <53E17F06.30401@oracle.com>
 <53E989FB.5000904@oracle.com>
 <53FD4D9F.6050500@oracle.com>
 <20140827152622.GC12424@suse.de>
 <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <54082B25.9090600@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:04:37AM -0400, Sasha Levin wrote:
> On 08/29/2014 09:23 PM, Sasha Levin wrote:
> > On 08/27/2014 11:26 AM, Mel Gorman wrote:
> >> > diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> >> > index 281870f..ffea570 100644
> >> > --- a/include/asm-generic/pgtable.h
> >> > +++ b/include/asm-generic/pgtable.h
> >> > @@ -723,6 +723,9 @@ static inline pte_t pte_mknuma(pte_t pte)
> >> >  
> >> >  	VM_BUG_ON(!(val & _PAGE_PRESENT));
> >> >  
> >> > +	/* debugging only, specific to x86 */
> >> > +	VM_BUG_ON(val & _PAGE_PROTNONE);
> >> > +
> >> >  	val &= ~_PAGE_PRESENT;
> >> >  	val |= _PAGE_NUMA;
> > Triggered again, the first VM_BUG_ON got hit, the second one never did.
> 
> Okay, this bug has reproduced quite a few times since then that I no longer
> suspect it's random memory corruption. I'd be happy to try out more debug
> patches if you have any leads.
> 

The fact the second one doesn't trigger makes me think that this is not
related to how the helpers are called and is instead relating to timing.
I tried reproducing this but got nothing after 3 hours. How long does it
typically take to reproduce in a given run? You mentioned that it takes a
few weeks to hit but maybe the frequency has changed since. I tried todays
linux-next kernel but it didn't even boot so next-20140826 to match your
original report but got nothing. Can you also send me the config you used
in case that's a factor.

I had one hunch that this may somehow be related to a collision between
pagetable teardown during exit and the scanner but I could not find a
way that could actually happen. During teardown there should be only one
user of the mm and it can't race with itself.

A worse possibility is that somehow the lock is getting corrupted but
that's also a tough sell considering that the locks should be allocated
from a dedicated cache. I guess I could try breaking that to allocate
one page per lock so DEBUG_PAGEALLOC triggers but I'm not very
optimistic.

-- 
Mel Gorman
SUSE Labs
