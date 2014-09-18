Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaIRK50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:57:26 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57278 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaIRK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:57:23 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 18 Sep 2014 12:54:58 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v4 3/3] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20140918105458.GA2337@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
 <1410290686-6680-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410290686-6680-4-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:24:46PM +0300, Octavian Purdila wrote:

<snip>

> +#define DLN2_GPIO_DIRECTION_IN		0
> +#define DLN2_GPIO_DIRECTION_OUT		1
> +
> +static int dln2_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
> +{
> +	int ret;
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +	struct dln2_gpio_pin req = {
> +		.pin = cpu_to_le16(offset),
> +	};
> +	struct dln2_gpio_pin_val rsp;
> +	int len = sizeof(rsp);
> +
> +	if (test_bit(offset, dln2->pin_dir_set)) {
> +		rsp.value = !!test_bit(offset, dln2->pin_dir);
> +		goto report;
> +	}
> +
> +	ret = dln2_transfer(dln2->pdev, DLN2_GPIO_PIN_GET_DIRECTION,
> +			    &req, sizeof(req), &rsp, &len);
> +	if (ret < 0)
> +		return ret;
> +	if (len < sizeof(rsp) || req.pin != rsp.pin)
> +		return -EPROTO;
> +	set_bit(offset, dln2->pin_dir_set);

You shouldn't set this flag until you've stored the direction.

> +
> +report:
> +	switch (rsp.value) {
> +	case DLN2_GPIO_DIRECTION_IN:
> +		clear_bit(offset, dln2->pin_dir);
> +		return 1;
> +	case DLN2_GPIO_DIRECTION_OUT:
> +		set_bit(offset, dln2->pin_dir);
> +		return 0;
> +	default:
> +		return -EPROTO;
> +	}
> +}
> +
> +static int dln2_gpio_get(struct gpio_chip *chip, unsigned int offset)
> +{
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +	int dir;
> +
> +	dir = dln2_gpio_get_direction(chip, offset);
> +	if (dir < 0)
> +		return dir;
> +
> +	if (dir)
> +		return dln2_gpio_pin_get_in_val(dln2, offset);
> +
> +	return dln2_gpio_pin_get_out_val(dln2, offset);
> +}
> +
> +static void dln2_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +
> +	dln2_gpio_pin_set_out_val(dln2, offset, value);
> +}
> +
> +static int dln2_gpio_set_direction(struct gpio_chip *chip, unsigned offset,
> +				   unsigned dir)
> +{
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +	struct dln2_gpio_pin_val req = {
> +		.pin = cpu_to_le16(offset),
> +		.value = cpu_to_le16(dir),
> +	};
> +
> +	set_bit(offset, dln2->pin_dir_set);

Set flag after you store the direction below.

> +	if (dir == DLN2_GPIO_DIRECTION_OUT)
> +		set_bit(offset, dln2->pin_dir);
> +	else
> +		clear_bit(offset, dln2->pin_dir);

Either way, it looks like this could race with get_direction() if you
get a set_direction() while get_direction() is retrieving the direction
from the device.

This would break gpio_get().

> +
> +	return dln2_transfer(dln2->pdev, DLN2_GPIO_PIN_SET_DIRECTION,
> +			     &req, sizeof(req), NULL, NULL);
> +}

<snip>

> +static int dln2_gpio_set_event_cfg(struct dln2_gpio *dln2, unsigned pin,
> +				   unsigned type, unsigned period)
> +{
> +	struct {
> +		__le16 pin;
> +		u8 type;
> +		__le16 period;
> +	} __packed req = {
> +		.pin = cpu_to_le16(pin),
> +		.type = type,
> +		.period = cpu_to_le16(period),
> +	};
> +
> +	return dln2_transfer(dln2->pdev, DLN2_GPIO_PIN_SET_EVENT_CFG,
> +			     &req, sizeof(req), NULL, NULL);
> +}
> +
> +static void dln2_irq_work(struct work_struct *w)
> +{
> +	struct dln2_irq_work *iw = container_of(w, struct dln2_irq_work, work);
> +	struct dln2_gpio *dln2 = iw->dln2;
> +	u8 type = iw->type & DLN2_GPIO_EVENT_MASK;
> +
> +	if (test_bit(iw->pin, dln2->irqs_enabled))
> +		dln2_gpio_set_event_cfg(dln2, iw->pin, type, 0);
> +	else
> +		dln2_gpio_set_event_cfg(dln2, iw->pin, DLN2_GPIO_EVENT_NONE, 0);
> +}
> +
> +static void dln2_irq_enable(struct irq_data *irqd)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
> +	int pin = irqd_to_hwirq(irqd);
> +
> +	set_bit(pin, dln2->irqs_enabled);
> +	schedule_work(&dln2->irq_work[pin].work);
> +}
> +
> +static void dln2_irq_disable(struct irq_data *irqd)
> +{
> +	struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +	struct dln2_gpio *dln2 = container_of(gc, struct dln2_gpio, gpio);
> +	int pin = irqd_to_hwirq(irqd);
> +
> +	clear_bit(pin, dln2->irqs_enabled);
> +	schedule_work(&dln2->irq_work[pin].work);
> +}

