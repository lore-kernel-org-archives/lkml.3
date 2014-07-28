Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaG1N04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:26:56 -0400
Received: from mta-out1.inet.fi ([62.71.2.232]:34260 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaG1N0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:26:52 -0400
Date: Mon, 28 Jul 2014 16:25:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
Message-ID: <20140728132558.GA967@node.dhcp.inet.fi>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
 <20140723135221.GA6754@linux.intel.com>
 <20140723142048.GA11963@node.dhcp.inet.fi>
 <20140723142745.GD6754@linux.intel.com>
 <20140723155500.GA12790@node.dhcp.inet.fi>
 <20140725194450.GJ6754@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725194450.GJ6754@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:44:50PM -0400, Matthew Wilcox wrote:
> On Wed, Jul 23, 2014 at 06:55:00PM +0300, Kirill A. Shutemov wrote:
> > >         update_hiwater_rss(mm);
> > 
> > No: you cannot end up with lower rss after replace, iiuc.
> 
> Actually, you can ... when we replace a real page with a PFN, our rss
> decreases.

Okay.

> > Do you mean you pointed to new file all the time? O_CREAT doesn't truncate
> > file if it exists, iirc.
> 
> It was pointing to a new file.  Still not sure why that one failed to trigger
> the problem.  The slightly modified version attached triggered the problem
> *just fine* :-)
> 
> I've attached all the patches in my tree so far.  For the v9 patch kit,
> I'll keep patch 3 as a separate patch, but roll patches 1, 2 and 4 into
> other patches.
> 
> I am seeing something odd though.  When I run double-map with debugging
> printks inserted in strategic spots in the kernel, I see four calls to
> do_dax_fault().  The first two, as expected, are the loads from the two
> mapped addresses.  The third is via mkwrite, but then the fourth time
> I get a regular page fault for write, and I don't understand why I get it.
> 
> Any ideas?

unmap_mapping_range() clears pte you've just set by vm_replace_mixed() on
third fault.

And locking looks wrong: it seems you need to hold i_mmap_mutex while
replacing hole page with pfn. Your VM_BUG_ON() in zap_pte_single()
triggers on my setup.

> +static void zap_pte_single(struct vm_area_struct *vma, pte_t *pte,
> +				unsigned long addr)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	int force_flush = 0;
> +	int rss[NR_MM_COUNTERS];
> +
> +	VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));

It's wrong place for VM_BUG_ON(): zap_pte_single() on anon mapping should
work fine)

> +
> +	init_rss_vec(rss);

Vector to commit single update to mm counters? What about inline counters
update for rss == NULL case?

> +	update_hiwater_rss(mm);
> +	flush_cache_page(vma, addr, pte_pfn(*pte));
> +	zap_pte(NULL, vma, pte, addr, NULL, rss, &force_flush);
> +	flush_tlb_page(vma, addr);
> +	add_mm_rss_vec(mm, rss);
> +}
> +

-- 
 Kirill A. Shutemov
