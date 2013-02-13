Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939Ab3BMVrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:47:52 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60758 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3BMVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:47:50 -0500
Date: Wed, 13 Feb 2013 13:47:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH 06/10] Input: atmel_mxt_ts - destroy state before fw
 update and restore after
Message-ID: <20130213214742.GD23390@core.coreip.homeip.net>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
 <1359706312-24642-7-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359706312-24642-7-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:11:48PM +0800, Daniel Kurtz wrote:
> After firmware update, the device may have a completely different object
> table which corresponds to an input device with different properties.
> So, destroy the old state before firmware update, and completely
> reinitialize the driver afterward.
> 
> Two benefits of this:
>  1) Since there is no input device during fw update, no need to worry
> about device open/close events.
>  2) If firmware update fails, the device and driver will still be in
> bootloader mode and an improperly configured input device will not exist.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 76a25d3..c74f5a5 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1001,6 +1001,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>  		client->addr = MXT_BOOT_HIGH;
>  
>  bootloader_ready:
> +	/* Free any driver state. It will get reinitialized after fw update. */
> +	mxt_free_object_table(data);
> +	if (data->input_dev) {
> +		input_unregister_device(data->input_dev);
> +		data->input_dev = NULL;
> +	}
> +
>  	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
>  	if (ret)
>  		goto out;
> @@ -1068,9 +1075,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
>  		/* Wait for reset */
>  		msleep(MXT_FWRESET_TIME);
>  
> -		mxt_free_object_table(data);
> -
>  		mxt_initialize(data);
> +		mxt_input_dev_create(data);

What if it fails?

>  	}
>  
>  	enable_irq(data->irq);
> -- 
> 1.8.1
> 

-- 
Dmitry
