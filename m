Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3LCMZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:25:14 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:46766 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3LCMZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:25:11 -0500
MIME-Version: 1.0
In-Reply-To: <529DC632.9010107@iki.fi>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee>
	<529DC632.9010107@iki.fi>
Date: Tue, 3 Dec 2013 21:25:09 +0900
Message-ID: <CAAmzW4N=2--OuOFVEME3FJa7uFCkVEYJp=9DbSBVOPjiXnLxcg@mail.gmail.com>
Subject: Re: Slab BUG with DEBUG_* options
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Meelis Roos <mroos@linux.ee>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/3 Pekka Enberg <penberg@iki.fi>:
> On 11/30/2013 01:42 PM, Meelis Roos wrote:
>>
>> I am debugging a reboot problem on Sun Ultra 5 (sparc64) with 512M RAM
>> and turned on DEBUG_PAGEALLOC DEBUG_SLAB and DEBUG_SLAB_LEAK (and most
>> other debug options) and got the following BUG and hang on startup. This
>> happened originally with 3.11-rc2-00058 where my bisection of
>> another problem lead, but I retested 3.12 to have the same BUG in the
>> same place.
>>
>> kernel BUG at mm/slab.c:2391!
>>                \|/ ____ \|/
>>                "@'/ .. \`@"
>>                /_| \__/ |_\
>>                   \__U_/
>> swapper(0): Kernel bad sw trap 5 [#1]
>> CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-rc2-00058-g20bafb3-dirty
>> #127
>> task: 00000000008ac468 ti: 000000000089c000 task.ti: 000000000089c000
>> TSTATE: 0000004480e01606 TPC: 00000000004f57d4 TNPC: 00000000004f57d8 Y:
>> 00000000    Not tainted
>> TPC: <__kmem_cache_create+0x374/0x480>
>> g0: 00000000000000f8 g1: 00000000008bb400 g2: 000000000002780b g3:
>> 00000000008b5120
>> g4: 00000000008ac468 g5: 0000000000000000 g6: 000000000089c000 g7:
>> 0000000000000000
>> o0: 0000000000845f08 o1: 0000000000000957 o2: ffffffffffffffe0 o3:
>> 0000000000000000
>> o4: 0000000000002004 o5: 0000000000000000 sp: 000000000089f301 ret_pc:
>> 00000000004f57cc
>> RPC: <__kmem_cache_create+0x36c/0x480>
>> l0: fffff8001e812040 l1: fffff8001e819f80 l2: fffff8001e819fb8 l3:
>> fffff8001e819fd8
>> l4: 0000000000000001 l5: fffff8001e819fc8 l6: 0000000000845f08 l7:
>> fffff8001e8300a0
>> i0: fffff8001e831fa0 i1: 0000000080002800 i2: 0000000080000000 i3:
>> 0000000000000034
>> i4: 0000000000000000 i5: 0000000000002000 i6: 000000000089f3b1 i7:
>> 0000000000907464
>> I7: <create_boot_cache+0x4c/0x84>
>> Call Trace:
>>   [0000000000907464] create_boot_cache+0x4c/0x84
>>   [00000000009074d0] create_kmalloc_cache+0x34/0x60
>>   [0000000000907540] create_kmalloc_caches+0x44/0x168
>>   [0000000000908dfc] kmem_cache_init+0x1d0/0x1e0
>>   [00000000008fc658] start_kernel+0x18c/0x370
>>   [0000000000761df4] tlb_fixup_done+0x88/0x94
>>   [0000000000000000]           (null)
>> Disabling lock debugging due to kernel taint
>> Caller[0000000000907464]: create_boot_cache+0x4c/0x84
>> Caller[00000000009074d0]: create_kmalloc_cache+0x34/0x60
>> Caller[0000000000907540]: create_kmalloc_caches+0x44/0x168
>> Caller[0000000000908dfc]: kmem_cache_init+0x1d0/0x1e0
>> Caller[00000000008fc658]: start_kernel+0x18c/0x370
>> Caller[0000000000761df4]: tlb_fixup_done+0x88/0x94
>> Caller[0000000000000000]:           (null)
>> Instruction DUMP: 92102957  7ffccb35  90122308 <91d02005> 90100018
>> 4009b371  920f20d0  ba922000  02480006
>> Kernel panic - not syncing: Attempted to kill the idle task!
>> Press Stop-A (L1-A) to return to the boot prom
>>
>> The line shows that __kmem_cache_create gets a NULL from kmalloc_slab().
>>
>> I instrumented the code and found the following:
>>
>> __kmem_cache_create: starting, size=248, flags=8192
>> __kmem_cache_create: now flags=76800
>> __kmem_cache_create: aligned size to 248 because of redzoning
>> __kmem_cache_create: pagealloc debug, setting size to 8192
>> __kmem_cache_create: aligned size to 8192
>> __kmem_cache_create: num=1, slab_size=64
>> __kmem_cache_create: starting, size=96, flags=8192
>> __kmem_cache_create: now flags=76800
>> __kmem_cache_create: aligned size to 96 because of redzoning
>> __kmem_cache_create: pagealloc debug, setting size to 8192
>> __kmem_cache_create: aligned size to 8192
>> __kmem_cache_create: num=1, slab_size=64
>> __kmem_cache_create: starting, size=192, flags=8192
>> __kmem_cache_create: now flags=76800
>> __kmem_cache_create: aligned size to 192 because of redzoning
>> __kmem_cache_create: pagealloc debug, setting size to 8192
>> __kmem_cache_create: aligned size to 8192
>> __kmem_cache_create: num=1, slab_size=64
>> __kmem_cache_create: starting, size=32, flags=8192
>> __kmem_cache_create: now flags=76800
>> __kmem_cache_create: aligned size to 32 because of redzoning
>> __kmem_cache_create: aligned size to 32
>> __kmem_cache_create: num=226, slab_size=960
>> __kmem_cache_create: starting, size=64, flags=8192
>> __kmem_cache_create: now flags=76800
>> __kmem_cache_create: aligned size to 64 because of redzoning
>> __kmem_cache_create: pagealloc debug, setting size to 8192
>> __kmem_cache_create: turning on CFLGS_OFF_SLAB, size=8192
>> __kmem_cache_create: aligned size to 8192
>> __kmem_cache_create: num=1, slab_size=64
>> __kmem_cache_create: CFLGS_OFF_SLAB, size=8192, slab_size=52
>> __kmem_cache_create: CFLGS_OFF_SLAB, allocating slab 52
>>
>> With slab size 64, it turns on CFLGS_OFF_SLAB and off slab allocation
>> with this size fails. I do not know slab internals so I can not tell if
>> this just happens because of the debug paths, or is it a real problem
>> without the debug options too.
>>
>
> There was a rather large change to mm/slab.c that changed it to use 'struct
> page' like SLUB. Perhaps slab debugging was broken in the process. Joonsoo,
> does the problem Meelis describes ring a bell?

Hello, Pekka.

No. He report that BUG() is triggered on v3.11-rc2 and v3.12.
And my recent change is merged into v3.13-rc1 as you know. :)

Thanks.
