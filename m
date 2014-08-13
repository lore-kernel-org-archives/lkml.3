Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaHMWWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:22:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49383 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaHMWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:22:15 -0400
Date: Wed, 13 Aug 2014 15:22:12 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Marc Carino <marc.ceeeee@gmail.com>, kernel-janitors@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 11/14] ARM: brcmstb: delete unneeded test before
 of_node_put
Message-ID: <20140813222212.GB18411@ld-irv-0074>
References: <1407492475-26283-11-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407492475-26283-11-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Fri, Aug 08, 2014 at 12:07:52PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Simplify the error path to avoid calling of_node_put when it is not needed.
> 
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> 
> -if (e)
>    of_node_put(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  arch/arm/mach-bcm/platsmp-brcmstb.c |   14 ++++++--------

This file is being dropped temporarily, for rework/resubmission at a
later time:

  https://lkml.org/lkml/2014/8/13/617

But thanks for the patch. I'll take it into account in the future. A few
comments below.

>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
> index af780e9..c515ea1 100644
> --- a/arch/arm/mach-bcm/platsmp-brcmstb.c
> +++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
> @@ -227,7 +227,7 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
>  	if (!syscon_np) {
>  		pr_err("can't find phandle %s\n", name);
>  		rc = -EINVAL;
> -		goto cleanup;
> +		goto out;
>  	}
>  
>  	cpubiuctrl_block = of_iomap(syscon_np, 0);
> @@ -256,9 +256,8 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
>  	}
>  
>  cleanup:
> -	if (syscon_np)
> -		of_node_put(syscon_np);
> -
> +	of_node_put(syscon_np);
> +out:

Is there a good reason for this new label? I thought part of the point
of this semantic patch is that the previous line (of_node_put()) is a
no-op for NULL arguments.

>  	return rc;
>  }
>  
> @@ -274,7 +273,7 @@ static int __init setup_hifcont_regs(struct device_node *np)
>  	if (!syscon_np) {
>  		pr_err("can't find phandle %s\n", name);
>  		rc = -EINVAL;
> -		goto cleanup;
> +		goto out;
>  	}
>  
>  	hif_cont_block = of_iomap(syscon_np, 0);
> @@ -288,9 +287,8 @@ static int __init setup_hifcont_regs(struct device_node *np)
>  	hif_cont_reg = 0;
>  
>  cleanup:
> -	if (syscon_np)
> -		of_node_put(syscon_np);
> -
> +	of_node_put(syscon_np);
> +out:

Ditto.

>  	return rc;
>  }
>  
> 

Brian
