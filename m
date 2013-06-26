Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3FZGyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:54:45 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751166Ab3FZGyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:54:43 -0400
Message-ID: <51CA900E.9020407@nod.at>
Date: Wed, 26 Jun 2013 08:54:06 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Jeff Dike <jdike@addtoit.com>, Arnd Bergmann <arnd@arndb.de>,
        dhsharp@google.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] include/asm-generic/io.h: add 'UML' case just like 'no-MMU'
References: <51CA8AB8.7080504@asianux.com>
In-Reply-To: <51CA8AB8.7080504@asianux.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 26.06.2013 08:31, schrieb Chen Gang:
> For "User Mode Linux", it may enable 'MMU', but not need implement
> ioremap and iounmap, so "include/asm-generic/io.h" need notice this
> case to keep itself 'generic'.
> 
> The related error (with allmodconfig, without pcap):
> 
>     CC [M]  drivers/ptp/ptp_pch.o
>   drivers/ptp/ptp_pch.c: In function ‘pch_remove’:
>   drivers/ptp/ptp_pch.c:571:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
>   drivers/ptp/ptp_pch.c: In function ‘pch_probe’:
>   drivers/ptp/ptp_pch.c:621:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
>   drivers/ptp/ptp_pch.c:621:13: warning: assignment makes pointer from integer without a cast [enabled by default]
>   cc1: some warnings being treated as errors
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/um/include/asm/Kbuild |    1 +
>  include/asm-generic/io.h   |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
> index b30f34a..a34ea5d 100644
> --- a/arch/um/include/asm/Kbuild
> +++ b/arch/um/include/asm/Kbuild
> @@ -3,3 +3,4 @@ generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
>  generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
>  generic-y += switch_to.h clkdev.h
>  generic-y += trace_clock.h
> +generic-y += io.h

We include that file already. See three lines above.

> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index d5afe96..e80331d 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -303,10 +303,10 @@ static inline void *phys_to_virt(unsigned long address)
>  /*
>   * Change "struct page" to physical address.
>   *
> - * This implementation is for the no-MMU case only... if you have an MMU
> + * This implementation is for the no-MMU or UML case only... if you have an MMU
>   * you'll need to provide your own definitions.
>   */
> -#ifndef CONFIG_MMU
> +#if !CONFIG_MMU || CONFIG_UML
>  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>  {
>  	return (void __iomem*) (unsigned long)offset;
> @@ -325,7 +325,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>  static inline void iounmap(void __iomem *addr)
>  {
>  }
> -#endif /* CONFIG_MMU */
> +#endif /* !CONFIG_MMU || CONFIG_UML */
>  
>  #ifdef CONFIG_HAS_IOPORT
>  #ifndef CONFIG_GENERIC_IOMAP
> 

UML has no io memory but a MMU, so I'd argue that you better fix drivers/ptp/ptp_pch.c dependencies.
_If_ ptp_pch.c really works without real io memory, you can look what I did in my GENERIC_IO series[1]
to make nandsim work on UML. Maybe this helps.

Thanks,
//richard

[1] http://lists.infradead.org/pipermail/linux-mtd/2012-February/039701.html

