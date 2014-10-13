Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaJMUgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:36:32 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:58657 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbaJMUga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:36:30 -0400
Date: Mon, 13 Oct 2014 23:36:15 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 2/7] mm: Prepare for DAX huge pages
Message-ID: <20141013203615.GA30140@node.dhcp.inet.fi>
References: <1412774729-23956-1-git-send-email-matthew.r.wilcox@intel.com>
 <1412774729-23956-3-git-send-email-matthew.r.wilcox@intel.com>
 <20141008152124.GA7288@node.dhcp.inet.fi>
 <20141008155758.GK5098@wil.cx>
 <20141008194335.GA9232@node.dhcp.inet.fi>
 <20141009204026.GP5098@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009204026.GP5098@wil.cx>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:40:26PM -0400, Matthew Wilcox wrote:
> On Wed, Oct 08, 2014 at 10:43:35PM +0300, Kirill A. Shutemov wrote:
> > On Wed, Oct 08, 2014 at 11:57:58AM -0400, Matthew Wilcox wrote:
> > > On Wed, Oct 08, 2014 at 06:21:24PM +0300, Kirill A. Shutemov wrote:
> > > > On Wed, Oct 08, 2014 at 09:25:24AM -0400, Matthew Wilcox wrote:
> > > > > From: Matthew Wilcox <willy@linux.intel.com>
> > > > > 
> > > > > DAX wants to use the 'special' bit to mark PMD entries that are not backed
> > > > > by struct page, just as for PTEs. 
> > > > 
> > > > Hm. I don't see where you use PMD without special set.
> > > 
> > > Right ... I don't currently insert PMDs that point to huge pages of DRAM,
> > > only to huge pages of PMEM.
> > 
> > Looks like you don't need pmd_{mk,}special() then. It seems you have all
> > inforamtion you need -- vma -- to find out what's going on. Right?
> 
> That would prevent us from putting huge pages of DRAM into a VM_MIXEDMAP |
> VM_HUGEPAGE vma.  Is that acceptable to the wider peanut gallery?

We didn't have huge pages on VM_MIXEDMAP | VM_HUGEPAGE before and we don't
have them there after the patchset. Nothing changed.

It probably worth adding VM_BUG_ON() in some code path to be able to catch
this situation.

> > > > No private THP pages with THP? Why?
> > > > It should be trivial: we already have a code path for !page case for zero
> > > > page and it shouldn't be too hard to modify do_dax_pmd_fault() to support
> > > > COW.
> > > > 
> > > > I remeber I've mentioned that you don't think it's reasonable to allocate
> > > > 2M page on COW, but that's what we do for anon memory...
> > > 
> > > I agree that it shouldn't be too hard, but I have no evidence that it'll
> > > be a performance win to COW 2MB pages for MAP_PRIVATE.  I'd rather be
> > > cautious for now and we can explore COWing 2MB chunks in a future patch.
> > 
> > I would rather make it other way around: use the same apporoach as for
> > anon memory until data shows it's doesn't make any good. Then consider
> > switching COW for *both* anon and file THP to fallback path.
> > This way we will get consistent behaviour for both types of mappings.
> 
> I'm not sure that we want consistent behaviour for both types of mappings.
> My understanding is that they're used for different purposes, and having
> different bahaviour is acceptable.

This should be described in commit message along with other design
solutions (split wrt. mlock, etc) with their pros and cons.

-- 
 Kirill A. Shutemov
