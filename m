Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaFLVpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:45:18 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56819 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFLVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:45:16 -0400
Date: Thu, 12 Jun 2014 14:45:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Waiman Long <waiman.long@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] mm: Move __vma_address() to internal.h to be inlined in
 huge_memory.c
In-Reply-To: <539A1CDA.5000709@hp.com>
Message-ID: <alpine.DEB.2.02.1406121444140.12437@chino.kir.corp.google.com>
References: <1402600540-52031-1-git-send-email-Waiman.Long@hp.com> <20140612122546.cfdebdb22bb22c0f767e30b5@linux-foundation.org> <539A1CDA.5000709@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Waiman Long wrote:

> > > The vma_address() function which is used to compute the virtual address
> > > within a VMA is used only by 2 files in the mm subsystem - rmap.c and
> > > huge_memory.c. This function is defined in rmap.c and is inlined by
> > > its callers there, but it is also declared as an external function.
> > > 
> > > However, the __split_huge_page() function which calls vma_address()
> > > in huge_memory.c is calling it as a real function call. This is not
> > > as efficient as an inlined function. This patch moves the underlying
> > > inlined __vma_address() function to internal.h to be shared by both
> > > the rmap.c and huge_memory.c file.
> > This increases huge_memory.o's text+data_bss by 311 bytes, which makes
> > me suspect that it is a bad change due to its increase of kernel cache
> > footprint.
> > 
> > Perhaps we should be noinlining __vma_address()?
> 
> On my test machine, I saw an increase of 144 bytes in the text segment
> of huge_memory.o. The size in size is caused by an increase in the size
> of the __split_huge_page function. When I remove the
> 
>         if (unlikely(is_vm_hugetlb_page(vma)))
>                 pgoff = page->index << huge_page_order(page_hstate(page));
> 
> check, the increase in size drops down to 24 bytes. As a THP cannot be
> a hugetlb page, there is no point in doing this check for a THP. I will
> update the patch to pass in an additional argument to disable this
> check for __split_huge_page.
> 

I think we're seeking a reason or performance numbers that suggest 
__vma_address() being inline is appropriate and so far we lack any such 
evidence.  Adding additional parameters to determine checks isn't going to 
change the fact that it increases text size needlessly.
