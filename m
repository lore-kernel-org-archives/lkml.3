Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaIKVeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:34:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60978 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaIKVek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:34:40 -0400
Message-ID: <541214A7.3040402@ti.com>
Date: Thu, 11 Sep 2014 17:31:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Kevin Hilman <khilman@linaro.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nishanth Menon <nm@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        <linux-arm-kernel@lists.infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PM / AVS: rockchip-io: add driver handling Rockchip
 io domains
References: <1410469229-30167-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1410469229-30167-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2014 05:00 PM, Doug Anderson wrote:
> From: Heiko Stübner <heiko@sntech.de>
> 
> IO domain voltages on some Rockchip SoCs are variable but need to be
> kept in sync between the regulators and the SoC using a special
> register.
> 
> A specific example using rk3288:
> - If the regulator hooked up to a pin like SDMMC0_VDD is 3.3V then
>   bit 7 of GRF_IO_VSEL needs to be 0.  If the regulator hooked up to
>   that same pin is 1.8V then bit 7 of GRF_IO_VSEL needs to be 1.
> 
> Said another way, this driver simply handles keeping bits in the SoC's
> general register file (GRF) in sync with the actual value of a voltage
> hooked up to the pins.
> 
> Note that this driver specifically doesn't include:
> - any logic for deciding what voltage we should set regulators to
> - any logic for deciding whether regulators (or internal SoC blocks)
>   should have power or not have power
> 
> If there were some other software that had the smarts of making
> decisions about regulators, it would work in conjunction with this
> driver.  When that other software adjusted a regulator's voltage then
> this driver would handle telling the SoC about it.  A good example is
> vqmmc for SD.  In that case the dw_mmc driver simply is told about a
> regulator.  It changes the regulator between 3.3V and 1.8V at the
> right time.  This driver notices the change and makes sure that the
> SoC is on the same page.
> 
> Signed-off-by: Heiko Stübner <heiko@sntech.de>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Regulator patch landed, so just io-domain patch now.
> - Now in AVS as per Kevin Hilman.
> - Updated commit message to make it clear why I think this driver
>   doesn't fit into some other framework.
> - Updated bindings to also include better description.
>
Nice to see that your driver is getting better home. Minor
comments below....

 
>  .../bindings/power/rockchip-io-domain.txt          |  83 +++++
>  drivers/power/avs/Kconfig                          |   8 +
>  drivers/power/avs/Makefile                         |   1 +
>  drivers/power/avs/rockchip-io-domain.c             | 333 +++++++++++++++++++++
>  4 files changed, 425 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/rockchip-io-domain.txt
>  create mode 100644 drivers/power/avs/rockchip-io-domain.c
> 
> diff --git a/Documentation/devicetree/bindings/power/rockchip-io-domain.txt b/Documentation/devicetree/bindings/power/rockchip-io-domain.txt
> new file mode 100644
> index 0000000..e663255
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/rockchip-io-domain.txt
> @@ -0,0 +1,83 @@
> +Rockchip SRAM for IO Voltage Domains:
> +-------------------------------------
> +
> +IO domain voltages on some Rockchip SoCs are variable but need to be
> +kept in sync between the regulators and the SoC using a special
> +register.
> +
> +A specific example using rk3288:
> +- If the regulator hooked up to a pin like SDMMC0_VDD is 3.3V then
> +  bit 7 of GRF_IO_VSEL needs to be 0.  If the regulator hooked up to
> +  that same pin is 1.8V then bit 7 of GRF_IO_VSEL needs to be 1.
> +
> +Said another way, this driver simply handles keeping bits in the SoC's
> +general register file (GRF) in sync with the actual value of a voltage
> +hooked up to the pins.
> +
> +Note that this driver specifically doesn't include:
> +- any logic for deciding what voltage we should set regulators to
> +- any logic for deciding whether regulators (or internal SoC blocks)
> +  should have power or not have power
> +
> +If there were some other software that had the smarts of making
> +decisions about regulators, it would work in conjunction with this
> +driver.  When that other software adjusted a regulator's voltage then
> +this driver would handle telling the SoC about it.  A good example is
> +vqmmc for SD.  In that case the dw_mmc driver simply is told about a
> +regulator.  It changes the regulator between 3.3V and 1.8V at the
> +right time.  This driver notices the change and makes sure that the
> +SoC is on the same page.
> +
> +
> +Required properties:
> +- compatible: should be one of:
> +  - "rockchip,rk3188-iodomain" for rk3188
> +  - "rockchip,rk3288-iodomain" for rk3288
The key word 'voltage' is missing from the compatible. iodomain itself
doesn't convey what it is actually.

