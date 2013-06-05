Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FEJKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:10:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3FEJKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:10:49 -0400
Date: Wed, 5 Jun 2013 11:10:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Frank Mehnert <frank.mehnert@oracle.com>
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Handling NUMA page migration
Message-ID: <20130605091048.GI15997@dhcp22.suse.cz>
References: <201306040922.10235.frank.mehnert@oracle.com>
 <201306042354.45984.frank.mehnert@oracle.com>
 <20130605075454.GD15997@dhcp22.suse.cz>
 <201306051034.19959.frank.mehnert@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306051034.19959.frank.mehnert@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-06-13 10:34:13, Frank Mehnert wrote:
> On Wednesday 05 June 2013 09:54:54 Michal Hocko wrote:
> > On Tue 04-06-13 23:54:45, Frank Mehnert wrote:
> > > On Tuesday 04 June 2013 20:17:02 Frank Mehnert wrote:
> > > > On Tuesday 04 June 2013 16:02:30 Michal Hocko wrote:
> > > > > On Tue 04-06-13 14:14:45, Frank Mehnert wrote:
> > > > > > On Tuesday 04 June 2013 13:58:07 Robin Holt wrote:
> > > > > > > This is probably more appropriate to be directed at the linux-mm
> > > > > > > mailing list.
> > > > > > > 
> > > > > > > On Tue, Jun 04, 2013 at 09:22:10AM +0200, Frank Mehnert wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > our memory management on Linux hosts conflicts with NUMA page
> > > > > > > > migration. I assume this problem existed for a longer time but
> > > > > > > > Linux 3.8 introduced automatic NUMA page balancing which makes
> > > > > > > > the problem visible on multi-node hosts leading to kernel
> > > > > > > > oopses.
> > > > > > > > 
> > > > > > > > NUMA page migration means that the physical address of a page
> > > > > > > > changes. This is fatal if the application assumes that this
> > > > > > > > never happens for that page as it was supposed to be pinned.
> > > > > > > > 
> > > > > > > > We have two kind of pinned memory:
> > > > > > > > 
> > > > > > > > A) 1. allocate memory in userland with mmap()
> > > > > > > > 
> > > > > > > >    2. madvise(MADV_DONTFORK)
> > > > > > > >    3. pin with get_user_pages().
> > > > > > > >    4. flush dcache_page()
> > > > > > > >    5. vm_flags |= (VM_DONTCOPY | VM_LOCKED)
> > > > > > > >    
> > > > > > > >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP |
> > > > > > > >       VM_DONTEXPAND
> > > > > > > >       
> > > > > > > >        VM_DONTCOPY | VM_LOCKED | 0xff)
> > > > > > > 
> > > > > > > I don't think this type of allocation should be affected.  The
> > > > > > > get_user_pages() call should elevate the pages reference count
> > > > > > > which should prevent migration from completing.  I would,
> > > > > > > however, wait for a more definitive answer.
> > > > > > 
> > > > > > Thanks Robin! Actually case B) is more important for us so I'm
> > > > > > waiting for more feedback :)
> > > > > 
> > > > > The manual node migration code seems to be OK in case B as well
> > > > > because Reserved are skipped (check check_pte_range called from down
> > > > > the do_migrate_pages path).
> > > > > 
> > > > > Maybe auto-numa code is missing this check assuming that it cannot
> > > > > encounter reserved pages.
> > > > > 
> > > > > migrate_misplaced_page relies on numamigrate_isolate_page which
> > > > > relies on isolate_lru_page and that one expects a LRU page. Is your
> > > > > Reserved page on the LRU list? That would be a bit unexpected.
> > > > 
> > > > I will check this.
> > > 
> > > I tested this now. When the Oops happens,
> > 
> > You didn't mention Oops before. Are you sure you are just not missing
> > any follow up fix?
> 
> Sorry, but remember, this is on a host running VirtualBox which is
> executing code in ring 0.

Then the problem might be almost anywhere... I am afraid I cannot help
you much with that. Good luck.
 
> > > PageLRU() of the corresponding page struct is NOT set! I've patched
> > > the kernel to find that out.
> > 
> > At which state? When you setup your page or when the Oops happens?
> > Are you sure that your out-of-tree code plays well with the migration
> > code?
> 
> I've added code to show_fault_oops(). This code determines the page struct
> for the address where the ring 0 page fault happened. It then prints
> the value of PageLRU(page) from that page struct as part of the Oops.
> This was to check if the page is part of the LRU list or not. I hope
> I did this right.

I am not sure this will tell you much. Your code would have to trip over
a page affected by the migration. And nothing indicates this so far.
-- 
Michal Hocko
SUSE Labs
