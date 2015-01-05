Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbbAEQ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:28:32 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56550 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbbAEQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:28:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Nkkw/nNEQRNEI6C07n04o
Date: Mon, 5 Jan 2015 08:24:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>, nm@ti.com, khilman@linaro.org
Subject: Re: [PATCH v11 4/9] ARM: l2c: Add interface to ask hypervisor to
 configure L2C
Message-ID: <20150105162438.GD4081@atomide.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
 <1420460348-20302-5-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420460348-20302-5-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Szyprowski <m.szyprowski@samsung.com> [150105 04:22]:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> Because certain secure hypervisor do not allow writes to individual L2C
> registers, but rather expect set of parameters to be passed as argument
> to secure monitor calls, there is a need to provide an interface for the
> L2C driver to ask the firmware to configure the hardware according to
> specified parameters. This patch adds such.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/include/asm/outercache.h | 3 +++
>  arch/arm/mm/cache-l2x0.c          | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
> index 891a56b35bcf..563b92fc2f41 100644
> --- a/arch/arm/include/asm/outercache.h
> +++ b/arch/arm/include/asm/outercache.h
> @@ -23,6 +23,8 @@
>  
>  #include <linux/types.h>
>  
> +struct l2x0_regs;
> +
>  struct outer_cache_fns {
>  	void (*inv_range)(unsigned long, unsigned long);
>  	void (*clean_range)(unsigned long, unsigned long);
> @@ -36,6 +38,7 @@ struct outer_cache_fns {
>  
>  	/* This is an ARM L2C thing */
>  	void (*write_sec)(unsigned long, unsigned);
> +	void (*configure)(const struct l2x0_regs *);
>  };
>  
>  extern struct outer_cache_fns outer_cache;
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index f9013320c8ce..dcde6086a228 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -110,6 +110,11 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
>  
>  static void l2c_configure(void __iomem *base)
>  {
> +	if (outer_cache.configure) {
> +		outer_cache.configure(&l2x0_saved_regs);
> +		return;
> +	}
> +
>  	if (l2x0_data->configure)
>  		l2x0_data->configure(base);
>  
> @@ -910,6 +915,7 @@ static int __init __l2c_init(const struct l2c_init_data *data,
>  
>  	fns = data->outer_cache;
>  	fns.write_sec = outer_cache.write_sec;
> +	fns.configure = outer_cache.configure;
>  	if (data->fixup)
>  		data->fixup(l2x0_base, cache_id, &fns);
>  
> -- 
> 1.9.2
> 
