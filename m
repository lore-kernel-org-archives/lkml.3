Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaLEJdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:33:12 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40931 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaLEJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:33:09 -0500
Message-ID: <1417771976.8400.8.camel@lnxlarper.se.axis.com>
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
From: Lars Persson <lars.persson@axis.com>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paul.burton@imgtec.com" <paul.burton@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "markos.chandras@imgtec.com" <markos.chandras@imgtec.com>
Date: Fri, 5 Dec 2014 10:32:56 +0100
In-Reply-To: <5481158D.1000409@imgtec.com>
References: <20141203032542.15388.17340.stgit@linux-yegoshin>
	 <1417599104.10996.16.camel@lnxlarper.se.axis.com>
	 <20141203134226.GC16063@linux-mips.org>
	 <1417615394.10198.3.camel@lnxlarper.se.axis.com>
	 <5481158D.1000409@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Our setup includes both a non-DMA block device and a compressing
file-system (UBIFS). A flush_dcache_page() is issued by UBIFS so your
patch fixes another problem that we do not hit.

The stack trace is not available now. Do we need it for any further
analysis ? I think the mechanism of the race window is understood and it
depends on the __flush_dcache_page() deciding that the flush should be
postponed.

- Lars

On Fri, 2014-12-05 at 03:16 +0100, Leonid Yegoshin wrote:
> (repeat mesg, first one went to wrong place)
> 
> Lars,
> 
> Do you have a stack trace or so then you found the second VPE between 
> set_pte_at and update_mmu_cache?
> It would be interesting how it happens - generally, to get a consistent 
> SIGILL in applications due to misbehaviour of memory subsystem, the bug 
> in FS is not enough.
> 
> Hold on - do you use non-DMA file system?
> If so, I advice you to try this simple patch:
> 
>      Author: Leonid Yegoshin <yegoshin@mips.com>
>      Date:   Tue Apr 2 14:20:37 2013 -0700
> 
>      MIPS: (opt) Fix of reading I-pages from non-DMA FS devices for ID 
> cache separation
> 
>      This optional fix provides a D-cache flush for instruction code 
> pages on
>      page faults. In case of non-DMA block device a driver doesn't know 
> that it
>      reads I-page and doesn't flush D-cache generally on systems without
>      cache aliasing. And that takes toll during page fault of 
> instruction pages.
> 
>      It is not a perfect fix, it should be considered as a temporary fix.
>      The permanent fix would track page origin in page cache and flushes 
> D-cache
>      during reception of page from driver only but not at each page fault.
>      It is not done yet.
> 
>      Change-Id: I43f5943d6ce0509729179615f6b81e77803a34ac
>      Author: Leonid Yegoshin <yegoshin@mips.com>
>      Signed-off-by: Leonid Yegoshin <yegoshin@mips.com>(imported from 
> commit 6ebd22eb7a3d9873582ebe990a77094f971652ee)(imported from commit 
> 0caf3b4a1eebb64572e81e4df6fdb3abf12c70
> 
> arch/mips/include/asm/cacheflush.h:
> 
>     @@ -61,6 +61,9 @@ static inline void flush_anon_page(struct 
> vm_area_struct *vma,
>      static inline void flush_icache_page(struct vm_area_struct *vma,
>             struct page *page)
>      {
>     +       if (cpu_has_dc_aliases ||
>     +           ((vma->vm_flags & VM_EXEC) && !cpu_has_ic_fills_f_dc))
>     +               __flush_dcache_page(page);
>      }
> 
>      extern void (*flush_icache_range)(unsigned long start, unsigned 
> long end);
> 
> 
> It fixed crash problems with non-DMA FS in a couple of our customers. 
> Without it the non-DMA root FS crashes are catastrophic in aliasing 
> systems but it is still a problem for I-cache too but much rare.
> 
> Unfortunately, it is also a performance hit, however is less than run a 
> page cache flush at each PTE setup. On 12/03/2014 06:03 AM, Lars Persson 
> wrote:
> > It is the flush_dcache_page() that was called from the file-system
> > reading the page contents into memory.
> >
> > - Lars
> >
> >
> 



