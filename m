Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab3HTNZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:25:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45132 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3HTNZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:25:07 -0400
Message-ID: <52136E1A.8020900@ti.com>
Date: Tue, 20 Aug 2013 18:54:42 +0530
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
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB
 ID detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com> <1376648029-30659-2-git-send-email-george.cherian@ti.com> <5212B740.2000000@samsung.com> <521338B7.7040208@ti.com> <52134513.1060304@samsung.com>
In-Reply-To: <52134513.1060304@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/2013 3:59 PM, Chanwoo Choi wrote:
> Hi George,
>
>>>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>>> new file mode 100644
>>>> index 0000000..37e4c22
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>>> @@ -0,0 +1,19 @@
>>>> +EXTCON FOR DRA7xx
>>>> +
>>>> +Required Properties:
>>>> + - compatible : Should be "ti,dra7xx-usb"
>>>> + - gpios : phandle to ID pin and interrupt gpio.
>>>> +
>>>> +Optional Properties:
>>>> +  - interrupt-parent : interrupt controller phandle
>>>> +  - interrupts : interrupt number
>>>> +
>>>> +
>>>> +dra7x_extcon1 {
>>> You used 'dra7xx-usb' device name. Why did you use 'dra7x_extcon1' name?
>>> What is meaning 'dra7x_extcon1'?
>> I will rename it to  dra7xx_extcon.
> extcon naming means various external connector device. e.g., usb, jack, etc...
> So, I prefer 'dra7xx_usb' instead of 'dra7xx_extcon'. I have plan to divide
> extcon device driver according to the kind of device.

okay will do it in v2
>
>
>>>> +static int id_poll_func(void *data)
>>>> +{
>>>> +    struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
>>>> +
>>>> +    allow_signal(SIGINT);
>>>> +    allow_signal(SIGTERM);
>>>> +    allow_signal(SIGKILL);
>>>> +    allow_signal(SIGUSR1);
>>>> +
>>>> +    set_freezable();
>>>> +
>>>> +    while (!kthread_should_stop()) {
>>>> +        dra7xx_usb->id_current = gpio_get_value_cansleep
>>>> +                        (dra7xx_usb->id_gpio);
>>>> +        if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
>>>> +            schedule_timeout_interruptible
>>>> +                        (msecs_to_jiffies(2*1000));
>>>> +            continue;
>>>> +        } else if (dra7xx_usb->id_current == 0) {
>>>> +            extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
>>>> +            extcon_set_cable_state(&dra7xx_usb->edev,
>>>> +                        "USB-HOST", true);
>>>> +        } else {
>>>> +            extcon_set_cable_state(&dra7xx_usb->edev,
>>>> +                        "USB-HOST", false);
>>>> +            extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
>>>> +        }
>>> Should dra7xx_usb keep always connected state with either USB or USB-HOST cable?
>>> I don't understand. So please explain detailed operation method of dra7xx_usb device.
>> In dra7xx only ID pin is connected to the SoC gpio. There is no way, currently to detect the VBUS on/off.
>> So I always default to either HOST/DEVICE mode solely depending on the ID pin value.
> OK.
>
> But I don't want to use kthread with polling method.
> I recommend that you use interrupt method for cable detection.
> All of extcon device driver have only used interrupt method without polling.

okay will remove the polling thread.
>
>>>> +        dra7xx_usb->id_prev = dra7xx_usb->id_current;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static irqreturn_t id_irq_handler(int irq, void *data)
>>>> +{
>>>> +    struct dra7xx_usb *dra7xx_usb = (struct dra7xx_usb *) data;
>>>> +
>>>> +    dra7xx_usb->id_current = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
>>>> +
>>>> +    if (dra7xx_usb->id_current == dra7xx_usb->id_prev) {
>>>> +        return IRQ_NONE;
>>>> +    } else if (dra7xx_usb->id_current == 0) {
> You should define some constant variable to clarify '0' meaning instead of using '0' directly.

okay
>
>>>> +    dra7xx_usb = devm_kzalloc(&pdev->dev, sizeof(*dra7xx_usb), GFP_KERNEL);
>>>> +    if (!dra7xx_usb)
>>>> +        return -ENOMEM;
>>> You have to add error message with dev_err().
>> devm_kzalloc itself should give some message.
> ok.
>
>
>>>> +    status = extcon_dev_register(&dra7xx_usb->edev, dra7xx_usb->dev);
>>>> +    if (status) {
>>>> +        dev_err(&pdev->dev, "failed to register extcon device\n");
>>>> +        return status;
>>> You should restore previous operation about dra7xx_usb->irq_gpio.
>> okay
>>>> +    }
>>>> +
>>>> +    dra7xx_usb->id_prev = gpio_get_value_cansleep(dra7xx_usb->id_gpio);
>>>> +    if (dra7xx_usb->id_prev) {
> ditto.
> You should define some constant variable to clarify 'dra7xx_usb->id_prev' meaning.

okay
>
>>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", false);
>>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB", true);
>>>> +    } else {
>>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB", false);
>>>> +        extcon_set_cable_state(&dra7xx_usb->edev, "USB-HOST", true);
>>>> +    }
>>> why did you do keep always connected state?
>> There is no way, currently to detect the VBUS on/off.
>> So I always default to either HOST/DEVICE mode solely depending on the ID pin value.
>>
>>>> +
>>>> +    if (dra7xx_usb->irq_gpio) {
>>>> +        status = devm_request_threaded_irq(dra7xx_usb->dev, irq_num,
>>>> +                NULL, id_irq_handler, IRQF_SHARED |
>>>> +                IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
>>>> +                dev_name(&pdev->dev), (void *) dra7xx_usb);
>>>> +        if (status)
>>>> +            dev_err(dra7xx_usb->dev, "failed to request irq #%d\n",
>>>> +                        irq_num);
>>> If devm_request_threaded_irq() return fail state, why did not you do add error exception?
>> If interrupt fails I fallback to polling thread.
>>>> +        else
>>>> +            return 0;
>>> If devm_request_threaded_irq() return success state, why did you directly call 'return'?
>>> kthread_create operation isn't necessary?
>> Yes kthread is optional. Some boards doenot have the ID pin hooked onto the GPIO.
>> In such cases we will run the kthread and poll on the ID pin values.
>>>> +    }
>>>> +
>>>> +    dra7xx_usb->thread_task = kthread_create(id_poll_func, dra7xx_usb,
>>>> +                         dev_name(&pdev->dev));
>>> Should you use polling method with kthread? I think it isn't proper method.
>>> You did get the irq number by using DT helper function and register irq handler
>>> with devm_request_threaded_irq(). I prefer interrupt method for detection of cable state.
>> I also prefer interrupt method. If any implementation does not have ID pin connected to GPIOs then still
>> it could use the driver in polling mode.
> As I mentioned above, I don't prefer interrupt method for cable detection.

I hope you meant, you prefer interrupt method for cable detection over 
polling .
> Polling method for detection isn't appropriate for extcon device driver.
>
> Instead, I will consider whether to support polling method or not on extcon core.
>
> Thanks,
> Chanwoo Choi
>
>

-- 
-George

