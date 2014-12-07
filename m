Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaLGRXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:23:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49894 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaLGRXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:23:14 -0500
Date: Sun, 7 Dec 2014 11:22:31 -0600
From: Nishanth Menon <nm@ti.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: arm: mach-omap2: powerdomain.c:  Remove some
 unused functions
Message-ID: <20141207172231.GA12811@kahuna>
References: <1417960707-11569-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1417960707-11569-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:58-20141207, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> pwrdm_get_voltdm() pwrdm_for_each_clkdm() pwrdm_del_clkdm()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/arm/mach-omap2/powerdomain.c |   81 -------------------------------------
>  arch/arm/mach-omap2/powerdomain.h |    5 ---
>  2 files changed, 86 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
> index 7fb033e..6bd6025 100644
> --- a/arch/arm/mach-omap2/powerdomain.c
> +++ b/arch/arm/mach-omap2/powerdomain.c
> @@ -484,87 +484,6 @@ pac_exit:
>  }
>  
>  /**
> - * pwrdm_del_clkdm - remove a clockdomain from a powerdomain
> - * @pwrdm: struct powerdomain * to add the clockdomain to
> - * @clkdm: struct clockdomain * to associate with a powerdomain
> - *
> - * Dissociate the clockdomain @clkdm from the powerdomain
> - * @pwrdm. Returns -EINVAL if presented with invalid pointers; -ENOENT
> - * if @clkdm was not associated with the powerdomain, or 0 upon
> - * success.
> - */
> -int pwrdm_del_clkdm(struct powerdomain *pwrdm, struct clockdomain *clkdm)
> -{
> -	int ret = -EINVAL;
> -	int i;
> -
> -	if (!pwrdm || !clkdm)
> -		return -EINVAL;
> -
> -	pr_debug("powerdomain: %s: dissociating clockdomain %s\n",
> -		 pwrdm->name, clkdm->name);
> -
> -	for (i = 0; i < PWRDM_MAX_CLKDMS; i++)
> -		if (pwrdm->pwrdm_clkdms[i] == clkdm)
> -			break;
> -
> -	if (i == PWRDM_MAX_CLKDMS) {
> -		pr_debug("powerdomain: %s: clkdm %s not associated?!\n",
> -			 pwrdm->name, clkdm->name);
> -		ret = -ENOENT;
> -		goto pdc_exit;
> -	}
> -
> -	pwrdm->pwrdm_clkdms[i] = NULL;
> -
> -	ret = 0;
> -
> -pdc_exit:
> -	return ret;
> -}
> -
> -/**
> - * pwrdm_for_each_clkdm - call function on each clkdm in a pwrdm
> - * @pwrdm: struct powerdomain * to iterate over
> - * @fn: callback function *
> - *
> - * Call the supplied function @fn for each clockdomain in the powerdomain
> - * @pwrdm.  The callback function can return anything but 0 to bail
> - * out early from the iterator.  Returns -EINVAL if presented with
> - * invalid pointers; or passes along the last return value of the
> - * callback function, which should be 0 for success or anything else
> - * to indicate failure.
> - */
> -int pwrdm_for_each_clkdm(struct powerdomain *pwrdm,
> -			 int (*fn)(struct powerdomain *pwrdm,
> -				   struct clockdomain *clkdm))
> -{
> -	int ret = 0;
> -	int i;
> -
> -	if (!fn)
> -		return -EINVAL;
> -
> -	for (i = 0; i < PWRDM_MAX_CLKDMS && !ret; i++)
> -		if (pwrdm->pwrdm_clkdms[i])
> -			ret = (*fn)(pwrdm, pwrdm->pwrdm_clkdms[i]);
> -
> -	return ret;
> -}
> -
> -/**
> - * pwrdm_get_voltdm - return a ptr to the voltdm that this pwrdm resides in
> - * @pwrdm: struct powerdomain *
> - *
> - * Return a pointer to the struct voltageomain that the specified powerdomain
> - * @pwrdm exists in.
> - */
> -struct voltagedomain *pwrdm_get_voltdm(struct powerdomain *pwrdm)
> -{
> -	return pwrdm->voltdm.ptr;
> -}
> -
> -/**
>   * pwrdm_get_mem_bank_count - get number of memory banks in this powerdomain
>   * @pwrdm: struct powerdomain *
>   *
> diff --git a/arch/arm/mach-omap2/powerdomain.h b/arch/arm/mach-omap2/powerdomain.h
> index 11bd4dd..28a796c 100644
> --- a/arch/arm/mach-omap2/powerdomain.h
> +++ b/arch/arm/mach-omap2/powerdomain.h
> @@ -212,11 +212,6 @@ int pwrdm_for_each_nolock(int (*fn)(struct powerdomain *pwrdm, void *user),
>  			void *user);
>  
>  int pwrdm_add_clkdm(struct powerdomain *pwrdm, struct clockdomain *clkdm);
> -int pwrdm_del_clkdm(struct powerdomain *pwrdm, struct clockdomain *clkdm);
> -int pwrdm_for_each_clkdm(struct powerdomain *pwrdm,
> -			 int (*fn)(struct powerdomain *pwrdm,
> -				   struct clockdomain *clkdm));
> -struct voltagedomain *pwrdm_get_voltdm(struct powerdomain *pwrdm);
>  
>  int pwrdm_get_mem_bank_count(struct powerdomain *pwrdm);
>  

I dont see immediate usage atm.. and at least looking at product kernel
for am335x, usage does not appear either.

Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
