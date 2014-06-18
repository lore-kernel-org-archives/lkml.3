Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaFRT7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:59:11 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63093 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaFRT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <53A11E60.5030704@gmail.com>
References: <53A11E60.5030704@gmail.com>
Date: Thu, 19 Jun 2014 03:59:08 +0800
Message-ID: <CAF0htA4jMe_ehEeh=B5euYZX0uP-Mnq+G_pA-6Sxexp_LyPEaA@mail.gmail.com>
Subject: Re: [PATCH] arch/score/include/asm/io.h: Add generic io map functions
 when MMU enabled
From: Lennox Wu <lennox.wu@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,
Although "SuperH Timer Support" are never used in our platforms, we
can still consider if these functions are necessary.
Could you send the config to us?

Best,
Lennox

2014-06-18 13:06 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
> score did not implement some io map functions when MMU enabled, so need
> add generic io map functions, just like some other architectures have
> done (e.g. sparc64, s390, and mn10300), or will cause compiling issue.
>
> The related error (allmodconfig under score):
>
>     CC      drivers/clocksource/sh_cmt.o
>   drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory':
>   drivers/clocksource/sh_cmt.c:932:2: error: implicit declaration of function 'ioremap_nocache' [-Werror=implicit-function-declaration]
>     cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
>     ^
>   drivers/clocksource/sh_cmt.c:932:15: warning: assignment makes pointer from integer without a cast
>     cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
>                  ^
>   drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory_legacy':
>   drivers/clocksource/sh_cmt.c:953:18: warning: assignment makes pointer from integer without a cast
>     cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
>                     ^
>   drivers/clocksource/sh_cmt.c:963:15: warning: assignment makes pointer from integer without a cast
>     cmt->mapbase = ioremap_nocache(res2 ? res2->start :
>                  ^
>   drivers/clocksource/sh_cmt.c:968:3: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
>      iounmap(cmt->mapbase_ch);
>      ^
>   cc1: some warnings being treated as errors
>   make[2]: *** [drivers/clocksource/sh_cmt.o] Error 1
>   make[1]: *** [drivers/clocksource] Error 2
>   make: *** [drivers] Error 2
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/score/include/asm/io.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
> index 574c8827..d67aeea 100644
> --- a/arch/score/include/asm/io.h
> +++ b/arch/score/include/asm/io.h
> @@ -3,6 +3,22 @@
>
>  #include <asm-generic/io.h>
>
> +#ifdef CONFIG_MMU
> +static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
> +{
> +       return (void __iomem *) (unsigned long)offset;
> +}
> +
> +#define __ioremap(offset, size, flags) ioremap(offset, size)
> +
> +#define ioremap_nocache ioremap
> +#define ioremap_wc ioremap_nocache
> +
> +static inline void iounmap(void __iomem *addr)
> +{
> +}
> +#endif
> +
>  #define virt_to_bus    virt_to_phys
>  #define bus_to_virt    phys_to_virt
>  #endif /* _ASM_SCORE_IO_H */
> --
> 1.9.2.459.g68773ac
