Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3H2LtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:49:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44203 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3H2LtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:49:08 -0400
Message-ID: <521F3515.7040001@ti.com>
Date: Thu, 29 Aug 2013 17:18:37 +0530
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
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-2-git-send-email-george.cherian@ti.com> <521EA563.4060305@samsung.com> <521EB018.3000301@ti.com> <521EE8FC.80802@samsung.com> <521EF88F.4070402@ti.com> <521F245E.8050506@samsung.com>
In-Reply-To: <521F245E.8050506@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2013 4:07 PM, Chanwoo Choi wrote:
> On 08/29/2013 04:30 PM, George Cherian wrote:
>> Hi Chanwoo,
>>
>> On 8/29/2013 11:53 AM, Chanwoo Choi wrote:
>> [snip]
>>> You should keep following naming stlye. extcon-gpio-usbvid.c is wrong naming style.
>>> - extcon-[device name].c
>>> - extcon-gpio-usbvid.c -> extcon-dra7xx.c or etc.
>>>> Actually dra7xx is the SoC name and the USB VBUS/ID detection is not specific to SoC.
>>>> It uses gpios to detect the VBUS/ID change. So i thought it would be better to have generic
>>>> gpio based VBUS/ID detection rather than making dra7xx specific. Stephen Warren had this opinion
>>>> with patch v1.
>>> Would you guarantee that this driver support all of extcon devices using gpio pin?
>> This driver would guarantee extcon devices using gpio pins for USB VBUS and ID detection.
>> Following is the basic assumption made, correct me if I am wrong.
>> ID pin ground means -> USB-HOST is true (this happens when a device is connected to USB port and we act as HOST )
>> ID pin Float means -> USB-HOST is false (this happens when nothing is connected or when we act as a peripheral under a HOST)
>> VBUS ON means -> USB is true (this happens when we are connected under a HOST as a peripheral)
>> VBUS OFF means -> USB is false ( this happens when we are either disconnected from a HOST or when we are in HOST mode).
>>
>> So normally USB is in peripheral mode is enabled when ID pin is float and VBUS is ON.
>> and USB is in HOST mode when ID pin is ground and VBUS is OFF.
>>
>> In all above cases VBUS is referred to the external VBUS supply from an external HOST.
>>
>>> I can't agree. This driver has specific dependency on dra7x SoC.
>>>
>>> First,
>>> vbus_irq_handler() determine USB cable state according to "gpio_usbvid->vbus_gpio" state.
>>> If "gpio_usbvid->vbus_gpio" value is VBUS_OFF(0), this patch set USB cable state as 'false'
>>> But, it include potential problems. Other extcon device using gpio would set USB cable state
>>> as 'true' when gpio state is 1. This way has dependency on specific SoC.
>> no this is not SoC specific. VBUS is referred to the external VBUS supply from an external HOST.
>> so if VBUS is zero means its definitely not in connected state.
> I tested various development board based on Samsung Exynos series SoC.
> Although some gpio of Exynos series SoC set high state(non zero, 1) as default value,
> this gpio state could mean off state, disconnected or un-powered state according to gpio.
> Of course, above explanation about specific gpio don't include all gpios.
> This is meaning that there is possibility.
okay then how about adding a flag for inverted logic too.  something 
like this

if(of_property_read_bool(np,"inverted_gpio))
     gpio_usbvid->gpio_inv = 1;
And always check on this before deciding?

>>> Second,
>>> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
>>> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
>>> would not control both "USB-HOST" and "USB" cable state at same time.
>>>
>>> Other extcon devices would support either "USB-HOST" or "USB" cable.
>> The driver has 2 configurations.
>> 1) supports implementations with both VBUS and ID pin are routed via gpio's for swicthing roles(compatible  gpio-usb-vid).
> As you explained about case 1, it is only used on dra7x SoC.
No gpio-usb-id is used in dra7xx. dra7xx has got only ID pin routed via 
gpio.
> Other SoC could not wish to control both "USB-HOST" and "USB" cable at same time.
>
>
>> 2) supports implementations with only ID pin routed via gpio for swicthing roles(compatible gpio-usb-id).
>> So if you take type as VBUS_ID_DETECT then it is as what you meant.
I think i didnt explain it properly last time.
In perfect world you will have both VBUS and ID pin routed via gpios
for eg: VBUS via gpio2 and ID via gpio3. if this is the case then we 
have to use compatible gpio-usb-vid where in 2 gpios will be used
2 irq handlers will be installed and it will control both USB-HOST and 
USB cables. In this case its possible to have 3 states
USB-HOST (true), USB(true) and both false.

Now in case of dra7xx the board designers chose not to route the VBUS to 
gpio and only ID pin is routed.
But still we need to  differentiate USB-HOST and USB cables In such 
cases we use compatible gpio-usb-id where in 1 gpio will be used
1 irq handler is installed  and it will control both USB-HOST  and USB 
cables. In this case its possible to have only 2 states
USB-HOST (true) or USB(true).