<snip>

> +static int dln2_gpio_probe(struct platform_device *pdev)
> +{
> +	struct dln2_gpio *dln2;
> +	struct device *dev = &pdev->dev;
> +	int pins = dln2_gpio_get_pin_count(pdev);

Again, don't do non-trivial intialisations when declaring your variables.

> +	int i, ret;
> +
> +	if (pins < 0) {
> +		dev_err(dev, "failed to get pin count: %d\n", pins);
> +		return pins;
> +	}
> +	if (pins > DLN2_GPIO_MAX_PINS) {
> +		pins = DLN2_GPIO_MAX_PINS;
> +		dev_warn(dev, "clamping pins to %d\n", DLN2_GPIO_MAX_PINS);
> +	}
> +
> +	dln2 = devm_kzalloc(&pdev->dev, sizeof(*dln2), GFP_KERNEL);
> +	if (!dln2)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < DLN2_GPIO_MAX_PINS; i++) {
> +		INIT_WORK(&dln2->irq_work[i].work, dln2_irq_work);
> +		dln2->irq_work[i].pin = i;
> +		dln2->irq_work[i].dln2 = dln2;
> +	}
> +
> +	dln2->pdev = pdev;
> +
> +	dln2->gpio.label = "dln2";
> +	dln2->gpio.dev = dev;
> +	dln2->gpio.owner = THIS_MODULE;
> +	dln2->gpio.base = -1;
> +	dln2->gpio.ngpio = pins;
> +	dln2->gpio.exported = 1;
> +	dln2->gpio.set = dln2_gpio_set;
> +	dln2->gpio.get = dln2_gpio_get;
> +	dln2->gpio.request = dln2_gpio_request;
> +	dln2->gpio.free = dln2_gpio_free;
> +	dln2->gpio.get_direction = dln2_gpio_get_direction;
> +	dln2->gpio.direction_input = dln2_gpio_direction_input;
> +	dln2->gpio.direction_output = dln2_gpio_direction_output;
> +	dln2->gpio.set_debounce = dln2_gpio_set_debounce;
> +
> +	platform_set_drvdata(pdev, dln2);
> +
> +	ret = gpiochip_add(&dln2->gpio);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to add gpio chip: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = gpiochip_irqchip_add(&dln2->gpio, &dln2_gpio_irqchip, 0,
> +				   handle_simple_irq, IRQ_TYPE_NONE);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to add irq chip: %d\n", ret);
> +		goto out_gpiochip_remove;
> +	}
> +
> +	ret = dln2_register_event_cb(pdev, DLN2_GPIO_CONDITION_MET_EV,
> +				     dln2_gpio_event);
> +	if (ret) {
> +		dev_err(dev, "failed to register event cb: %d\n", ret);
> +		goto out_gpiochip_remove;
> +	}
> +
> +	return 0;
> +
> +out_gpiochip_remove:
> +	gpiochip_remove(&dln2->gpio);
> +out:
> +	return ret;
> +}
> +
> +static int dln2_gpio_remove(struct platform_device *pdev)
> +{
> +	struct dln2_gpio *dln2 = platform_get_drvdata(pdev);
> +
> +	dln2_unregister_event_cb(pdev, DLN2_GPIO_CONDITION_MET_EV);
> +	dln2->pdev = NULL;
> +	gpiochip_remove(&dln2->gpio);

You probably need to flush all your work structs here.

> +
> +	return 0;
> +}
> +
> +static struct platform_driver dln2_gpio_driver = {
> +	.driver.name	= DRIVER_NAME,
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= dln2_gpio_probe,
> +	.remove		= dln2_gpio_remove,
> +};
> +
> +module_platform_driver(dln2_gpio_driver);
> +
> +MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com");
> +MODULE_DESCRIPTION(DRIVER_NAME "driver");
> +MODULE_LICENSE("GPL");

Johan
