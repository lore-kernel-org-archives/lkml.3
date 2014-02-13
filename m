Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBMUAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:00:16 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:34696 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaBMUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:00:12 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 13 Feb 2014 11:47:33 -0800
Message-ID: <52FD244B.1050307@synaptics.com>
Date: Thu, 13 Feb 2014 12:00:11 -0800
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
Subject: Re: [PATCH 10/11] Input: synaptics-rmi4 - make accessor for platform
 data return const pointer
References: <1392269277-16391-1-git-send-email-dmitry.torokhov@gmail.com> <1392269277-16391-10-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1392269277-16391-10-git-send-email-dmitry.torokhov@gmail.com>
X-Originating-IP: [10.3.20.103]
X-Brightmail-Tracker: AAAAAQAAAWE=
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 09:27 PM, Dmitry Torokhov wrote:
> When accessing platform data of RMI device let's make sure we do not
> accidentally change data that may be shared by returning const pointer.
> Also switch to an inline function instead of macro to ensure type safety.

That's a good idea.  We'll want to look at some of our other #define 
accessors as well, I think.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/rmi4/rmi_bus.h    | 7 ++++++-
>   drivers/input/rmi4/rmi_driver.c | 8 ++++----
>   drivers/input/rmi4/rmi_f01.c    | 2 +-
>   drivers/input/rmi4/rmi_f11.c    | 2 +-
>   4 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_bus.h b/drivers/input/rmi4/rmi_bus.h
> index 8d47f52..02a2af8 100644
> --- a/drivers/input/rmi4/rmi_bus.h
> +++ b/drivers/input/rmi4/rmi_bus.h
> @@ -224,7 +224,12 @@ struct rmi_device {
>   };
>
>   #define to_rmi_device(d) container_of(d, struct rmi_device, dev)
> -#define to_rmi_platform_data(d) ((d)->xport->dev->platform_data)
> +
> +static inline const struct rmi_device_platform_data *
> +rmi_get_platform_data(struct rmi_device *d)
> +{
> +	return dev_get_platdata(d->xport->dev);
> +}
>
>   bool rmi_is_physical_device(struct device *dev);
>
> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
> index 736cfbd..473efbc 100644
> --- a/drivers/input/rmi4/rmi_driver.c
> +++ b/drivers/input/rmi4/rmi_driver.c
> @@ -598,7 +598,7 @@ static int rmi_initial_reset(struct rmi_device *rmi_dev,
>   		u16 cmd_addr = pdt->page_start + pdt->command_base_addr;
>   		u8 cmd_buf = RMI_DEVICE_RESET_CMD;
>   		const struct rmi_device_platform_data *pdata =
> -				to_rmi_platform_data(rmi_dev);
> +				rmi_get_platform_data(rmi_dev);
>
>   		error = rmi_write_block(rmi_dev, cmd_addr, &cmd_buf, 1);
>   		if (error) {
> @@ -621,7 +621,7 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
>   {
>   	struct device *dev = &rmi_dev->dev;
>   	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
> -	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
>   	int *current_irq_count = ctx;
>   	struct rmi_function *fn;
>   	int i;
> @@ -745,7 +745,7 @@ static int rmi_driver_remove(struct device *dev)
>   	struct rmi_device *rmi_dev = to_rmi_device(dev);
>   	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
>   	const struct rmi_device_platform_data *pdata =
> -					to_rmi_platform_data(rmi_dev);
> +					rmi_get_platform_data(rmi_dev);
>
>   	disable_sensor(rmi_dev);
>   	rmi_free_function_list(rmi_dev);
> @@ -781,7 +781,7 @@ static int rmi_driver_probe(struct device *dev)
>   	rmi_driver = to_rmi_driver(dev->driver);
>   	rmi_dev->driver = rmi_driver;
>
> -	pdata = to_rmi_platform_data(rmi_dev);
> +	pdata = rmi_get_platform_data(rmi_dev);
>
>   	data = devm_kzalloc(dev, sizeof(struct rmi_driver_data), GFP_KERNEL);
>   	if (!data) {
> diff --git a/drivers/input/rmi4/rmi_f01.c b/drivers/input/rmi4/rmi_f01.c
> index 0e21004..36fcf8d 100644
> --- a/drivers/input/rmi4/rmi_f01.c
> +++ b/drivers/input/rmi4/rmi_f01.c
> @@ -184,7 +184,7 @@ static int rmi_f01_probe(struct rmi_function *fn)
>   {
>   	struct rmi_device *rmi_dev = fn->rmi_dev;
>   	struct rmi_driver_data *driver_data = dev_get_drvdata(&rmi_dev->dev);
> -	const struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
>   	struct f01_data *f01;
>   	size_t f01_size;
>   	int error;
> diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
> index 2aa7d17..5072437 100644
> --- a/drivers/input/rmi4/rmi_f11.c
> +++ b/drivers/input/rmi4/rmi_f11.c
> @@ -1176,7 +1176,7 @@ static int rmi_f11_initialize(struct rmi_function *fn)
>   	u16 control_base_addr;
>   	u16 max_x_pos, max_y_pos, temp;
>   	int rc;
> -	struct rmi_device_platform_data *pdata = to_rmi_platform_data(rmi_dev);
> +	const struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
>   	struct f11_2d_sensor *sensor;
>   	u8 buf;
>
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated
