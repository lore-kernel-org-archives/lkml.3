Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbbA0QRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:17:25 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:41163 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbbA0QRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:17:21 -0500
Date: Tue, 27 Jan 2015 18:16:57 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: mmotm 2015-01-22-15-04: qemu failures due to 'mm: account pmd
 page tables to the process'
Message-ID: <20150127161657.GA7155@node.dhcp.inet.fi>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
 <20150123050445.GA22751@roeck-us.net>
 <20150123111304.GA5975@node.dhcp.inet.fi>
 <54C263CC.1060904@roeck-us.net>
 <20150123135519.9f1061caf875f41f89298d59@linux-foundation.org>
 <20150124055207.GA8926@roeck-us.net>
 <20150126122944.GE25833@node.dhcp.inet.fi>
 <54C6494D.80802@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C6494D.80802@roeck-us.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:03:57AM -0800, Guenter Roeck wrote:
> On 01/26/2015 04:29 AM, Kirill A. Shutemov wrote:
> >On Fri, Jan 23, 2015 at 09:52:07PM -0800, Guenter Roeck wrote:
> >>On Fri, Jan 23, 2015 at 01:55:19PM -0800, Andrew Morton wrote:
> >>>On Fri, 23 Jan 2015 07:07:56 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
> >>>
> >>>>>>
> >>>>>>qemu:microblaze generates warnings to the console.
> >>>>>>
> >>>>>>WARNING: CPU: 0 PID: 32 at mm/mmap.c:2858 exit_mmap+0x184/0x1a4()
> >>>>>>
> >>>>>>with various call stacks. See
> >>>>>>http://server.roeck-us.net:8010/builders/qemu-microblaze-mmotm/builds/15/steps/qemubuildcommand/logs/stdio
> >>>>>>for details.
> >>>>>
> >>>>>Could you try patch below? Completely untested.
> >>>>>
> >>>>>>From b584bb8d493794f67484c0b57c161d61c02599bc Mon Sep 17 00:00:00 2001
> >>>>>From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >>>>>Date: Fri, 23 Jan 2015 13:08:26 +0200
> >>>>>Subject: [PATCH] microblaze: define __PAGETABLE_PMD_FOLDED
> >>>>>
> >>>>>Microblaze uses custom implementation of PMD folding, but doesn't define
> >>>>>__PAGETABLE_PMD_FOLDED, which generic code expects to see. Let's fix it.
> >>>>>
> >>>>>Defining __PAGETABLE_PMD_FOLDED will drop out unused __pmd_alloc().
> >>>>>It also fixes problems with recently-introduced pmd accounting.
> >>>>>
> >>>>>Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >>>>>Reported-by: Guenter Roeck <linux@roeck-us.net>
> >>>>
> >>>>Tested working.
> >>>>
> >>>>Tested-by: Guenter Roeck <linux@roeck-us.net>
> >>>>
> >>>>Any idea how to fix the sh problem ?
> >>>
> >>>Can you tell us more about it?  All I'm seeing is "qemu:sh fails to
> >>>shut down", which isn't very clear.
> >>
> >>Turns out that the include file defining __PAGETABLE_PMD_FOLDED
> >>was not always included where used, resulting in a messed up mm_struct.
> >
> >What means "messed up" here? It should only affect size of mm_struct.
> >
> Plus the offset of all variables after the #ifndef.

Okay, I guess the problem is that different parts of the kernel see
different mm_struct depending on include ordering.

Tried to look for options, but don't see anything better than patch below.
Andrew, is it okay to you?

>From 0f113e16a058d47f3bc63a3b6ced5296afb934a6 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Tue, 27 Jan 2015 17:59:55 +0200
Subject: [PATCH] mm: add nr_pmds into mm_struct unconditionally

__PAGETABLE_PMD_FOLDED is defined during <asm/pgtable.h> which is not
included into <linux/mm_types.h>. And we cannot include it here since
many of <asm/pgtables> needs <linux/mm_types.h> to define struct page.

I failed to come up with better solution rather than put nr_pmds into
mm_struct unconditionally.

One possible solution would be to expose number of page table levels
architecture has via Kconfig, but that's ugly and requires changes to
all architectures.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm_types.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 79cdf6f5c746..199a03aab8dc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -364,9 +364,7 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	atomic_long_t nr_ptes;			/* PTE page table pages */
-#ifndef __PAGETABLE_PMD_FOLDED
 	atomic_long_t nr_pmds;			/* PMD page table pages */
-#endif
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
-- 
 Kirill A. Shutemov
