Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaCCJPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:15:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32252 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaCCJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:15:27 -0500
Date: Mon, 3 Mar 2014 12:15:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Axel Rasmussen <axel.rasmussen1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] drivers: staging: rtl8187se: refactor
 wmm_param_update
Message-ID: <20140303091515.GK26722@mwanda>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
 <1393737773-13937-10-git-send-email-axel.rasmussen1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393737773-13937-10-git-send-email-axel.rasmussen1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 10:22:53PM -0700, Axel Rasmussen wrote:
> The function rtl8180_wmm_param_update contained two blocks of code which
> were nearly identical. This patch combines those two blocks into a
> single function, to reduce code duplication, and do fix some
> checkpatch.pl warnings about excessively long lines due to the large
> number of indents that were needed for the original blocks of code.
> 
> Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
> ---
>  drivers/staging/rtl8187se/r8180_core.c | 119 ++++++++++++++-------------------
>  1 file changed, 49 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index b6fdb6f..fc5d4d9 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -2114,16 +2114,49 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
>  	spin_unlock_irqrestore(&priv->ps_lock, flags);
>  }
>  
> +static void rtl8180_wmm_single_param_update(struct net_device *dev,
> +	u8 mode, AC_CODING eACI, PAC_PARAM param)
> +{
> +	u8 u1bAIFS;
> +	u32 u4bAcParam;
> +
> +	/* Retrieve parameters to update. */
> +	/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
> +	u1bAIFS = param->f.AciAifsn.f.AIFSN * ((mode & IEEE_G) == IEEE_G ?
> +		9 : 20) + aSifsTime;
> +	u4bAcParam = (((u32)param->f.TXOPLimit << AC_PARAM_TXOP_LIMIT_OFFSET) |
> +		((u32)param->f.Ecw.f.ECWmax << AC_PARAM_ECW_MAX_OFFSET) |
> +		((u32)param->f.Ecw.f.ECWmin << AC_PARAM_ECW_MIN_OFFSET) |
> +		((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
> +
> +	switch (eACI) {
> +	case AC1_BK:
> +		write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
> +		break;
> +	case AC0_BE:
> +		write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
> +		break;
> +	case AC2_VI:
> +		write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
> +		break;
> +	case AC3_VO:
> +		write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
> +		break;
> +	default:
> +		pr_warn("SetHwReg8185(): invalid ACI: %d!\n", eACI);
> +	break;

Missing tab here.  Anyway, just swap all the break statements for
returns.

regards,
dan carpenter

> +	}
> +}
> +

