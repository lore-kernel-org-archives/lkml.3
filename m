Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaCGEm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:42:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60903 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaCGEmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:42:53 -0500
Date: Thu, 6 Mar 2014 20:42:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Laura Abbott <lauraa@codeaurora.org>, Sricharan R <r.sricharan@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140307044251.GD9985@codeaurora.org>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Sebastian Capella wrote:
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 8756e4b..d32adbb 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -291,6 +291,7 @@ static inline void *phys_to_virt(phys_addr_t x)
>   */
>  #define __pa(x)			__virt_to_phys((unsigned long)(x))
>  #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
> +#define __pa_symbol(x)		__pa((unsigned long)(x))

Thanks for removing RELOC_HIDE, as Russell already stated it's
never been necessary on ARM.

Looking at this definition now it doesn't look right. Isn't
&__nosave_begin a virtual address? Casting it to an unsigned long
isn't going to give you a physical address. Why can't we use
__pa()?

> +extern const void __nosave_begin, __nosave_end;
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +	unsigned long nosave_begin_pfn =
> +			__pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
> +	unsigned long nosave_end_pfn =
> +			PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> +
> +	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> +}

Perhaps this code could be:

	unsigned long nosave_begin_pfn = virt_to_pfn(&__nosave_begin);
	unsigned long nosave_end_pfn = virt_to_pfn(&__nosave_end);

	return (pfn >= nosave_begin_pfn) && (pfn <= nosave_end_pfn);

or if virt_to_pfn() doesn't exist on ARM and we can't add it for
some reason:

	unsigned long nosave_begin_pfn = __phys_to_pfn(__pa(&__nosave_begin));
	unsigned long nosave_end_pfn = __phys_to_pfn(__pa(&__nosave_end));

	return (pfn >= nosave_begin_pfn) && (pfn <= nosave_end_pfn);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
