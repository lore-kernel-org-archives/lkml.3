Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBMVdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:33:17 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:17306 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaBMVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:33:12 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 13:20:32 -0800
Message-ID: <52FD3A17.7040803@synaptics.com>
Date: Thu, 13 Feb 2014 13:33:11 -0800
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
Subject: Re: [PATCH 08/11] Input: synaptics-rmi4 - use rmi_read/rmi_write
 in F01
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-8-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-8-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> Use rmi_read()/rmi_write() for reading/writing single-byte data. Also print
> error code when IO fails.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Christopher Heiny <cheiny@synaptics.com>

> ---
>   drivers/input/rmi4/rmi_f01.c | 170 ++++++++++++++++++++++---------------------
>   1 file changed, 88 insertions(+), 82 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 1219e0c..a2f05bc 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -171,8 +171,9 @@ static int rmi_f01_read_properties(struct rmi_device *rmi_dev,
>
>   	error = rmi_read_block(rmi_dev, query_base_addr,
>   			       basic_query, sizeof(basic_query));
> -	if (error < 0) {
> -		dev_err(&rmi_dev->dev, "Failed to read device query registers.\n");
> +	if (error) {
> +		dev_err(&rmi_dev->dev,
> +			"Failed to read device query registers: %d\n", error);
>   		return error;
>   	}
>
> @@ -205,25 +206,25 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   {
>   	u8 temp;
>   	int error;
> -	u16 ctrl_base_addr;
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
>   	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
>   	struct f01_data *f01 = fn->data;
> -	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	const struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	u16 ctrl_base_addr = fn->fd.control_base_addr;
>   	u8 device_status;
>
>   	/*
>   	 * Set the configured bit and (optionally) other important stuff
>   	 * in the device control register.
>   	 */
> -	ctrl_base_addr = fn->fd.control_base_addr;
> -	error = rmi_read_block(rmi_dev, fn->fd.control_base_addr,
> -			&f01->device_control.ctrl0,
> -			sizeof(f01->device_control.ctrl0));
> -	if (error < 0) {
> -		dev_err(&fn->dev, "Failed to read F01 control.\n");
> +
> +	error = rmi_read(rmi_dev, fn->fd.control_base_addr,
> +			 &f01->device_control.ctrl0);
> +	if (error) {
> +		dev_err(&fn->dev, "Failed to read F01 control: %d\n", error);
>   		return error;
>   	}
> +
>   	switch (pdata->power_management.nosleep) {
>   	case RMI_F01_NOSLEEP_DEFAULT:
>   		break;
> @@ -249,11 +250,10 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>
>   	f01->device_control.ctrl0 |= RMI_F01_CRTL0_CONFIGURED_BIT;
>
> -	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
> -				&f01->device_control.ctrl0,
> -				sizeof(f01->device_control.ctrl0));
> -	if (error < 0) {
> -		dev_err(&fn->dev, "Failed to write F01 control.\n");
> +	error = rmi_write(rmi_dev, fn->fd.control_base_addr,
> +			  f01->device_control.ctrl0);
> +	if (error) {
> +		dev_err(&fn->dev, "Failed to write F01 control: %d\n", error);
>   		return error;
>   	}
>
> @@ -265,9 +265,10 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   	error = rmi_read_block(rmi_dev, ctrl_base_addr,
>   				f01->device_control.interrupt_enable,
>   				sizeof(u8) * (f01->num_of_irq_regs));
> -	if (error < 0) {
> +	if (error) {
>   		dev_err(&fn->dev,
> -			"Failed to read F01 control interrupt enable register.\n");
> +			"Failed to read F01 control interrupt enable register: %d\n",
> +			error);
>   		return error;
>   	}
>
> @@ -302,8 +303,10 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		} else {
>   			error = rmi_read(rmi_dev, f01->doze_interval_addr,
>   					 &f01->device_control.doze_interval);
> -			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to read F01 doze interval register.\n");
> +			if (error) {
> +				dev_err(&fn->dev,
> +					"Failed to read F01 doze interval register: %d\n",
> +					error);
>   				return error;
>   			}
>   		}
> @@ -318,7 +321,9 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   			error = rmi_read(rmi_dev, f01->wakeup_threshold_addr,
>   					 &f01->device_control.wakeup_threshold);
>   			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to read F01 wakeup threshold register.\n");
> +				dev_err(&fn->dev,
> +					"Failed to read F01 wakeup threshold register: %d\n",
> +					error);
>   				return error;
>   			}
>   		}
> @@ -337,17 +342,19 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   		} else {
>   			error = rmi_read(rmi_dev, f01->doze_holdoff_addr,
>   					 &f01->device_control.doze_holdoff);
> -			if (error < 0) {
> -				dev_err(&fn->dev, "Failed to read F01 doze holdoff register.\n");
> +			if (error) {
> +				dev_err(&fn->dev,
> +					"Failed to read F01 doze holdoff register: %d\n",
> +					error);
>   				return error;
>   			}
>   		}
>   	}
>
> -	error = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
> -		&device_status, sizeof(device_status));
> +	error = rmi_read(rmi_dev, fn->fd.data_base_addr, &device_status);
>   	if (error < 0) {
> -		dev_err(&fn->dev, "Failed to read device status.\n");
> +		dev_err(&fn->dev,
> +			"Failed to read device status: %d\n", error);
>   		return error;
>   	}
>
> @@ -364,50 +371,53 @@ static int rmi_f01_initialize(struct rmi_function *fn)
>   static int rmi_f01_config(struct rmi_function *fn)
>   {
>   	struct f01_data *f01 = fn->data;
> -	int retval;
> -
> -	retval = rmi_write_block(fn->rmi_dev, fn->fd.control_base_addr,
> -				 &f01->device_control.ctrl0,
> -				 sizeof(f01->device_control.ctrl0));
> -	if (retval < 0) {
> -		dev_err(&fn->dev, "Failed to write device_control.reg.\n");
> -		return retval;
> +	int error;
> +
> +	error = rmi_write(fn->rmi_dev, fn->fd.control_base_addr,
> +			  f01->device_control.ctrl0);
> +	if (error) {
> +		dev_err(&fn->dev,
> +			"Failed to write device_control register: %d\n", error);
> +		return error;
>   	}
>
> -	retval = rmi_write_block(fn->rmi_dev, f01->interrupt_enable_addr,
> -				 f01->device_control.interrupt_enable,
> -				 sizeof(u8) * f01->num_of_irq_regs);
> -	if (retval < 0) {
> -		dev_err(&fn->dev, "Failed to write interrupt enable.\n");
> -		return retval;
> +	error = rmi_write_block(fn->rmi_dev, f01->interrupt_enable_addr,
> +				f01->device_control.interrupt_enable,
> +				sizeof(u8) * f01->num_of_irq_regs);
> +	if (error) {
> +		dev_err(&fn->dev,
> +			"Failed to write interrupt enable: %d\n", error);
> +		return error;
>   	}
>
>   	if (f01->properties.has_adjustable_doze) {
> -		retval = rmi_write_block(fn->rmi_dev, f01->doze_interval_addr,
> -					 &f01->device_control.doze_interval,
> -					 sizeof(u8));
> -		if (retval < 0) {
> -			dev_err(&fn->dev, "Failed to write doze interval.\n");
> -			return retval;
> +		error = rmi_write(fn->rmi_dev, f01->doze_interval_addr,
> +				  f01->device_control.doze_interval);
> +		if (error) {
> +			dev_err(&fn->dev,
> +				"Failed to write doze interval: %d\n", error);
> +			return error;
>   		}
>
> -		retval = rmi_write_block(fn->rmi_dev,
> +		error = rmi_write_block(fn->rmi_dev,
>   					 f01->wakeup_threshold_addr,
>   					 &f01->device_control.wakeup_threshold,
>   					 sizeof(u8));
> -		if (retval < 0) {
> -			dev_err(&fn->dev, "Failed to write wakeup threshold.\n");
> -			return retval;
> +		if (error) {
> +			dev_err(&fn->dev,
> +				"Failed to write wakeup threshold: %d\n",
> +				error);
> +			return error;
>   		}
>   	}
>
>   	if (f01->properties.has_adjustable_doze_holdoff) {
> -		retval = rmi_write_block(fn->rmi_dev, f01->doze_holdoff_addr,
> -					 &f01->device_control.doze_holdoff,
> -					 sizeof(u8));
> -		if (retval < 0) {
> -			dev_err(&fn->dev, "Failed to write doze holdoff.\n");
> -			return retval;
> +		error = rmi_write(fn->rmi_dev, f01->doze_holdoff_addr,
> +				  f01->device_control.doze_holdoff);
> +		if (error) {
> +			dev_err(&fn->dev,
> +				"Failed to write doze holdoff: %d\n", error);
> +			return error;
>   		}
>   	}
>
> @@ -439,23 +449,19 @@ static int rmi_f01_suspend(struct device *dev)
>   	struct f01_data *f01 = fn->data;
>   	int error;
>
> -	f01->old_nosleep = f01->device_control.ctrl0 &
> -					RMI_F01_CRTL0_NOSLEEP_BIT;
> +	f01->old_nosleep =
> +		f01->device_control.ctrl0 & RMI_F01_CRTL0_NOSLEEP_BIT;
>   	f01->device_control.ctrl0 &= ~RMI_F01_CRTL0_NOSLEEP_BIT;
>
>   	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_SENSOR_SLEEP;
>
> -	error = rmi_write_block(rmi_dev,
> -				fn->fd.control_base_addr,
> -				&f01->device_control.ctrl0,
> -				sizeof(f01->device_control.ctrl0));
> -	if (error < 0) {
> -		dev_err(&fn->dev, "Failed to write sleep mode. Code: %d.\n",
> -			error);
> +	error = rmi_write(rmi_dev, fn->fd.control_base_addr,
> +			  f01->device_control.ctrl0);
> +	if (error) {
> +		dev_err(&fn->dev, "Failed to write sleep mode: %d.\n", error);
>   		if (f01->old_nosleep)
> -			f01->device_control.ctrl0 |=
> -					RMI_F01_CRTL0_NOSLEEP_BIT;
> +			f01->device_control.ctrl0 |= RMI_F01_CRTL0_NOSLEEP_BIT;
>   		f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   		f01->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
>   		return error;
> @@ -477,13 +483,11 @@ static int rmi_f01_resume(struct device *dev)
>   	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
>
> -	error = rmi_write_block(rmi_dev, fn->fd.control_base_addr,
> -				&f01->device_control.ctrl0,
> -				sizeof(f01->device_control.ctrl0));
> -	if (error < 0) {
> +	error = rmi_write(rmi_dev, fn->fd.control_base_addr,
> +			  f01->device_control.ctrl0);
> +	if (error) {
>   		dev_err(&fn->dev,
> -			"Failed to restore normal operation. Code: %d.\n",
> -			error);
> +			"Failed to restore normal operation: %d.\n", error);
>   		return error;
>   	}
>
> @@ -497,23 +501,25 @@ static int rmi_f01_attention(struct rmi_function *fn,
>   			     unsigned long *irq_bits)
>   {
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	int retval;
> +	int error;
>   	u8 device_status;
>
> -	retval = rmi_read_block(rmi_dev, fn->fd.data_base_addr,
> -		&device_status, sizeof(device_status));
> -	if (retval < 0) {
> -		dev_err(&fn->dev, "Failed to read device status, code: %d.\n",
> -			retval);
> -		return retval;
> +	error = rmi_read(rmi_dev, fn->fd.data_base_addr, &device_status);
> +	if (error) {
> +		dev_err(&fn->dev,
> +			"Failed to read device status: %d.\n", error);
> +		return error;
>   	}
>
>   	if (RMI_F01_STATUS_UNCONFIGURED(device_status)) {
>   		dev_warn(&fn->dev, "Device reset detected.\n");
> -		retval = rmi_dev->driver->reset_handler(rmi_dev);
> -		if (retval < 0)
> -			return retval;
> +		error = rmi_dev->driver->reset_handler(rmi_dev);
> +		if (error) {
> +			dev_err(&fn->dev, "Device reset failed: %d\n", error);
> +			return error;
> +		}
>   	}
> +
>   	return 0;
>   }
>
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
