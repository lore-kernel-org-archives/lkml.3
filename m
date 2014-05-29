Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaE2VlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:41:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39745 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaE2VlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:41:06 -0400
Message-ID: <5387A96C.6080404@linaro.org>
Date: Thu, 29 May 2014 22:41:00 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>	<1401211721-19712-3-git-send-email-bjorn.andersson@sonymobile.com>	<53875E2A.7050902@linaro.org> <CAJAp7Ogd5CCsyBhQmaDsy6SAG+YPAPzEJWP0fSKHK1kov3Z6cw@mail.gmail.com>
In-Reply-To: <CAJAp7Ogd5CCsyBhQmaDsy6SAG+YPAPzEJWP0fSKHK1kov3Z6cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/05/14 20:45, Bjorn Andersson wrote:
> On Thu, May 29, 2014 at 9:19 AM, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>>> +++ b/drivers/mfd/qcom_rpm.c
>
>> the line spacing looks bit odd.
>>
>
> I'll fix
>
>>> +};
>>> +
>>> +#define RPM_STATUS_REG(rpm, i) ((rpm)->status_regs + (i) * 4)
>>> +#define RPM_CTRL_REG(rpm, i)   ((rpm)->ctrl_regs + (i) * 4)
>>> +#define RPM_REQ_REG(rpm, i)    ((rpm)->req_regs + (i) * 4)
>>
>>
>> Probably you could make these macros bit more generic by removing the rpm
>> and let the calling code dereference it.
>>
>>
>
> I first open coded them, I then had separate writel/readl wrappers for them and
> then I settled for this, as I figured it help clarifying the code. I can have
> another look at it, but I don't think that below will make things clearer.
>
> #define RPM_IDX_2_OFFSET(i) ((i) * 4)
>

Yes, just leave it as it is.
> [...]
>
>>
>>> +static int qcom_rpm_probe(struct platform_device *pdev)
>>> +{
>>> +       const struct of_device_id *match;
>>> +       const struct qcom_rpm *template;
>>> +       struct resource *res;
>>> +       struct qcom_rpm *rpm;
>>> +       u32 fw_version[3];
>>> +       int irq_wakeup;
>>> +       int irq_ack;
>>> +       int irq_err;
>>> +       int ret;
>>> +
>>> +       rpm = devm_kzalloc(&pdev->dev, sizeof(*rpm), GFP_KERNEL);
>>
>>
>> Sorry If I missed somthing obvious, But why not just use the structure from
>> of_data. Is the global structure going to be used for something else?
>>
>> Or make a seperate structure for of_data and not use struct qcom_rpm?
>>
>>
>>
>
> Although we will not have more than one rpm in a system and therefore not
> instatiate this driver multiple times I do not want to run it off the global
> state.
>
I agree.

Why not make a separate data structure for the qcom_of_data?

>>> +       if (!rpm) {
>>> +               dev_err(&pdev->dev, "Can't allocate qcom_rpm\n");
>>
>> message not necessary as kernel will print the alocation failures.
>>
>
> Thanks!
>
>>> +               return -ENOMEM;
>>> +       }
>
> [...]
>
>>> +
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>
>> Should't you use the platform_get_resource_byname here?
>>
>> missed error case checks too.
>>
>
> This is a fairly commonly used construct, to have the error from
> platform_get_resource being propagated through devm_ioremap_resource and catch
> it there. It gives an extra error print in the log, but I find it very clean.
Sorry I missed that point...


But my point on platform_get_resource_byname is to remove the dependency 
on the resource ordering, It is very difficult to catch errors resulting 
in wrong ordered resources in DT.

>
>>> +       rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
>>> +       rpm->ctrl_regs = rpm->status_regs + 0x400;
>>> +       rpm->req_regs = rpm->status_regs + 0x600;
>>> +       if (IS_ERR(rpm->status_regs))
>>> +               return PTR_ERR(rpm->status_regs);
>>> +
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>>
>> Dito.
>>
>
> [...]
>
>>
>>
>> [ ..
>>
>>> +       ret = irq_set_irq_wake(irq_ack, 1);
>>> +       if (ret)
>>> +               dev_warn(&pdev->dev, "failed to mark ack irq as
>>> wakeup\n");
>>> +
>>
>> ..]
>>
>> Shouln't these be set as part of the pm suspend call, if the device is
>> wakeup capable?
>>
>>
>
> Is there any reason to toggle this?
>
> I'm not sure when this interrupt will actually be fired, but I don't see any
> harm in keeping it wakup enabled at all times.

Typically the wake-up source is driven/enabled by the user. When the 
system goes to low-power state it would enable the wakeup on the irq. 
And when there is an interrupt it would wake up the system as part of 
resuming from low-power state.

Again if you what this interrupt to wakeup the system, I would expect 
pm_wakeup_event/related calls in the interrupt handler too.

>
> [...]
>
>>> +++ b/include/linux/mfd/qcom_rpm.h
>>> @@ -0,0 +1,12 @@
>>> +#ifndef __QCOM_RPM_H__
>>> +#define __QCOM_RPM_H__
>>> +
>>> +#include <linux/types.h>
>>> +
>>> +struct device;
>>> +struct qcom_rpm;
>>> +
>>> +struct qcom_rpm *dev_get_qcom_rpm(struct device *dev);
>>> +int qcom_rpm_write(struct qcom_rpm *rpm, int resource, u32 *buf, size_t
>>> count);
>>
>>
>> IMHO, dummy functions for these are required, otherwise you would get a
>> compilation errors on client drivers.
>>
>
> I didn't expect us to compile the children into a kernel that doesn't have the
> rpm, as I see them as one entity. An exception would be if we want to add
> COMPILE_TEST to the children, but that would require an extra change anyways.
>
> Thanks for the review!
>
NP,

Thanks,
srini

> Regards,
> Bjorn
>
