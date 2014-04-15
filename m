Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaDOOob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:44:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbaDOOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:44:28 -0400
Date: Tue, 15 Apr 2014 15:44:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Linux-X86 <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Noonan <steven@uplinklabs.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] mm: use paravirt friendly ops for NUMA hinting ptes
Message-ID: <20140415144423.GV7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <1396962570-18762-5-git-send-email-mgorman@suse.de>
 <534D09AC.7020704@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <534D09AC.7020704@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:27:56AM +0100, David Vrabel wrote:
> On 08/04/14 14:09, Mel Gorman wrote:
> > David Vrabel identified a regression when using automatic NUMA balancing
> > under Xen whereby page table entries were getting corrupted due to the
> > use of native PTE operations. Quoting him
> > 
> > 	Xen PV guest page tables require that their entries use machine
> > 	addresses if the preset bit (_PAGE_PRESENT) is set, and (for
> > 	successful migration) non-present PTEs must use pseudo-physical
> > 	addresses.  This is because on migration MFNs in present PTEs are
> > 	translated to PFNs (canonicalised) so they may be translated back
> > 	to the new MFN in the destination domain (uncanonicalised).
> > 
> > 	pte_mknonnuma(), pmd_mknonnuma(), pte_mknuma() and pmd_mknuma()
> > 	set and clear the _PAGE_PRESENT bit using pte_set_flags(),
> > 	pte_clear_flags(), etc.
> > 
> > 	In a Xen PV guest, these functions must translate MFNs to PFNs
> > 	when clearing _PAGE_PRESENT and translate PFNs to MFNs when setting
> > 	_PAGE_PRESENT.
> > 
> > His suggested fix converted p[te|md]_[set|clear]_flags to using
> > paravirt-friendly ops but this is overkill. He suggested an alternative of
> > using p[te|md]_modify in the NUMA page table operations but this is does
> > more work than necessary and would require looking up a VMA for protections.
> > 
> > This patch modifies the NUMA page table operations to use paravirt friendly
> > operations to set/clear the flags of interest. Unfortunately this will take
> > a performance hit when updating the PTEs on CONFIG_PARAVIRT but I do not
> > see a way around it that does not break Xen.
> 
> We're getting more reports of users hitting this regression with distro
> provided kernels.  Irrespective of the rest of this series, can we get
> at least this applied and tagged for stable, please?
> 
> http://lists.xenproject.org/archives/html/xen-devel/2014-04/msg01905.html
> 

The resending of the series got delayed until today. Fengguang Wu hit
problems testing the series and I ran into a number of similarly shaped
problems that took time to resolve. I sent out a v4 of the series with this
patch at the front and a note on the leader saying it should be picked up
for stable regardless of what happens with the patches 2 and 3.

-- 
Mel Gorman
SUSE Labs
