Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KONok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:44:40 -0500
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:55864 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751456Ab3KONoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:44:34 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Nov 2013 08:44:34 EST
Date: Fri, 15 Nov 2013 14:46:46 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        galak@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 1/2] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131115134646.GO28304@ns203013.ovh.net>
References: <1384509208-10762-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384509208-10762-1-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2684708329810668339
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:53 Fri 15 Nov     , Bo Shen wrote:
> Add Atmel PWM controller driver based on PWM framework.
> 
> This is the basic function implementation of Atmel PWM controller.
> It can work with PWM based led and backlight.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Changes in v7:
>   - fix issue for none device tree issues.
> 
> Changes in v6:
>   - using relaxed version for writel and readl
>   - add none device tree support
>   - change some define from lower case to upper case
>   - split device tree binding document as a separate patch
> 
> Changes in v5:
>   - call clk_disable directly, if so, it won't cause more than one channel
>     enabled, the clock can not be disabled.
> 
> Changes in v4:
>   - check the return value of clk_prepare()
>   - change channel register size as constant
> 
> Changes in v3:
>   - change compatible string from "atmel,sama5-pwm" to "atmel,sama5d3-pwm"
>   - Add PWM led example in binding documentation
>   - Using micro replace hard code
> 
> Changes in v2:
>   - Address the comments from Thierry Reding
> 
>  drivers/pwm/Kconfig     |    9 ++
>  drivers/pwm/Makefile    |    1 +
>  drivers/pwm/pwm-atmel.c |  380 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 390 insertions(+)
>  create mode 100644 drivers/pwm/pwm-atmel.c
> 
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index eece329..5043572 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -41,6 +41,15 @@ config PWM_AB8500
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-ab8500.
>  
> +config PWM_ATMEL
> +	tristate "Atmel PWM support"
> +	depends on ARCH_AT91
> +	help
> +	  Generic PWM framework driver for Atmel SoC.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-atmel.
> +
>  config PWM_ATMEL_TCB
>  	tristate "Atmel TC Block PWM support"
>  	depends on ATMEL_TCLIB && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 8b754e4..1b99cfb 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,6 +1,7 @@
>  obj-$(CONFIG_PWM)		+= core.o
>  obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
>  obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
> +obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
>  obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>  obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> new file mode 100644
> index 0000000..d012538
> --- /dev/null
> +++ b/drivers/pwm/pwm-atmel.c
> @@ -0,0 +1,380 @@
> +/*
> + * Driver for Atmel Pulse Width Modulation Controller
> + *
> + * Copyright (C) 2013 Atmel Corporation
> + *		 Bo Shen <voice.shen@atmel.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +/* The following is global registers for PWM controller */
> +#define PWM_ENA			0x04
> +#define PWM_DIS			0x08
> +#define PWM_SR			0x0C
> +/* Bit field in SR */
> +#define PWM_SR_ALL_CH_ON	0x0F
> +
> +/* The following register is PWM channel related registers */
> +#define PWM_CH_REG_OFFSET	0x200
> +#define PWM_CH_REG_SIZE		0x20
> +
> +#define PWM_CMR			0x0
> +/* Bit field in CMR */
> +#define PWM_CMR_CPOL		(1 << 9)
> +#define PWM_CMR_UPD_CDTY	(1 << 10)
> +
> +/* The following registers for PWM v1 */
> +#define PWMV1_CDTY		0x04
> +#define PWMV1_CPRD		0x08
> +#define PWMV1_CUPD		0x10
> +
> +/* The following registers for PWM v2 */
> +#define PWMV2_CDTY		0x04
> +#define PWMV2_CDTYUPD		0x08
> +#define PWMV2_CPRD		0x0C
> +#define PWMV2_CPRDUPD		0x10
> +
> +/* Max value for duty and period
> + *
> + * Although the duty and period register is 32 bit,
> + * however only the LSB 16 bits are significant.
> + */
> +#define PWM_MAX_DTY		0xFFFF
> +#define PWM_MAX_PRD		0xFFFF
> +#define PRD_MAX_PRES		10
> +
> +struct atmel_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +
> +	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
> +		       int dty, int prd);
> +};
> +
> +static inline struct atmel_pwm_chip *to_atmel_pwm_chip(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct atmel_pwm_chip, chip);
> +}
> +
> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl_relaxed(chip->base + offset);
> +}
> +
> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip,
> +				    unsigned long offset, unsigned long val)
> +{
> +	writel_relaxed(val, chip->base + offset);
> +}
> +
> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip,
> +				     unsigned int ch, unsigned long offset)
> +{
> +	return readl_relaxed(chip->base + PWM_CH_REG_OFFSET +
> +			ch * PWM_CH_REG_SIZE + offset);
> +}
> +
> +static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip,
> +				       unsigned int ch, unsigned long offset,
> +				       unsigned long val)
> +{
> +	writel_relaxed(val, chip->base + PWM_CH_REG_OFFSET +
> +			ch * PWM_CH_REG_SIZE + offset);
> +}
> +
> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +		int duty_ns, int period_ns)
> +{
> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
> +	unsigned long clk_rate, prd, dty;
> +	unsigned long long div;
> +	int ret, pres = 0;
> +
> +	clk_rate = clk_get_rate(atmel_pwm->clk);
> +	div = clk_rate;
> +
> +	/* Calculate the period cycles */
> +	while (div > PWM_MAX_PRD) {
> +		div = clk_rate / (1 << pres);
> +		div = div * period_ns;
> +		/* 1/Hz = 100000000 ns */
> +		do_div(div, 1000000000);
> +
> +		if (pres++ > PRD_MAX_PRES) {
> +			pr_err("PRES is bigger than maximum pre-scaler\n");
if we have more than 1 pwm with pr_err we can known which is it use dev_xxx
instead of all pr_xx


with this Ack

Best Regards,
J.
