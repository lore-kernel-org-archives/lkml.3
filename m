Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaLPCAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:00:52 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:38112 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaLPCAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:00:50 -0500
MIME-Version: 1.0
In-Reply-To: <548EEE9F.4030508@gmail.com>
References: <CAFiDJ58uQifY7th-mzvm2mjgJdw_MWmWFFhDPYT9TomOexiVNw@mail.gmail.com>
	<548EEE9F.4030508@gmail.com>
Date: Tue, 16 Dec 2014 10:00:48 +0800
X-Google-Sender-Auth: 6lB1n_pHLlOEuO5lG4UCnO4w-uo
Message-ID: <CAFiDJ5_7u3hSAjxXOxDG_RwFOMA+bNeu8w3DYhVHUN9tC5ucsw@mail.gmail.com>
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan@altera.com>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:22 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
>
>
> On 12/15/14, 12:22 AM, Ley Foon Tan wrote:
>> On Fri, Dec 12, 2014 at 10:38 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
>>
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/device.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/io.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/mailbox_controller.h>
>>>
>>> Alphabetize the headers.
>> Okay.
>>
>>
>>>> +static int altera_mbox_startup_sender(struct mbox_chan *chan)
>>>> +{
>>>> +     int ret;
>>>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>>>> +
>>>> +     if (mbox->intr_mode) {
>>>> +             ret = request_irq(mbox->irq, altera_mbox_tx_interrupt, 0,
>>>
>>> Use devm_request_irq, since you didn't have and don't need use free_irq
>>> in the shutdown function.
>> We want to free_irq when it shutdown. That means nobody requests for
>> that mailbox (or channel) and request_irq() again if someone requests
>> for a mailbox.
>>
>
> But you didn't have any free_irq in the shutdown function. Use
> devm_request_irq here, so you don't have to add them.

Hi Dinh

free_irq() is in  altera_mbox_shutdown(). This function will be called
when user free/release the mailbox (channel).
But, devm_free_irq() only will be called when unload the module.

+static void altera_mbox_shutdown(struct mbox_chan *chan)
+{
+       struct altera_mbox *mbox = to_altera_mbox(chan);
+
+       if (WARN_ON(!mbox))
+               return;
+
+       if (mbox->intr_mode) {
+               /* Unmask all interrupt masks */
+               __raw_writel(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
+               free_irq(mbox->irq, chan);
