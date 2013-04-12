Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3DLNlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:41:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab3DLNlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:41:09 -0400
Date: Fri, 12 Apr 2013 15:42:02 +0200
From: chrubis@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: Check for RLIMIT_AS before unmapping
Message-ID: <20130412134202.GA2764@rei.scz.novell.com>
References: <20130402095402.GA6568@rei>
 <20130411155734.911dc8bf8e555b169191be5a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411155734.911dc8bf8e555b169191be5a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > +static unsigned long count_vma_pages_range(struct mm_struct *mm,
> > +		unsigned long addr, unsigned long end)
> > +{
> > +	unsigned long nr_pages = 0;
> > +	struct vm_area_struct *vma;
> > +
> > +	/* Find first overlaping mapping */
> > +	vma = find_vma_intersection(mm, addr, end);
> > +	if (!vma)
> > +		return 0;
> > +
> > +	nr_pages = (min(end, vma->vm_end) -
> > +		max(addr, vma->vm_start)) >> PAGE_SHIFT;
> 
> urgh, these things always make my head spin.  Is it guaranteed that
> end, vm_end, addr and vm_start are all multiples of PAGE_SIZE?  If not,
> we have a problem don't we?

Yes, it takes a little of concentration before one can say what the code
does, unfortunatelly this is the most readable variant I've came up
with.

The len is page aligned right at the start of the do_mmap_pgoff() (end
is addr + len). The addr should be aligned in the get_unmapped_area()
although the codepath is more complicated to follow, but it seems to end
up in one of the arch_get_unmapped_area* and these makes sure the
address is aligned.

Moreover mmap() manual page says that the addr passed to mmap() is page
aligned (although I tend to check the code rather than the docs).

And for the vmas I belive these are page aligned by definition, correct
me if I'm wrong.

-- 
Cyril Hrubis
chrubis@suse.cz
