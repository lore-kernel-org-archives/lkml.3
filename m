Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3LWHgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:36:41 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41335 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWHgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:36:39 -0500
MIME-Version: 1.0
In-Reply-To: <52B7D990.2020206@samsung.com>
References: <1387526987-12455-1-git-send-email-rongjun.ying@csr.com>
 <52B7B9F0.1020801@samsung.com> <CAGsJ_4xwc63kEBgmMk+E3JpYLhX0Vt1qQPcBXNtOGC2Gmo=MOw@mail.gmail.com>
 <52B7D990.2020206@samsung.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 23 Dec 2013 15:36:19 +0800
Message-ID: <CAGsJ_4wbYkadoM5HHwbGUcwuimxiq-u9FMaWMs7wD-SXU4ybcQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] extcon: gpio: Add power resume support
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjying <rjying@gmail.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RongJun Ying <Rongjun.Ying@csr.com>,
        Binghua Duan <Binghua.Duan@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
> On 12/23/2013 03:10 PM, Barry Song wrote:
>> 2013/12/23 Chanwoo Choi <cw00.choi@samsung.com>:
>>> On 12/20/2013 05:09 PM, rjying wrote:
>>>> From: Rongjun Ying <rongjun.ying@csr.com>
>>>>
>>>> After system resume, need send extcon uevent to userspace
>>>
>>> Why did extcon send uevent after wakeup from suspend?
>>>
>>> If extcon cable is attatched or detached on suspend state,
>>> Kernel can detect the interrupt about changed state of extcon.
>>
>> irq controller has lost power in suspend, so there is no pending interrupt.
>> and HW will not pend any interrupt when we hotplug cable during sleep.
>
> No, SoC in suspend state must maintain the minimum power under 1mA
> if completed the power-optimization on suspend state.
>
> If user insert USB cable to target, the external interrupt connected to
> USB port is happened. And kernel would be waked up from suspend state
> to operate proper interrupt handler of external interrupt.

no. not every USB supports that. that depends on the power domain design of SoC.

>
> Also,
> Input subsystem used gpio-keys driver for power button..
> If user press power button in suspend state, target would be waked up from suspend state.
> It is same case both extcon gpio and gpio-keys of input subsystem.

no. it depends on the SoC design. many SoC only support 1 special key
which can work as ON-KEY as wakeup source. and this kind of keys might
not be GPIO at all.
there is a special power domain which is still open for it.

>
>>
>>> So, kernel would execute proper operation about interrupt
>>> after wakeup from suspend state.
>>
>> kernel only save/restore the register status of gpio, how could it
>> know whether there is a pending interrupt if the HW doesn't do it?
>>
>>>
>>> I think it isn't necessary.
>>>
>>> Thanks,
>>> Chanwoo Choi
>>>
>>>>
>>>> Change-Id: I32a9e1c6646035f95765bba79a7acaccb8ce45a7
>>>>
>>>> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
>>>> ---
>>>>  drivers/extcon/extcon-gpio.c |   17 +++++++++++++++++
>>>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>>>> index 7e0dff5..d916522 100644
>>>> --- a/drivers/extcon/extcon-gpio.c
>>>> +++ b/drivers/extcon/extcon-gpio.c
>>>> @@ -159,12 +159,29 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>>>>       return 0;
>>>>  }
>>>>
>>>> +#ifdef CONFIG_PM_SLEEP
>>>> +static int gpio_extcon_resume(struct device *dev)
>>>> +{
>>>> +     struct gpio_extcon_data *extcon_data;
>>>> +
>>>> +     extcon_data = dev_get_drvdata(dev);
>>>> +     queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
>>>> +                           extcon_data->debounce_jiffies);
>>>> +     return 0;
>>>> +}
>>>> +#endif
>>>> +
>>>> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
>>>> +     SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
>>>> +};
>>>> +
>>>>  static struct platform_driver gpio_extcon_driver = {
>>>>       .probe          = gpio_extcon_probe,
>>>>       .remove         = gpio_extcon_remove,
>>>>       .driver         = {
>>>>               .name   = "extcon-gpio",
>>>>               .owner  = THIS_MODULE,
>>>> +             .pm = &gpio_extcon_pm_ops,
>>>>       },
>>>>  };
>>>>
>>>>
>>>
>>
>> -barry

-barry
