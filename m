Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaDPFPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:15:44 -0400
Received: from mx13.pku.edu.cn ([162.105.129.176]:46461 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753091AbaDPFPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:15:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.236
Date: Wed, 16 Apr 2014 13:15:29 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mhocko@suse.cz, mgorman@suse.de, linux-kernel@vger.kernel.org
Message-ID: <1834032058.38902.1397625329658.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <534C899A.2020008@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_v3]_arch:?=
 =?utf-8?Q?unicore32:mm:_add_dev?=
 =?utf-8?Q?mem=5Fis=5Fallowed()_to_support_STRICT=5FDEVMEM?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> unicore32 supports STRICT_DEVMEM, so it needs devmem_is_allowed(), like
> some of other architectures have done (e.g. arm, powerpc, x86 ...).
> 
> The related error with allmodconfig:
> 
>     CC      drivers/char/mem.o
>   drivers/char/mem.c: In function ‘range_is_allowed’:
>   drivers/char/mem.c:69: error: implicit declaration of function ‘devmem_is_allowed’
>   make[2]: *** [drivers/char/mem.o] Error 1
>   make[1]: *** [drivers/char] Error 2
>   make: *** [drivers] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/include/asm/io.h |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
> index 39decb6..ae327e4 100644
> --- a/arch/unicore32/include/asm/io.h
> +++ b/arch/unicore32/include/asm/io.h
> @@ -44,5 +44,28 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
>  #define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
>  #define PIO_RESERVED		(PIO_OFFSET + PIO_MASK + 1)
>  
> +#ifdef CONFIG_STRICT_DEVMEM
> +
> +#include <linux/ioport.h>
> +#include <linux/mm.h>
> +
> +/*
> + * devmem_is_allowed() checks to see if /dev/mem access to a certain
> + * address is valid. The argument is a physical page number.
> + * We mimic x86 here by disallowing access to system RAM as well as
> + * device-exclusive MMIO regions. This effectively disable read()/write()
> + * on /dev/mem.
> + */
> +static inline int devmem_is_allowed(unsigned long pfn)
> +{
> +	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
> +		return 0;
> +	if (!page_is_ram(pfn))
> +		return 1;
> +	return 0;
> +}
> +
> +#endif /* CONFIG_STRICT_DEVMEM */
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* __UNICORE_IO_H__ */
> -- 
> 1.7.9.5
> 

