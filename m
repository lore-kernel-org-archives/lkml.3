Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaLCT2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:28:53 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:13465 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaLCT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:28:52 -0500
Message-ID: <547F646F.6020008@imgtec.com>
Date: Wed, 3 Dec 2014 11:28:47 -0800
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lars Persson <lars.persson@axis.com>, Ralf Baechle <ralf@linux-mips.org>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paul.burton@imgtec.com" <paul.burton@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "markos.chandras@imgtec.com" <markos.chandras@imgtec.com>
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
References: <20141203032542.15388.17340.stgit@linux-yegoshin>	 <1417599104.10996.16.camel@lnxlarper.se.axis.com>	 <20141203134226.GC16063@linux-mips.org> <1417615394.10198.3.camel@lnxlarper.se.axis.com>
In-Reply-To: <1417615394.10198.3.camel@lnxlarper.se.axis.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars,

Do you have a stack trace or so then you found the second VPE between 
set_pte_at and update_mmu_cache?
It would be interesting how it happens - generally, to get a consistent 
SIGILL in applications due to misbehaviour of memory subsystem, the bug 
in FS is not enough.

Hold on - do you use non-DMA file system?
If so, I advice you to try this simple patch:

Author: Leonid Yegoshin <yegoshin@mips.com>
Date:   Tue Apr 2 14:20:37 2013 -0700

     MIPS: (opt) Fix of reading I-pages from non-DMA FS devices for ID 
cache separation

     This optional fix provides a D-cache flush for instruction code 
pages on
     page faults. In case of non-DMA block device a driver doesn't know 
that it
     reads I-page and doesn't flush D-cache generally on systems without
     cache aliasing. And that takes toll during page fault of 
instruction pages.

     It is not a perfect fix, it should be considered as a temporary fix.
     The permanent fix would track page origin in page cache and flushes 
D-cache
     during reception of page from driver only but not at each page fault.
     It is not done yet.

     Change-Id: I43f5943d6ce0509729179615f6b81e77803a34ac
     Author: Leonid Yegoshin <yegoshin@mips.com>
     Signed-off-by: Leonid Yegoshin <yegoshin@mips.com>(imported from 
commit 6ebd22eb7a3d9873582ebe990a77094f971652ee)(imported from commit 
0caf3b4a1eebb64572e81e4df6fdb3abf12c70

diff --git a/arch/mips/include/asm/cacheflush.h 
b/arch/mips/include/asm/cacheflush.h
index 42e5fc682590..27b17b16a96d 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -61,6 +61,9 @@ static inline void flush_anon_page(struct 
vm_area_struct *vma,
  static inline void flush_icache_page(struct vm_area_struct *vma,
         struct page *page)
  {
+       if (cpu_has_dc_aliases ||
+           ((vma->vm_flags & VM_EXEC) && !cpu_has_ic_fills_f_dc))
+               __flush_dcache_page(page);
  }

  extern void (*flush_icache_range)(unsigned long start, unsigned long end);


It fixed crash problems with non-DMA FS in a couple of our customers. 
Without it the non-DMA root FS crashes are catastrophic in aliasing 
systems but it is still a problem for I-cache too but much rare.

Unfortunately, it is also a performance hit, however is less than run a 
page cache flush at each PTE setup.

- Leonid.

On 12/03/2014 06:03 AM, Lars Persson wrote:
> It is the flush_dcache_page() that was called from the file-system 
> reading the page contents into memory. - Lars On Wed, 2014-12-03 at 
> 14:42 +0100, Ralf Baechle wrote:
>> Lars, normally set_pte_at() is invoked in a cache_flush_*() 
>> set_pte_at() tlb_flush_*() sequence. So I'm wondering if you're 
>> trying to fix something in set_pte_at that actually ought to be fixed 
>> in the cache_flush_*() function. I'm wondering, have you identified 
>> which cache flush function in particular was used in the sequence in 
>> your particular bug's case? Ralf 
>

