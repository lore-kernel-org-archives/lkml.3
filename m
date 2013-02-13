Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3BMTnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:43:16 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47377 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3BMTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:43:14 -0500
Date: Wed, 13 Feb 2013 11:43:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Glass <sjg@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Input: matrix-keymap: Add function to read the
 new DT binding
Message-ID: <20130213194307.GA22031@core.coreip.homeip.net>
References: <1360723347-28701-1-git-send-email-sjg@chromium.org>
 <1360723347-28701-6-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360723347-28701-6-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Tue, Feb 12, 2013 at 06:42:25PM -0800, Simon Glass wrote:
> We now have a binding which adds two parameters to the matrix keypad DT
> node. This is separate from the GPIO-driven matrix keypad binding, and
> unfortunately incompatible, since that uses row-gpios/col-gpios for the
> row and column counts.
> 
> So the easiest option here is to provide a function for non-GPIO drivers
> to use to decode the binding.
> 
> Note: We could in fact create an entirely separate structure to hold
> these two fields, but it does not seem worth it, yet. If we have more
> parameters then we can add this, and then refactor each driver to hold
> such a structure.
> 
> Signed-off-by: Simon Glass <sjg@chromium.org>
> ---
> Changes in v2:
> - Add new patch to decode matrix-keypad DT binding
> 
>  drivers/input/keyboard/lpc32xx-keys.c   | 11 ++++++-----
>  drivers/input/keyboard/omap4-keypad.c   | 16 +++++-----------
>  drivers/input/keyboard/tca8418_keypad.c | 11 +++++++----
>  drivers/input/matrix-keymap.c           | 20 ++++++++++++++++++++
>  include/linux/input/matrix_keypad.h     | 11 +++++++++++
>  5 files changed, 49 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
> index 1b8add6..4218143 100644
> --- a/drivers/input/keyboard/lpc32xx-keys.c
> +++ b/drivers/input/keyboard/lpc32xx-keys.c
> @@ -144,12 +144,13 @@ static int lpc32xx_parse_dt(struct device *dev,
>  {
>  	struct device_node *np = dev->of_node;
>  	u32 rows = 0, columns = 0;
> +	int err;
>  
> -	of_property_read_u32(np, "keypad,num-rows", &rows);
> -	of_property_read_u32(np, "keypad,num-columns", &columns);
> -	if (!rows || rows != columns) {
> -		dev_err(dev,
> -			"rows and columns must be specified and be equal!\n");
> +	err = matrix_keypad_parse_of_params(dev, &rows, &columns);
> +	if (err)
> +		return err;
> +	if (rows != columns) {
> +		dev_err(dev, "rows and columns must be equal!\n");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
> index e25b022..1b28909 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -215,18 +215,12 @@ static int omap4_keypad_parse_dt(struct device *dev,
>  				 struct omap4_keypad *keypad_data)
>  {
>  	struct device_node *np = dev->of_node;
> +	int err;
>  
> -	if (!np) {
> -		dev_err(dev, "missing DT data");
> -		return -EINVAL;
> -	}
> -
> -	of_property_read_u32(np, "keypad,num-rows", &keypad_data->rows);
> -	of_property_read_u32(np, "keypad,num-columns", &keypad_data->cols);
> -	if (!keypad_data->rows || !keypad_data->cols) {
> -		dev_err(dev, "number of keypad rows/columns not specified\n");
> -		return -EINVAL;
> -	}
> +	err = matrix_keypad_parse_of_params(dev, &keypad_data->rows,
> +					    &keypad_data->cols);
> +	if (err)
> +		return err;
>  
>  	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
>  		keypad_data->no_autorepeat = true;
> diff --git a/drivers/input/keyboard/tca8418_keypad.c b/drivers/input/keyboard/tca8418_keypad.c
> index a34cc67..4d5a6d5 100644
> --- a/drivers/input/keyboard/tca8418_keypad.c
> +++ b/drivers/input/keyboard/tca8418_keypad.c
> @@ -288,17 +288,20 @@ static int tca8418_keypad_probe(struct i2c_client *client,
>  		irq_is_gpio = pdata->irq_is_gpio;
>  	} else {
>  		struct device_node *np = dev->of_node;
> -		of_property_read_u32(np, "keypad,num-rows", &rows);
> -		of_property_read_u32(np, "keypad,num-columns", &cols);
> +		int err;
> +
> +		err = matrix_keypad_parse_of_params(dev, &rows, &cols);
> +		if (err)
> +			return err;
>  		rep = of_property_read_bool(np, "keypad,autorepeat");
>  	}
>  
> -	if (!rows || rows > TCA8418_MAX_ROWS) {
> +	if (rows > TCA8418_MAX_ROWS) {

Why? Your new function only checks rows != 0 for the DT case, but we
also need to validate platform data supplied values.

>  		dev_err(dev, "invalid rows\n");
>  		return -EINVAL;
>  	}
>  
> -	if (!cols || cols > TCA8418_MAX_COLS) {
> +	if (cols > TCA8418_MAX_COLS) {
>  		dev_err(dev, "invalid columns\n");
>  		return -EINVAL;
>  	}
> diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
> index 3ae496e..64bad81 100644
> --- a/drivers/input/matrix-keymap.c
> +++ b/drivers/input/matrix-keymap.c
> @@ -50,6 +50,25 @@ static bool matrix_keypad_map_key(struct input_dev *input_dev,
>  }
>  
>  #ifdef CONFIG_OF
> +int matrix_keypad_parse_of_params(struct device *dev,
> +				  unsigned int *rows, unsigned int *cols)
> +{
> +	struct device_node *np = dev->of_node;
> +
> +	if (!np) {
> +		dev_err(dev, "missing DT data");
> +		return -EINVAL;
> +	}
> +	of_property_read_u32(np, "keypad,num-rows", rows);
> +	of_property_read_u32(np, "keypad,num-columns", cols);
> +	if (!*rows || !*cols) {
> +		dev_err(dev, "number of keypad rows/columns not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int matrix_keypad_parse_of_keymap(const char *propname,
>  					 unsigned int rows, unsigned int cols,
>  					 struct input_dev *input_dev)
> @@ -112,6 +131,7 @@ static int matrix_keypad_parse_of_keymap(const char *propname,
>   *	tree support is enabled).
>   * @rows: number of rows in target keymap array
>   * @cols: number of cols in target keymap array
> + *   (if either/both is 0 then they will be read from the FDT if available)

Huh?

>   * @keymap: expanded version of keymap that is suitable for use by
>   * matrix keyboard driver
>   * @input_dev: input devices for which we are setting up the keymap
> diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
> index 5f3aa6b..01a30cf 100644
> --- a/include/linux/input/matrix_keypad.h
> +++ b/include/linux/input/matrix_keypad.h
> @@ -81,4 +81,15 @@ int matrix_keypad_build_keymap(const struct matrix_keymap_data *keymap_data,
>  			       unsigned short *keymap,
>  			       struct input_dev *input_dev);
>  
> +/**
> + * matrix_keypad_parse_of_params() - Read parameters from matrix-keypad node
> + *
> + * @dev: Device containing of_node
> + * @rows: Returns number of matrix rows
> + * @cols: Returns number of matrix columns
> + * @return 0 if OK, <0 on error
> + */
> +int matrix_keypad_parse_of_params(struct device *dev,
> +				  unsigned int *rows, unsigned int *cols);
> +

The new function needs a non-CONFIG_OF stub as some drivers
(tca8418-keypad for example) use it in common code.

Thanks.

-- 
Dmitry
