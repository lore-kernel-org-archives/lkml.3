Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaIIWVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:21:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34587 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaIIWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:21:36 -0400
Message-ID: <540F7D42.1020402@oracle.com>
Date: Tue, 09 Sep 2014 18:20:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de> <540127AC.4040804@oracle.com> <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de>
In-Reply-To: <20140909213309.GQ17501@suse.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 05:33 PM, Mel Gorman wrote:
> On Mon, Sep 08, 2014 at 01:56:55PM -0400, Sasha Levin wrote:
>> On 09/08/2014 01:18 PM, Mel Gorman wrote:
>>> A worse possibility is that somehow the lock is getting corrupted but
>>> that's also a tough sell considering that the locks should be allocated
>>> from a dedicated cache. I guess I could try breaking that to allocate
>>> one page per lock so DEBUG_PAGEALLOC triggers but I'm not very
>>> optimistic.
>>
>> I did see ptl corruption couple days ago:
>>
>> 	https://lkml.org/lkml/2014/9/4/599
>>
>> Could this be related?
>>
> 
> Possibly although the likely explanation then would be that there is
> just general corruption coming from somewhere. Even using your config
> and applying a patch to make linux-next boot (already in Tejun's tree)
> I was unable to reproduce the problem after running for several hours. I
> had to run trinity on tmpfs as ext4 and xfs blew up almost immediately
> so I have a few questions.

I agree it could be a case of random corruption somewhere else, it's just
that the amount of times this exact issue reproduced

> 1. What filesystem are you using?

virtio-9p. I'm willing to try something more "common" if you feel this could
be related, but I haven't seen any issues coming out of 9p in a while now.

> 2. What compiler in case it's an experimental compiler? I ask because I
>    think I saw a patch from you adding support so that the kernel would
>    build with gcc 5

Right, I've been testing with gcc 5 as well as Debian's gcc 4.7.2, it
reproduces with both compilers.

> 3. Does your hardware support TSX or anything similarly funky that would
>    potentially affect locking?

Not that I know of, here are the cpu flags for reference:

fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 x2apic popcnt lahf_lm ida epb dtherm tpr_shadow vnmi flexpriority ept vpid

> 4. How many sockets are on your test machine in case reproducing it
>    depends in a machine large enough to open a timing race?

128 sockets.

> As I'm drawing a blank on what would trigger the bug I'm hoping I can
> reproduce this locally and experiement a bit.

I was thinking about sneaking in something like the following (untested) patch
to see if it's really memory corruption that is wiping out stuff:
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 0f9724c..0205655 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -25,6 +25,7 @@
 #define _PAGE_BIT_SPLITTING    _PAGE_BIT_SOFTW2 /* only valid on a PSE pmd */
 #define _PAGE_BIT_IOMAP                _PAGE_BIT_SOFTW2 /* flag used to indicate IO mapping */
 #define _PAGE_BIT_HIDDEN       _PAGE_BIT_SOFTW3 /* hidden by kmemcheck */
+#define _PAGE_BIT_SANITY       _PAGE_BIT_SOFTW3 /* Memory corruption canary */
 #define _PAGE_BIT_SOFT_DIRTY   _PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */

@@ -66,6 +67,8 @@
 #define _PAGE_HIDDEN   (_AT(pteval_t, 0))
 #endif

+#define _PAGE_SANITY   (_AT(pteval_t, 1) << _PAGE_BIT_SANITY)
+
 /*
  * The same hidden bit is used by kmemcheck, but since kmemcheck
  * works on kernel pages while soft-dirty engine on user space,
@@ -312,7 +315,7 @@ static inline pmdval_t pmd_flags(pmd_t pmd)

 static inline pte_t native_make_pte(pteval_t val)
 {
-       return (pte_t) { .pte = val };
+       return (pte_t) { .pte = val | _PAGE_SANITY };
 }

 static inline pteval_t native_pte_val(pte_t pte)
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ffea570..bc897a1 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -720,6 +720,8 @@ static inline pmd_t pmd_mknonnuma(pmd_t pmd)
 static inline pte_t pte_mknuma(pte_t pte)
 {
        pteval_t val = pte_val(pte);
+
+       VM_BUG_ON(!(val & _PAGE_SANITY));

        VM_BUG_ON(!(val & _PAGE_PRESENT));

Does it make sense at all?


Thanks,
Sasha



