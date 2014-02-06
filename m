Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaBFPD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:03:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46879 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbaBFPDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:03:53 -0500
Message-ID: <52F3A435.3020209@ti.com>
Date: Thu, 6 Feb 2014 17:03:17 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Illia Smyrnov <illia.smyrnov@globallogic.com>,
        =?ISO-8859-1?Q?Beno=EE?= =?ISO-8859-1?Q?t_Cousson?= 
	<bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP4: hwmod: Fix SOFTRESET logic for OMAP4
References: <1391612769-27890-1-git-send-email-illia.smyrnov@globallogic.com>
In-Reply-To: <1391612769-27890-1-git-send-email-illia.smyrnov@globallogic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 05:06 PM, Illia Smyrnov wrote:
> Commit 313a76e (ARM: OMAP2+: hwmod: Fix SOFTRESET logic) introduced
> softreset bit cleaning right after set one. It is caused L3 error for
> OMAP4 ISS because ISS register write occurs when ISS reset process is in
> progress. Avoid this situation by cleaning softreset bit later, when reset
> process is successfully finished.
> 
> Signed-off-by: Illia Smyrnov <illia.smyrnov@globallogic.com>

Acked-by: Roger Quadros <rogerq@ti.com>

> ---
>  arch/arm/mach-omap2/omap_hwmod.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
> index 42d8188..1f33f5d 100644
> --- a/arch/arm/mach-omap2/omap_hwmod.c
> +++ b/arch/arm/mach-omap2/omap_hwmod.c
> @@ -1947,29 +1947,31 @@ static int _ocp_softreset(struct omap_hwmod *oh)
>  		goto dis_opt_clks;
>  
>  	_write_sysconfig(v, oh);
> -	ret = _clear_softreset(oh, &v);
> -	if (ret)
> -		goto dis_opt_clks;
> -
> -	_write_sysconfig(v, oh);
>  
>  	if (oh->class->sysc->srst_udelay)
>  		udelay(oh->class->sysc->srst_udelay);
>  
>  	c = _wait_softreset_complete(oh);
> -	if (c == MAX_MODULE_SOFTRESET_WAIT)
> +	if (c == MAX_MODULE_SOFTRESET_WAIT) {
>  		pr_warning("omap_hwmod: %s: softreset failed (waited %d usec)\n",
>  			   oh->name, MAX_MODULE_SOFTRESET_WAIT);
> -	else
> +		ret = -ETIMEDOUT;
> +		goto dis_opt_clks;
> +	} else {
>  		pr_debug("omap_hwmod: %s: softreset in %d usec\n", oh->name, c);
> +	}
> +
> +	ret = _clear_softreset(oh, &v);
> +	if (ret)
> +		goto dis_opt_clks;
> +
> +	_write_sysconfig(v, oh);
>  
>  	/*
>  	 * XXX add _HWMOD_STATE_WEDGED for modules that don't come back from
>  	 * _wait_target_ready() or _reset()
>  	 */
>  
> -	ret = (c == MAX_MODULE_SOFTRESET_WAIT) ? -ETIMEDOUT : 0;
> -
>  dis_opt_clks:
>  	if (oh->flags & HWMOD_CONTROL_OPT_CLKS_IN_RESET)
>  		_disable_optional_clocks(oh);
> 

