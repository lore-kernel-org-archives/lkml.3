Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3H2Haz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:30:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35006 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3H2Hax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:30:53 -0400
Message-ID: <521EF88F.4070402@ti.com>
Date: Thu, 29 Aug 2013 13:00:23 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>
Subject: Re: [PATCH v3 1/3] extcon: extcon-gpio-usbvid: Generic USB VBUS/ID
 detection via GPIO
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-2-git-send-email-george.cherian@ti.com> <521EA563.4060305@samsung.com> <521EB018.3000301@ti.com> <521EE8FC.80802@samsung.com>
In-Reply-To: <521EE8FC.80802@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 8/29/2013 11:53 AM, Chanwoo Choi wrote:
[snip]
> You should keep following naming stlye. extcon-gpio-usbvid.c is wrong naming style.
> - extcon-[device name].c
> - extcon-gpio-usbvid.c -> extcon-dra7xx.c or etc.
>> Actually dra7xx is the SoC name and the USB VBUS/ID detection is not specific to SoC.
>> It uses gpios to detect the VBUS/ID change. So i thought it would be better to have generic
>> gpio based VBUS/ID detection rather than making dra7xx specific. Stephen Warren had this opinion
>> with patch v1.
> Would you guarantee that this driver support all of extcon devices using gpio pin?
This driver would guarantee extcon devices using gpio pins for USB VBUS 
and ID detection.
Following is the basic assumption made, correct me if I am wrong.
ID pin ground means -> USB-HOST is true (this happens when a device is 
connected to USB port and we act as HOST )
ID pin Float means -> USB-HOST is false (this happens when nothing is 
connected or when we act as a peripheral under a HOST)
VBUS ON means -> USB is true (this happens when we are connected under a 
HOST as a peripheral)
VBUS OFF means -> USB is false ( this happens when we are either 
disconnected from a HOST or when we are in HOST mode).

So normally USB is in peripheral mode is enabled when ID pin is float 
and VBUS is ON.
and USB is in HOST mode when ID pin is ground and VBUS is OFF.

In all above cases VBUS is referred to the external VBUS supply from an 
external HOST.

> I can't agree. This driver has specific dependency on dra7x SoC.
>
> First,
> vbus_irq_handler() determine USB cable state according to "gpio_usbvid->vbus_gpio" state.
> If "gpio_usbvid->vbus_gpio" value is VBUS_OFF(0), this patch set USB cable state as 'false'
> But, it include potential problems. Other extcon device using gpio would set USB cable state
> as 'true' when gpio state is 1. This way has dependency on specific SoC.
no this is not SoC specific. VBUS is referred to the external VBUS 
supply from an external HOST.
so if VBUS is zero means its definitely not in connected state.
>
> Second,
> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
> would not control both "USB-HOST" and "USB" cable state at same time.
>
> Other extcon devices would support either "USB-HOST" or "USB" cable.
The driver has 2 configurations.
1) supports implementations with both VBUS and ID pin are routed via 
gpio's for swicthing roles(compatible  gpio-usb-vid).
2) supports implementations with only ID pin routed via gpio for 
swicthing roles(compatible gpio-usb-id).
So if you take type as VBUS_ID_DETECT then it is as what you meant.
>
> Third,
> gpio_usbvid_probe() get both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq by using DT helper function.
> and gpio_usbvid_request_irq() register each interrupt handler(id_irq and vbus_irq) according to DT data.
> In result,
> 	id_irq_handler() would control both "USB-HOST" and "USB" cable state.
only if type is ID_DETECT id_irq_handler control both USB-HOST and USB 
cable states
if type is VBUS_ID_DETECT then id_irq_handler only controls USB-HOST.
> 	vbus_irq_handler() would control only "USB" cable state.
>
> Two interrupt handler(id_irq_handler()/vbus_irq_handler()) would control "USB" cable state
> according to each gpio state at same time. Also, It include critical problem.
No it depends on the configuration as explained above.

[snip]

