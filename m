Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaDHDUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:20:34 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:47618 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755964AbaDHDUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:20:32 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.252
Date: Tue, 8 Apr 2014 11:20:16 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mhocko@suse.cz, mgorman@suse.de, linux-kernel@vger.kernel.org
Message-ID: <629583968.18592.1396927216694.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53428BC9.3070001@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch:unicore32:mm:_add_devm?=
 =?utf-8?Q?em=5Fis=5Fallowed()_to_support_STRICT=5FDEVMEM?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to put the code into asm/io.h, and make it static.

> +#ifdef CONFIG_STRICT_DEVMEM
> +/*
> + * devmem_is_allowed() checks to see if /dev/mem access to a certain
> + * address is valid. The argument is a physical page number.
> + * We mimic x86 here by disallowing access to system RAM as well as
> + * device-exclusive MMIO regions. This effectively disable read()/write()
> + * on /dev/mem.
> + */
> +static int devmem_is_allowed(unsigned long pfn)
> +{
> +	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
> +		return 0;
> +	if (!page_is_ram(pfn))
> +		return 1;
> +	return 0;
> +}
> +#endif /* CONFIG_STRICT_DEVMEM */

Thanks,

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
>  arch/unicore32/include/asm/page.h |    4 ++++
>  arch/unicore32/mm/init.c          |   18 ++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/unicore32/include/asm/page.h b/arch/unicore32/include/asm/page.h
> index 594b322..231cb89 100644
> --- a/arch/unicore32/include/asm/page.h
> +++ b/arch/unicore32/include/asm/page.h
> @@ -68,6 +68,10 @@ typedef struct page *pgtable_t;
>  
>  extern int pfn_valid(unsigned long);
>  
> +#ifdef CONFIG_STRICT_DEVMEM
> +extern int devmem_is_allowed(unsigned long pfn);
> +#endif /* CONFIG_STRICT_DEVMEM */
> +
>  #include <asm/memory.h>
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/unicore32/mm/init.c b/arch/unicore32/mm/init.c
> index be2bde9..3bc3a59 100644
> --- a/arch/unicore32/mm/init.c
> +++ b/arch/unicore32/mm/init.c
> @@ -449,3 +449,21 @@ static int __init keepinitrd_setup(char *__unused)
>  
>  __setup("keepinitrd", keepinitrd_setup);
>  #endif
> +
> +#ifdef CONFIG_STRICT_DEVMEM
> +/*
> + * devmem_is_allowed() checks to see if /dev/mem access to a certain
> + * address is valid. The argument is a physical page number.
> + * We mimic x86 here by disallowing access to system RAM as well as
> + * device-exclusive MMIO regions. This effectively disable read()/write()
> + * on /dev/mem.
> + */
> +int devmem_is_allowed(unsigned long pfn)
> +{
> +	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
> +		return 0;
> +	if (!page_is_ram(pfn))
> +		return 1;
> +	return 0;
> +}
> +#endif /* CONFIG_STRICT_DEVMEM */
> -- 
> 1.7.9.5
