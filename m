Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaAXOVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:21:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40013 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaAXOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:21:38 -0500
Date: Fri, 24 Jan 2014 15:21:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: penberg@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Warning at mm/slub.c
Message-ID: <20140124142112.GA30183@twins.programming.kicks-ass.net>
References: <CAOMZO5ASeLoa3s2PqaPqA-zd83hc8qQCHyfedP+KEzvitBpqog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ASeLoa3s2PqaPqA-zd83hc8qQCHyfedP+KEzvitBpqog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 11:52:37AM -0200, Fabio Estevam wrote:
> Peter,
> 
> Commit c65c1877bd68 (slub: use lockdep_assert_held) introduced the following
> warning on mx5/mx6 systems (ARMv7) running linux-next 20140124:
> 
> Virtual kernel memory layout:
>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
>     vmalloc : 0xa0800000 - 0xff000000   (1512 MB)
>     lowmem  : 0x80000000 - 0xa0000000   ( 512 MB)
>     pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
>     modules : 0x7f000000 - 0x7fe00000   (  14 MB)
>       .text : 0x80008000 - 0x807e0edc   (8036 kB)
>       .init : 0x807e1000 - 0x8082e300   ( 309 kB)
>       .data : 0x80830000 - 0x8088b900   ( 367 kB)
>        .bss : 0x8088b908 - 0x80debdb0   (5506 kB)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at mm/slub.c:1511 __kmem_cache_create+0x24c/0x318()
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.13.0-next-20140124 #685
> Backtrace:
> [<8001235c>] (dump_backtrace) from [<800124f8>] (show_stack+0x18/0x1c)
>  r6:800da30c r5:00000009 r4:00000000 r3:00000000
> [<800124e0>] (show_stack) from [<805e56d8>] (dump_stack+0x80/0x9c)
> [<805e5658>] (dump_stack) from [<80027834>] (warn_slowpath_common+0x70/0x94)
>  r4:00000000 r3:8083bcf0
> [<800277c4>] (warn_slowpath_common) from [<8002787c>] (warn_slowpath_null+0x24/0
> x2c)
>  r8:80dbeb18 r7:00002000 r6:80821c94 r5:9ffd8000 r4:9f000000
> [<80027858>] (warn_slowpath_null) from [<800da30c>] (__kmem_cache_create+0x24c/0
> x318)
> [<800da0c0>] (__kmem_cache_create) from [<80801d34>] (create_boot_cache+0x50/0x7
> 8)
>  r10:9fffcb80 r9:412fc085 r8:80838880 r7:80821d08 r6:8073e360 r5:80821c94
>  r4:0000002c
> [<80801ce4>] (create_boot_cache) from [<80803544>] (kmem_cache_init+0x3c/0xe0)
>  r6:80dbeb14 r5:80821c94 r4:80dc41a4 r3:00002000
> [<80803508>] (kmem_cache_init) from [<807e19cc>] (start_kernel+0x198/0x384)
>  r8:80838880 r7:8081f4c0 r6:ffffffff r5:8088b940 r4:00000001
> [<807e1834>] (start_kernel) from [<90008074>] (0x90008074)
>  r10:00000000 r8:90004059 r7:8083d3ac r6:8081f4bc r5:80838928 r4:10c53c7d
> ---[ end trace 3406ff24bd97382e ]---
> 
> If I revert this commit, the warning goes away.
> 
> It also goes away if this only line is removed:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d2388c8..fde5852 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1508,8 +1508,6 @@ static void discard_slab(struct kmem_cache *s,
> struct page *page)
>  static inline void add_partial(struct kmem_cache_node *n,
>                  struct page *page, int tail)
>  {
> -    lockdep_assert_held(&n->list_lock);
> -
>      n->nr_partial++;
>      if (tail == DEACTIVATE_TO_TAIL)
>          list_add_tail(&page->lru, &n->partial);


Dave Hansen already send a fix for that:

lkml.kernel.org/r/52D5746F.2040604@intel.com



Pekka, any chance to get that merged?
