Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3EHVBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:01:39 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:51924 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3EHVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:01:38 -0400
Date: Wed, 8 May 2013 17:01:34 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] SLAB changes for v3.10
Message-ID: <20130508210131.GA25849@phenom.dumpdata.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com>
 <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508181353.23991.17852@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:13:53PM -0400, Chris Mason wrote:
> [ Sorry if I break the threading on this, I had to pull it off gmane ]
> 
> On Tue, 7 May 2013, Tony Lindgren wrote:
> > OK got it narrowed down to CONFIG_DEBUG_SPINLOCK=y causing the problem
> > with commit 8a965b3b. Ain't nothing like bisecting and booting and then
> > diffing .config files on top of that.
> 
> I'm unable to boot with slab on current Linus -master, and bisected it
> down almost as far as Tony did before trying SLUB and then finding this
> thread.   My box is a standard x86-64, nothing exciting and spinlock
> debugging isn't on.
> 
> A few printks stuffed into Christoph's code:
> 
> cache ffff88047f000080 at index 5
> creating slab cache at 6
> create special cache #1 (this is kmalloc_caches[1])
> cache ffff88047f0001c0 at index 7
> creating slab cache at 8
> creating slab cache at 9
> creating slab cache at 10
> ... more get created
> 
> Pulling this into the code from commit 8a965b3b:
> 
>         for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
>                 if (!kmalloc_caches[i]) {
>                         kmalloc_caches[i] = create_kmalloc_cache(NULL,
>                                                         1 << i, flags);
> 
>                         /*
>                          * Caches that are not of the two-to-the-power-of size.
>                          * These have to be created immediately after the
>                          * earlier power of two caches
>                          */
>                         if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
>                                 kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
> 
>                         if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
>                                 kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
>                 }
>         }
> 
> kmalloc_caches[7] was not null, and so kmalloc_caches[2] was never
> created.
> 
> I get this oops (with early printk on)
> 
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:1635!
> invalid opcode: 0000 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0-josef+ #920
> Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 1.0a 03/06/2012
> task: ffffffff8196a410 ti: ffffffff8195a000 task.ti: ffffffff8195a000
> RIP: 0010:[<ffffffff81a49c9d>]  [<ffffffff81a49c9d>] kmem_cache_init_late+0x40/0x7d
> RSP: 0000:ffffffff8195bf78  EFLAGS: 00010282
> RAX: 00000000fffffff4 RBX: ffff88047f006480 RCX: 000000000000ff31
> RDX: 000000000000000e RSI: 0000000000000046 RDI: ffffffff81baf238
> RBP: ffffffff8195bf80 R08: 0000000000000400 R09: 0000000000000000
> R10: 0000000000002fa4 R11: 0000000000000000 R12: ffffffff81ab58d0
> R13: ffffffff81abd2c0 R14: ffff88047ffaf0c0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88047fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88047ffff000 CR3: 0000000001965000 CR4: 00000000000406b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>  ffffffffffffffff ffffffff8195bfc0 ffffffff81a25b64 ffffffff81a2573d
>  ffffffff81abd2c0 0000000000003000 0000000000000000 0000000000000000
>  0000000000000000 ffffffff8195bfd0 ffffffff81a2547f ffffffff8195bfe8
> Call Trace:
>  [<ffffffff81a25b64>] start_kernel+0x235/0x394
>  [<ffffffff81a2573d>] ? repair_env_string+0x58/0x58
>  [<ffffffff81a2547f>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81a25548>] x86_64_start_kernel+0xc7/0xca
> Code: 53 e8 40 57 bd ff 48 8b 05 21 f2 f4 ff 48 8d 58 a8 48 8d 43 58 48 3d a0 8e 99 81 74 1a 31 f6 48 89 df e8 ba 7f 6d ff 85 c0 74 02 <0f> 0b 48 8b 5b 58 48 83 eb 58 eb da 48 c7 c7 70 8e 99 81 e8 e6
> RIP  [<ffffffff81a49c9d>] kmem_cache_init_late+0x40/0x7d
>  RSP <ffffffff8195bf78>
> ---[ end trace 2e5587581263f881 ]---
> 
> This patch fixes things for me, but to maintain the rules from
> Christoph's patch,  kmalloc_caches[2] should have been created whenever
> kmalloc_caches[7] was done.

And you might also want to add:

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d2517b0..ff3218a 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -446,18 +446,18 @@ void __init create_kmalloc_caches(unsigned long flags)
>  		if (!kmalloc_caches[i]) {
>  			kmalloc_caches[i] = create_kmalloc_cache(NULL,
>  							1 << i, flags);
> +		}
>  
> -			/*
> -			 * Caches that are not of the two-to-the-power-of size.
> -			 * These have to be created immediately after the
> -			 * earlier power of two caches
> -			 */
> -			if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
> -				kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
> +		/*
> +		 * Caches that are not of the two-to-the-power-of size.
> +		 * These have to be created immediately after the
> +		 * earlier power of two caches
> +		 */
> +		if (KMALLOC_MIN_SIZE <= 32 && !kmalloc_caches[1] && i == 6)
> +			kmalloc_caches[1] = create_kmalloc_cache(NULL, 96, flags);
>  
> -			if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
> -				kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
> -		}
> +		if (KMALLOC_MIN_SIZE <= 64 && !kmalloc_caches[2] && i == 7)
> +			kmalloc_caches[2] = create_kmalloc_cache(NULL, 192, flags);
>  	}
>  
>  	/* Kmalloc array is now usable */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
