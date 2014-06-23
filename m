Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaFWU1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaFWU1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:27:30 -0400
Date: Mon, 23 Jun 2014 16:27:14 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: XFS WARN_ON in xfs_vm_writepage
Message-ID: <20140623202714.GA2714@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20140613051631.GA9394@redhat.com>
 <20140613062645.GZ9508@dastard>
 <20140613141925.GA24199@redhat.com>
 <20140619020340.GI4453@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619020340.GI4453@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:03:40PM +1000, Dave Chinner wrote:
 > On Fri, Jun 13, 2014 at 10:19:25AM -0400, Dave Jones wrote:
 > > On Fri, Jun 13, 2014 at 04:26:45PM +1000, Dave Chinner wrote:
 > > 
 > > > >  970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
 > > > >  971                         PF_MEMALLOC))
 > > >
 > > > What were you running at the time? The XFS warning is there to
 > > > indicate that memory reclaim is doing something it shouldn't (i.e.
 > > > dirty page writeback from direct reclaim), so this is one for the mm
 > > > folk to work out...
 > > 
 > > Trinity had driven the machine deeply into swap, and the oom killer was
 > > kicking in pretty often. Then this happened.
 > 
 > Yup, sounds like a problem somewhere in mm/vmscan.c....
 
I'm now hitting this fairly often, and no-one seems to have offered up
any suggestions yet, so I'm going to flail and guess randomly until someone
has a better idea what could be wrong.

That WARN commentary for the benefit of linux-mm readers..

 960         /*
 961          * Refuse to write the page out if we are called from reclaim context.
 962          *
 963          * This avoids stack overflows when called from deeply used stacks in
 964          * random callers for direct reclaim or memcg reclaim.  We explicitly
 965          * allow reclaim from kswapd as the stack usage there is relatively low.
 966          *
 967          * This should never happen except in the case of a VM regression so
 968          * warn about it.
 969          */
 970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
 971                         PF_MEMALLOC))
 972                 goto redirty;


Looking at this trace..

xfs_vm_writepage+0x5ce/0x630 [xfs]
? preempt_count_sub+0xab/0x100
? __percpu_counter_add+0x85/0xc0
shrink_page_list+0x8f9/0xb90
shrink_inactive_list+0x253/0x510
shrink_lruvec+0x563/0x6c0
shrink_zone+0x3b/0x100
shrink_zones+0x1f1/0x3c0
try_to_free_pages+0x164/0x380
__alloc_pages_nodemask+0x822/0xc90
alloc_pages_vma+0xaf/0x1c0
read_swap_cache_async+0x123/0x220
? final_putname+0x22/0x50
swapin_readahead+0x149/0x1d0
? find_get_entry+0xd5/0x130
? pagecache_get_page+0x30/0x210
? debug_smp_processor_id+0x17/0x20
handle_mm_fault+0x9d5/0xc50
__do_page_fault+0x1d2/0x640
? __acct_update_integrals+0x8b/0x120
? preempt_count_sub+0xab/0x100
do_page_fault+0x1e/0x70
page_fault+0x22/0x30

The reclaim here looks to be triggered from the readahead code.
Should something in that path be setting PF_KSWAPD in the gfp mask ?

	Dave

