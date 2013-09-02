Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3IBCBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:01:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51156 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab3IBCB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:01:29 -0400
Message-ID: <5223F160.6030006@ti.com>
Date: Mon, 2 Sep 2013 07:31:04 +0530
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
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-2-git-send-email-george.cherian@ti.com> <521EA563.4060305@samsung.com> <521EB018.3000301@ti.com> <521EE8FC.80802@samsung.com> <521EF88F.4070402@ti.com> <521F245E.8050506@samsung.com> <521F3515.7040001@ti.com> <521F3AA2.9010707@samsung.com> <521F505E.8090607@ti.com> <521FE31D.8050902@samsung.com> <52203872.2050304@ti.com> <52204641.3020203@samsung.com>
In-Reply-To: <52204641.3020203@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/2013 12:44 PM, Chanwoo Choi wrote:
> Hi George,
>
> In addition, I add answer about that device driver control gpio pin directly.
>
> On 08/30/2013 03:15 PM, George Cherian wrote:
>> Hi Chanwoo,
>>
>> On 8/30/2013 5:41 AM, Chanwoo Choi wrote:
>>> Hi George,
>>>
>>> On 08/29/2013 10:45 PM, George Cherian wrote:
>>>> Hi Chanwoo,
>>>>
>>>>
>>>> On 8/29/2013 5:42 PM, Chanwoo Choi wrote:
>>>> [big snip ]
>>>>>>> I tested various development board based on Samsung Exynos series SoC.
>>>>>>> Although some gpio of Exynos series SoC set high state(non zero, 1) as default value,
>>>>>>> this gpio state could mean off state, disconnected or un-powered state according to gpio.
>>>>>>> Of course, above explanation about specific gpio don't include all gpios.
>>>>>>> This is meaning that there is possibility.
>>>>>> okay then how about adding a flag for inverted logic too.  something like this
>>>>>>
>>>>>> if(of_property_read_bool(np,"inverted_gpio))
>>>>>>        gpio_usbvid->gpio_inv = 1;
>>>>>> And always check on this before deciding?
>>>> Is this fine ?
>>> OK.
>>> But, as Stephen commented on other mail, you should use proper DT helper function.
>> okay
>>>>>>>>> Second,
>>>>>>>>> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
>>>>>>>>> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
>>>>>>>>> would not control both "USB-HOST" and "USB" cable state at same time.
>>>>>>>>>
>>>>>>>>> Other extcon devices would support either "USB-HOST" or "USB" cable.
>>>>>>>> The driver has 2 configurations.
>>>>>>>> 1) supports implementations with both VBUS and ID pin are routed via gpio's for swicthing roles(compatible  gpio-usb-vid).
>>>>>>> As you explained about case 1, it is only used on dra7x SoC.
>>>>>> No gpio-usb-id is used in dra7xx. dra7xx has got only ID pin routed via gpio.
>>>>>>> Other SoC could not wish to control both "USB-HOST" and "USB" cable at same time.
>>>> I could'nt actually parse this. You meant since the id_irq_handler handles both USB and USB-HOST cable
>>>> its not proper?
>>> It's not proper in general case. The generic driver must guarantee all of extcon device using gpio.
>>> As far as I know, the generic driver cannot direclty control gpio pin and get value from gpio pin.
>>> Almost device driver including in kernel/drivers control gpio pin on specific device driver
>>> instead of generic driver.
>> But without reading the gpio value how can we set the cable states?
> hmm. I mentioned above my answer as following:
> 	>> As far as I know, the generic driver cannot direclty control gpio pin and get value from gpio pin.
> 	>> Almost device driver including in kernel/drivers control gpio pin on specific device driver
> Because your extcon driver directly control gpio pin so I think your extcon driver isn't generic.
>
> for this driver the assumption is the dedicated gpio
Obviously when I am writing a generic driver for USB VBUS-ID detetction 
which is via gpio then i assume I have a dedicated gpio.
what is wrong in that assumption? How else can you detect ID pin change 
and VBUS change via gpio if not you have them dedicated?
>> is always DIR_IN and in the driver we just read the value.
> What is DIR_IN?
Direction IN gpio.
>>>>> I need your answer about above my opinion for other SoC.
>>>> So how about this, I have removed the dra7x specific stuffs (gpio-usb-id)
>>>>
>>>> static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
>>>> {
>>>>           int id_current, vbus_current;
>>>>
>>>>       id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>>       if (!!id_current == ID_FLOAT)
>>>>           extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>>>       else
>>>>           extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>>
>>>>       vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>>>        if (!!vbus_current == VBUS_ON)
>>>>           extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
>>>>       else
>>>>           extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>>> }
>>>>
>>>> and the irq handlers like this
>>>>
>>>> static irqreturn_t id_irq_handler(int irq, void *data)
>>>> {
>>>>           struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>>>>           int id_current;
>>>>
>>>>           id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
>>>>           if (id_current == ID_GND)
>>>>                   extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
>>>>           else
>>>>                   extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
>>>>           return IRQ_HANDLED;
>>>> }
>>>>
>>>> static irqreturn_t vbus_irq_handler(int irq, void *data)
>>>> {
>>>>           struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
>>>>           int vbus_current;
>>>>
>>>>           vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
>>>>           if (vbus_current == VBUS_OFF)
>>>>                   extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
>>>>           else
>>>>                   extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
>>>>
>>>>           return IRQ_HANDLED;
>>>> }
>>> I know your intention dividing interrupt handler for each cable.
>>> But I don't think this driver must guarantee all of extcon device using gpio.
>>>
>>> For example,
>>> below three SoC wish to detect USB/USB-HOST cable with each different methods.
>>>
>>> "SoC A" wish to detect USB/USB-HOST cable through only one gpio pin.
>> You mean to say that both USB ID pin and VBUS are connected to same gpio?
>> If so that is a really bad h/w design and it will not fly.
>> Or, you meant that only USB ID pin is connected to single gpio and it controls the state of the USB/USB-HOST cables?
>> If so thats what exactly the v3 driver did with compatible gpio-usb-id.
>>
>>> "SoC B" wish to detect USB/USB-HOST cable through ADC value instead of gpio pin.
>> Via ADC this driver should never be used , it should be extcon-adc-usbvid driver and not extcon-gpio-usbvid driver.
>>> "SoC C" wish to detect USB/USB-HOST cable through two gpio pin because USB connected on gpio an USB-HOST connected on another.
>> Whatever modifications above should meet this need  in combination with named gpios (id_gpio and vbus_gpio in dt)as stephen pointed.
>> But still i feel the above modification would even support Soc A provided the code registered for the notifier could handle it properly.
>>> In addition,
>>> if "SoC A/C" wish to write some data to own specific registers for proper opeating,
>>> Could we write some data to register on generic driver?
>> Yes definitely, those register configuration should not be part of this driver and it should be done in the notifier handler.
>>> Finally,
>>> "SoC D" wish to detect USB/USB-HOST/JIG cable through two gpio pin
>> Correct me If I am wrong, USB JIG is not a standard cable. so for supporting that anyways you need to have
>> a different driver.
>>> - one gpio may detect either USB or USB-HOST and another may detect JIG cable
>> I assume u meant the USB ID pin is connected to one gpio and based on it value USB/USB-HOST  is detected.
>>> or one gpio may detect either USb or JIG and another may detect USB-HOST cable.
>>   As I mentioned earlier these are gpios configured as input and if you try to drive with 2 sources (USB and JIG or USB and USB-HOST etc)
>> then its a potentially bad design . If at all we need to identify all 3 then there should be 3 dedicated gpios.
>>
>>> That way, there are many cases we cannot guarantee all of extcon devices.
>>>
>>> I think this driver could support dra7x series SoC but as I mentioned,
>>> this driver may not guarantee all of cases.
>> I am sorry, I feel it supports all standard cases except for something like a JIG cable which is not standard.
>>>> [snip]
>>>>>>> I have some confusion. I need additional your explanation.
>>>>>>> Could this driver register only one interrupt handler either id_irq_handler() or vbus_irq_handler()?
>>>>>> If compatible == ID_DETECT, only one handler --> id_irq_handler() and it will handle both USB and USB-HOST
>>>>>>> or
>>>>>>> Could this driver register two interrupt handler both id_irq_handler() or vbus_irq_handler()?
>>>>>> If compatible == VBUS_ID_DETECT, 2 handlers --> id_irq_handler() will handle USB-HOST and vbus_irq_handler will handle USB.
>>>>> As you mentioned, we cannot only control either USB or USB-HOST cable on this extcon driver.
>>>>> This extcon driver is only suitable dra7x SoC.
>>>> Do you still feel its dra7x specific if i modify it as above?
>>> I commented above about your modification.
>>>
>>>>> Because id_irq_handler() control both "USB-HOST" and "USB" cable at same time,
>>>>> you need this setting order between "USB-HOST" and "USB" cable.
>>>>>> yes
>>>>> I think that the setting order between cables isn't general. It is specific method for dra7x SoC.
>>>> So if i remove that part then?
>>> The setting order should be removed in generic driver.
>> Yes I agree and should be done by the subscriber to the notifier.
>>>>>>> Did you think that SoC should always connect either "USB-HOST" cable or "USB" cable?
>>>>>> No,  even if a physical cable is not connected it should  default to either USB-HOST or USB
>>>>> It isn't general.
>>>>>
>>>>> If physical cable isn't connected to extcon device, the state both USB-HOST and USB cable
>>>>> should certainly be zero. Because The extcon consumer driver could set proper operation
>>>>> according to cable state.
>>>> okay
>>>>>>> I don't know this case except for dra7x SoC. So, I think it has dependency on specific SoC.
>>>>> I need your answer about above my opinion.
>>>> Hope i could answer you :-)
>>>>>>> and can't agree as generic extcon gpio driver.
>>> Thanks,
>>> Chanwoo Choi
>>
> Thanks,
> Chanwoo Choi
>


-- 
-George

