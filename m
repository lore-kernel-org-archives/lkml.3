Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaDHRVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:21:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29120 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaDHRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:21:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,819,1389744000"; 
   d="scan'208";a="117975078"
Message-ID: <53443018.2090408@citrix.com>
Date: Tue, 8 Apr 2014 18:21:28 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-X86 <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <1396962570-18762-1-git-send-email-mgorman@suse.de> <1396962570-18762-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1396962570-18762-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 14:09, Mel Gorman wrote:
> David Vrabel identified a regression when using automatic NUMA balancing
> under Xen whereby page table entries were getting corrupted due to the
> use of native PTE operations. Quoting him
> 
> 	Xen PV guest page tables require that their entries use machine
> 	addresses if the preset bit (_PAGE_PRESENT) is set, and (for
> 	successful migration) non-present PTEs must use pseudo-physical
> 	addresses.  This is because on migration MFNs in present PTEs are
> 	translated to PFNs (canonicalised) so they may be translated back
> 	to the new MFN in the destination domain (uncanonicalised).
> 
> 	pte_mknonnuma(), pmd_mknonnuma(), pte_mknuma() and pmd_mknuma()
> 	set and clear the _PAGE_PRESENT bit using pte_set_flags(),
> 	pte_clear_flags(), etc.
> 
> 	In a Xen PV guest, these functions must translate MFNs to PFNs
> 	when clearing _PAGE_PRESENT and translate PFNs to MFNs when setting
> 	_PAGE_PRESENT.
> 
> His suggested fix converted p[te|md]_[set|clear]_flags to using
> paravirt-friendly ops but this is overkill. He suggested an alternative of
> using p[te|md]_modify in the NUMA page table operations but this is does
> more work than necessary and would require looking up a VMA for protections.
> 
> This patch modifies the NUMA page table operations to use paravirt friendly
> operations to set/clear the flags of interest. Unfortunately this will take
> a performance hit when updating the PTEs on CONFIG_PARAVIRT but I do not
> see a way around it that does not break Xen.

Acked-by: David Vrabel <david.vrabel@citrix.com>

It passed my mprotect() PROT_NONE -> PROT_READ test case so

Tested-by: David Vrabel <david.vrabel@citrix.com>

I'll leave it up to the x86 maintainers to decide which fix to take.
This one or the more generic "x86: use pv-ops in
{pte,pmd}_{set,clear}_flags()"

David
