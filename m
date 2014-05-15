Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaENRJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:09:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:31443 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaENRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:09:49 -0400
Date: Thu, 15 May 2014 19:00:35 +0200
From: Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
To: Dave Hansen <dave@sr71.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Shay Goikhman <shay.goikhman@huawei.com>,
        Paul Mundt <paul.mundt@huawei.com>,
        Carlos Villavieja <villavieja@hps.utexas.edu>,
        Nacho Navarro <nacho.navarro@bsc.es>,
        "Avi Mendelson" <avi.mendelson@tce.technion.ac.il>,
        Yoav Etsion <yetsion@tce.technion.ac.il>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] x86, hugetlb: add missing TLB page invalidation for
 hugetlb_cow()
Message-ID: <20140515170035.GA15779@server-36.huawei.corp>
References: <20140514092948.GA17391@server-36.huawei.corp>
 <5372A067.9010808@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5372A067.9010808@sr71.net>
X-Originating-IP: [10.220.139.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:44:55PM -0700, Dave Hansen wrote:
> On 05/14/2014 02:29 AM, Anthony Iliopoulos wrote:
> > The invalidation is required in order to maintain proper semantics
> > under CoW conditions. In scenarios where a process clones several
> > threads, a thread operating on a core whose DTLB entry for a
> > particular hugepage has not been invalidated, will be reading from
> > the hugepage that belongs to the forked child process, even after
> > hugetlb_cow().
> > 
> > The thread will not see the updated page as long as the stale DTLB
> > entry remains cached, the thread attempts to write into the page,
> > the child process exits, or the thread gets migrated to a different
> > processor.
> 
> No to be too nitpicky, but this applies to ITLB too, right?

Quite true, this does apply to ITLB too. I suppose there might be cases
like self-modifying code that touches the private text pages, or some
JIT compiler writing on mmap-ed executable regions that would observe
the same behavior under similar conditions.

> I believe this bug came all the way back from:
> 
> > commit 1e8f889b10d8d2223105719e36ce45688fedbd59
> > Author: David Gibson <david@gibson.dropbear.id.au>
> > Date:   Fri Jan 6 00:10:44 2006 -0800
> > 
> >     [PATCH] Hugetlb: Copy on Write support
> 
> It was probably the first time that we ever changed an _existing_
> hugetlbfs pte, and that patch probably just missed the TLB flush because
> none of the other pte-setting hugetlb.c code needed TLB flushes.

This seems to be the case, I assume that our internal use case was
also probably the first that needed to rely on proper semantics under
a multithreaded CoW scenario with hugetlb pages, so this came into
the surface.

I have actually also wondered about another related thing:
even when we actually do invalidate the page, there may still be a
race between a thread on a core that reads the page in some tight
loop (e.g. on a spinlock), and the page fault handler running on
a different core, at the point where the pte is set. Since we
invalidate the page via the TLB shootdowns *before* we update
the pte (this is true for all do_wp_page(), do_huge_pmd_wp_page()
as well as hugetlb_cow()), there may be some tiny window where the
thread might re-read the page before the pte is set.

I have dismissed this case, since I assume that there are many more
cycles spent in servicing the TLB invalidation IPI, walking the pgtable
plus other related overhead (e.g. sched) than in updating the pte/pmd
so I am not sure how possible it would be to hit this condition.

I am also hesitant to simply submit a patch that reverses the order
of flushing and setting the pte, due to the following commit:

    commit 4ce072f1faf29d24df4600f53db8cdd62d400a8f
    Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
    Date:   Fri Sep 29 01:58:42 2006 -0700

    [PATCH] mm: fix a race condition under SMC + COW

> The bogus x86 version of huge_ptep_clear_flush() came from the s390
> guys, so double-shame on IBM! :P
> 
> > commit 8fe627ec5b7c47b1654dff50536d9709863295a3
> > Author: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > Date:   Mon Apr 28 02:13:28 2008 -0700
> > 
> >     hugetlbfs: add missing TLB flush to hugetlb_cow()
> 
> This is probably an opportunity for all the other architecture
> maintainers to make sure that they have proper copies of
> huge_ptep_clear_flush().
> 
> I went through the hugetlb code on x86 and couldn't find another TLB
> flush that fixes this issue, and I believe this is correct, so:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>

Many thanks for confirming, and for your prompt response.

Regards,
Anthony
