Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3FXOsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:48:25 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19085 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3FXOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:48:23 -0400
Message-ID: <51C85C31.4070003@imgtec.com>
Date: Mon, 24 Jun 2013 15:48:17 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 2/4] gpio-tz1090: add TZ1090 gpio driver
References: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com> <1371720391-21825-3-git-send-email-james.hogan@imgtec.com> <20130624133453.8FC5D3E0A89@localhost>
In-Reply-To: <20130624133453.8FC5D3E0A89@localhost>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_24_15_48_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 14:34, Grant Likely wrote:
> On Thu, 20 Jun 2013 10:26:28 +0100, James Hogan <james.hogan@imgtec.com> wrote:
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
>> new file mode 100644
>> index 0000000..e017d4b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
>> @@ -0,0 +1,87 @@
>> +ImgTec TZ1090 GPIO Controller
>> +
>> +Required properties:
>> +- compatible: Compatible property value should be "img,tz1090-gpio>".
> 
> typo at end of line

Yes, I'll fix in gpio-tz1090-pdc driver bindings too

>> +  Bank subnode optional properties:
>> +  - gpio-ranges: Mapping to pin controller pins
> 
> This is specific to this binding. To avoid namespace colisions, add a
> "img," prefix to the property name.

This property is described in
Documentation/devicetree/bindings/gpio/gpio.txt... (and my examples are
out of date from when the gpio offset cell was added in v3.10). I'll add
a reference to that Document.

