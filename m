Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaLEVld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:41:33 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:60418 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaLEVlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:41:31 -0500
Message-ID: <54822685.8070504@imgtec.com>
Date: Fri, 5 Dec 2014 13:41:25 -0800
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lars Persson <lars.persson@axis.com>
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
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
References: <20141203032542.15388.17340.stgit@linux-yegoshin>	 <1417599104.10996.16.camel@lnxlarper.se.axis.com>	 <20141203134226.GC16063@linux-mips.org>	 <1417615394.10198.3.camel@lnxlarper.se.axis.com>	 <5481158D.1000409@imgtec.com> <1417771976.8400.8.camel@lnxlarper.se.axis.com>
In-Reply-To: <1417771976.8400.8.camel@lnxlarper.se.axis.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars,

On 12/05/2014 01:32 AM, Lars Persson wrote:
> Hi
>
> Our setup includes both a non-DMA block device and a compressing
> file-system (UBIFS). A flush_dcache_page() is issued by UBIFS so your
> patch fixes another problem that we do not hit.
>
> The stack trace is not available now. Do we need it for any further
> analysis ? I think the mechanism of the race window is understood and it
> depends on the __flush_dcache_page() deciding that the flush should be
> postponed.

Unfortunately, the research of original case is still needed.
I looked into all cases of update_mmu_cache() besides HUGE page support 
and NUMA, and I see:

1.  insert_pfn()
     It is used to put a special page (read - VDSO) into memory map. No 
cache flush is needed here because page is done and flushed during 
system boot.

2.  do_wp_page(), first occurrence
     It has flush_cache_page() before it sets PTE in 
ptep_set_access_flags(). This flush is unconditional and affects all caches.

3.  do_wp_page(), second case
     It is done after preparing a clear new page or after COW. COW has 
an appropriate cache flush of destination in copy_user_highpage(). The 
immediate use of cleared new page as instruction (you had SIGILL, 
right?)... hm-m, something wrong in application in this case.

4.  do_swap_page()
     Well, it may be a case of flush_icache_page() is not used (see 
below) and page is taken from non-DMA swap. But I also recommend to look 
into

         http://patchwork.linux-mips.org/patch/7615/

there is a bug in swap entry number presentation and it may affect your 
system.

5.  do_anonymous_page()
     The similar to case (3) - cleared new page, using of it as 
instruction page may point to some app problem.

6.  do_set_pte()
     It also has flush_icache_page() which may have impact if not 
implemented, see below.

7.  handle_pte_fault()
     Page is not touched and cache flush is NO-OP.

8.  remove_migration_pte()
     Well, it is a place for suspicion. But it should not run in 
parallel with any running thread - dirtying page while other thread is 
running is a way to disaster.

So, you see - if I understand it correctly, there is no place for 
failure... besides application misbehaviour or potential kernel bug in 
migration. Of course, I may miss something and that is a reason why 
stack trace is desirable.


> I think the mechanism of the race window is understood and it
> depends on the __flush_dcache_page() deciding that the flush should be
> postponed.

As I remember, you said you use HIGHMEM patch, right? It changes a 
little __flush_dcache_page() and flush of any mapped page is not 
postponed anymore. So, it has an immediate effect for application pages.

- Leonid.

>
>
> - Lars
>
> On Fri, 2014-12-05 at 03:16 +0100, Leonid Yegoshin wrote:
>> (repeat mesg, first one went to wrong place)
>>
>> Lars,
>>
>> Do you have a stack trace or so then you found the second VPE between
>> set_pte_at and update_mmu_cache?
>> It would be interesting how it happens - generally, to get a consistent
>> SIGILL in applications due to misbehaviour of memory subsystem, the bug
>> in FS is not enough.
>>
>> Hold on - do you use non-DMA file system?
>> If so, I advice you to try this simple patch:
>>
>>       Author: Leonid Yegoshin <yegoshin@mips.com>
>>       Date:   Tue Apr 2 14:20:37 2013 -0700
>>
>>       MIPS: (opt) Fix of reading I-pages from non-DMA FS devices for ID
>> cache separation
>>
>>       This optional fix provides a D-cache flush for instruction code
>> pages on
>>       page faults. In case of non-DMA block device a driver doesn't know
>> that it
>>       reads I-page and doesn't flush D-cache generally on systems without
>>       cache aliasing. And that takes toll during page fault of
>> instruction pages.
>>
>>       It is not a perfect fix, it should be considered as a temporary fix.
>>       The permanent fix would track page origin in page cache and flushes
>> D-cache
>>       during reception of page from driver only but not at each page fault.
>>       It is not done yet.
>>
>>       Change-Id: I43f5943d6ce0509729179615f6b81e77803a34ac
>>       Author: Leonid Yegoshin <yegoshin@mips.com>
>>       Signed-off-by: Leonid Yegoshin <yegoshin@mips.com>(imported from
>> commit 6ebd22eb7a3d9873582ebe990a77094f971652ee)(imported from commit
>> 0caf3b4a1eebb64572e81e4df6fdb3abf12c70
>>
>> arch/mips/include/asm/cacheflush.h:
>>
>>      @@ -61,6 +61,9 @@ static inline void flush_anon_page(struct
>> vm_area_struct *vma,
>>       static inline void flush_icache_page(struct vm_area_struct *vma,
>>              struct page *page)
>>       {
>>      +       if (cpu_has_dc_aliases ||
>>      +           ((vma->vm_flags & VM_EXEC) && !cpu_has_ic_fills_f_dc))
>>      +               __flush_dcache_page(page);
>>       }
>>
>>       extern void (*flush_icache_range)(unsigned long start, unsigned
>> long end);
>>
>>
>> It fixed crash problems with non-DMA FS in a couple of our customers.
>> Without it the non-DMA root FS crashes are catastrophic in aliasing
>> systems but it is still a problem for I-cache too but much rare.
>>
>> Unfortunately, it is also a performance hit, however is less than run a
>> page cache flush at each PTE setup. On 12/03/2014 06:03 AM, Lars Persson
>> wrote:
>>> It is the flush_dcache_page() that was called from the file-system
>>> reading the page contents into memory.
>>>
>>> - Lars
>>>
>>>
>
>

