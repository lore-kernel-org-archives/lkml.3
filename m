Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaEVL6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:58:49 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:41304 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaEVL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:58:47 -0400
Message-ID: <537DE67A.10203@cogentembedded.com>
Date: Thu, 22 May 2014 15:58:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: gregkh@linuxfoundation.org, balbi@ti.com, zonque@gmail.com, b-liu@ti.com
Subject: Re: [PATCH v5 6/6] usb: musb: dsps: Enable sw babble control for
 newer silicon
References: <1400740181-31213-1-git-send-email-george.cherian@ti.com> <1400740181-31213-7-git-send-email-george.cherian@ti.com>
In-Reply-To: <1400740181-31213-7-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-05-2014 10:29, George Cherian wrote:

> Find whether we are running on newer silicon. The babble control
> register reads 0x4 by default in newer silicon as opposed to 0
> in old versions of AM335x. Based on this enable the sw babble
> control logic.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_dsps.c | 38 ++++++++++++++++++++++++++++++++------
>   1 file changed, 32 insertions(+), 6 deletions(-)

> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 868caf8..2ced061 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
[...]
> @@ -469,6 +470,19 @@ static int dsps_musb_init(struct musb *musb)
>   	val &= ~(1 << wrp->otg_disable);
>   	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
>
> +	/*
> +	 *  Check whether the dsps version has babble control enabled.

    One space too many before this sentence.

> +	 * In latest silicon revision the babble control logic is enabled.
> +	 * If MUSB_BABBLE_CTL returns 0x4 then we have the babble control
> +	 * logic enabled.
> +	 */
> +	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> +	if (val == MUSB_BABBLE_RCV_DISABLE) {
> +		glue->sw_babble_enabled = true;
> +		val |= MUSB_BABBLE_SW_SESSION_CTRL;
> +		dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, val);
> +	}
> +

    Hm, from the register offset that you declared in the previous patch, I 
got an impression that this is a new standard MUSB register? Shouldn't this 
check be done in the generic MUSB code then?

WBR, Sergei

