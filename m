Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbaEMNOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:14:44 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33471 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbaEMNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:14:42 -0400
Message-ID: <53721ABF.8060705@gmail.com>
Date: Tue, 13 May 2014 15:14:39 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com> <5371EA01.3080307@gmail.com> <537208A9.4020507@ti.com> <53720E0F.3070008@gmail.com> <537216AC.4090401@ti.com>
In-Reply-To: <537216AC.4090401@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 05/13/2014 02:57 PM, George Cherian wrote:
> I never enabled the MUSB_BABBLE_SW_SESSION_CTRL in the MUSB_BABBLE_CTL reg.
> can you try with the following patch.
> 
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 1ae6681..1160cd1 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -477,8 +477,11 @@ static int dsps_musb_init(struct musb *musb)
>   	 * logic enabled.
>   	 */
>   	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
> -	if (val == MUSB_BABBLE_RCV_DISABLE)
> +	if (val == MUSB_BABBLE_RCV_DISABLE) {
>   		glue->sw_babble_enabled = true;
> +		val |= MUSB_BABBLE_SW_SESSION_CTRL;
> +	        dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, val);
> +	}
>   
>   	ret = dsps_musb_dbg_init(musb, glue);
>   	if (ret)

MUSB_BABBLE_STUCK_J still remains unset, so I get the same result as
without the patch: a full glue reset is conducted. Do I get you right
that you expect MUSB_BABBLE_STUCK_J to be set in babble conditions when
MUSB_BABBLE_SW_SESSION_CTRL is set?


[   19.672373] CAUTION: musb: Babble Interrupt Occurred
[   19.677776] musb_stage0_irq 789: unhandled DISCONNECT transition
(a_wait_bcon)
[   19.685815] usb 1-1: USB disconnect, device number 3
[   19.769720] musb-hdrc musb-hdrc.0.auto: babble: MUSB_BABBLE_CTL value 44
[   19.776765] musb-hdrc musb-hdrc.0.auto: STUCK_J is reset


I don't quite follow, especially as I lack documentation of the IP core.
How do you test babble errors, is there any way to force them to happen
reliably?

Anyway, the full glue layer solves this rare condition quite well for
me. Is there any downside of this?


Daniel

