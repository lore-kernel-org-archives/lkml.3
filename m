Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaLQV6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:58:09 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38663 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaLQV6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:58:06 -0500
Message-ID: <5491FC69.7090203@cogentembedded.com>
Date: Thu, 18 Dec 2014 00:58:01 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        myungjoo.ham@samsung.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] extcon: add MAX3355 driver
References: <14631865.01KLlU2iKL@wasted.cogentembedded.com> <5490CEE2.1030900@samsung.com>
In-Reply-To: <5490CEE2.1030900@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/17/2014 03:31 AM, Chanwoo Choi wrote:

>> MAX3355E chip integrates a charge pump and comparators to enable a system with
>> an integrated USB OTG dual-role transceiver to function as a USB OTG dual-role
>> device. In addition to sensing/controlling Vbus, the chip also passes thru the
>> ID signal from the USB OTG connector.  On some Renesas boards, this signal  is
>> just  fed into the SoC thru a GPIO pin -- there's no real OTG controller, only
>> host and gadget USB controllers sharing the same USB bus; however,  we'd  like
>> to allow host or gadget drivers to be loaded depending on the cable type, hence
>> the need for the MAX3355 extcon driver. The Vbus status signals are also wired
>> to GPIOs (however, we're not currently intested in them), the  OFFVBUS# signal
>> is controlled  by the host controllers, there's also the SHDN# signal wired to
>> GPIO, which should be high for normal operation.

>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>> The patch is against the 'extcon-next' branch of the 'extcon.git' repo.

>>   Documentation/devicetree/bindings/extcon/extcon-max3355.txt |   21 ++
>>   drivers/extcon/Kconfig                                      |    6
>>   drivers/extcon/Makefile                                     |    1
>>   drivers/extcon/extcon-max3355.c                             |  122 ++++++++++++
>>   4 files changed, 150 insertions(+)

>> Index: extcon/Documentation/devicetree/bindings/extcon/extcon-max3355.txt
>> ===================================================================
>> --- /dev/null
>> +++ extcon/Documentation/devicetree/bindings/extcon/extcon-max3355.txt
>> @@ -0,0 +1,21 @@
>> +MAX3355 USB OTG chip

> Need manufactor information as following :
>    -> Maxim MAX3355

    Would be Maxim enough? Or perhaps I should use Maxim Integrated [Products]?

>> +--------------------
>> +
>> +MAX3355 integrates a charge pump and comparators to enable a system with an
>> +integrated USB OTG dual-role transceiver to function as a USB OTG dual-role
>> +device.
>> +
>> +Required properties:
>> +- compatible: should be "maxim,max3355";
>> +- maxim,shdn-gpio: should contain a phandle and GPIO specifier for the GPIO pin
>> +  connected to the MAX3355's SHDN# pin;
>> +- maxim,id-gpio: should contain a phandle and GPIO specifier for the GPIO pin
>> +  connected to the MAX3355's ID_OUT pin.
>> +
>> +Example (Koelsch board):
>> +
>> +	usb-otg {
>> +		compatible = "maxim,max3355";
>> +		maxim,shdn-gpio = <&gpio2 4 GPIO_ACTIVE_LOW>;
>> +		maxim,id-gpio = <&gpio5 31 GPIO_ACTIVE_HIGH>;

> Kernel already supported the gpio helper function to get gpio from devicetree.
> I prefer use follwoing style by using of_get_gpio()/of_get_gpio_flags() in include/linux/of_gpio.h.

> 		gpios = <&gpio2 4 GPIO_ACTIVE_LOW>, <&gpio5 31 GPIO_ACTIVE_HIGH>;

    OK, though Documentation/devicetree/bindings/gpio/gpio.txt does not seem 
to insist on using this one...

[...]

>> Index: extcon/drivers/extcon/extcon-max3355.c
>> ===================================================================
>> --- /dev/null
>> +++ extcon/drivers/extcon/extcon-max3355.c
>> @@ -0,0 +1,122 @@
>> +/*
>> + * MAX3355 USB OTG chip extcon driver

> ditto.

    OK, though the other Maxim extcon drivers don't serve as a good example 
here...

[...]
>> +static irqreturn_t max3355_id_irq(int irq, void *dev_id)
>> +{
>> +	struct max3355_data *data = dev_id;
>> +	int id = gpio_get_value(data->id_gpio);
>> +
>> +	extcon_set_cable_state(data->edev, "USB-HOST", !id);

> You have to get the gpio flag in the devicetree by using of_get_gpio_flags() function
> and then you would set the cable state according to gpio state and flag.

    I'm sorry but I just don't see why I have to do it. This is not a generic 
GPIO driver, and the polarities of the GPIOs are determined solely by the 
MAX3355 specs.

[...]
>> +static int max3355_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct max3355_data *data;
>> +	int gpio, irq, ret;
>> +
>> +	data = devm_kzalloc(&pdev->dev, sizeof(struct max3355_data),
>> +			    GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	data->edev = devm_extcon_dev_allocate(&pdev->dev, max3355_cable);
>> +	if (IS_ERR(data->edev)) {
>> +		dev_err(&pdev->dev, "failed to allocate extcon device\n");
>> +		return PTR_ERR(data->edev);
>> +	}
>> +	data->edev->name = kstrdup(np->name, GFP_KERNEL);
>> +
>> +	gpio = of_get_named_gpio(np, "maxim,id-gpio", 0);

> Use of_get_gpio() or of_get_gpio_flags().

    OK, I'll use the first one.

> "maxim,id-gpio" property has strong dependency on this driver and it is not standard.

    I indented it to be Maxim specific. Not sure what using the standard 
property buys...

>> +	if (gpio < 0)
>> +		return gpio;

> Need to add error message.

    OK for all cases; extcon-gpio.c was probably a bad example...

[...]

>> +
>> +	ret = devm_gpio_request_one(&pdev->dev, gpio, GPIOF_DIR_OUT |
>> +				    GPIOF_INIT_HIGH, pdev->name);
>> +	if (ret < 0)
>> +		return ret;

> Need to add error message.

>> +
>> +	ret = devm_gpio_request_one(&pdev->dev, data->id_gpio, GPIOF_DIR_IN,
>> +				    pdev->name);

> Why do you use same name for two gpio when devm_gpio_request_one?
> I prefer to use other name because two gpio is different.

    And you're absolutely right here. Mindlessly copy-pasted the code from 
extcon-gpio.c...

[...]

>> +
>> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, max3355_id_irq,
>> +					IRQF_TRIGGER_RISING |
>> +					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,

> Is it right to add both RISING and FALLING trigger?

    How else I'm supposed to know when the OTG ID signal goes low and high?

> and need to add IRQF_NO_SUSPEND to wakeup from suspend state when interrupt happen.

    Hm, are you sure we want to wake up on plugging another kind of USB cable?

[...]
>> +static struct platform_driver max3355_driver = {
>> +	.probe		= max3355_probe,
>> +	.driver		= {
>> +		.name	= "extcon-max3355",
>> +		.of_match_table = max3355_match_table,
>> +		.owner	= THIS_MODULE,
>> +	},
>> +};
>> +
>> +module_platform_driver(max3355_driver);
>> +

> Don't need un-used blank line.

    I don't understand. There's empty line in such case in extcon-gpio.c...

>> +MODULE_AUTHOR("Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>");
>> +MODULE_DESCRIPTION("MAX3355 extcon driver");

> Maxim MAX3355.

    OK, seeing it in the other Maxim drivers.

>> +MODULE_LICENSE("GPL v2");

> Thanks,
> Chanwoo Choi

WBR, Sergei

