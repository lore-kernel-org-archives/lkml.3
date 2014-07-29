Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaG2B4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:56:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:43456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaG2B4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:56:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,753,1400050800"; 
   d="scan'208";a="576879339"
From: "Zhang, Tianfei" <tianfei.zhang@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@linux.intel.com>
CC: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 05/22] Add vm_replace_mixed()
Thread-Topic: [PATCH v8 05/22] Add vm_replace_mixed()
Thread-Index: AQHPqmfU//4Qq8M5pEOi/SgrMTNcHpu2QtUA
Date: Tue, 29 Jul 2014 01:55:17 +0000
Message-ID: <BA6F50564D52C24884F9840E07E32DEC17D74A50@CDSMSX102.ccr.corp.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
 <20140723135221.GA6754@linux.intel.com>
 <20140723142048.GA11963@node.dhcp.inet.fi>
 <20140723142745.GD6754@linux.intel.com>
 <20140723155500.GA12790@node.dhcp.inet.fi>
 <20140725194450.GJ6754@linux.intel.com>
 <20140728132558.GA967@node.dhcp.inet.fi>
In-Reply-To: <20140728132558.GA967@node.dhcp.inet.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.17.6.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> Behalf Of Kirill A. Shutemov
> Sent: Monday, July 28, 2014 9:26 PM
> To: Matthew Wilcox
> Cc: Wilcox, Matthew R; linux-fsdevel@vger.kernel.org; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
> 
> On Fri, Jul 25, 2014 at 03:44:50PM -0400, Matthew Wilcox wrote:
> > On Wed, Jul 23, 2014 at 06:55:00PM +0300, Kirill A. Shutemov wrote:
> > > >         update_hiwater_rss(mm);
> > >
> > > No: you cannot end up with lower rss after replace, iiuc.
> >
> > Actually, you can ... when we replace a real page with a PFN, our rss
> > decreases.
> 
> Okay.
> 
> > > Do you mean you pointed to new file all the time? O_CREAT doesn't
> > > truncate file if it exists, iirc.
> >
> > It was pointing to a new file.  Still not sure why that one failed to
> > trigger the problem.  The slightly modified version attached triggered
> > the problem *just fine* :-)
> >
> > I've attached all the patches in my tree so far.  For the v9 patch
> > kit, I'll keep patch 3 as a separate patch, but roll patches 1, 2 and
> > 4 into other patches.
> >
> > I am seeing something odd though.  When I run double-map with
> > debugging printks inserted in strategic spots in the kernel, I see
> > four calls to do_dax_fault().  The first two, as expected, are the
> > loads from the two mapped addresses.  The third is via mkwrite, but
> > then the fourth time I get a regular page fault for write, and I don't
> understand why I get it.
> >
> > Any ideas?
> 
> unmap_mapping_range() clears pte you've just set by vm_replace_mixed() on
> third fault.
> 
> And locking looks wrong: it seems you need to hold i_mmap_mutex while
> replacing hole page with pfn. Your VM_BUG_ON() in zap_pte_single() triggers
> on my setup.
> 
> > +static void zap_pte_single(struct vm_area_struct *vma, pte_t *pte,
> > +				unsigned long addr)
> > +{
> > +	struct mm_struct *mm = vma->vm_mm;
> > +	int force_flush = 0;
> > +	int rss[NR_MM_COUNTERS];
> > +
> > +
> 	VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_m
> utex));
> 
> It's wrong place for VM_BUG_ON(): zap_pte_single() on anon mapping should
> work fine)

Hi Shutemov:
1. I am confuse that why insert_page() drop the PageAnon, insert_pfn() donot drop PageAnon?

2. 
remap_vmalloc_range() -> vm_insert_page()->insert_page() -> inc_mm_counter_fast(mm, MM_FILEPAGES);

so, in this scenario, this vmalloc page maybe not sure be a page cache, why increase the MM_FILEPAGES ?


> 
> > +
> > +	init_rss_vec(rss);
> 
> Vector to commit single update to mm counters? What about inline counters
> update for rss == NULL case?
> 
> > +	update_hiwater_rss(mm);
> > +	flush_cache_page(vma, addr, pte_pfn(*pte));
> > +	zap_pte(NULL, vma, pte, addr, NULL, rss, &force_flush);
> > +	flush_tlb_page(vma, addr);
> > +	add_mm_rss_vec(mm, rss);
> > +}
> > +
> 
> --
>  Kirill A. Shutemov
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in the body to
> majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
