Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3EIMZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:25:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60703 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3EIMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:25:37 -0400
X-Nat-Received: from [202.181.97.72]:56288 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368102323.30385
To: cl@linux.com, glommer@parallels.com
Cc: penberg@kernel.org, linux-kernel@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
	<517E8758.9040803@parallels.com>
	<0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
	<201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
	<201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp>
In-Reply-To: <201304300116.FGJ56210.FMSOJHFOtFQVOL@I-love.SAKURA.ne.jp>
Message-Id: <201305092125.FGG13076.LFOtVOFMSFQJHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 9 May 2013 21:25:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09052013 #9926694, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> > Christoph Lameter wrote:
> > > What is MAX_ORDER on the architecture?
> > 
> > In my environment (x86_32), the constants are
> > 
> >   MAX_ORDER=11 PAGE_SHIFT=12 KMALLOC_SHIFT_HIGH=22 KMALLOC_MAX_SIZE=4194304
> > 
> 
> I don't know if any, but on an architecture with PAGE_SHIFT + MAX_ORDER > 26,
> 
>   static void init_node_lock_keys(int q)
>   {
>           int i;
>   
>           if (slab_state < UP)
>                   return;
>   
>           for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
>                   struct kmem_cache_node *n;
>                   struct kmem_cache *cache = kmalloc_caches[i];
> 
> looks like out of bounds access due to
> 
>   #define KMALLOC_SHIFT_HIGH      ((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
>                                   (MAX_ORDER + PAGE_SHIFT - 1) : 25)
> 
> and
> 
>   struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
> 
> .
> 

As of commit e0fd9aff on linux.git#master,
CONFIG_PPC_256K_PAGES=y (which makes PAGE_SHIFT 18) &&
CONFIG_FORCE_MAX_ZONEORDER=11 (which makes MAX_ORDER 11) &&
CONFIG_PROVE_LOCKING=y with below assertion

----------
diff --git a/mm/slab.c b/mm/slab.c
index 8ccd296..0401982 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -565,6 +565,7 @@ static void init_node_lock_keys(int q)
        if (slab_state < UP)
                return;

+       BUILD_BUG_ON(PAGE_SHIFT + MAX_ORDER != KMALLOC_SHIFT_HIGH + 1);
        for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
                struct kmem_cache_node *n;
                struct kmem_cache *cache = kmalloc_caches[i];
----------

on powerpc triggers below error.

  CC      mm/slab.o
mm/slab.c: In function 'init_node_lock_keys':
mm/slab.c:568:2: error: call to '__compiletime_assert_568' declared with attribute error: BUILD_BUG_ON failed: PAGE_SHIFT + MAX_ORDER != KMALLOC_SHIFT_HIGH + 1
make[1]: *** [mm/slab.o] Error 1
make: *** [mm/slab.o] Error 2

This is an example of overrun at kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1]
range which the compiler may not be able to detect.