>> +/* GPIO chip callbacks */
>> +
>> +static int tz1090_gpio_direction_input(struct gpio_chip *chip,
>> +				       unsigned int offset)
>> +{
>> +	struct tz1090_gpio_bank *bank = to_bank(chip);
>> +	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
>> +
>> +	return 0;
>> +}
>> +
>> +static int tz1090_gpio_direction_output(struct gpio_chip *chip,
>> +					unsigned int offset, int output_value)
>> +{
>> +	struct tz1090_gpio_bank *bank = to_bank(chip);
>> +	int lstat;
>> +
>> +	__global_lock2(lstat);
>> +	_tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
>> +	_tz1090_gpio_clear_bit(bank, REG_GPIO_DIR, offset);
>> +	__global_unlock2(lstat);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Return GPIO level
>> + */
>> +static int tz1090_gpio_get(struct gpio_chip *chip, unsigned int offset)
>> +{
>> +	struct tz1090_gpio_bank *bank = to_bank(chip);
>> +
>> +	return tz1090_gpio_read_bit(bank, REG_GPIO_DIN, offset);
>> +}
>> +
>> +/*
>> + * Set output GPIO level
>> + */
>> +static void tz1090_gpio_set(struct gpio_chip *chip, unsigned int offset,
>> +			    int output_value)
>> +{
>> +	struct tz1090_gpio_bank *bank = to_bank(chip);
>> +
>> +	tz1090_gpio_mod_bit(bank, REG_GPIO_DOUT, offset, output_value);
>> +}
>> +
>> +static int tz1090_gpio_request(struct gpio_chip *chip, unsigned int offset)
>> +{
>> +	struct tz1090_gpio_bank *bank = to_bank(chip);
>> +	int ret;
>> +
>> +	ret = pinctrl_request_gpio(chip->base + offset);
>> +	if (ret)
>> +		return ret;
>> +
>> +	tz1090_gpio_set_bit(bank, REG_GPIO_DIR, offset);
>> +	tz1090_gpio_set_bit(bank, REG_GPIO_BIT_EN, offset);
>> +
>> +	return 0;
>> +}
> 
> Is it possible to use the gpio-generic.c hooks for manipulating the
> gpio bits?

Due to the unfortunate necessity to use the __global_lock2 functions
(for atomic accesses between different non-linux threads/cores) I don't
think this is possible.

>> +/* IRQ chip handlers */
>> +
>> +/* Get TZ1090 GPIO chip from irq data provided to generic IRQ callbacks */
>> +static inline struct tz1090_gpio_bank *irqd_to_gpio_bank(struct irq_data *data)
>> +{
>> +	return (struct tz1090_gpio_bank *)data->domain->host_data;
>> +}
>> +
>> +static void tz1090_gpio_irq_clear(struct tz1090_gpio_bank *bank,
>> +				  unsigned int offset)
>> +{
>> +	tz1090_gpio_clear_bit(bank, REG_GPIO_IRQ_STS, offset);
>> +}
>> +
>> +static void tz1090_gpio_irq_enable(struct tz1090_gpio_bank *bank,
>> +				   unsigned int offset, bool enable)
>> +{
>> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_EN, offset, enable);
>> +}
>> +
>> +static void tz1090_gpio_irq_polarity(struct tz1090_gpio_bank *bank,
>> +				     unsigned int offset, unsigned int polarity)
>> +{
>> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_PLRT, offset, polarity);
>> +}
>> +
>> +static int tz1090_gpio_valid_handler(struct irq_desc *desc)
>> +{
>> +	return desc->handle_irq == handle_level_irq ||
>> +		desc->handle_irq == handle_edge_irq;
>> +}
>> +
>> +static void tz1090_gpio_irq_type(struct tz1090_gpio_bank *bank,
>> +				 unsigned int offset, unsigned int type)
>> +{
>> +	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_TYPE, offset, type);
>> +}
>> +
>> +/* set polarity to trigger on next edge, whether rising or falling */
>> +static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
>> +				      unsigned int offset)
>> +{
>> +	unsigned int value_p, value_i;
>> +	int lstat;
>> +
>> +	/*
>> +	 * Set the GPIO's interrupt polarity to the opposite of the current
>> +	 * input value so that the next edge triggers an interrupt.
>> +	 */
>> +	__global_lock2(lstat);
>> +	value_i = ~tz1090_gpio_read(bank, REG_GPIO_DIN);
>> +	value_p = tz1090_gpio_read(bank, REG_GPIO_IRQ_PLRT);
>> +	value_p &= ~BIT(offset);
>> +	value_p |= value_i & BIT(offset);
>> +	tz1090_gpio_write(bank, REG_GPIO_IRQ_PLRT, value_p);
>> +	__global_unlock2(lstat);
>> +}
>> +
>> +static void gpio_ack_irq(struct irq_data *data)
>> +{
>> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
>> +
>> +	tz1090_gpio_irq_clear(bank, data->hwirq);
>> +}
>> +
>> +static void gpio_mask_irq(struct irq_data *data)
>> +{
>> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
>> +
>> +	tz1090_gpio_irq_enable(bank, data->hwirq, false);
>> +}
>> +
>> +static void gpio_unmask_irq(struct irq_data *data)
>> +{
>> +	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
>> +
>> +	tz1090_gpio_irq_enable(bank, data->hwirq, true);
>> +}
> 
> Similarly, can this driver use the generic irq chip to eliminate the
> above hooks?

hmm, I could probably get away with it for irq callbacks since a bank's
IRQ cannot be shared with non-Linux threads/cores.

> 
> [...]
>> +
>> +static void tz1090_gpio_register_banks(struct tz1090_gpio *priv)
>> +{
>> +	struct device_node *np = priv->dev->of_node;
>> +	struct device_node *node;
>> +
>> +	for_each_available_child_of_node(np, node) {
>> +		struct tz1090_gpio_bank_info info;
>> +		const __be32 *addr;
>> +		int len, ret;
>> +
>> +		addr = of_get_property(node, "reg", &len);
>> +		if (!addr || (len < sizeof(int))) {
>> +			dev_err(priv->dev, "invalid reg on %s\n",
>> +				node->full_name);
>> +			continue;
>> +		}
> 
> Use of_property_read_u32(). It's safer and does the be32 conversion for you.

will do.

Thanks for the review.

Cheers
James

