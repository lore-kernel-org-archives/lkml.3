Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaAQA05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:26:57 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50801 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaAQA0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:26:54 -0500
Date: Thu, 16 Jan 2014 16:26:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-input@vger.kernel.org, Simon Budig <simon.budig@kernelconcepts.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/3] Input: edt-ft5x06: Add DT support
Message-ID: <20140117002649.GA837@core.coreip.homeip.net>
References: <1389859338-11685-1-git-send-email-LW@KARO-electronics.de>
 <1389859338-11685-4-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389859338-11685-4-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On Thu, Jan 16, 2014 at 09:02:18AM +0100, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  .../bindings/input/touchscreen/edt-ft5x06.txt      |   29 +++++
>  drivers/input/touchscreen/edt-ft5x06.c             |  121 +++++++++++++++++---
>  2 files changed, 132 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> new file mode 100644
> index 0000000..8d94cdc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
> @@ -0,0 +1,29 @@
> +* EDT FT5x06 Multiple Touch Controller
> +
> +Required properties:
> +- compatible: must be "edt,ft5x06"
> +- reg: i2c slave address
> +- interrupt-parent: the phandle for the interrupt controller
> +- interrupts: touch controller interrupt
> +
> +Optional properties:
> +- reset-gpios: the gpio pin to be used for resetting the controller
> +- wake-gpios:  the gpio pin to be used for waking up the controller
> +
> +  The following properties provide default values for the
> +  corresponding parameters (see Documentation/input/edt-ft5x06.txt)
> +- edt,threshold: allows setting the "click"-threshold in the range from 20 to 80.
> +- edt,gain: sensitivity (0..31) (lower value -> higher sensitivity)
> +- edt,offset: edge compensation (0..31)
> +- edt,report-rate: report rate (3..14)

I wonder if we really need to have it in device tree? Can users needing
top tweak the settings do it via udev rules?

> +
> +Example:
> +
> +	edt_ft5x06@38 {
> +		compatible = "edt,ft5x06";
> +		reg = <0x38>;
> +		interrupt-parent = <&gpio2>;
> +		interrupts = <5 0>;
> +		reset-gpios = <&gpio2 6 1>;
> +		wake-gpios = <&gpio4 9 0>;
> +	};
> diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
> index acb6b9f..0467591 100644
> --- a/drivers/input/touchscreen/edt-ft5x06.c
> +++ b/drivers/input/touchscreen/edt-ft5x06.c
> @@ -33,6 +33,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/slab.h>
>  #include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #include <linux/input/mt.h>
>  #include <linux/input/edt-ft5x06.h>
>  
> @@ -65,6 +66,10 @@ struct edt_ft5x06_ts_data {
>  	u16 num_x;
>  	u16 num_y;
>  
> +	int reset_pin;
> +	int irq_pin;
> +	int wake_pin;
> +
>  #if defined(CONFIG_DEBUG_FS)
>  	struct dentry *debug_dir;
>  	u8 *raw_buffer;
> @@ -617,25 +622,38 @@ edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
>  
>  
>  static int edt_ft5x06_ts_reset(struct i2c_client *client,
> -					 int reset_pin)
> +			struct edt_ft5x06_ts_data *tsdata)
>  {
>  	int error;
>  
> -	if (gpio_is_valid(reset_pin)) {
> +	if (gpio_is_valid(tsdata->wake_pin)) {
> +		error = devm_gpio_request_one(&client->dev, tsdata->wake_pin,
> +					GPIOF_OUT_INIT_LOW, "edt-ft5x06 wake");
> +		if (error) {
> +			dev_err(&client->dev,
> +				"Failed to request GPIO %d as wake pin, error %d\n",
> +				tsdata->wake_pin, error);
> +			return error;
> +		}
> +
> +		mdelay(5);
> +		gpio_set_value(tsdata->wake_pin, 1);
> +	}
> +	if (gpio_is_valid(tsdata->reset_pin)) {
>  		/* this pulls reset down, enabling the low active reset */
> -		error = devm_gpio_request_one(&client->dev, reset_pin,
> +		error = devm_gpio_request_one(&client->dev, tsdata->reset_pin,
>  					GPIOF_OUT_INIT_LOW,
>  					"edt-ft5x06 reset");
>  		if (error) {
>  			dev_err(&client->dev,
>  				"Failed to request GPIO %d as reset pin, error %d\n",
> -				reset_pin, error);
> +				tsdata->reset_pin, error);
>  			return error;
>  		}
>  
> -		mdelay(50);
> -		gpio_set_value(reset_pin, 1);
> -		mdelay(100);
> +		mdelay(5);
> +		gpio_set_value(tsdata->reset_pin, 1);
> +		mdelay(300);

Hmm, this change seems unrelated to DT support.

Thanks.

-- 
Dmitry
