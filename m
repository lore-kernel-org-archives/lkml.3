Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaEVLXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:23:15 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:47782 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaEVLXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:23:13 -0400
Message-ID: <537DDE24.9040105@cogentembedded.com>
Date: Thu, 22 May 2014 15:23:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: gregkh@linuxfoundation.org, balbi@ti.com, zonque@gmail.com, b-liu@ti.com
Subject: Re: [PATCH v5 5/6] usb: musb: dsps: Add the sw_babble_control()
References: <1400740181-31213-1-git-send-email-george.cherian@ti.com> <1400740181-31213-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1400740181-31213-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-05-2014 10:29, George Cherian wrote:

> Add sw_babble_control() logic to differentiate between transient
> babble and real babble condition. Also add the SW babble control
> register definitions.

> Babble control register logic is implemented in the latest
> revision of AM335x.

> Signed-off-by: George Cherian <george.cherian@ti.com>

    Sorry for the late comments, I probably didn't pay enough attention to 
this series before...

> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index f6f3087..868caf8 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -536,6 +536,56 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
>   	return 0;
>   }
>
> +static int sw_babble_control(struct musb *musb)

    Perhaps the result type should be *bool* instead of *int*?

> +{
> +	int timeout = 10;
> +	u8 babble_ctl, session_restart = 0;
> +
> +	babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> +	dev_dbg(musb->controller, "babble: MUSB_BABBLE_CTL value %x\n",
> +		babble_ctl);
> +	/*
> +	 * check line monitor flag to check whether babble is
> +	 * due to noise
> +	 */
> +	dev_dbg(musb->controller, "STUCK_J is %s\n",
> +		babble_ctl & MUSB_BABBLE_STUCK_J ? "set" : "reset");
> +
> +	if (babble_ctl & MUSB_BABBLE_STUCK_J) {

    'timeout' could be declared here, local to the block using it.

> +		/*
> +		 * babble is due to noise, then set transmit idle (d7 bit)
> +		 * to resume normal operation
> +		 */
> +		babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> +		babble_ctl |= MUSB_BABBLE_FORCE_TXIDLE;
> +		dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, babble_ctl);
> +
> +		/* wait till line monitor flag cleared */
> +		dev_dbg(musb->controller, "Set TXIDLE, wait J to clear\n");
> +		do {
> +			babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> +			udelay(1);
> +		} while ((babble_ctl & MUSB_BABBLE_STUCK_J) && timeout--);
> +
> +		/* check whether stuck_at_j bit cleared */
> +		if (babble_ctl & MUSB_BABBLE_STUCK_J) {
> +			/*
> +			 * real babble condition is occured

    s/is occured/has occurred/.

> +			 * restart the controller to start the
> +			 * session again
> +			 */
> +			dev_dbg(musb->controller, "J not cleared, misc (%x)\n",
> +				babble_ctl);
> +			session_restart = 1;
> +		}
> +

    Empty line not needed here.

> +	} else {
> +		session_restart = 1;
> +	}
> +
> +	return session_restart;
> +}

WBR, Sergei