> +- rockchip,grf: phandle to the syscon managing the "general register files"
> +
> +
> +You specify supplies using the standard regulator bindings by including
> +a phandle the the relevant regulator.  All specified supplies must be able
> +to report their voltage.  The IO Voltage Domain for any non-specified
> +supplies will be not be touched.
> +
> +Possible supplies for rk3188:
> +- ap0-supply:    The supply connected to AP0_VCC.
> +- ap1-supply:    The supply connected to AP1_VCC.
> +- cif-supply:    The supply connected to CIF_VCC.
> +- flash-supply:  The supply connected to FLASH_VCC.
> +- lcdc0-supply:  The supply connected to LCD0_VCC.
> +- lcdc1-supply:  The supply connected to LCD1_VCC.
> +- vccio0-supply: The supply connected to VCCIO0.
> +- vccio1-supply: The supply connected to VCCIO1.
> +                 Sometimes also labeled VCCIO1 and VCCIO2.
> +
> +Possible supplies for rk3288:
> +- audio-supply:  The supply connected to APIO4_VDD.
> +- bb-supply:     The supply connected to APIO5_VDD.
> +- dvp-supply:    The supply connected to DVPIO_VDD.
> +- flash0-supply: The supply connected to FLASH0_VDD.  Typically for eMMC
> +- flash1-supply: The supply connected to FLASH1_VDD.  Also known as SDIO1.
> +- gpio30-supply: The supply connected to APIO1_VDD.
> +- gpio1830       The supply connected to APIO2_VDD.
> +- lcdc-supply:   The supply connected to LCDC_VDD.
> +- sdcard-supply: The supply connected to SDMMC0_VDD.
> +- wifi-supply:   The supply connected to APIO3_VDD.  Also known as SDIO0.
> +
> +
> +Example:
> +
> +	io-domains {
> +		compatible = "rockchip,rk3288-iodomain";
> +		rockchip,grf = <&grf>;
> +
> +		audio-supply = <&vcc18_codec>;
> +		bb-supply = <&vcc33_io>;
> +		dvp-supply = <&vcc_18>;
> +		flash0-supply = <&vcc18_flashio>;
> +		gpio1830-supply = <&vcc33_io>;
> +		gpio30-supply = <&vcc33_pmuio>;
> +		lcdc-supply = <&vcc33_lcd>;
> +		sdcard-supply = <&vccio_sd>;
> +		wifi-supply = <&vcc18_wl>;
> +	};
> diff --git a/drivers/power/avs/Kconfig b/drivers/power/avs/Kconfig
> index 2a1008b..7f3d389 100644
> --- a/drivers/power/avs/Kconfig
> +++ b/drivers/power/avs/Kconfig
> @@ -10,3 +10,11 @@ menuconfig POWER_AVS
>  	  AVS is also called SmartReflex on OMAP devices.
>  
>  	  Say Y here to enable Adaptive Voltage Scaling class support.
> +
> +config ROCKCHIP_IODOMAIN
> +        tristate "Rockchip IO domain support"
> +        depends on ARCH_ROCKCHIP && OF
> +        help
> +          Say y here to enable support io domains on Rockchip SoCs. It is
> +          necessary for the io domain setting of the SoC to match the
> +          voltage supplied by the regulators.
> diff --git a/drivers/power/avs/Makefile b/drivers/power/avs/Makefile
> index 0843386..ba4c7bc 100644
> --- a/drivers/power/avs/Makefile
> +++ b/drivers/power/avs/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_POWER_AVS_OMAP)		+= smartreflex.o
> +obj-$(CONFIG_ROCKCHIP_IODOMAIN)		+= rockchip-io-domain.o
> diff --git a/drivers/power/avs/rockchip-io-domain.c b/drivers/power/avs/rockchip-io-domain.c
> new file mode 100644
> index 0000000..f4e0ebc
> --- /dev/null
> +++ b/drivers/power/avs/rockchip-io-domain.c
> @@ -0,0 +1,333 @@
> +/*
> + * Rockchip IO Voltage Domain driver
> + *
> + * Copyright 2014 MundoReader S.L.
> + * Copyright 2014 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/mfd/syscon.h>
The bindings are not talking about syscon usage. You might
want to document it appropriately to make the usage clear.

> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/regulator/consumer.h>
> +
> +#define MAX_SUPPLIES		16
> +
> +#define MAX_VOLTAGE_1_8		1980000
This is close to 2V, Is that intentional.

> +#define MAX_VOLTAGE_3_3		3600000
> +
Same here.

> +struct rockchip_iodomain;
> +
> +/**
> + * @supplies: voltage settings matching the register bits.
> + */
> +struct rockchip_iodomain_soc_data {
> +	int grf_offset;
> +	const char *supply_names[MAX_SUPPLIES];
> +	void (*init)(struct rockchip_iodomain *iod);
> +};
> +
> +struct rockchip_iodomain_supply {
> +	struct rockchip_iodomain *iod;
> +	struct regulator *reg;
> +	struct notifier_block nb;
> +	int idx;
> +};
> +
> +struct rockchip_iodomain {
> +	struct device *dev;
> +	struct regmap *grf;
> +	struct rockchip_iodomain_soc_data *soc_data;
> +	struct rockchip_iodomain_supply supplies[MAX_SUPPLIES];
> +};
> +
> +static int rockchip_iodomain_write(struct rockchip_iodomain_supply *supply,
> +				   int uV)
> +{
> +	struct rockchip_iodomain *iod = supply->iod;
> +	u32 val;
> +	int ret;
> +
> +	/* set value bit */
> +	val = (uV > MAX_VOLTAGE_1_8) ? 0 : 1;
> +	val <<= supply->idx;
> +
> +	/* apply hiword-mask */
> +	val |= (BIT(supply->idx) << 16);
> +
> +	ret = regmap_write(iod->grf, iod->soc_data->grf_offset, val);
> +	if (ret)
> +		dev_err(iod->dev, "Couldn't write to GRF\n");
> +
> +	return ret;
> +}
> +
> +static int rockchip_iodomain_notify(struct notifier_block *nb,
> +				    unsigned long event,
> +				    void *data)
> +{
> +	struct rockchip_iodomain_supply *supply =
> +			container_of(nb, struct rockchip_iodomain_supply, nb);
> +	int uV;
> +	int ret;
> +
> +	/*
> +	 * According to Rockchip it's important to keep the SoC IO domain
> +	 * higher than (or equal to) the external voltage.  That means we need
> +	 * to change it before external voltage changes happen in the case
> +	 * of an increase.
> +	 */
> +	if (event & REGULATOR_EVENT_PRE_VOLTAGE_CHANGE) {
> +		struct pre_voltage_change_data *pvc_data = data;
> +
> +		uV = max_t(unsigned long, pvc_data->old_uV, pvc_data->max_uV);
> +	} else if (event & (REGULATOR_EVENT_VOLTAGE_CHANGE |
> +			    REGULATOR_EVENT_ABORT_VOLTAGE_CHANGE)) {
> +		uV = (unsigned long)data;
> +	} else {
> +		return NOTIFY_OK;
> +	}
> +
> +	dev_dbg(supply->iod->dev, "Setting to %d\n", uV);
> +
> +	if (uV > MAX_VOLTAGE_3_3) {
> +		dev_err(supply->iod->dev, "Voltage too high: %d\n", uV);
> +
> +		if (event == REGULATOR_EVENT_PRE_VOLTAGE_CHANGE)
> +			return NOTIFY_BAD;
> +	}
> +
> +	ret = rockchip_iodomain_write(supply, uV);
> +	if (ret && event == REGULATOR_EVENT_PRE_VOLTAGE_CHANGE)
> +		return NOTIFY_BAD;
> +
> +	dev_info(supply->iod->dev, "Setting to %d done\n", uV);
> +	return NOTIFY_OK;
> +}
> +
> +#define RK3288_SOC_CON2			0x24c
> +#define RK3288_SOC_CON2_FLASH0		BIT(7)
> +#define RK3288_SOC_FLASH_SUPPLY_NUM	2
> +
Not a strong opinion but you can club all the defines on top
of the file.

Regards,
Santosh
