Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaBGX1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:27:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54321 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBGX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:27:23 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 7 Feb 2014 15:27:12 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
Message-ID: <20140207232711.GA16836@jtriplet-mobl1>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
 <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
 <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
 <20140207210705.GB13604@jtriplet-mobl1>
 <alpine.DEB.2.02.1402071314180.4212@chino.kir.corp.google.com>
 <20140207143050.6bd35ed5c670a3ca143ba59a@linux-foundation.org>
 <alpine.DEB.2.02.1402071503120.24644@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402071503120.24644@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 03:09:09PM -0800, David Rientjes wrote:
> On Fri, 7 Feb 2014, Andrew Morton wrote:
> 
> > > > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > > > index 1cedd00..5f8348f 100644
> > > > > > --- a/include/linux/mm.h
> > > > > > +++ b/include/linux/mm.h
> > > > > > @@ -1589,10 +1589,8 @@ static inline int __early_pfn_to_nid(unsigned long pfn)
> > > > > >  #else
> > > > > >  /* please see mm/page_alloc.c */
> > > > > >  extern int __meminit early_pfn_to_nid(unsigned long pfn);
> > > > > > -#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> > > > > >  /* there is a per-arch backend function. */
> > > > > >  extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> > > > > > -#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> > > > > >  #endif
> > > > > >  
> > > > > >  extern void set_dma_reserve(unsigned long new_dma_reserve);
> > > > > 
> > > > > Wouldn't it be better to just declare the __early_pfn_to_nid() in 
> > > > > mm/page_alloc.c to be static?
> > > > 
> > > > Won't that break the ability to override that function in
> > > > architecture-specific code (as arch/ia64/mm/numa.c does)?
> > > > 
> > > 
> > > Why?  CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID should define where this function 
> > > is defined so ia64 should have it set and the definition which I'm 
> > > suggesting be static is only compiled when this is undefined in 
> > > mm/page_alloc.c.  I'm not sure why we'd want to be messing with the 
> > > declaration?
> > 
> > __early_pfn_to_nid() must be global if it is implemented in arch/. 
> > 
> 
> Why??  If CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID then, yes, we need it to be 
> global.  Otherwise it's perfectly fine just being static in file scope.  
> This causes the compilation unit to break when you compile it, not wait 
> until vmlinux and find undefined references.
> 
> I see no reason it can't be done like this in mm/page_alloc.c:
> 
> 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);

No, a .c file should not have an extern declaration in it.  This should
live in an appropriate header file, to be included in both page_alloc.c
and any arch file that defines an overriding function.

> Both of these options look much better than
> 
> 	include/linux/mm.h:
> 
> 	#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
> 	    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> 	static inline int __early_pfn_to_nid(unsigned long pfn)
> 	{
> 	        return 0;
> 	}
> 	#else
> 	/* please see mm/page_alloc.c */
> 	extern int __meminit early_pfn_to_nid(unsigned long pfn);
> 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> 	/* there is a per-arch backend function. */
> 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> 	#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> 	#endif
> 
> where all this confusion is originating from.

The proposal is to first simplify those ifdefs by eliminating the inner
one in the #else; I agree with Andrew that we ought to go ahead and take
that step given the patch at hand, and then figure out if there's an
additional simplification possible.

- Josh Triplett
