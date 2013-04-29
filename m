Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3D2Rsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:48:45 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:45116 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236Ab3D2Rso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:48:44 -0400
Date: Mon, 29 Apr 2013 17:48:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
Message-ID: <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
References: <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp> <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp> <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com> <517E8758.9040803@parallels.com>
 <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.29-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 30 Apr 2013, Tetsuo Handa wrote:

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
>
> Christoph Lameter wrote:
> > What is MAX_ORDER on the architecture?
>
> In my environment (x86_32), the constants are
>
>   MAX_ORDER=11 PAGE_SHIFT=12 KMALLOC_SHIFT_HIGH=22 KMALLOC_MAX_SIZE=4194304
>

Ok so the maximum allocation is 11+12=23 which is 8M. KMALLOC_MAX_SIZE
amd KMALLOC_SHIFT_HIGH are wrong.

Take the -1 off the constants under #ifdef CONFIG_SLAB in

include/linux/slab.h
Index: linux/include/linux/slab.h
===================================================================
--- linux.orig/include/linux/slab.h	2013-04-29 12:44:42.339011800 -0500
+++ linux/include/linux/slab.h	2013-04-29 12:48:11.446435859 -0500
@@ -176,8 +176,8 @@ struct kmem_cache {
  * to do various tricks to work around compiler limitations in order to
  * ensure proper constant folding.
  */
-#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT - 1) <= 25 ? \
-				(MAX_ORDER + PAGE_SHIFT - 1) : 25)
+#define KMALLOC_SHIFT_HIGH	((MAX_ORDER + PAGE_SHIFT) <= 26 ? \
+				(MAX_ORDER + PAGE_SHIFT) : 26)
 #define KMALLOC_SHIFT_MAX	KMALLOC_SHIFT_HIGH
 #define KMALLOC_SHIFT_LOW	5
 #else
@@ -206,9 +206,9 @@ struct kmem_cache {
 #define KMALLOC_MIN_SIZE (1 << KMALLOC_SHIFT_LOW)
 #endif

-extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_caches[KMALLOC_SHIFT_HIGH];
 #ifdef CONFIG_ZONE_DMA
-extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH + 1];
+extern struct kmem_cache *kmalloc_dma_caches[KMALLOC_SHIFT_HIGH];
 #endif

 /*

