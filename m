Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab3CNPCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777Ab3CNPCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:02:00 -0400
Date: Thu, 14 Mar 2013 12:01:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kevin Baradon <kevin.baradon@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 1/2] media/rc/imon.c: make send_packet() delay
 configurable
Message-ID: <20130314120153.7bb71ad8@redhat.com>
In-Reply-To: <1361737170-4687-2-git-send-email-kevin.baradon@gmail.com>
References: <1361737170-4687-1-git-send-email-kevin.baradon@gmail.com>
	<1361737170-4687-2-git-send-email-kevin.baradon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 24 Feb 2013 21:19:29 +0100
Kevin Baradon <kevin.baradon@gmail.com> escreveu:

> Some imon devices (like 15c2:0036) need a higher delay between send_packet calls.
> Default value is still 5ms to avoid regressions on already working hardware.
> 
> Also use interruptible wait to avoid load average going too high (and let caller handle signals).
> 
> Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
> ---
>  drivers/media/rc/imon.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 78d109b..a3e66a0 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -347,6 +347,11 @@ module_param(pad_stabilize, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(pad_stabilize, "Apply stabilization algorithm to iMON PAD "
>  		 "presses in arrow key mode. 0=disable, 1=enable (default).");
>  
> +static unsigned int send_packet_delay = 5;
> +module_param(send_packet_delay, uint, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(send_packet_delay, "Minimum delay between send_packet() calls "
> +		 "(default 5ms)");
> +

Users will find a hard time discovering what delay is needed for each device.

If this is a per-device type property, then it should, instead, be associated
with the device's USB ID.

The better would be to encapsulate it at the USB device table, like adding a
NEED_(extra)_DELAY flag, like:

	{ USB_DEVICE(0x15c2, 0x0036),  .driver_info = NEED_10MS_DELAY },

If such flag is zero (like on all devices where .driver_info is not filled, as
Kernel zeroes the memory on all static vars), then it will keep using 5ms.

Another alternative would be to use .driver_info for the device type, and
add a logic to handle different types with different logic. This is what
mceusb.c does, for example.

>  /*
>   * In certain use cases, mouse mode isn't really helpful, and could actually
>   * cause confusion, so allow disabling it when the IR device is open.
> @@ -535,12 +540,15 @@ static int send_packet(struct imon_context *ictx)
>  	kfree(control_req);
>  
>  	/*
> -	 * Induce a mandatory 5ms delay before returning, as otherwise,
> +	 * Induce a mandatory delay before returning, as otherwise,
>  	 * send_packet can get called so rapidly as to overwhelm the device,
>  	 * particularly on faster systems and/or those with quirky usb.
> +	 * Do not use TASK_UNINTERRUPTIBLE as this routine is called quite often
> +	 * and doing so will increase load average slightly. Caller will handle
> +	 * signals itself.
>  	 */
> -	timeout = msecs_to_jiffies(5);
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> +	timeout = msecs_to_jiffies(send_packet_delay);
> +	set_current_state(TASK_INTERRUPTIBLE);
>  	schedule_timeout(timeout);
>  
>  	return retval;

Regards,
Mauro