Now there could be a 3rd scenario were in only VBUS is routed via gpio, 
that we would not support since we cant assume the value of ID pin
and configure the UTMI is not proper. So I have mentioned even in 
documentation that ID pin is mandatory. We can always assume role 
depending on ID pin.
> "2) case" don't support the detection of "USB-HOST" cable.
> Only detect "USB" cable according to "vbus_gpio" value.
>
> If user wish to detect only "USB-HOST" cable, should user enter "ID_DETECT" as "ti,gpio-usb-id" on DT file?
> But, id_irq_handler() control both "USB-HOST" and "USB" cable at same time. It may not prefer this method.
>
>>> Third,
>>> gpio_usbvid_probe() get both gpio_usbvid->id_irq and gpio_usbvid->vbus_irq by using DT helper function.
>>> and gpio_usbvid_request_irq() register each interrupt handler(id_irq and vbus_irq) according to DT data.
>>> In result,
>>>      id_irq_handler() would control both "USB-HOST" and "USB" cable state.
>> only if type is ID_DETECT id_irq_handler control both USB-HOST and USB cable states
>> if type is VBUS_ID_DETECT then id_irq_handler only controls USB-HOST.
> I have some confusion. I need additional your explanation.
> Could this driver register only one interrupt handler either id_irq_handler() or vbus_irq_handler()?
If compatible == ID_DETECT, only one handler --> id_irq_handler() and it 
will handle both USB and USB-HOST
> or
> Could this driver register two interrupt handler both id_irq_handler() or vbus_irq_handler()?
If compatible == VBUS_ID_DETECT, 2 handlers --> id_irq_handler() will 
handle USB-HOST and vbus_irq_handler will handle USB.
>>>      vbus_irq_handler() would control only "USB" cable state.
>>>
>>> Two interrupt handler(id_irq_handler()/vbus_irq_handler()) would control "USB" cable state
>>> according to each gpio state at same time. Also, It include critical problem.
>> No it depends on the configuration as explained above.
>>
>> [snip]
>>
>>> +
>>> +#define ID_GND        0
>>> +#define ID_FLOAT    1
>>> +#define VBUS_OFF    0
>>> +#define VBUS_ON        1
>>>>> I think you could only use two constant instead of four constant definition.
>>>> you mean only ID_GND and VBUS_OFF?
>>> you could only define two contant (0 and 1) to detect gpio state.
>> okay
>>>>>> +
>>>>>> +
>>>>> This blank line isn't necessary.
>>>>>
>>>>>> +static irqreturn_t id_irq_handler(int irq, void *data)
>>>>>> +{
>>>>>> +    struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
>>>>> You should delete blank between ')' and 'data' as follwong:
>>>>>       - (struct gpio_usbvid *)data;
>>>> okay
>>>>>> +    int id_current;
>>>>>> +
>>>>>> +    id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>>>> +    if (id_current == ID_GND) {
>>>>>> +        if (gpio_usbvid->type == ID_DETECT)
>>>>>> +            extcon_set_cable_state(&gpio_usbvid->edev,
>>>>>> +                            "USB", false);
>>>>>> +        extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>>> As else statement, you should set "USB-HOST" cable state to improve readability.
>>>>>
>>>>>           extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>>>           if (gpio_usbvid->type == ID_DETECT)
>>>>>               extcon_set_cable_state(&gpio_usbvid->edev,
>>>>>                               "USB", false);
>>>> Actually, USB-HOST state should be set in the id_irq handler. But in cases were only ID pin is routed to gpio
>>>> and VBUS is not used we set the USB state too. The gpio_usbvid->type differentiates whether its an ID only or
>>>> VBUS and ID.
>>> I don't understand. Wht does not you change the order of function call as following?
>>>
>>>      Before:
>>>              if (gpio_usbvid->type == ID_DETECT)
>>>              extcon_set_cable_state(&gpio_usbvid->edev,
>>>                                      "USB", false);
>>>          extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>> Basically these notifiers would go and change the UTMI modes which is s/w controlled.
>> so we want to gracefully exit Device mode first and then enter HOST mode.
>> this is only with type=ID_DETECT.
> Because id_irq_handler() control both "USB-HOST" and "USB" cable at same time,
> you need this setting order between "USB-HOST" and "USB" cable.
yes
> Did you think that SoC should always connect either "USB-HOST" cable or "USB" cable?
No,  even if a physical cable is not connected it should  default to 
either USB-HOST or USB

> I don't know this case except for dra7x SoC. So, I think it has dependency on specific SoC.
> and can't agree as generic extcon gpio driver.
>
>
[snip]

-- 
-George

