Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030956Ab3HIUab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:30:31 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34151 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030827Ab3HIUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:30:29 -0400
Message-ID: <5205516D.1030707@cogentembedded.com>
Date: Sat, 10 Aug 2013 00:30:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Bin Liu <binmlist@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, george.cherian@ti.com
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin HOST-only
 mode
References: <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com> <51F2DD90.2030405@linutronix.de> <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com> <20130729165329.GA5773@linutronix.de> <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com> <51F6ABA2.7060102@linutronix.de> <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com> <20130809160339.GA14829@linutronix.de>
In-Reply-To: <20130809160339.GA14829@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/09/2013 08:03 PM, Sebastian Andrzej Siewior wrote:

> This is what I observe:
> On the first connect, the musb starts with DEVCTL.Session set. On
> disconnect, musb_core calls try_idle. That functions removes the Session
> bit signalize that the session is over (something that only in OTG is
> required). A new device, that is plugged, is no longer recognized.
> I've setup a timer and checked the DEVCTL register and I haven't seen a
> change in VBus and I saw the B-Device bit set. After setting the IDDIG
> into A mode and forcing the device to behave like I didn't see a change.
> Neither VBUS goes to 0b11 nor does a session start request come.
> The TI-v3.2 kernel they skip to call musb_platform_try_idle() in the
> OTG_STATE_A_WAIT_BCON state while not in OTG mode.
> Since the second port hast a standard A plug the patch changes the port
> to run in host mode only, force the id-pin to host only and skip the
> timer which would remove DEVCTL.Session.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
[...]

> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 4ffbaac..b0752fa 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
[...]
> @@ -388,6 +393,14 @@ static int dsps_musb_init(struct musb *musb)
>   	val &= ~(1 << wrp->otg_disable);
>   	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
>
> +	if (musb->port_mode == MUSB_PORT_MODE_HOST) {
> +		val = USBMODE_IDDIG_A;
> +		val |= USBMODE_ID_MUX_REG;

    Why not do the above in one line and save on {} {}? It will look more 
aesthetically pleasing IMHO.

> +	} else {
> +		val = USBMODE_ID_MUX_PHY;
> +	}
> +	dsps_writel(musb->ctrl_base, wrp->mode, val);
> +

WBR, Sergei


