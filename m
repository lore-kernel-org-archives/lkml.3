Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaIAJHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:07:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:10518 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaIAJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:06:58 -0400
Date: Mon, 1 Sep 2014 11:07:16 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Simon Lindgren <simon@aqwary.com>
CC: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c:at91: Fix a race condition during signal handling in
 at91_do_twi_xfer.
Message-ID: <20140901090715.GS4434@ldesroches-Latitude-E6320>
Mail-Followup-To: Simon Lindgren <simon@aqwary.com>, wsa@the-dreams.de,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1409080404-19069-1-git-send-email-simon@aqwary.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409080404-19069-1-git-send-email-simon@aqwary.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:13:24PM +0200, Simon Lindgren wrote:
> There is a race condition in at91_do_twi_xfer when signals arrive.
> If a signal is recieved while waiting for a transfer to complete
> wait_for_completion_interruptible_timeout() will return -ERESTARTSYS.
> This is not handled correctly resulting in interrupts still being
> enabled and a transfer being in flight when we return.
> 
> Symptoms include a range of oopses and bus lockups. Oopses can happen
> when the transfer completes because the interrupt handler will corrupt
> the stack. If a new transfer is started before the interrupt fires
> the controller will start a new transfer in the middle of the old one,
> resulting in confused slaves and a locked bus.
> 
> To avoid this, use wait_for_completion_io_timeout instead so that we
> don't have to deal with gracefully shutting down the transfer and
> disabling the interrupts.
> 
> Signed-off-by: Simon Lindgren <simon@aqwary.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks for this fix.

> ---
>  drivers/i2c/busses/i2c-at91.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 79a6899..ec299ae 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -421,8 +421,8 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
>  		}
>  	}
>  
> -	ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete,
> -							dev->adapter.timeout);
> +	ret = wait_for_completion_io_timeout(&dev->cmd_complete,
> +					     dev->adapter.timeout);
>  	if (ret == 0) {
>  		dev_err(dev->dev, "controller timed out\n");
>  		at91_init_twi_bus(dev);
> -- 
> 1.7.9.5
> 
