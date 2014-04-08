Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbaDHQrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbaDHQq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:46:59 -0400
Date: Tue, 8 Apr 2014 17:46:52 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
Message-ID: <20140408164652.GL7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <53440A5D.6050301@zytor.com>
 <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 08:22:15AM -0700, Linus Torvalds wrote:
> On Tue, Apr 8, 2014 at 7:40 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > David, is your patchset going to be pushed in this merge window as expected?
> 
> Apparently aiming for 3.16 right now.
> 

> > That being said, these bits are precious, and if this ends up being a
> > case where "only Xen needs another bit" once again then Xen should
> > expect to get kicked to the curb at a moment's notice.
> 
> Quite frankly, I don't think it's a Xen-only issue. The code was hard
> to figure out even without the Xen issues. For example, nobody ever
> explained to me why it
> 
>  (a) could be the same as PROTNONE on x86
>  (b) could not be the same as PROTNONE in general

This series exists in response to your comment

	I fundamentally think that it was a horrible horrible disaster to
	make _PAGE_NUMA alias onto _PAGE_PROTNONE.

As long as _PAGE_NUMA aliases to _PAGE_PROTNONE on x86 then the core has to
play games to take that into account and the code will be "hard to figure
out even without the Xen issues". FWIW, ppc64 already uses a different
bit to identify a NUMA pte so it's already the case that _PAGE_NUMA is
not always _PAGE_PROTNONE. The series is an alternative approach but it
needs to use a different bit.

If you are ok with leaving _PAGE_NUMA as _PAGE_PROTNONE on x86 then most of
this series goes away and we're left patch 1 (as NUMA_BALANCING on 32-bit is
pointless) and "[PATCH 4/5] mm: use paravirt friendly ops for NUMA hinting
ptes" which is an (untested on Xen) alternative to David Vrabel's patch
"x86: use pv-ops in {pte,pmd}_{set,clear}_flags()".  The alternative patch
modifies the NUMA PTE helpers instead of the main set/clear helpers to
limit the performance hit when PARAVIRT is enabled.

Someone will ask why automatic NUMA balancing hints do not use "real"
PROT_NONE but as it would need VMA information to do that on all
architectures it would mean that VMA-fixups would be required when marking
PTEs for NUMA hinting faults so would be expensive.

-- 
Mel Gorman
SUSE Labs
