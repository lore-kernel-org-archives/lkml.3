Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3IZR6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:58:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57225 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab3IZR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:58:18 -0400
Date: Thu, 26 Sep 2013 18:57:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Nicolas Pitre <nico@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tile: use a more conservative __my_cpu_offset in
 CONFIG_PREEMPT
Message-ID: <20130926175754.GD7146@mudshark.cambridge.arm.com>
References: <201309261738.r8QHcGZX007708@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309261738.r8QHcGZX007708@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Thu, Sep 26, 2013 at 06:24:53PM +0100, Chris Metcalf wrote:
> It turns out the kernel relies on barrier() to force a reload of the
> percpu offset value.  Since we can't easily modify the definition of
> barrier() to include "tp" as an output register, we instead provide a
> definition of __my_cpu_offset as extended assembly that includes a fake
> stack read to hazard against barrier(), forcing gcc to know that it
> must reread "tp" and recompute anything based on "tp" after a barrier.
> 
> This fixes observed hangs in the slub allocator when we are looping
> on a percpu cmpxchg_double.
> 
> A similar fix for ARMv7 was made in June in change 509eb76ebf97.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> Ben Herrenschmidt offered to look into extending barrier() in some
> per-architecture way, but for now this patch is the minimal thing to
> fix the bug in 3.12 and earlier, so I'm planning to push it as-is.
> 
>  arch/tile/include/asm/percpu.h | 33 ++++++++++++++++++++++++++++++---
>  1 file changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/tile/include/asm/percpu.h b/arch/tile/include/asm/percpu.h
> index 63294f5..de121d3 100644
> --- a/arch/tile/include/asm/percpu.h
> +++ b/arch/tile/include/asm/percpu.h
> @@ -15,9 +15,36 @@
>  #ifndef _ASM_TILE_PERCPU_H
>  #define _ASM_TILE_PERCPU_H
>  
> -register unsigned long __my_cpu_offset __asm__("tp");
> -#define __my_cpu_offset __my_cpu_offset
> -#define set_my_cpu_offset(tp) (__my_cpu_offset = (tp))
> +register unsigned long my_cpu_offset_reg asm("tp");
> +
> +#ifdef CONFIG_PREEMPT
> +/*
> + * For full preemption, we can't just use the register variable
> + * directly, since we need barrier() to hazard against it, causing the
> + * compiler to reload anything computed from a previous "tp" value.
> + * But we also don't want to use volatile asm, since we'd like the
> + * compiler to be able to cache the value across multiple percpu reads.
> + * So we use a fake stack read as a hazard against barrier().
> + */
> +static inline unsigned long __my_cpu_offset(void)
> +{
> +	unsigned long tp;
> +	register unsigned long *sp asm("sp");
> +	asm("move %0, tp" : "=r" (tp) : "m" (*sp));
> +	return tp;
> +}

Hehe, nice to see this hack working out for you too. One thing to check is
whether you have any funky addressing modes (things like writeback or
post-increment), since the "m" constraint can bite you if you don't actually
use it in the asm.

Will
