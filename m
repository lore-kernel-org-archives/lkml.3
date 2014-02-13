Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaBMTXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:23:47 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:8864 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaBMTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:23:46 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 11:11:06 -0800
Message-ID: <52FD1BC0.1050009@synaptics.com>
Date: Thu, 13 Feb 2014 11:23:44 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andrew Duggan <aduggan@synaptics.com>,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] Input: synaptics-rmi4 - do not update configuration
 in rmi_f01_probe()
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-3-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-3-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> Do not write configuration data in probe(), we have config() for that.

Then we should call config() in rmi_function_probe() to ensure that
any platform data or device tree configuration settings get written
to the device.

Thinking about that, it looks like it's not fatal if the config
write fails in that situation.  The device might not function as
intended, but you can hopefully get some use out of it (for
instance, a phone's touchscreen sensitivity might be wacky, but
the user will still be able to dial tech support).

For example:

static int rmi_function_probe(struct device *dev)
{
	struct rmi_function *fn = to_rmi_function(dev);
	struct rmi_function_handler *handler = 			 
to_rmi_function_handler(dev->driver);
	int error;

	if (handler->probe) {
		error = handler->probe(fn);
		if (error)
			return error;
	}
	if (handler->config) {
		error = handler->config(fn);
		if (error)
			dev_warn(dev, "Driver config failed.\n");
	}

	return 0;
}

>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/rmi4/rmi_f01.c | 18 ------------------
>   1 file changed, 18 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 897d8ac..976aba3 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -303,12 +303,6 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		if (pdata->power_management.doze_interval) {
>   			data->device_control.doze_interval =
>   				pdata->power_management.doze_interval;
> -			error = rmi_write(rmi_dev, data->doze_interval_addr,
> -					data->device_control.doze_interval);
> -			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to configure F01 doze interval register.\n");
> -				return error;
> -			}
>   		} else {
>   			error = rmi_read(rmi_dev, data->doze_interval_addr,
>   					&data->device_control.doze_interval);
> @@ -324,12 +318,6 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		if (pdata->power_management.wakeup_threshold) {
>   			data->device_control.wakeup_threshold =
>   				pdata->power_management.wakeup_threshold;
> -			error = rmi_write(rmi_dev, data->wakeup_threshold_addr,
> -					data->device_control.wakeup_threshold);
> -			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to configure F01 wakeup threshold register.\n");
> -				return error;
> -			}
>   		} else {
>   			error = rmi_read(rmi_dev, data->wakeup_threshold_addr,
>   					&data->device_control.wakeup_threshold);
> @@ -347,12 +335,6 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		if (pdata->power_management.doze_holdoff) {
>   			data->device_control.doze_holdoff =
>   				pdata->power_management.doze_holdoff;
> -			error = rmi_write(rmi_dev, data->doze_holdoff_addr,
> -					data->device_control.doze_holdoff);
> -			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to configure F01 doze holdoff register.\n");
> -				return error;
> -			}
>   		} else {
>   			error = rmi_read(rmi_dev, data->doze_holdoff_addr,
>   					&data->device_control.doze_holdoff);
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
