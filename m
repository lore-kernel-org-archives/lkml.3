Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbbAZXzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:55:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbbAZXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:54:58 -0500
Date: Mon, 26 Jan 2015 15:54:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/7] lib: Add huge I/O map capability interfaces
Message-Id: <20150126155456.a40df49e42b1b7f8077421f4@linux-foundation.org>
In-Reply-To: <1422314009-31667-3-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
	<1422314009-31667-3-git-send-email-toshi.kani@hp.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 16:13:24 -0700 Toshi Kani <toshi.kani@hp.com> wrote:

> Add ioremap_pud_enabled() and ioremap_pmd_enabled(), which
> return 1 when I/O mappings of pud/pmd are enabled on the kernel.
> 
> ioremap_huge_init() calls arch_ioremap_pud_supported() and
> arch_ioremap_pmd_supported() to initialize the capabilities.
> 
> A new kernel option "nohgiomap" is also added, so that user can
> disable the huge I/O map capabilities if necessary.

Why?  What's the problem with leaving it enabled?

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2304,6 +2304,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			register save and restore. The kernel will only save
>  			legacy floating-point registers on task switch.
>  
> +	nohgiomap	[KNL,x86] Disable huge I/O mappings.

That reads like "no high iomap" to me.  "nohugeiomap" would be better.

> --- a/lib/ioremap.c
> +++ b/lib/ioremap.c
> @@ -13,6 +13,44 @@
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
>  
> +#ifdef CONFIG_HUGE_IOMAP
> +int __read_mostly ioremap_pud_capable;
> +int __read_mostly ioremap_pmd_capable;
> +int __read_mostly ioremap_huge_disabled;
> +
> +static int __init set_nohgiomap(char *str)
> +{
> +	ioremap_huge_disabled = 1;
> +	return 0;
> +}
> +early_param("nohgiomap", set_nohgiomap);

Why early?

> +static inline void ioremap_huge_init(void)
> +{
> +	if (!ioremap_huge_disabled) {
> +		if (arch_ioremap_pud_supported())
> +			ioremap_pud_capable = 1;
> +		if (arch_ioremap_pmd_supported())
> +			ioremap_pmd_capable = 1;
> +	}
> +}
> +
> +static inline int ioremap_pud_enabled(void)
> +{
> +	return ioremap_pud_capable;
> +}
> +
> +static inline int ioremap_pmd_enabled(void)
> +{
> +	return ioremap_pmd_capable;
> +}
> +
> +#else	/* !CONFIG_HUGE_IOMAP */
> +static inline void ioremap_huge_init(void) { }
> +static inline int ioremap_pud_enabled(void) { return 0; }
> +static inline int ioremap_pmd_enabled(void) { return 0; }
> +#endif	/* CONFIG_HUGE_IOMAP */
> +
>  static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
>  {
> @@ -74,6 +112,12 @@ int ioremap_page_range(unsigned long addr,
>  	unsigned long start;
>  	unsigned long next;
>  	int err;
> +	static int ioremap_huge_init_done;
> +
> +	if (!ioremap_huge_init_done) {
> +		ioremap_huge_init_done = 1;
> +		ioremap_huge_init();
> +	}

Looks hacky.  Why can't we just get the startup ordering correct?  It
at least needs a comment which fully explains the situation.

