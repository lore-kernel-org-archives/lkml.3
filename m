Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3FGSi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:38:27 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:46190 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3FGSi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:38:26 -0400
Message-ID: <51B228A6.3010908@cogentembedded.com>
Date: Fri, 07 Jun 2013 22:38:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Stoffregen <paul@pjrc.com>
Subject: Re: [PATCH] USB: cdc-acm: remove unneeded spin_lock_irqsave/restore
 on write path
References: <20130607183247.GA6850@kroah.com>
In-Reply-To: <20130607183247.GA6850@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/07/2013 10:32 PM, Greg Kroah-Hartman wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> When writing data we were:
> 	lock
> 	do some work
> 	unlock
> 	call function
> 		lock
> 		do some work
> 		unlock
> 		return
> 	return
>
> It turns out, that "function" was only ever called in the one place, so
> instead of locking/unlocking for no good reason, just inline the
> function and only grab the lock once.
>
> This has sped up the pathological case of sending 1 byte packets to a
> loop-back cdc-acm device from 49600 bytes per second to 50100 bytes a
> second on my workstation.  A tiny increase yes, but noticable, and now
> the spinlock isn't the hottest thing on the perf graph anymore.  Yes, we
> are still waiting for the hardware for the most part, but getting rid of
> a spin_lock_irqsave() call for every packet is still a good thing.
>
> And we end up deleting lines of code, always a win overall.
>
> This was found by using a Teensy 3.0 device and the test program and
> firmware located at:
> 	http://www.pjrc.com/teensy/benchmark_usb_serial_receive.html
>
> Reported-by: Paul Stoffregen <paul@pjrc.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   drivers/usb/class/cdc-acm.c |   51 +++++++++++++++-----------------------------
>   1 file changed, 18 insertions(+), 33 deletions(-)
>
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
[...]
> @@ -653,13 +621,30 @@ static int acm_tty_write(struct tty_stru
>   	}
>   	wb = &acm->wb[wbn];
>   
> +	if (!acm->dev) {
> +		wb->use = 0;
> +		spin_unlock_irqrestore(&acm->write_lock, flags);
> +		return -ENODEV;
> +	}
> +
>   	count = (count > acm->writesize) ? acm->writesize : count;
>   	dev_vdbg(&acm->data->dev, "%s - write %d\n", __func__, count);
>   	memcpy(wb->buf, buf, count);
>   	wb->len = count;
>   	spin_unlock_irqrestore(&acm->write_lock, flags);
>   
> -	stat = acm_write_start(acm, wbn);
> +	usb_autopm_get_interface_async(acm->control);
> +	if (acm->susp_count) {
> +		if (!acm->delayed_wb)
> +			acm->delayed_wb = wb;
> +		else
> +			usb_autopm_put_interface_async(acm->control);
> +		spin_unlock_irqrestore(&acm->write_lock, flags);

    But you've already dropped it above the *if* and not taken again?

> +		return count;	/* A white lie */
> +	}
> +	usb_mark_last_busy(acm->dev);
> +
> +	stat = acm_start_wb(acm, wb);
>   	if (stat < 0)
>   		return stat;
>   	return count;
>

WBR, Sergei

