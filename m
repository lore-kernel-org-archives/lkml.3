Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaBHBZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 20:25:30 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53422 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaBHBZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 20:25:28 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 7 Feb 2014 17:25:16 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
Message-ID: <20140208012515.GA18890@jtriplet-mobl1>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
 <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
 <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
 <20140207210705.GB13604@jtriplet-mobl1>
 <alpine.DEB.2.02.1402071314180.4212@chino.kir.corp.google.com>
 <20140207143050.6bd35ed5c670a3ca143ba59a@linux-foundation.org>
 <alpine.DEB.2.02.1402071503120.24644@chino.kir.corp.google.com>
 <20140207232711.GA16836@jtriplet-mobl1>
 <alpine.DEB.2.02.1402071654560.775@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402071654560.775@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:02:02PM -0800, David Rientjes wrote:
> On Fri, 7 Feb 2014, Josh Triplett wrote:
> 
> > > Why??  If CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID then, yes, we need it to be 
> > > global.  Otherwise it's perfectly fine just being static in file scope.  
> > > This causes the compilation unit to break when you compile it, not wait 
> > > until vmlinux and find undefined references.
> > > 
> > > I see no reason it can't be done like this in mm/page_alloc.c:
> > > 
> > > 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> > > 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> > 
> > No, a .c file should not have an extern declaration in it.  This should
> > live in an appropriate header file, to be included in both page_alloc.c
> > and any arch file that defines an overriding function.
> > 
> 
> Ok, so you have religious beliefs about extern being used in files ending 
> in .c and don't mind the 2900 occurrences of it in the kernel tree and 
> desire 14 line obfuscation in header files with comments to what is being 
> defined in .c files such as "please see mm/page_alloc.c" as mm.h has.  

I (and many others) have very specific technical objections to not
having the same prototype seen by both the definition and use of a
function: that helps keep the prototype in sync with the definition(s),
helps keep all definitions in sync if there are multiple such
definitions, and eliminates -Wmissing-prototype warnings (which in
addition to those benefits also help detect functions that should be
made static or eliminated).

And as mentioned before, those 14 lines can be significantly simplified;
Rashika's patch already does one such simplification.

Those 2900 occurrences should go away as well, and Rashika's previous
patches have already fixed many of them.

> > > Both of these options look much better than
> > > 
> > > 	include/linux/mm.h:
> > > 
> > > 	#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
> > > 	    !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
> > > 	static inline int __early_pfn_to_nid(unsigned long pfn)
> > > 	{
> > > 	        return 0;
> > > 	}
> > > 	#else
> > > 	/* please see mm/page_alloc.c */
> > > 	extern int __meminit early_pfn_to_nid(unsigned long pfn);
> > > 	#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> > > 	/* there is a per-arch backend function. */
> > > 	extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> > > 	#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> > > 	#endif
> > > 
> > > where all this confusion is originating from.
> > 
> > The proposal is to first simplify those ifdefs by eliminating the inner
> > one in the #else; I agree with Andrew that we ought to go ahead and take
> > that step given the patch at hand, and then figure out if there's an
> > additional simplification possible.
> > 
> 
> If additional simplification is possible?  Yeah, it's __weak which is 
> designed for this purpose.

No objections here if someone wants to write that patch.

- Josh Triplett
