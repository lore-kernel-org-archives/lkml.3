Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaDPJFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:05:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaDPJFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:05:17 -0400
Date: Wed, 16 Apr 2014 11:05:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arch:unicore32:mm: add devmem_is_allowed() to support
 STRICT_DEVMEM
Message-ID: <20140416090511.GB12866@dhcp22.suse.cz>
References: <629583968.18592.1396927216694.JavaMail.root@bj-mail03.pku.edu.cn>
 <534380F6.7090703@gmail.com>
 <534C79EE.3030505@gmail.com>
 <534C7D46.6040602@gmail.com>
 <534C8073.3060607@gmail.com>
 <534C899A.2020008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C899A.2020008@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-04-14 09:21:30, Chen Gang wrote:
[...]
> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
> index 39decb6..ae327e4 100644
> --- a/arch/unicore32/include/asm/io.h
> +++ b/arch/unicore32/include/asm/io.h

There is already quite a mess where the function is defined. We have it
in mmap.c, init.c, mem.c and s390 defines it in page.h. Is there any
good reason to add yet another place and pull in additional header files
dependencies?
Why not follow x86 here? Or even better git rid of the code duplication
and provide generic implementation which different arches can reuse and
extend? arm{64}, unicore32 seem to be identical. Powepc and x86 have an
additional test to the core one used by the above arches. Only tile
seems to be be doing something completely different.

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

-- 
Michal Hocko
SUSE Labs
