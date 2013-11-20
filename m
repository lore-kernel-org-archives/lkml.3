Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3KTSPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:15:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:64288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3KTSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:15:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438677310"
Message-ID: <528CFBC0.3080905@linux.intel.com>
Date: Wed, 20 Nov 2013 10:13:20 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
CC: "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 3/3] intel_mid: switch to use SFI GPIO API
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com> <1384957896-3477-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1384957896-3477-4-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Thanks for the patch.

On 11/20/2013 06:31 AM, Andy Shevchenko wrote:
> Instead of custom implementation of the SFI GPIO API let's use one provided by
> gpiolib.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: David Cohen <david.a.cohen@linux.intel.com>

> ---
>  arch/x86/include/asm/intel-mid.h                   |  1 -
>  .../intel-mid/device_libs/platform_emc1403.c       |  8 ++--
>  .../intel-mid/device_libs/platform_gpio_keys.c     | 10 ++---
>  .../intel-mid/device_libs/platform_lis331.c        |  8 ++--
>  .../intel-mid/device_libs/platform_max3111.c       |  6 +--
>  .../intel-mid/device_libs/platform_max7315.c       | 10 ++---
>  .../intel-mid/device_libs/platform_mpu3050.c       |  6 +--
>  .../intel-mid/device_libs/platform_msic_gpio.c     |  6 +--
>  .../intel-mid/device_libs/platform_msic_ocd.c      |  5 +--
>  .../intel-mid/device_libs/platform_pmic_gpio.c     |  7 +--
>  .../intel-mid/device_libs/platform_tc35876x.c      |  8 ++--
>  .../intel-mid/device_libs/platform_tca6416.c       | 10 ++---
>  arch/x86/platform/intel-mid/sfi.c                  | 51 ----------------------
>  13 files changed, 42 insertions(+), 94 deletions(-)
>
> diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
> index 459769d..7e426b1 100644
> --- a/arch/x86/include/asm/intel-mid.h
> +++ b/arch/x86/include/asm/intel-mid.h
> @@ -15,7 +15,6 @@
>  #include <linux/platform_device.h>
>  
>  extern int intel_mid_pci_init(void);
> -extern int get_gpio_by_name(const char *name);
>  extern void intel_scu_device_register(struct platform_device *pdev);
>  extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
>  extern int __init sfi_parse_mtmr(struct sfi_table_header *table);
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
> index 0d942c1..502f50f 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
> @@ -11,7 +11,7 @@
>   */
>  
>  #include <linux/init.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/i2c.h>
>  #include <asm/intel-mid.h>
>  
> @@ -19,10 +19,10 @@ static void __init *emc1403_platform_data(void *info)
>  {
>  	static short intr2nd_pdata;
>  	struct i2c_board_info *i2c_info = info;
> -	int intr = get_gpio_by_name("thermal_int");
> -	int intr2nd = get_gpio_by_name("thermal_alert");
> +	int intr = sfi_get_gpio_by_name("thermal_int");
> +	int intr2nd = sfi_get_gpio_by_name("thermal_alert");
>  
> -	if (intr == -1 || intr2nd == -1)
> +	if (intr < 0 || intr2nd < 0)
>  		return NULL;
>  
>  	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
> index a013a48..e3fb5be 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
> @@ -13,7 +13,7 @@
>  #include <linux/input.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/gpio_keys.h>
>  #include <linux/platform_device.h>
>  #include <asm/intel-mid.h>
> @@ -61,12 +61,12 @@ static int __init pb_keys_init(void)
>  	struct gpio_keys_button *gb = gpio_button;
>  	int i, num, good = 0;
>  
> -	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
> +	num = ARRAY_SIZE(gpio_button);
>  	for (i = 0; i < num; i++) {
> -		gb[i].gpio = get_gpio_by_name(gb[i].desc);
> +		gb[i].gpio = sfi_get_gpio_by_name(gb[i].desc);
>  		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
> -					gb[i].gpio);
> -		if (gb[i].gpio == -1)
> +			 gb[i].gpio);
> +		if (gb[i].gpio < 0)
>  			continue;
>  
>  		if (i != good)
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
> index 15278c1..8cd0c33 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
> @@ -11,17 +11,17 @@
>   */
>  
>  #include <linux/i2c.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <asm/intel-mid.h>
>  
>  static void __init *lis331dl_platform_data(void *info)
>  {
>  	static short intr2nd_pdata;
>  	struct i2c_board_info *i2c_info = info;
> -	int intr = get_gpio_by_name("accel_int");
> -	int intr2nd = get_gpio_by_name("accel_2");
> +	int intr = sfi_get_gpio_by_name("accel_int");
> +	int intr2nd = sfi_get_gpio_by_name("accel_2");
>  
> -	if (intr == -1 || intr2nd == -1)
> +	if (intr < 0 || intr2nd < 0)
>  		return NULL;
>  
>  	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
> index afd1df9..99d3832 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
> @@ -10,17 +10,17 @@
>   * of the License.
>   */
>  
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/spi/spi.h>
>  #include <asm/intel-mid.h>
>  
>  static void __init *max3111_platform_data(void *info)
>  {
>  	struct spi_board_info *spi_info = info;
> -	int intr = get_gpio_by_name("max3111_int");
> +	int intr = sfi_get_gpio_by_name("max3111_int");
>  
>  	spi_info->mode = SPI_MODE_0;
> -	if (intr == -1)
> +	if (intr < 0)
>  		return NULL;
>  	spi_info->irq = intr + INTEL_MID_IRQ_OFFSET;
>  	return NULL;
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
> index 94ade10..7613b86 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
> @@ -11,7 +11,7 @@
>   */
>  
>  #include <linux/init.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_data/pca953x.h>
>  #include <asm/intel-mid.h>
> @@ -45,13 +45,13 @@ static void __init *max7315_platform_data(void *info)
>  		strcpy(intr_pin_name, "max7315_int");
>  	}
>  
> -	gpio_base = get_gpio_by_name(base_pin_name);
> -	intr = get_gpio_by_name(intr_pin_name);
> +	gpio_base = sfi_get_gpio_by_name(base_pin_name);
> +	intr = sfi_get_gpio_by_name(intr_pin_name);
>  
> -	if (gpio_base == -1)
> +	if (gpio_base < 0)
>  		return NULL;
>  	max7315->gpio_base = gpio_base;
> -	if (intr != -1) {
> +	if (intr >= 0) {
>  		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
>  		max7315->irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
>  	} else {
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
> index dd28d63..af62a2a 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
> @@ -10,16 +10,16 @@
>   * of the License.
>   */
>  
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/i2c.h>
>  #include <asm/intel-mid.h>
>  
>  static void *mpu3050_platform_data(void *info)
>  {
>  	struct i2c_board_info *i2c_info = info;
> -	int intr = get_gpio_by_name("mpu3050_int");
> +	int intr = sfi_get_gpio_by_name("mpu3050_int");
>  
> -	if (intr == -1)
> +	if (intr < 0)
>  		return NULL;
>  
>  	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
> index 2a4f7b1..dc347da 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
> @@ -15,7 +15,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/sfi.h>
>  #include <linux/init.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/mfd/intel_msic.h>
>  #include <asm/intel-mid.h>
>  
> @@ -25,9 +25,9 @@
>  static void __init *msic_gpio_platform_data(void *info)
>  {
>  	static struct intel_msic_gpio_pdata msic_gpio_pdata;
> +	int gpio;
>  
> -	int gpio = get_gpio_by_name("msic_gpio_base");
> -
> +	gpio = sfi_get_gpio_by_name("msic_gpio_base");
>  	if (gpio < 0)
>  		return NULL;
>  
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
> index 6497111..8f59154 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
> @@ -15,7 +15,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/sfi.h>
>  #include <linux/init.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/mfd/intel_msic.h>
>  #include <asm/intel-mid.h>
>  
> @@ -27,8 +27,7 @@ static void __init *msic_ocd_platform_data(void *info)
>  	static struct intel_msic_ocd_pdata msic_ocd_pdata;
>  	int gpio;
>  
> -	gpio = get_gpio_by_name("ocd_gpio");
> -
> +	gpio = sfi_get_gpio_by_name("ocd_gpio");
>  	if (gpio < 0)
>  		return NULL;
>  
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
> index d87182a..954f5d9 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
> @@ -13,7 +13,7 @@
>  #include <linux/kernel.h>
>  #include <linux/interrupt.h>
>  #include <linux/scatterlist.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/init.h>
>  #include <linux/sfi.h>
>  #include <linux/intel_pmic_gpio.h>
> @@ -24,10 +24,11 @@
>  static void __init *pmic_gpio_platform_data(void *info)
>  {
>  	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
> -	int gpio_base = get_gpio_by_name("pmic_gpio_base");
> +	int gpio_base = sfi_get_gpio_by_name("pmic_gpio_base");
>  
> -	if (gpio_base == -1)
> +	if (gpio_base < 0)
>  		gpio_base = 64;
> +
>  	pmic_gpio_pdata.gpio_base = gpio_base;
>  	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
>  	pmic_gpio_pdata.gpiointr = 0xffffeff8;
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
> index 740fc75..3c62875 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
> @@ -10,7 +10,7 @@
>   * of the License.
>   */
>  
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <linux/i2c/tc35876x.h>
>  #include <asm/intel-mid.h>
>  
> @@ -20,9 +20,9 @@ static void *tc35876x_platform_data(void *data)
>  	static struct tc35876x_platform_data pdata;
>  
>  	/* gpio pins set to -1 will not be used by the driver */
> -	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
> -	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
> -	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
> +	pdata.gpio_bridge_reset = sfi_get_gpio_by_name("LCMB_RXEN");
> +	pdata.gpio_panel_bl_en = sfi_get_gpio_by_name("6S6P_BL_EN");
> +	pdata.gpio_panel_vadd = sfi_get_gpio_by_name("EN_VREG_LCD_V3P3");
>  
>  	return &pdata;
>  }
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
> index 22881c9..eb6d241 100644
> --- a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
> @@ -12,7 +12,7 @@
>  
>  #include <linux/platform_data/pca953x.h>
>  #include <linux/i2c.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/sfi.h>
>  #include <asm/intel-mid.h>
>  
>  #define TCA6416_NAME	"tca6416"
> @@ -31,13 +31,13 @@ static void *tca6416_platform_data(void *info)
>  	strcpy(base_pin_name, TCA6416_BASE);
>  	strcpy(intr_pin_name, TCA6416_INTR);
>  
> -	gpio_base = get_gpio_by_name(base_pin_name);
> -	intr = get_gpio_by_name(intr_pin_name);
> +	gpio_base = sfi_get_gpio_by_name(base_pin_name);
> +	intr = sfi_get_gpio_by_name(intr_pin_name);
>  
> -	if (gpio_base == -1)
> +	if (gpio_base < 0)
>  		return NULL;
>  	tca6416.gpio_base = gpio_base;
> -	if (intr != -1) {
> +	if (intr >= 0) {
>  		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
>  		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
>  	} else {
> diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
> index c84c1ca..88beeb2 100644
> --- a/arch/x86/platform/intel-mid/sfi.c
> +++ b/arch/x86/platform/intel-mid/sfi.c
> @@ -19,7 +19,6 @@
>  #include <linux/spi/spi.h>
>  #include <linux/i2c.h>
>  #include <linux/skbuff.h>
> -#include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
>  #include <linux/input.h>
>  #include <linux/platform_device.h>
> @@ -51,13 +50,11 @@
>  static struct platform_device *ipc_devs[MAX_IPCDEVS];
>  static struct spi_board_info *spi_devs[MAX_SCU_SPI];
>  static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
> -static struct sfi_gpio_table_entry *gpio_table;
>  static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
>  static int ipc_next_dev;
>  static int spi_next_dev;
>  static int i2c_next_dev;
>  static int i2c_bus[MAX_SCU_I2C];
> -static int gpio_num_entry;
>  static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
>  int sfi_mrtc_num;
>  int sfi_mtimer_num;
> @@ -180,53 +177,6 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
>  	return 0;
>  }
>  
> -
> -/*
> - * Parsing GPIO table first, since the DEVS table will need this table
> - * to map the pin name to the actual pin.
> - */
> -static int __init sfi_parse_gpio(struct sfi_table_header *table)
> -{
> -	struct sfi_table_simple *sb;
> -	struct sfi_gpio_table_entry *pentry;
> -	int num, i;
> -
> -	if (gpio_table)
> -		return 0;
> -	sb = (struct sfi_table_simple *)table;
> -	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
> -	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
> -
> -	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> -	if (!gpio_table)
> -		return -1;
> -	memcpy(gpio_table, pentry, num * sizeof(*pentry));
> -	gpio_num_entry = num;
> -
> -	pr_debug("GPIO pin info:\n");
> -	for (i = 0; i < num; i++, pentry++)
> -		pr_debug("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
> -		" pin = %d\n", i,
> -			pentry->controller_name,
> -			pentry->pin_name,
> -			pentry->pin_no);
> -	return 0;
> -}
> -
> -int get_gpio_by_name(const char *name)
> -{
> -	struct sfi_gpio_table_entry *pentry = gpio_table;
> -	int i;
> -
> -	if (!pentry)
> -		return -1;
> -	for (i = 0; i < gpio_num_entry; i++, pentry++) {
> -		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> -			return pentry->pin_no;
> -	}
> -	return -1;
> -}
> -
>  void __init intel_scu_device_register(struct platform_device *pdev)
>  {
>  	if (ipc_next_dev == MAX_IPCDEVS)
> @@ -481,7 +431,6 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
>  
>  static int __init intel_mid_platform_init(void)
>  {
> -	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
>  	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
>  	return 0;
>  }

