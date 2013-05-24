Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3EXVis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 17:38:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50670 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755176Ab3EXVir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 17:38:47 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
Cc: akpm@linux-foundation.org
Message-Id: <E1UfzhG-0008Vw-EI@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Fri, 24 May 2013 16:38:46 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> On Thur, 23 May 2013 Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Wed, 15 May 2013 07:46:36 -0500 Cliff Wickman <cpw@sgi.com> wrote:
> > Certain tests in walk_page_range() (specifically split_huge_page_pmd())
> > assume that all the mapped PFN's are backed with page structures. And this is
> > not usually true for VM_PFNMAP areas. This can result in panics on kernel
> > page faults when attempting to address those page structures.
> > 
> > There are a half dozen callers of walk_page_range() that walk through
> > a task's entire page table (as N. Horiguchi pointed out). So rather than
> > change all of them, this patch changes just walk_page_range() to ignore 
> > VM_PFNMAP areas.
> > 
> > The logic of hugetlb_vma() is moved back into walk_page_range(), as we
> > want to test any vma in the range.
> > 
> > VM_PFNMAP areas are used by:
> > - graphics memory manager   gpu/drm/drm_gem.c
> > - global reference unit     sgi-gru/grufile.c
> > - sgi special memory        char/mspec.c
> > - and probably several out-of-tree modules
> 
> What are your thoughts on the urgency/scheduling of this fix?

The panic can be caused by simply cat'ing /proc/<pid>/smaps while an
application has a VM_PFNMAP range.  It happened in-house when a benchmarker
was trying to decipher the memory layout of his program.
So that makes it rather urgent from our point of view.
We would like to see the fix included in upcoming distro releases, and having
it upstream makes that much easier to accomplish.

> (Just to be irritating: "When writing a changelog, please describe the
> end-user-visible effects of the bug, so that others can more easily
> decide which kernel version(s) should be fixed, and so that downstream
> kernel maintainers can more easily work out whether this patch will fix
> a problem which they or their customers are observing.")

