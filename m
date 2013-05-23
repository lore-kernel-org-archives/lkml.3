Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3EWLd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:33:28 -0400
Received: from ns.mm-sol.com ([213.240.235.226]:55878 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab3EWLd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:33:26 -0400
Message-ID: <519DFE7B.5090706@mm-sol.com>
Date: Thu, 23 May 2013 14:33:15 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv2 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org> <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rohit,

Thanks for the new version!

I have few more comments below.

On 05/23/2013 03:29 AM, Rohit Vaswani wrote:
> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  .../devicetree/bindings/gpio/gpio-msm.txt          |   26 +++
>  arch/arm/boot/dts/msm8660-surf.dts                 |   11 ++
>  arch/arm/boot/dts/msm8960-cdp.dts                  |   11 ++
>  drivers/gpio/Kconfig                               |    2 +-
>  drivers/gpio/gpio-msm-v2.c                         |  168 +++++++++++++-------
>  5 files changed, 157 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-msm.txt
> 

<cut>

>  static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>  {
> -	return MSM_GPIO_TO_INT(chip->base + offset);
> +	struct msm_gpio_dev *g_dev = to_msm_gpio_dev(chip);
> +	struct irq_domain *domain = g_dev->domain;

Could you add blank line here.

> +	return irq_create_mapping(domain, offset);
>  }
>  
>  static inline int msm_irq_to_gpio(struct gpio_chip *chip, unsigned irq)
>  {
> -	return irq - MSM_GPIO_TO_INT(chip->base);
> +	struct irq_data *irq_data = irq_get_irq_data(irq);

Blank line please.

> +	return irq_data->hwirq;
>  }
>  
>  static struct msm_gpio_dev msm_gpio = {
>  	.gpio_chip = {
>  		.base             = 0,
> -		.ngpio            = NR_GPIO_IRQS,
>  		.direction_input  = msm_gpio_direction_input,
>  		.direction_output = msm_gpio_direction_output,
>  		.get              = msm_gpio_get,
> @@ -226,9 +234,9 @@ static void msm_gpio_update_dual_edge_pos(unsigned gpio)
>  		if (intstat || val == val2)
>  			return;
>  	} while (loop_limit-- > 0);
> -	pr_err("dual-edge irq failed to stabilize, "
> +	pr_err("%s: dual-edge irq failed to stabilize, "
>  	       "interrupts dropped. %#08x != %#08x\n",
> -	       val, val2);
> +	       __func__, val, val2);
>  }
>  
>  static void msm_gpio_irq_ack(struct irq_data *d)
> @@ -312,10 +320,11 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>  {
>  	unsigned long i;
>  	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	int ngpio = msm_gpio.gpio_chip.ngpio;
>  
>  	chained_irq_enter(chip, desc);
>  
> -	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
> +	for_each_set_bit(i, msm_gpio.enabled_irqs, ngpio) {
>  		if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS))
>  			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
>  							   i));

As you decided to call irq_create_mapping() from msm_gpio_to_irq, then
in irq handler you must call irq_find_mapping() as stated in
IRQ-domain.txt and probably check return value.

<cut>

> +static int msm_gpio_irqdomain_init(struct device_node *node, int ngpio)
> +{
> +	msm_gpio.domain = irq_domain_add_linear(node, ngpio,
> +			&msm_gpio_irq_domain_ops, &msm_gpio);
> +	if (!msm_gpio.domain)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +

This function seems meaningless, could you call irq_domain_add_linear
from .probe directly?

- Stan

