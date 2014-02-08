Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaBHBCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 20:02:07 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41154 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBHBCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 20:02:05 -0500
Date: Fri, 7 Feb 2014 17:02:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
In-Reply-To: <20140207232711.GA16836@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1402071654560.775@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com> <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
 <20140207210705.GB13604@jtriplet-mobl1> <alpine.DEB.2.02.1402071314180.4212@chino.kir.corp.google.com> <20140207143050.6bd35ed5c670a3ca143ba59a@linux-foundation.org> <alpine.DEB.2.02.1402071503120.24644@chino.kir.corp.google.com>
 <20140207232711.GA16836@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Josh Triplett wrote:

> > Why??  If CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID then, yes, we need it to be 
> > global.  Otherwise it's perfectly fine just being static in file scope.  
> > This causes the compilation unit to break when you compile it, not wait 
> > until vmlinux and find undefined references.
> > 
> > I see no reason it can't be done like this in mm/page_alloc.c:
> > 
> > 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> > 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> 
> No, a .c file should not have an extern declaration in it.  This should
> live in an appropriate header file, to be included in both page_alloc.c
> and any arch file that defines an overriding function.
> 

Ok, so you have religious beliefs about extern being used in files ending 
in .c and don't mind the 2900 occurrences of it in the kernel tree and 
desire 14 line obfuscation in header files with comments to what is being 
defined in .c files such as "please see mm/page_alloc.c" as mm.h has.  
Good point.

> > Both of these options look much better than
> > 
> > 	include/linux/mm.h:
> > 
> > 	#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
> > 	    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> > 	static inline int __early_pfn_to_nid(unsigned long pfn)
> > 	{
> > 	        return 0;
> > 	}
> > 	#else
> > 	/* please see mm/page_alloc.c */
> > 	extern int __meminit early_pfn_to_nid(unsigned long pfn);
> > 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> > 	/* there is a per-arch backend function. */
> > 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> > 	#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> > 	#endif
> > 
> > where all this confusion is originating from.
> 
> The proposal is to first simplify those ifdefs by eliminating the inner
> one in the #else; I agree with Andrew that we ought to go ahead and take
> that step given the patch at hand, and then figure out if there's an
> additional simplification possible.
> 

If additional simplification is possible?  Yeah, it's __weak which is 
designed for this purpose.
