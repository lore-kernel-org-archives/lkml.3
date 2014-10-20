Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaJTGoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:44:02 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:47352 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaJTGn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:43:58 -0400
Date: Mon, 20 Oct 2014 07:43:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/3] input: stmpe: enforce device tree only mode
Message-ID: <20141020064347.GA25349@x1>
References: <1413636989-3286-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413636989-3286-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2014, Linus Walleij wrote:

> The STMPE keypad controller is only used with device tree
> configured systems, so force the configuration to come from
> device tree only, and now actually get the rows and cols from
> the device tree too.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  .../devicetree/bindings/input/stmpe-keypad.txt     |   2 +
>  drivers/input/keyboard/Kconfig                     |   1 +
>  drivers/input/keyboard/stmpe-keypad.c              | 104 +++++++++------------
>  include/linux/mfd/stmpe.h                          |  20 ----
>  4 files changed, 48 insertions(+), 79 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/input/stmpe-keypad.txt b/Documentation/devicetree/bindings/input/stmpe-keypad.txt
> index 1b97222e8a0b..12bb771d66d4 100644
> --- a/Documentation/devicetree/bindings/input/stmpe-keypad.txt
> +++ b/Documentation/devicetree/bindings/input/stmpe-keypad.txt
> @@ -8,6 +8,8 @@ Optional properties:
>   - debounce-interval        : Debouncing interval time in milliseconds
>   - st,scan-count            : Scanning cycles elapsed before key data is updated
>   - st,no-autorepeat         : If specified device will not autorepeat
> + - keypad,num-rows          : See ./matrix-keymap.txt
> + - keypad,num-columns       : See ./matrix-keymap.txt
>  
>  Example:
>  
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index a3958c63d7d5..753d61c0a3a9 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -559,6 +559,7 @@ config KEYBOARD_SH_KEYSC
>  config KEYBOARD_STMPE
>  	tristate "STMPE keypad support"
>  	depends on MFD_STMPE
> +	depends on OF
>  	select INPUT_MATRIXKMAP
>  	help
>  	  Say Y here if you want to use the keypad controller on STMPE I/O
> diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
> index ef5e67fb567e..d46391f48310 100644
> --- a/drivers/input/keyboard/stmpe-keypad.c
> +++ b/drivers/input/keyboard/stmpe-keypad.c
> @@ -45,7 +45,7 @@
>  #define STMPE_KEYPAD_MAX_ROWS		8
>  #define STMPE_KEYPAD_MAX_COLS		8
>  #define STMPE_KEYPAD_ROW_SHIFT		3
> -#define STMPE_KEYPAD_KEYMAP_SIZE	\
> +#define STMPE_KEYPAD_KEYMAP_MAX_SIZE \
>  	(STMPE_KEYPAD_MAX_ROWS * STMPE_KEYPAD_MAX_COLS)
>  
>  /**
> @@ -99,16 +99,30 @@ static const struct stmpe_keypad_variant stmpe_keypad_variants[] = {
>  	},
>  };
>  
> +/**
> + * struct stmpe_keypad - STMPE keypad state container
> + * @stmpe: pointer to parent STMPE device
> + * @input: spawned input device
> + * @variant: STMPE variant
> + * @debounce_ms: debounce interval, in ms.  Maximum is
> + *		 %STMPE_KEYPAD_MAX_DEBOUNCE.
> + * @scan_count: number of key scanning cycles to confirm key data.
> + *		Maximum is %STMPE_KEYPAD_MAX_SCAN_COUNT.
> + * @no_autorepeat: disable key autorepeat
> + * @rows: bitmask for the rows
> + * @cols: bitmask for the columns
> + * @keymap: the keymap
> + */
>  struct stmpe_keypad {
>  	struct stmpe *stmpe;
>  	struct input_dev *input;
>  	const struct stmpe_keypad_variant *variant;
> -	const struct stmpe_keypad_platform_data *plat;
> -
> +	unsigned int debounce_ms;
> +	unsigned int scan_count;
> +	bool no_autorepeat;
>  	unsigned int rows;
>  	unsigned int cols;
> -
> -	unsigned short keymap[STMPE_KEYPAD_KEYMAP_SIZE];
> +	unsigned short keymap[STMPE_KEYPAD_KEYMAP_MAX_SIZE];
>  };
>  
>  static int stmpe_keypad_read_data(struct stmpe_keypad *keypad, u8 *data)
> @@ -208,15 +222,14 @@ static int stmpe_keypad_altfunc_init(struct stmpe_keypad *keypad)
>  
>  static int stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
>  {
> -	const struct stmpe_keypad_platform_data *plat = keypad->plat;
>  	const struct stmpe_keypad_variant *variant = keypad->variant;
>  	struct stmpe *stmpe = keypad->stmpe;
>  	int ret;
>  
> -	if (plat->debounce_ms > STMPE_KEYPAD_MAX_DEBOUNCE)
> +	if (keypad->debounce_ms > STMPE_KEYPAD_MAX_DEBOUNCE)
>  		return -EINVAL;
>  
> -	if (plat->scan_count > STMPE_KEYPAD_MAX_SCAN_COUNT)
> +	if (keypad->scan_count > STMPE_KEYPAD_MAX_SCAN_COUNT)
>  		return -EINVAL;
>  
>  	ret = stmpe_enable(stmpe, STMPE_BLOCK_KEYPAD);
> @@ -245,7 +258,7 @@ static int stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
>  
>  	ret = stmpe_set_bits(stmpe, STMPE_KPC_CTRL_MSB,
>  			     STMPE_KPC_CTRL_MSB_SCAN_COUNT,
> -			     plat->scan_count << 4);
> +			     keypad->scan_count << 4);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -253,17 +266,18 @@ static int stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
>  			      STMPE_KPC_CTRL_LSB_SCAN |
>  			      STMPE_KPC_CTRL_LSB_DEBOUNCE,
>  			      STMPE_KPC_CTRL_LSB_SCAN |
> -			      (plat->debounce_ms << 1));
> +			      (keypad->debounce_ms << 1));
>  }
>  
> -static void stmpe_keypad_fill_used_pins(struct stmpe_keypad *keypad)
> +static void stmpe_keypad_fill_used_pins(struct stmpe_keypad *keypad,
> +					u32 used_rows, u32 used_cols)
>  {
>  	int row, col;
>  
> -	for (row = 0; row < STMPE_KEYPAD_MAX_ROWS; row++) {
> -		for (col = 0; col < STMPE_KEYPAD_MAX_COLS; col++) {
> +	for (row = 0; row < used_rows; row++) {
> +		for (col = 0; col < used_cols; col++) {
>  			int code = MATRIX_SCAN_CODE(row, col,
> -						STMPE_KEYPAD_ROW_SHIFT);
> +						    STMPE_KEYPAD_ROW_SHIFT);
>  			if (keypad->keymap[code] != KEY_RESERVED) {
>  				keypad->rows |= 1 << row;
>  				keypad->cols |= 1 << col;
> @@ -272,51 +286,17 @@ static void stmpe_keypad_fill_used_pins(struct stmpe_keypad *keypad)
>  	}
>  }
>  
> -#ifdef CONFIG_OF
> -static const struct stmpe_keypad_platform_data *
> -stmpe_keypad_of_probe(struct device *dev)
> -{
> -	struct device_node *np = dev->of_node;
> -	struct stmpe_keypad_platform_data *plat;
> -
> -	if (!np)
> -		return ERR_PTR(-ENODEV);
> -
> -	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
> -	if (!plat)
> -		return ERR_PTR(-ENOMEM);
> -
> -	of_property_read_u32(np, "debounce-interval", &plat->debounce_ms);
> -	of_property_read_u32(np, "st,scan-count", &plat->scan_count);
> -
> -	plat->no_autorepeat = of_property_read_bool(np, "st,no-autorepeat");
> -
> -	return plat;
> -}
> -#else
> -static inline const struct stmpe_keypad_platform_data *
> -stmpe_keypad_of_probe(struct device *dev)
> -{
> -	return ERR_PTR(-EINVAL);
> -}
> -#endif
> -
>  static int stmpe_keypad_probe(struct platform_device *pdev)
>  {
>  	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
> -	const struct stmpe_keypad_platform_data *plat;
> +	struct device_node *np = pdev->dev.of_node;
>  	struct stmpe_keypad *keypad;
>  	struct input_dev *input;
> +	u32 rows;
> +	u32 cols;
>  	int error;
>  	int irq;
>  
> -	plat = stmpe->pdata->keypad;
> -	if (!plat) {
> -		plat = stmpe_keypad_of_probe(&pdev->dev);
> -		if (IS_ERR(plat))
> -			return PTR_ERR(plat);
> -	}
> -
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
>  		return irq;
> @@ -326,6 +306,13 @@ static int stmpe_keypad_probe(struct platform_device *pdev)
>  	if (!keypad)
>  		return -ENOMEM;
>  
> +	keypad->stmpe = stmpe;
> +	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
> +
> +	of_property_read_u32(np, "debounce-interval", &keypad->debounce_ms);
> +	of_property_read_u32(np, "st,scan-count", &keypad->scan_count);
> +	keypad->no_autorepeat = of_property_read_bool(np, "st,no-autorepeat");
> +
>  	input = devm_input_allocate_device(&pdev->dev);
>  	if (!input)
>  		return -ENOMEM;
> @@ -334,23 +321,22 @@ static int stmpe_keypad_probe(struct platform_device *pdev)
>  	input->id.bustype = BUS_I2C;
>  	input->dev.parent = &pdev->dev;
>  
> -	error = matrix_keypad_build_keymap(plat->keymap_data, NULL,
> -					   STMPE_KEYPAD_MAX_ROWS,
> -					   STMPE_KEYPAD_MAX_COLS,
> +	error = matrix_keypad_parse_of_params(&pdev->dev, &rows, &cols);
> +	if (error)
> +		return error;
> +
> +	error = matrix_keypad_build_keymap(NULL, NULL, rows, cols,
>  					   keypad->keymap, input);
>  	if (error)
>  		return error;
>  
>  	input_set_capability(input, EV_MSC, MSC_SCAN);
> -	if (!plat->no_autorepeat)
> +	if (!keypad->no_autorepeat)
>  		__set_bit(EV_REP, input->evbit);
>  
> -	stmpe_keypad_fill_used_pins(keypad);
> +	stmpe_keypad_fill_used_pins(keypad, rows, cols);
>  
> -	keypad->stmpe = stmpe;
> -	keypad->plat = plat;
>  	keypad->input = input;
> -	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
>  
>  	error = stmpe_keypad_chip_init(keypad);
>  	if (error < 0)
> diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
> index 976e1a390177..dd908fea8c5b 100644
> --- a/include/linux/mfd/stmpe.h
> +++ b/include/linux/mfd/stmpe.h
> @@ -116,24 +116,6 @@ extern int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins,
>  extern int stmpe_enable(struct stmpe *stmpe, unsigned int blocks);
>  extern int stmpe_disable(struct stmpe *stmpe, unsigned int blocks);
>  
> -struct matrix_keymap_data;
> -
> -/**
> - * struct stmpe_keypad_platform_data - STMPE keypad platform data
> - * @keymap_data: key map table and size
> - * @debounce_ms: debounce interval, in ms.  Maximum is
> - *		 %STMPE_KEYPAD_MAX_DEBOUNCE.
> - * @scan_count: number of key scanning cycles to confirm key data.
> - *		Maximum is %STMPE_KEYPAD_MAX_SCAN_COUNT.
> - * @no_autorepeat: disable key autorepeat
> - */
> -struct stmpe_keypad_platform_data {
> -	const struct matrix_keymap_data *keymap_data;
> -	unsigned int debounce_ms;
> -	unsigned int scan_count;
> -	bool no_autorepeat;
> -};
> -
>  #define STMPE_GPIO_NOREQ_811_TOUCH	(0xf0)
>  
>  /**
> @@ -202,7 +184,6 @@ struct stmpe_ts_platform_data {
>   * @irq_gpio: gpio number over which irq will be requested (significant only if
>   *	      irq_over_gpio is true)
>   * @gpio: GPIO-specific platform data
> - * @keypad: keypad-specific platform data
>   * @ts: touchscreen-specific platform data
>   */
>  struct stmpe_platform_data {
> @@ -215,7 +196,6 @@ struct stmpe_platform_data {
>  	int autosleep_timeout;
>  
>  	struct stmpe_gpio_platform_data *gpio;
> -	struct stmpe_keypad_platform_data *keypad;
>  	struct stmpe_ts_platform_data *ts;
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
