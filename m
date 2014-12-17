Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaLQCao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:30:44 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:45220 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaLQCam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <54908DAC.3090009@ti.com>
References: <1418378690-3466-1-git-send-email-lftan@altera.com>
	<548AFDE9.6000909@gmail.com>
	<548F4A99.7040409@ti.com>
	<CAFiDJ5-b9qsLKj8Qh2+yx8_Y1nv5CG1PHyn2Se0zzZLSHWTKNg@mail.gmail.com>
	<54908DAC.3090009@ti.com>
Date: Wed, 17 Dec 2014 10:30:41 +0800
X-Google-Sender-Auth: giREpa8jnAC7ODyJ_cvLaq1DOwg
Message-ID: <CAFiDJ58etaJxO3csGzeTYq3j0a4=e-eu4MpTn3Xd8BtJmzssNA@mail.gmail.com>
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan@altera.com>
To: Suman Anna <s-anna@ti.com>
Cc: Dinh Nguyen <dinh.linux@gmail.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 3:53 AM, Suman Anna <s-anna@ti.com> wrote:

>>> I think this logic in general will conflict between interrupt and poll
>>> mode. send_data is supposed to return -EBUSY only in polling mode and
>>> not in interrupt mode.
>> What is the recommended error code for this case? BTW, omap-mailbox.c
>> also return -EBUSY if mailbox is full.
>
> Looks like the mbox core doesn't care about the error, it's just
> checking for non-success case. I made that comment based on the
> documentation in last_tx_done. OMAP mailbox is always interrupt driven,
> and it is very rare that we will ever hit the mbox full because of the
> Tx-ready interrupt driven Tx ticker and also the h/w fifo.
>
> I see that your mailbox is very similar to OMAP mailbox though without
> the h/w fifo, but you do have support for both polling and interrupt
> modes in your code. OMAP mailbox can do that as well, but it's
> inefficient to use polling so the driver is strictly interrupt driven.
Yes, you are right. So, I think -EBUSY still can use it in interrupt case.



>>>>> +
>>>>> +    mbox->mbox_base = devm_ioremap_resource(&pdev->dev, regs);
>>>>> +    if (IS_ERR(mbox->mbox_base))
>>>>> +            return PTR_ERR(mbox->mbox_base);
>>>>> +
>>>>> +    /* Check is it a sender or receiver? */
>>>>> +    mbox->is_sender = altera_mbox_is_sender(mbox);
>>>>> +
>>>>> +    mbox->irq = platform_get_irq(pdev, 0);
>>>>> +    if (mbox->irq >= 0)
>>>>> +            mbox->intr_mode = true;
>>>
>>> This seems to be a poor way of setting up the mode. Is it the same IP
>>> block but different integration on different SoCs? Or on the same SoC,
>>> and you can use it either by interrupt driven or by polling.
>> Yes, it can use interrupt or polling mode depends on hardware configurations.
>> It is a soft IP and can be configured with different hardware configurations.
>
> OK, the platform_get_irq suggests that this decision is made by having
> or not having the interrupts property in the DT node, is that the only
> way of differentiating this mode?
Yes, we don't have other DTS property to identify the interrupt mode.

Regards
Ley Foon