> +
> +#define ID_GND        0
> +#define ID_FLOAT    1
> +#define VBUS_OFF    0
> +#define VBUS_ON        1
>>> I think you could only use two constant instead of four constant definition.
>> you mean only ID_GND and VBUS_OFF?
> you could only define two contant (0 and 1) to detect gpio state.
okay
>
>>>> +
>>>> +
>>> This blank line isn't necessary.
>>>
>>>> +static irqreturn_t id_irq_handler(int irq, void *data)
>>>> +{
>>>> +    struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
>>> You should delete blank between ')' and 'data' as follwong:
>>>      - (struct gpio_usbvid *)data;
>> okay
>>>> +    int id_current;
>>>> +
>>>> +    id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>> +    if (id_current == ID_GND) {
>>>> +        if (gpio_usbvid->type == ID_DETECT)
>>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>>> +                            "USB", false);
>>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>> As else statement, you should set "USB-HOST" cable state to improve readability.
>>>
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>          if (gpio_usbvid->type == ID_DETECT)
>>>              extcon_set_cable_state(&gpio_usbvid->edev,
>>>                              "USB", false);
>> Actually, USB-HOST state should be set in the id_irq handler. But in cases were only ID pin is routed to gpio
>> and VBUS is not used we set the USB state too. The gpio_usbvid->type differentiates whether its an ID only or
>> VBUS and ID.
> I don't understand. Wht does not you change the order of function call as following?
>
> 	Before:
> 	        if (gpio_usbvid->type == ID_DETECT)
> 			extcon_set_cable_state(&gpio_usbvid->edev,
> 	                            	"USB", false);
> 		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
Basically these notifiers would go and change the UTMI modes which is 
s/w controlled.
so we want to gracefully exit Device mode first and then enter HOST mode.
this is only with type=ID_DETECT.
> 	After:
> 		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
> 		if (gpio_usbvid->type == ID_DETECT)
> 			extcon_set_cable_state(&gpio_usbvid->edev,
> 					"USB", false);
>
> id_irq_handler() determine the state of "USB-HOST" cable according to 'id_current' value.
> And this function dermine the state of "USB" cable accordign to "gpio_usbvid->type" value.
>
>>>> +    } else {
>>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>>> +        if (gpio_usbvid->type == ID_DETECT)
>>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>>> +                            "USB", true);
>>>> +    }
>>> Add blank line.
>> okay
>>>> +    return IRQ_HANDLED;
>>>> +}
>>>> +
>>>> +static irqreturn_t vbus_irq_handler(int irq, void *data)
>>>> +{
>>>> +    struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
>>> ditto.
>> okay
>>>> +    int vbus_current;
>>>> +
>>>> +    vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>>> +    if (vbus_current == VBUS_OFF)
>>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>>> +    else
>>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
> First,
> vbus_irq_handler() determine USB cable state according to "gpio_usbvid->vbus_gpio" state.
> If "gpio_usbvid->vbus_gpio" value is VBUS_OFF(0), this patch set USB cable state as 'false'
> But, it include potential problems. Other extcon device using gpio would set USB cable state
> as 'true' when gpio state is 1. This way has dependency on specific SoC.
see above
[snip]
>>> +
>>> +    switch (gpio_usbvid->type) {
>>> +    case ID_DETECT:
>>> +        id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>> +        if (!!id_current == ID_FLOAT) {
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", false);
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", true);
>>> +        } else {
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB", false);
>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>> +                            "USB-HOST", true);
>>> +        }
> Second,
> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
> would not control both "USB-HOST" and "USB" cable state at same time.
>
> Other extcon devices would support either "USB-HOST" or "USB" cable.
see above
[snip]
> Why do you use the same interrupt name both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq?
> You should use characteristic interrupt name.
>> if I use dev_name it gives me 2 same name interrupts associated with a single extcon device.
>> Where as if i use characteristic (for eg: VBUS or ID) names then I will get multiple with same name
>> since there will be 2 instances of extcon being used as of now.
> I can't agree. Single extcon driver can have various interrupt.
> If you use same interrupt name about different two interrupt,
> can we know the kind of interrupt which is happened on /proc/interrupts?
> We cannot count the number of each interrupt occurrences.
ya so i will use something like "extcon_devname + VBUS/ID"
otherwise if i have 3 instance of extcon device in type VBUS_ID_DETECT 
then i will have
2 entries named VBUS and 2 named ID.
I will change it.
[snip]
> +
> +    platform_set_drvdata(pdev, gpio_usbvid);
> +
> +    gpio_usbvid->edev.name = dev_name(&pdev->dev);
>>> I add as follwong comment about your v1 patchset
>>>
>>>      "If edev name is equal with device name, this line is unnecessary.
>>>      Because extcon_dev_register() use dev_name(&pdev->dev) as edev name
>>>      in extcon-class.c"
>>>
>>> Why did not apply for my comment to v3 patchset?
>>> Plesae pay attention for previous comment.
>> I removed it but it gave me a  NULL pointer dereference  in extcon_get_extcon_dev (strcmp the sd->name was NULL).
>> I am based on v3.11-rc3, did you have any fix for this in later rc's? probably I would rebase to your latest and check.
> Always, you have to develop patch based on extcon-next or extcon-linux branch according to patch content.
>
> This feature related to your NULL pointer issue will include v3.12.
> - http://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-next&id=6eee5b3b493824731ed34ade0299241f91f04096
guilty as charged i will rebase.
>>>> +    gpio_usbvid->edev.supported_cable = dra7xx_extcon_cable;
>>>> +    gpio_usbvid->edev.mutually_exclusive = mutually_exclusive;
>>>> +
>>>> +    if (of_device_is_compatible(node, "ti,gpio-usb-id"))
>>>> +        gpio_usbvid->type = ID_DETECT;
>>>> +
>>>> +    gpio = of_get_gpio(node, 0);
>>>> +    if (gpio_is_valid(gpio)) {
>>>> +        gpio_usbvid->id_gpio = gpio;
>>>> +        ret = devm_gpio_request(&pdev->dev, gpio_usbvid->id_gpio,
>>>> +                    "id_gpio");
>>>> +        if (ret)
>>>> +            return ret;
>>> Add blank line.
>>>
>>>> +        gpio_usbvid->id_irq = gpio_to_irq(gpio_usbvid->id_gpio);
>>>> +    } else {
>>>> +        dev_err(&pdev->dev, "failed to get id gpio\n");
>>>> +        return -ENODEV;
>>>> +    }
>>>> +
>>>> +    if (of_device_is_compatible(node, "ti,gpio-usb-vid")) {
>>>> +        gpio_usbvid->type = VBUS_ID_DETECT;
>>>> +        gpio = of_get_gpio(node, 1);
>>>> +        if (gpio_is_valid(gpio)) {
>>>> +            gpio_usbvid->vbus_gpio = gpio;
>>>> +            ret = devm_gpio_request(&pdev->dev,
>>>> +                        gpio_usbvid->vbus_gpio,
>>>> +                        "vbus_gpio");
>>>> +            if (ret)
>>>> +                return ret;
>>> Add blank line.
>>>
>>>> +            gpio_usbvid->vbus_irq =
>>>> +                    gpio_to_irq(gpio_usbvid->vbus_gpio);
>>>> +        } else {
>>>> +            dev_err(&pdev->dev, "failed to get vbus gpio\n");
>>>> +            return -ENODEV;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    ret = extcon_dev_register(&gpio_usbvid->edev, gpio_usbvid->dev);
>>>> +    if (ret) {
>>>> +        dev_err(&pdev->dev, "failed to register extcon device\n");
>>>> +        return ret;
>>>> +    }
>>>> +
>>>> +    gpio_usbvid_set_initial_state(gpio_usbvid);
>>>> +    ret = gpio_usbvid_request_irq(gpio_usbvid);
> Third,
> gpio_usbvid_probe() get both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq by using DT helper function.
> and gpio_usbvid_request_irq() register each interrupt handler(id_irq and vbus_irq) according to DT data.
> In result,
> id_irq_handler() would control both "USB-HOST" and "USB" cable state.
> vbus_irq_handler() would control only "USB" cable state.
>
> Two interrupt handler(id_irq_handler()/vbus_irq_handler()) would control "USB" cable state
> according to each gpio state at same time. Also, It include critical problem.
see above
>>> You should move gpio_usbvid_request_irq() call before extcon_dev_register().
>>>
>>>> +    if (ret)
>>>> +        goto err0;
>>> ? As following previous comment about v1 patchset:
>>>      I need correct meaning name as err_thread or etc ...
>> okay
>>>> +
>>>> +    return 0;
>>>> +
>>>> +err0:
>>> ditto.
>> okay
>>>> +    extcon_dev_unregister(&gpio_usbvid->edev);
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int gpio_usbvid_remove(struct platform_device *pdev)
>>>> +{
>>>> +    struct gpio_usbvid *gpio_usbvid = platform_get_drvdata(pdev);
>>>> +
>>>> +    extcon_dev_unregister(&gpio_usbvid->edev);
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static struct of_device_id of_gpio_usbvid_match_tbl[] = {
>>>> +    { .compatible = "ti,gpio-usb-vid", },
>>>> +    { .compatible = "ti,gpio-usb-id", },
>>>> +    { /* end */ }
>>>> +};
>>>> +
>>>> +static struct platform_driver gpio_usbvid_driver = {
>>>> +    .probe = gpio_usbvid_probe,
>>>> +    .remove = gpio_usbvid_remove,
>>>> +    .driver = {
>>>> +        .name = "gpio-usbvid",
>>>> +        .of_match_table = of_gpio_usbvid_match_tbl,
>>>> +        .owner = THIS_MODULE,
>>>> +    },
>>>> +};
>>>> +
>>>> +module_platform_driver(gpio_usbvid_driver);
>>>> +
>>>> +MODULE_ALIAS("platform:gpio-usbvid");
>>>> +MODULE_AUTHOR("George Cherian <george.cherian@ti.com>");
>>>> +MODULE_DESCRIPTION("GPIO based USB Connector driver");
>>>> +MODULE_LICENSE("GPL");
>>>> +MODULE_DEVICE_TABLE(of, of_gpio_usbvid_match_tbl);
>>>>
>>> Cheers,
>>> Chanwoo Choi
>>
> Thanks,
> Chanwoo Choi
>


-- 
-George

