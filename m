Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3H2Npd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:45:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab3H2Npa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:45:30 -0400
Message-ID: <521F505E.8090607@ti.com>
Date: Thu, 29 Aug 2013 19:15:02 +0530
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
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-2-git-send-email-george.cherian@ti.com> <521EA563.4060305@samsung.com> <521EB018.3000301@ti.com> <521EE8FC.80802@samsung.com> <521EF88F.4070402@ti.com> <521F245E.8050506@samsung.com> <521F3515.7040001@ti.com> <521F3AA2.9010707@samsung.com>
In-Reply-To: <521F3AA2.9010707@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,


On 8/29/2013 5:42 PM, Chanwoo Choi wrote:
[big snip ]
>>> I tested various development board based on Samsung Exynos series SoC.
>>> Although some gpio of Exynos series SoC set high state(non zero, 1) as default value,
>>> this gpio state could mean off state, disconnected or un-powered state according to gpio.
>>> Of course, above explanation about specific gpio don't include all gpios.
>>> This is meaning that there is possibility.
>> okay then how about adding a flag for inverted logic too.  something like this
>>
>> if(of_property_read_bool(np,"inverted_gpio))
>>      gpio_usbvid->gpio_inv = 1;
>> And always check on this before deciding?
Is this fine ?
>>
>>>>> Second,
>>>>> gpio_usbvid_set_initial_state() dertermine both "USB-HOST" and "USB" cable state at same time
>>>>> in 'case ID_DETCT' according to 'gpio_usbvid->id_gpio'. But, I think that other extcon devices
>>>>> would not control both "USB-HOST" and "USB" cable state at same time.
>>>>>
>>>>> Other extcon devices would support either "USB-HOST" or "USB" cable.
>>>> The driver has 2 configurations.
>>>> 1) supports implementations with both VBUS and ID pin are routed via gpio's for swicthing roles(compatible  gpio-usb-vid).
>>> As you explained about case 1, it is only used on dra7x SoC.
>> No gpio-usb-id is used in dra7xx. dra7xx has got only ID pin routed via gpio.
>>> Other SoC could not wish to control both "USB-HOST" and "USB" cable at same time.
I could'nt actually parse this. You meant since the id_irq_handler 
handles both USB and USB-HOST cable
its not proper?
> I need your answer about above my opinion for other SoC.
So how about this, I have removed the dra7x specific stuffs (gpio-usb-id)

static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
{
         int id_current, vbus_current;

     id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
     if (!!id_current == ID_FLOAT)
         extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
     else
         extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);

     vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
      if (!!vbus_current == VBUS_ON)
         extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
     else
         extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
}

and the irq handlers like this

static irqreturn_t id_irq_handler(int irq, void *data)
{
         struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
         int id_current;

         id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
         if (id_current == ID_GND)
                 extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", 
true);
         else
                 extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", 
false);
         return IRQ_HANDLED;
}

static irqreturn_t vbus_irq_handler(int irq, void *data)
{
         struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *)data;
         int vbus_current;

         vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
         if (vbus_current == VBUS_OFF)
                 extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
         else
                 extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);

         return IRQ_HANDLED;
}
[snip]
>>> I have some confusion. I need additional your explanation.
>>> Could this driver register only one interrupt handler either id_irq_handler() or vbus_irq_handler()?
>> If compatible == ID_DETECT, only one handler --> id_irq_handler() and it will handle both USB and USB-HOST
>>> or
>>> Could this driver register two interrupt handler both id_irq_handler() or vbus_irq_handler()?
>> If compatible == VBUS_ID_DETECT, 2 handlers --> id_irq_handler() will handle USB-HOST and vbus_irq_handler will handle USB.
> As you mentioned, we cannot only control either USB or USB-HOST cable on this extcon driver.
> This extcon driver is only suitable dra7x SoC.
Do you still feel its dra7x specific if i modify it as above?
> Because id_irq_handler() control both "USB-HOST" and "USB" cable at same time,
> you need this setting order between "USB-HOST" and "USB" cable.
>> yes
> I think that the setting order between cables isn't general. It is specific method for dra7x SoC.
So if i remove that part then?
>>> Did you think that SoC should always connect either "USB-HOST" cable or "USB" cable?
>> No,  even if a physical cable is not connected it should  default to either USB-HOST or USB
> It isn't general.
>
> If physical cable isn't connected to extcon device, the state both USB-HOST and USB cable
> should certainly be zero. Because The extcon consumer driver could set proper operation
> according to cable state.
okay
>
>>
>>> I don't know this case except for dra7x SoC. So, I think it has dependency on specific SoC.
> I need your answer about above my opinion.
Hope i could answer you :-)
>>> and can't agree as generic extcon gpio driver.
>

-- 
-George

