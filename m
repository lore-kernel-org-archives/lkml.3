Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBMVdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:33:32 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:35071 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaBMVd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:33:29 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 13:20:50 -0800
Message-ID: <52FD3A28.8050306@synaptics.com>
Date: Thu, 13 Feb 2014 13:33:28 -0800
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
Subject: Re: [PATCH 11/11] Input: synaptics-rmi4 - remove data pointer from
 RMI fucntion structure
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-11-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-11-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> Device core provides way of accessing driver-private data, we should
> use it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Christopher Heiny <cheiny@synaptics.com>

> ---
>   drivers/input/rmi4/rmi_bus.h |  1 -
>   drivers/input/rmi4/rmi_f01.c | 14 +++++------
>   drivers/input/rmi4/rmi_f11.c | 57 ++++++++++++++++++++------------------------
>   3 files changed, 32 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_bus.h b/drivers/input/rmi4/rmi_bus.h
> index 02a2af8..5ad94c6 100644
> --- a/drivers/input/rmi4/rmi_bus.h
> +++ b/drivers/input/rmi4/rmi_bus.h
> @@ -48,7 +48,6 @@ struct rmi_function {
>   	int num_of_irqs;
>   	int irq_pos;
>   	unsigned long *irq_mask;
> -	void *data;
>   	struct list_head node;
>
>   #ifdef CONFIG_RMI4_DEBUG
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 36fcf8d..e646f60 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -354,14 +354,14 @@ static int rmi_f01_probe(struct rmi_function *fn)
>   		return -EINVAL;
>   	}
>
> -	fn->data = f01;
> +	dev_set_drvdata(&fn->dev, f01);
>
>   	return 0;
>   }
>
>   static int rmi_f01_config(struct rmi_function *fn)
>   {
> -	struct f01_data *f01 = fn->data;
> +	struct f01_data *f01 = dev_get_drvdata(&fn->dev);
>   	int error;
>
>   	error = rmi_write(fn->rmi_dev, fn->fd.control_base_addr,
> @@ -419,8 +419,7 @@ static int rmi_f01_config(struct rmi_function *fn)
>   static int rmi_f01_suspend(struct device *dev)
>   {
>   	struct rmi_function *fn = to_rmi_function(dev);
> -	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f01_data *f01 = fn->data;
> +	struct f01_data *f01 = dev_get_drvdata(&fn->dev);
>   	int error;
>
>   	f01->old_nosleep =
> @@ -430,7 +429,7 @@ static int rmi_f01_suspend(struct device *dev)
>   	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_SENSOR_SLEEP;
>
> -	error = rmi_write(rmi_dev, fn->fd.control_base_addr,
> +	error = rmi_write(fn->rmi_dev, fn->fd.control_base_addr,
>   			  f01->device_control.ctrl0);
>   	if (error) {
>   		dev_err(&fn->dev, "Failed to write sleep mode: %d.\n", error);
> @@ -447,8 +446,7 @@ static int rmi_f01_suspend(struct device *dev)
>   static int rmi_f01_resume(struct device *dev)
>   {
>   	struct rmi_function *fn = to_rmi_function(dev);
> -	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f01_data *f01 = fn->data;
> +	struct f01_data *f01 = dev_get_drvdata(&fn->dev);
>   	int error;
>
>   	if (f01->old_nosleep)
> @@ -457,7 +455,7 @@ static int rmi_f01_resume(struct device *dev)
>   	f01->device_control.ctrl0 &= ~RMI_F01_CTRL0_SLEEP_MODE_MASK;
>   	f01->device_control.ctrl0 |= RMI_SLEEP_MODE_NORMAL;
>
> -	error = rmi_write(rmi_dev, fn->fd.control_base_addr,
> +	error = rmi_write(fn->rmi_dev, fn->fd.control_base_addr,
>   			  f01->device_control.ctrl0);
>   	if (error) {
>   		dev_err(&fn->dev,
> diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
> index 5072437..a26b944 100644
> --- a/drivers/input/rmi4/rmi_f11.c
> +++ b/drivers/input/rmi4/rmi_f11.c
> @@ -1087,9 +1087,8 @@ static int rmi_f11_get_query_parameters(struct rmi_device *rmi_dev,
>   /* This operation is done in a number of places, so we have a handy routine
>    * for it.
>    */
> -static void f11_set_abs_params(struct rmi_function *fn)
> +static void f11_set_abs_params(struct rmi_function *fn, struct f11_data *f11)
>   {
> -	struct f11_data *f11 = fn->data;
>   	struct f11_2d_sensor *sensor = &f11->sensor;
>   	struct input_dev *input = sensor->input;
>   	/* These two lines are not doing what we want them to.  So we use
> @@ -1190,7 +1189,6 @@ static int rmi_f11_initialize(struct rmi_function *fn)
>   	if (!f11)
>   		return -ENOMEM;
>
> -	fn->data = f11;
>   	f11->rezero_wait_ms = pdata->f11_rezero_wait;
>
>   	query_base_addr = fn->fd.query_base_addr;
> @@ -1280,13 +1278,16 @@ static int rmi_f11_initialize(struct rmi_function *fn)
>   	}
>
>   	mutex_init(&f11->dev_controls_mutex);
> +
> +	dev_set_drvdata(&fn->dev, f11);
> +
>   	return 0;
>   }
>
>   static int rmi_f11_register_devices(struct rmi_function *fn)
>   {
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f11_data *f11 = fn->data;
> +	struct f11_data *f11 = dev_get_drvdata(&fn->dev);
>   	struct input_dev *input_dev;
>   	struct input_dev *input_dev_mouse;
>   	struct rmi_driver *driver = rmi_dev->driver;
> @@ -1304,8 +1305,8 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
>   		rc = driver->set_input_params(rmi_dev, input_dev);
>   		if (rc < 0) {
>   			dev_err(&fn->dev,
> -			"%s: Error in setting input device.\n",
> -			__func__);
> +				"%s: Error in setting input device.\n",
> +				__func__);
>   			goto error_unregister;
>   		}
>   	}
> @@ -1319,7 +1320,7 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
>   	set_bit(EV_ABS, input_dev->evbit);
>   	input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
>
> -	f11_set_abs_params(fn);
> +	f11_set_abs_params(fn, f11);
>
>   	if (sensor->sens_query.has_rel) {
>   		set_bit(EV_REL, input_dev->evbit);
> @@ -1327,7 +1328,7 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
>   		set_bit(REL_Y, input_dev->relbit);
>   	}
>   	rc = input_register_device(input_dev);
> -	if (rc < 0) {
> +	if (rc) {
>   		input_free_device(input_dev);
>   		sensor->input = NULL;
>   		goto error_unregister;
> @@ -1347,8 +1348,8 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
>   				input_dev_mouse);
>   			if (rc < 0) {
>   				dev_err(&fn->dev,
> -				"%s: Error in setting input device.\n",
> -				__func__);
> +					"%s: Error in setting input device.\n",
> +					__func__);
>   				goto error_unregister;
>   			}
>   		}
> @@ -1366,7 +1367,7 @@ static int rmi_f11_register_devices(struct rmi_function *fn)
>   		set_bit(BTN_RIGHT, input_dev_mouse->keybit);
>
>   		rc = input_register_device(input_dev_mouse);
> -		if (rc < 0) {
> +		if (rc) {
>   			input_free_device(input_dev_mouse);
>   			sensor->mouse_input = NULL;
>   			goto error_unregister;
> @@ -1390,19 +1391,9 @@ error_unregister:
>   	return rc;
>   }
>
> -static void rmi_f11_free_devices(struct rmi_function *fn)
> -{
> -	struct f11_data *f11 = fn->data;
> -
> -	if (f11->sensor.input)
> -		input_unregister_device(f11->sensor.input);
> -	if (f11->sensor.mouse_input)
> -		input_unregister_device(f11->sensor.mouse_input);
> -}
> -
>   static int rmi_f11_config(struct rmi_function *fn)
>   {
> -	struct f11_data *f11 = fn->data;
> +	struct f11_data *f11 = dev_get_drvdata(&fn->dev);
>   	int rc;
>
>   	rc = f11_write_control_regs(fn, &f11->sensor.sens_query,
> @@ -1416,7 +1407,7 @@ static int rmi_f11_config(struct rmi_function *fn)
>   static int rmi_f11_attention(struct rmi_function *fn, unsigned long *irq_bits)
>   {
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f11_data *f11 = fn->data;
> +	struct f11_data *f11 = dev_get_drvdata(&fn->dev);
>   	u16 data_base_addr = fn->fd.data_base_addr;
>   	u16 data_base_addr_offset = 0;
>   	int error;
> @@ -1425,7 +1416,7 @@ static int rmi_f11_attention(struct rmi_function *fn, unsigned long *irq_bits)
>   			data_base_addr + data_base_addr_offset,
>   			f11->sensor.data_pkt,
>   			f11->sensor.pkt_size);
> -	if (error < 0)
> +	if (error)
>   		return error;
>
>   	rmi_f11_finger_handler(f11, &f11->sensor);
> @@ -1438,18 +1429,17 @@ static int rmi_f11_attention(struct rmi_function *fn, unsigned long *irq_bits)
>   static int rmi_f11_resume(struct device *dev)
>   {
>   	struct rmi_function *fn = to_rmi_function(dev);
> -	struct rmi_device *rmi_dev = fn->rmi_dev;
> -	struct f11_data *data = fn->data;
> +	struct f11_data *f11 = dev_get_drvdata(&fn->dev);
>   	int error;
>
>   	dev_dbg(&fn->dev, "Resuming...\n");
> -	if (!data->rezero_wait_ms)
> +	if (!f11->rezero_wait_ms)
>   		return 0;
>
> -	mdelay(data->rezero_wait_ms);
> +	mdelay(f11->rezero_wait_ms);
>
> -	error = rmi_write(rmi_dev, fn->fd.command_base_addr, RMI_F11_REZERO);
> -	if (error < 0) {
> +	error = rmi_write(fn->rmi_dev, fn->fd.command_base_addr, RMI_F11_REZERO);
> +	if (error) {
>   		dev_err(&fn->dev,
>   			"%s: failed to issue rezero command, error = %d.",
>   			__func__, error);
> @@ -1479,7 +1469,12 @@ static int rmi_f11_probe(struct rmi_function *fn)
>
>   static void rmi_f11_remove(struct rmi_function *fn)
>   {
> -	rmi_f11_free_devices(fn);
> +	struct f11_data *f11 = dev_get_drvdata(&fn->dev);
> +
> +	if (f11->sensor.input)
> +		input_unregister_device(f11->sensor.input);
> +	if (f11->sensor.mouse_input)
> +		input_unregister_device(f11->sensor.mouse_input);
>   }
>
>   static struct rmi_function_handler rmi_f11_handler = {
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
