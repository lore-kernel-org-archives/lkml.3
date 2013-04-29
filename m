Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3D2QQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:16:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53151 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab3D2QQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:16:30 -0400
X-Nat-Received: from [202.181.97.72]:65414 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367252181.3381
To: cl@linux.com, glommer@parallels.com
Cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp>
	<CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
	<517E8758.9040803@parallels.com>
	<0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
	<201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
In-Reply-To: <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
Message-Id: <201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 30 Apr 2013 01:16:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 29042013 #9855826, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Glauber Costa wrote:
> > If I am right, the following (untested) patch should solve the problem.
> 
> This patch did not help;
> 
>   kmalloc(8 * 1024 * 1024, GFP_KERNEL)
> 
> still causes both
> 
>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
> 
> and
> 
>   BUG: unable to handle kernel NULL pointer dereference at 00000058
>   IP: [<c10b9d76>] kmem_cache_alloc+0x26/0xb0
> 
> .

I copied this patch (which modifies "static __always_inline void *kmalloc_node
(size_t size, gfp_t flags, int node)") to "static __always_inline void *kmalloc
(size_t size, gfp_t flags)", but it didn't help.

-------- test cases --------
        volatile unsigned int size = 0;
        void *ptr = kmalloc(size, GFP_KERNEL);
        printk("kmalloc(0)=%p\n", ptr);
        kfree(ptr);
        for (size = 1; size <= 256 * 1024 * 1024; size *= 2) {
                ptr = kmalloc(size, GFP_KERNEL);
                printk("kmalloc(%u)=%p\n", size, ptr);
                kfree(ptr);
        }
-------- test cases --------

kmalloc(0)=00000010
kmalloc(1)=de7eb840
kmalloc(2)=de7eb840
kmalloc(4)=de7eb840
kmalloc(8)=de7eb840
kmalloc(16)=de7eb840
kmalloc(32)=de7eb840
kmalloc(64)=de28ae40
kmalloc(128)=de5ba140
kmalloc(256)=de69e180
kmalloc(512)=dea14600
kmalloc(1024)=de522400
kmalloc(2048)=de1e4000
kmalloc(4096)=de9b3000
kmalloc(8192)=de24a000
kmalloc(16384)=de444000
kmalloc(32768)=de9b8000
kmalloc(65536)=dea20000
kmalloc(131072)=de980000
kmalloc(262144)=deb00000
kmalloc(524288)=dea80000
kmalloc(1048576)=de800000
kmalloc(2097152)=dde00000
kmalloc(4194304)=d5800000
kmalloc(8388608)=  (null)
kmalloc(16777216)=  (null)

Got BUG() at 32 * 1024 * 1024 bytes.

  Kernel BUG at c10b9c9b [verbose debug info unavailable]
  invalid opcode: 0000 [#1] SMP

There still seems to be a bug in the non-constant case.



> Christoph Lameter wrote:
> > What is MAX_ORDER on the architecture?
> 
> In my environment (x86_32), the constants are
> 
>   MAX_ORDER=11 PAGE_SHIFT=12 KMALLOC_SHIFT_HIGH=22 KMALLOC_MAX_SIZE=4194304
> 

I don't know if any, but on an architecture with PAGE_SHIFT + MAX_ORDER > 26,

  static void init_node_lock_keys(int q)
  {
          int i;
  
          if (slab_state < UP)
                  return;
  
          for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
                  struct kmem_cache_node *n;
                  struct kmem_cache *cache = kmalloc_caches[i];

looks like out of bounds access due to

  #define KMALLOC_SHIFT_HIGH      ((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
                                  (MAX_ORDER + PAGE_SHIFT - 1) : 25)

and

  struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];

.
