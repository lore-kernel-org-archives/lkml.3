Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3LXILz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:11:55 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:28761
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab3LXILx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:11:53 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 24 Dec 2013 16:13:31 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Anson Huang <b20788@freescale.com>
CC: <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: improve the comment of CCM lpm SW workaround
Message-ID: <20131224081329.GF3872@S2101-09.ap.freescale.net>
References: <1387908047-1848-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387908047-1848-1-git-send-email-b20788@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 01:00:47PM -0500, Anson Huang wrote:
> Improve the comment of SW workaround for CCM lpm issue using
> hardware errata description to avoid confusion.
> 
> TKT194736:

This is not the errata number that will be seen by people publicly.
That's why I did not give it in the original commit d48866f (ARM: imx:
ensure dsm_request signal is not asserted when setting LPM).  But if you
check the log of that commit, you will find we already have the
information you're adding here.

The good thing is we have that errata publicly available now as below.

ERR007265 CCM: When improper low-power sequence is used, the SoC
enters low power mode before the ARM core executes WFI

http://cache.freescale.com/files/32bit/doc/errata/IMX6DQCE.pdf?fpsp=1

So if you want to make it clear, you should quote the errata info that
is publicly available to people.

Shawn

> Chip will enter low power mode before ARM A9 CPU executes
> WFI when improper low power sequence is used.
> 
> SW workaround:
> 1) SW will trigger irq #32(IOMUX) to be always pending manually by setting IOMUX_GPR1_GINT bit,
> 2) SW should then Unmask it in GPC before setting CCM LPM
> 3) SW should Mask it right after CCM LPM is set (set bit0-1 of CCM_CLPCR)
> 
> Signed-off-by: Anson Huang <b20788@freescale.com>
> ---
>  arch/arm/mach-imx/pm-imx6q.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
> index aecd9f8..8da4732 100644
> --- a/arch/arm/mach-imx/pm-imx6q.c
> +++ b/arch/arm/mach-imx/pm-imx6q.c
> @@ -156,10 +156,13 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
>  	}
>  
>  	/*
> -	 * Unmask the always pending IOMUXC interrupt #32 as wakeup source to
> -	 * deassert dsm_request signal, so that we can ensure dsm_request
> -	 * is not asserted when we're going to write CLPCR register to set LPM.
> -	 * After setting up LPM bits, we need to mask this wakeup source.
> +	 * TKT194736:
> +	 * Chip will enter low power mode before ARM A9 CPU executes WFI when improper low power sequence is used.
> +	 *
> +	 * SW workaround:
> +	 * 1) SW will trigger irq #32(IOMUXC) to be always pending manually by setting IOMUX_GPR1_GINT bit,
> +	 * 2) SW should then Unmask it in GPC before setting CCM LPM
> +	 * 3) SW should Mask it right after CCM LPM is set (set bit0-1 of CCM_CLPCR)
>  	 */
>  	iomuxc_irq_desc = irq_to_desc(32);
>  	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
> @@ -219,6 +222,8 @@ void __init imx6q_pm_init(void)
>  	WARN_ON(!ccm_base);
>  
>  	/*
> +	 * This is for SW workaround step #1 of TKT194736, see comments
> +	 * in imx6q_set_lpm for details of this errata.
>  	 * Force IOMUXC irq pending, so that the interrupt to GPC can be
>  	 * used to deassert dsm_request signal when the signal gets
>  	 * asserted unexpectedly.
> -- 
> 1.7.9.5
> 
> 

