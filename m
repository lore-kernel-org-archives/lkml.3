Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbaJVLj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:39:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:57535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaJVLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:39:58 -0400
Date: Wed, 22 Oct 2014 13:39:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 3/6] mm: VMA sequence count
Message-ID: <20141022113951.GB21513@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.361741939@infradead.org>
 <20141022112657.GG30588@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022112657.GG30588@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:26:57PM +0300, Kirill A. Shutemov wrote:
> On Mon, Oct 20, 2014 at 11:56:36PM +0200, Peter Zijlstra wrote:
> > Wrap the VMA modifications (vma_adjust/unmap_page_range) with sequence
> > counts such that we can easily test if a VMA is changed.
> > 
> > The unmap_page_range() one allows us to make assumptions about
> > page-tables; when we find the seqcount hasn't changed we can assume
> > page-tables are still valid.
> > 
> > The flip side is that we cannot distinguish between a vma_adjust() and
> > the unmap_page_range() -- where with the former we could have
> > re-checked the vma bounds against the address.
> 
> You only took care about changing size of VMA or unmap. What about other
> aspects of VMA. How would you care about race with mprotect(2)?
> 
> 		CPU0						CPU1
>  mprotect()
>    mprotect_fixup()
>      vma_merge()
>        [ maybe update vm_sequence ]
>     						[ page fault kicks in ]
> 						  do_anonymous_page()
> 						    entry = mk_pte(page, fe->vma->vm_page_prot);
>      vma_set_page_prot(vma)
>        [ update vma->vm_page_prot ]
>      change_protection()
> 						    pte_map_lock()
> 						      [ vm_sequence is ok ]
> 						    set_pte_at(entry) // With old vm_page_prot!!!
> 

This won't happen, this is be serialized by the PTL and the fault
validates that the PTE is the 'same' it started out with after acquiring
the PTL.
