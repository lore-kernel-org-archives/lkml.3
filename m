Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3DYMXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:23:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61433 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3DYMXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:23:38 -0400
X-Nat-Received: from [202.181.97.72]:59496 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366892451.19842
To: glommer@parallels.com, cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp>
In-Reply-To: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp>
Message-Id: <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 25 Apr 2013 21:20:47 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25042013 #9885514, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> linux-next-20130422 does not boot when built with CONFIG_DEBUG_SLAB=y &&
> CONFIG_DEBUG_SPINLOCK=y && CONFIG_DEBUG_PAGEALLOC=y .
> 
> It hangs (with CPU#0 spinning) immediately after printing
> 
>   Decompressing Linux... Parsing ELF... done.
>   Booting the kernel.
> 
> lines.
> 
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc8-next-20130422 .
> 
> Any clue before starting bisection?
> 
> Regards.
> 

Bisection (with a build fix from commit db845067 "slab: Fixup
CONFIG_PAGE_ALLOC/DEBUG_SLAB_LEAK sections") reached commit e3366016
"slab: Use common kmalloc_index/kmalloc_size functions".
Would you have a look at commit e3366016?



By the way, I have a fear regarding commit e3366016.

include/linux/slab_def.h says

  extern struct kmem_cache *kmalloc_caches[PAGE_SHIFT + MAX_ORDER];
  extern struct kmem_cache *kmalloc_dma_caches[PAGE_SHIFT + MAX_ORDER];

while mm/slab.c says

  struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
  struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];

and include/linux/slab.h says

  #define KMALLOC_SHIFT_HIGH      ((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
                                  (MAX_ORDER + PAGE_SHIFT - 1) : 25)

.

If (MAX_ORDER + PAGE_SHIFT - 1) <= 25 is true, mm/slab.c will allocate

  struct kmem_cache *kmalloc_caches[MAX_ORDER + PAGE_SHIFT - 1 + 1];
  struct kmem_cache *kmalloc_dma_caches[MAX_ORDER + PAGE_SHIFT - 1 + 1];

which matches the size declared in include/linux/slab_def.h .

If (MAX_ORDER + PAGE_SHIFT - 1) > 25 is true (I don't know whether such case
happens), mm/slab.c will allocate

  struct kmem_cache *kmalloc_caches[25 + 1];
  struct kmem_cache *kmalloc_dma_caches[25 + 1];

which is smaller than the size declared in include/linux/slab_def.h .

Well, this mismatch seems to be fixed by commit 9425c58e "slab: Common
definition for the array of kmalloc caches". But usage like

  for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
          struct kmem_cache_node *n;
          struct kmem_cache *cache = kmalloc_caches[i];

is remaining.

Also, kmalloc_index() in include/linux/slab.h can return 0 to 26.

If (MAX_ORDER + PAGE_SHIFT - 1) > 25 is true and
kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
happens), kmalloc_caches[26] is beyond the array, for kmalloc_caches[26]
allows 0 to 25.

If (MAX_ORDER + PAGE_SHIFT - 1) <= 25 is true and
kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
happens), kmalloc_caches[26] is beyond the array, for
kmalloc_caches[MAX_ORDER + PAGE_SHIFT] allows 0 to MAX_ORDER + PAGE_SHIFT - 1.

Would you recheck that the array size is correct?



Regards.
