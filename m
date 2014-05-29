Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaE2TpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:45:11 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44298 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaE2TpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <53875E2A.7050902@linaro.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-3-git-send-email-bjorn.andersson@sonymobile.com>
	<53875E2A.7050902@linaro.org>
Date: Thu, 29 May 2014 12:45:07 -0700
Message-ID: <CAJAp7Ogd5CCsyBhQmaDsy6SAG+YPAPzEJWP0fSKHK1kov3Z6cw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 9:19 AM, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
>> +++ b/drivers/mfd/qcom_rpm.c

[...]

>> +struct qcom_rpm {
>> +       struct device *dev;
>> +       struct completion ack;
>> +       struct mutex lock;
>> +
>> +       void __iomem *status_regs;
>> +       void __iomem *ctrl_regs;
>> +       void __iomem *req_regs;
>> +
>> +       void __iomem *ipc_rpm_reg;
>> +
>> +       u32 ack_status;
>> +
>> +       u32 version;
>> +
>> +       const struct qcom_rpm_resource *resource_table;
>> +       unsigned n_resources;
>
>
> the line spacing looks bit odd.
>

I'll fix

>> +};
>> +
>> +#define RPM_STATUS_REG(rpm, i) ((rpm)->status_regs + (i) * 4)
>> +#define RPM_CTRL_REG(rpm, i)   ((rpm)->ctrl_regs + (i) * 4)
>> +#define RPM_REQ_REG(rpm, i)    ((rpm)->req_regs + (i) * 4)
>
>
> Probably you could make these macros bit more generic by removing the rpm
> and let the calling code dereference it.
>
>

I first open coded them, I then had separate writel/readl wrappers for them and
then I settled for this, as I figured it help clarifying the code. I can have
another look at it, but I don't think that below will make things clearer.

#define RPM_IDX_2_OFFSET(i) ((i) * 4)

[...]

>> +
>> +static irqreturn_t qcom_rpm_ack_interrupt(int irq, void *dev)
>> +{
>> +       struct qcom_rpm *rpm = dev;
>> +       u32 ack;
>> +       int i;
>> +
>> +       ack = readl_relaxed(RPM_CTRL_REG(rpm, RPM_ACK_CONTEXT));
>
> /n
>

Will try it out.

>> +       for (i = 0; i < RPM_SELECT_SIZE; i++)
>> +               writel_relaxed(0, RPM_CTRL_REG(rpm, RPM_ACK_SELECTOR +
>> i));
>
>
> /n
>

Will try it out, although to me this grouping says "write all selectors and the
context".

>> +       writel(0, RPM_CTRL_REG(rpm, RPM_ACK_CONTEXT));
>> +
>> +       if (ack & RPM_NOTIFICATION) {
>> +               dev_warn(rpm->dev, "ignoring notification!\n");
>> +       } else {
>> +               rpm->ack_status = ack;
>> +               complete(&rpm->ack);
>> +       }
>> +
>> +       return IRQ_HANDLED;
>> +}

[...]

>> +static int qcom_rpm_probe(struct platform_device *pdev)
>> +{
>> +       const struct of_device_id *match;
>> +       const struct qcom_rpm *template;
>> +       struct resource *res;
>> +       struct qcom_rpm *rpm;
>> +       u32 fw_version[3];
>> +       int irq_wakeup;
>> +       int irq_ack;
>> +       int irq_err;
>> +       int ret;
>> +
>> +       rpm = devm_kzalloc(&pdev->dev, sizeof(*rpm), GFP_KERNEL);
>
>
> Sorry If I missed somthing obvious, But why not just use the structure from
> of_data. Is the global structure going to be used for something else?
>
> Or make a seperate structure for of_data and not use struct qcom_rpm?
>
>
>

Although we will not have more than one rpm in a system and therefore not
instatiate this driver multiple times I do not want to run it off the global
state.

>> +       if (!rpm) {
>> +               dev_err(&pdev->dev, "Can't allocate qcom_rpm\n");
>
> message not necessary as kernel will print the alocation failures.
>

Thanks!

>> +               return -ENOMEM;
>> +       }

[...]

>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> Should't you use the platform_get_resource_byname here?
>
> missed error case checks too.
>

This is a fairly commonly used construct, to have the error from
platform_get_resource being propagated through devm_ioremap_resource and catch
it there. It gives an extra error print in the log, but I find it very clean.

>> +       rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
>> +       rpm->ctrl_regs = rpm->status_regs + 0x400;
>> +       rpm->req_regs = rpm->status_regs + 0x600;
>> +       if (IS_ERR(rpm->status_regs))
>> +               return PTR_ERR(rpm->status_regs);
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>
> Dito.
>

[...]

>
>
> [ ..
>
>> +       ret = irq_set_irq_wake(irq_ack, 1);
>> +       if (ret)
>> +               dev_warn(&pdev->dev, "failed to mark ack irq as
>> wakeup\n");
>> +
>
> ..]
>
> Shouln't these be set as part of the pm suspend call, if the device is
> wakeup capable?
>
>

Is there any reason to toggle this?

I'm not sure when this interrupt will actually be fired, but I don't see any
harm in keeping it wakup enabled at all times.

[...]

>> +++ b/include/linux/mfd/qcom_rpm.h
>> @@ -0,0 +1,12 @@
>> +#ifndef __QCOM_RPM_H__
>> +#define __QCOM_RPM_H__
>> +
>> +#include <linux/types.h>
>> +
>> +struct device;
>> +struct qcom_rpm;
>> +
>> +struct qcom_rpm *dev_get_qcom_rpm(struct device *dev);
>> +int qcom_rpm_write(struct qcom_rpm *rpm, int resource, u32 *buf, size_t
>> count);
>
>
> IMHO, dummy functions for these are required, otherwise you would get a
> compilation errors on client drivers.
>

I didn't expect us to compile the children into a kernel that doesn't have the
rpm, as I see them as one entity. An exception would be if we want to add
COMPILE_TEST to the children, but that would require an extra change anyways.

Thanks for the review!

Regards,
Bjorn
