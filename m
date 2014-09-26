Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaIZKxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:53:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43492 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbaIZKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:53:36 -0400
Date: Fri, 26 Sep 2014 11:53:33 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the asm-generic tree
Message-ID: <20140926105333.GG22293@arm.com>
References: <20140926200251.78f0d713@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926200251.78f0d713@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:02:51AM +0100, Stephen Rothwell wrote:
> After merging the asm-generic tree, today's linux-next build (sparc
> defconfig) failed like this:
> 
> In file included from /scratch/sfr/next/include/linux/clocksource.h:19:0,
>                  from /scratch/sfr/next/arch/sparc/include/asm/timer_32.h:11,
>                  from /scratch/sfr/next/arch/sparc/include/asm/timer.h:6,
>                  from /scratch/sfr/next/arch/sparc/kernel/sun4m_irq.c:14:
> /scratch/sfr/next/arch/sparc/include/asm/io.h:14:0: error: "readb_relaxed" redefined [-Werror]
>  #define readb_relaxed(__addr)  readb(__addr)
>  ^
> In file included from /scratch/sfr/next/arch/sparc/include/asm/io_32.h:13:0,
>                  from /scratch/sfr/next/arch/sparc/include/asm/io.h:6,
>                  from /scratch/sfr/next/include/linux/clocksource.h:19,
>                  from /scratch/sfr/next/arch/sparc/include/asm/timer_32.h:11,
>                  from /scratch/sfr/next/arch/sparc/include/asm/timer.h:6,
>                  from /scratch/sfr/next/arch/sparc/kernel/sun4m_irq.c:14:
> /scratch/sfr/next/include/asm-generic/io.h:182:0: note: this is the location of the previous definition
>  #define readb_relaxed readb
>  ^
> 
> And so on several hundred times ... :-(
> 
> Caused by commits 95a668b0452e ("sparc: io: implement dummy relaxed
> accessor macros for writes") and 4c255791ffd6 ("asm-generic: io:
> implement relaxed accessor macros as conditional wrappers").
> 
> arch/sparc/include/asm_32.h includes asm-generic/io.h which means it is
> include before the arch specific versions of the relaxed functions are
> defined ...

Ah yes, Sam recently moved sparc32 over to asm-generic/io.h.

> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 26 Sep 2014 19:57:03 +1000
> Subject: [PATCH] sparc: io: fix for asm-generic: io: implement relaxed
>  accessor macros as conditional wrappers
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/include/asm/io.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
> index 493f22c4684f..79b167674010 100644
> --- a/arch/sparc/include/asm/io.h
> +++ b/arch/sparc/include/asm/io.h
> @@ -1,10 +1,5 @@
>  #ifndef ___ASM_SPARC_IO_H
>  #define ___ASM_SPARC_IO_H
> -#if defined(__sparc__) && defined(__arch64__)
> -#include <asm/io_64.h>
> -#else
> -#include <asm/io_32.h>
> -#endif
>  
>  /*
>   * Defines used for both SPARC32 and SPARC64
> @@ -19,6 +14,12 @@
>  #define writew_relaxed(__w, __addr)	writew(__w, __addr)
>  #define writel_relaxed(__l, __addr)	writel(__l, __addr)
>  
> +#if defined(__sparc__) && defined(__arch64__)
> +#include <asm/io_64.h>
> +#else
> +#include <asm/io_32.h>
> +#endif
> +

This patch looks fine to me. Arnd, can you pick this up please?

Thanks,

Will
