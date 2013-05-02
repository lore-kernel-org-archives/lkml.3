Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab3EBLvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:51:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61513 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EBLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:51:42 -0400
X-Nat-Received: from [202.181.97.72]:60798 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367495487.22364
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
	<0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
In-Reply-To: <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
Message-Id: <201305022051.FGC60601.FtOVJSOHFFLQMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 2 May 2013 20:51:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02052013 #9865657, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> > Hmm... Where does this fail? In slab?
> > 
> It hangs (with CPU#0 spinning) immediately after printing
> 
>   Decompressing Linux... Parsing ELF... done.
>   Booting the kernel.
> 
> lines. Today I heard that gdb can be used if I use qemu, but I doubt that I can
> manage time to understand and find the exact location within a few days.
> 
> The culprit location is possibly in SLAB because the kernel boots if built with
> CONFIG_DEBUG_SLAB=n || CONFIG_DEBUG_SPINLOCK=n || CONFIG_DEBUG_PAGEALLOC=n.
> 
It turned out that cachep->slabp_cache == NULL is the cause of boot failure.
cachep->slabp_cache == NULL is caused by kmalloc_caches[5] == NULL. Any clue?

int __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
{
        (...snipped...)
        if (flags & CFLGS_OFF_SLAB) {
                cachep->slabp_cache = kmalloc_slab(slab_size, 0u);
                /*
                 * This is a possibility for one of the malloc_sizes caches.
                 * But since we go off slab only for object size greater than
                 * PAGE_SIZE/8, and malloc_sizes gets created in ascending order,
                 * this should not happen at all.
                 * But leave a BUG_ON for some lucky dude.
                 */
                BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
        }
        (...snipped...)
}

(gdb) b __find_general_cachep
Breakpoint 1 at 0xc10b6030: file mm/slab.c, line 679.
(gdb) c
Continuing.

Breakpoint 1, __find_general_cachep (size=32, gfpflags=0) at mm/slab.c:679
679             BUG_ON(kmalloc_caches[INDEX_AC] == NULL);
(gdb) s
671     {
(gdb)
679             BUG_ON(kmalloc_caches[INDEX_AC] == NULL);
(gdb)
681             if (!size)
(gdb)
684             i = kmalloc_index(size);
(gdb)
kmalloc_index (size=32, gfpflags=0) at include/linux/slab.h:208
208             if (size <= KMALLOC_MIN_SIZE)
(gdb)
__find_general_cachep (size=32, gfpflags=0) at mm/slab.c:692
692             if (unlikely(gfpflags & GFP_DMA))
(gdb)
695             return kmalloc_caches[i];
(gdb) print i
$1 = 5
(gdb) print kmalloc_caches[i]
$2 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[0]
$3 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[1]
$4 = (struct kmem_cache *) 0xf6800120
(gdb) print kmalloc_caches[2]
$5 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[3]
$6 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[4]
$7 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[5]
$8 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[6]
$9 = (struct kmem_cache *) 0xf6800080
(gdb) print kmalloc_caches[7]
$10 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[8]
$11 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[9]
$12 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[10]
$13 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[11]
$14 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[12]
$15 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[13]
$16 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[14]
$17 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[15]
$18 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[16]
$19 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[17]
$20 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[18]
$21 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[19]
$22 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[20]
$23 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[21]
$24 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[22]
$25 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[23]
$26 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[24]
$27 = (struct kmem_cache *) 0x0
(gdb) print kmalloc_caches[25]
$28 = (struct kmem_cache *) 0xf68001c0
(gdb) print kmalloc_caches[26]
$29 = (struct kmem_cache *) 0x0
(gdb) s
696     }
(gdb)
__kmem_cache_create (cachep=0xf6800260, flags=2147493888) at mm/slab.c:2493
2493                    BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
(gdb)
2485                    cachep->slabp_cache = kmem_find_general_cachep(slab_size, 0u);
(gdb)
2493                    BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
(gdb)
^C
Program received signal SIGINT, Interrupt.
0xc1409afc in panic (fmt=0xc1511274 "Attempted to kill the idle task!") at kernel/panic.c:182
182                     mdelay(PANIC_TIMER_STEP);
(gdb) bt
#0  0xc1409afc in panic (fmt=0xc1511274 "Attempted to kill the idle task!") at kernel/panic.c:182
#1  0xc1034a5f in do_exit (code=11) at kernel/exit.c:718
#2  0xc1005887 in oops_end (flags=70, regs=0xc158def0, signr=11) at arch/x86/kernel/dumpstack.c:249
#3  0xc10059af in die (str=0xc1502c45 "invalid opcode", regs=0xc158def0, err=0) at arch/x86/kernel/dumpstack.c:310
#4  0xc1002e25 in do_trap_no_signal (trapnr=6, signr=4, str=0xc1502c45 "invalid opcode", regs=0xc158def0, error_code=0, info=0xc158de60)
    at arch/x86/kernel/traps.c:130
#5  do_trap (trapnr=6, signr=4, str=0xc1502c45 "invalid opcode", regs=0xc158def0, error_code=0, info=0xc158de60) at arch/x86/kernel/traps.c:145
#6  0xc10032a6 in do_invalid_op (regs=0xc158def0, error_code=0) at arch/x86/kernel/traps.c:213
#7  0xc140c742 in ?? () at arch/x86/kernel/entry_32.S:1318
#8  0xc10b91d5 in __kmem_cache_create (cachep=0xf6800260, flags=2147493888) at mm/slab.c:2493
#9  0xc15dfcde in create_boot_cache (s=0xf6800260, name=0xc15148be "kmalloc", size=192, flags=8192) at mm/slab_common.c:299
#10 0xc15dfd4b in create_kmalloc_cache (name=0xc15148be "kmalloc", size=192, flags=8192) at mm/slab_common.c:316
#11 0xc15e0aa2 in kmem_cache_init () at mm/slab.c:1652
#12 0xc15c972a in mm_init () at init/main.c:462
#13 start_kernel () at init/main.c:527
#14 0xc15c929f in i386_start_kernel () at arch/x86/kernel/head32.c:66
#15 0x00000000 in ?? ()
