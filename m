Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaHFUdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:33:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59512 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHFUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:33:43 -0400
Date: Wed, 6 Aug 2014 13:33:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] Input: hyperv-keyboard: register as a wakeup source
Message-ID: <20140806203339.GA22889@core.coreip.homeip.net>
References: <1406903304-7256-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406903304-7256-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 07:28:24AM -0700, Dexuan Cui wrote:
> With this patch, we can press a key to wake up the VM after the VM executes
> "echo freeze > /sys/power/state".
> 
> This addresses part of https://bugzilla.redhat.com/show_bug.cgi?id=1086100

I am sorry but this bug is not open to the public. Please avoid
mentioning such bugs in changelogs. Otherwise I'll apply it.

> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/input/serio/hyperv-keyboard.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
> index 6132619..e74e5d6 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -170,6 +170,15 @@ static void hv_kbd_on_receive(struct hv_device *hv_dev,
>  			serio_interrupt(kbd_dev->hv_serio, scan_code, 0);
>  		}
>  		spin_unlock_irqrestore(&kbd_dev->lock, flags);
> +
> +		/*
> +		 * Only trigger a wakeup on key down, otherwise
> +		 * "echo freeze > /sys/power/state" can't really enter the
> +		 * state because the Enter-UP can trigger a wakeup at once.
> +		 */
> +		if (!(info & IS_BREAK))
> +			pm_wakeup_event(&hv_dev->device, 0);
> +
>  		break;
>  
>  	default:
> @@ -376,6 +385,9 @@ static int hv_kbd_probe(struct hv_device *hv_dev,
>  		goto err_close_vmbus;
>  
>  	serio_register_port(kbd_dev->hv_serio);
> +
> +	device_init_wakeup(&hv_dev->device, true);
> +
>  	return 0;
>  
>  err_close_vmbus:
> @@ -390,6 +402,7 @@ static int hv_kbd_remove(struct hv_device *hv_dev)
>  {
>  	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(hv_dev);
>  
> +	device_init_wakeup(&hv_dev->device, false);
>  	serio_unregister_port(kbd_dev->hv_serio);
>  	vmbus_close(hv_dev->channel);
>  	kfree(kbd_dev);
> -- 
> 1.9.1
> 

-- 
Dmitry
