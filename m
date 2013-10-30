Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3J3LZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:25:59 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:54726 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3J3LZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:25:56 -0400
Date: Wed, 30 Oct 2013 12:25:51 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, Johan Hovold <jhovold@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: atmel_pwm: add deferred-probing support
Message-ID: <20131030112551.GB29813@localhost>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
 <1382459560-26596-2-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382459560-26596-2-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:32:39PM +0200, Johan Hovold wrote:
> Two drivers (atmel-pwm-bl and leds-atmel-pwm) currently depend on the
> atmel_pwm driver to have bound to any pwm-device before their devices
> are probed.
> 
> Support deferred probing of such devices by making sure to return
> -EPROBE_DEFER from pwm_channel_alloc when no pwm-device has yet been
> bound.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

This patch, 5c6d6fd1 ("misc: atmel_pwm: add deferred-probing support"),
and 9d3fde86 ("backlight: atmel-pwm-bl: fix deferred probe from __init")
in linux-next should probably be considered for inclusion in stable.

Without them the atmel-pwm-bl driver may always fail to probe depending
on link order.

Thanks,
Johan

> ---
>  drivers/misc/atmel_pwm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
> index 494d050..a6dc56e 100644
> --- a/drivers/misc/atmel_pwm.c
> +++ b/drivers/misc/atmel_pwm.c
> @@ -90,8 +90,10 @@ int pwm_channel_alloc(int index, struct pwm_channel *ch)
>  	unsigned long	flags;
>  	int		status = 0;
>  
> -	/* insist on PWM init, with this signal pinned out */
> -	if (!pwm || !(pwm->mask & 1 << index))
> +	if (!pwm)
> +		return -EPROBE_DEFER;
> +
> +	if (!(pwm->mask & 1 << index))
>  		return -ENODEV;
>  
>  	if (index < 0 || index >= PWM_NCHAN || !ch)
> -- 
> 1.8.4
> 
