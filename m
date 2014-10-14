Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaJNHWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:22:55 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:43125 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaJNHWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:22:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhJPsW+h9DEEEKfhBdz3e4tTxmA_ZBR6SbLr2jY6XJY7pMHhA@mail.gmail.com>
References: <CAJhJPsW+h9DEEEKfhBdz3e4tTxmA_ZBR6SbLr2jY6XJY7pMHhA@mail.gmail.com>
Date: Tue, 14 Oct 2014 12:52:53 +0530
Message-ID: <CAKohpomcJM53bnRA7ef-+61KHq0DxTZ=Lf3oEUWejif5X+g_2Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2014 12:29, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
>
> 2014-10-10 12:40 GMT+08:00 Viresh Kumar <viresh.kumar@linaro.org>:

>> > +#include <cpufreq.h>
>> > +#include <loongson1.h>
>>
>> Okay, it looks like I have forgotten some of the C basics :)
>> But wouldn't the above two lines search for this file in <include/*>, unless
>> you have compiled it with something like -I include/linux ??
>> And even then I don't think loongson1.h is present there ..
>>
>> What am I missing ?
>
>
> The two header files are located in arch/mips/include/asm/mach-loongson1

Okay, but I didn't knew it works this way as well. I thought preprocessor will
search in include/ and arch/mips/include/ directories only and so you need to
do this:

#include <asm/mach-loongson1/cpufreq.h>

Do you know why it works directly in your case? Probably for readability above
might be better ?

>> > +static int ls1x_cpufreq_notifier(struct notifier_block *nb,
>> > +                                unsigned long val, void *data)
>> > +{
>> > +       if (val == CPUFREQ_POSTCHANGE)
>> > +               current_cpu_data.udelay_val = loops_per_jiffy;
>> > +
>> > +       return NOTIFY_OK;
>> > +}
>>
>> Why don't you do this at a single place in mips core instead of every
>> mips cpufreq driver ?
>
>
> Most of MIPS CPUs use performance counter as the system timer, which is built-in to the CPU core. They can't do cpufreq due to lack of external timer. Therefore, the above section is not a common code.

Not sure if I understood your reply Or you understood mine :)
Let me try again to clarify the question. On freq change you need
to update 'current_cpu_data.udelay_val', this is done in both
loongson drivers.

What I was asking you is to register the notifier in some core code,
so that this isn't required to be done in all cpufreq drivers.

NOTE: The notifier routine will only be called if cpufreq is enabled
for the platform..

>> > +static int ls1x_cpufreq_probe(struct platform_device *pdev)
>> > +{
>> > +       struct plat_ls1x_cpufreq *pdata = pdev->dev.platform_data;
>> > +       struct clk *clk;
>> > +       int ret;
>> > +
>>
>> Try this code here:
>>
>> pdata = NULL;
>>
>> > +       if (!pdata && !pdata->clk_name && !pdata->osc_clk_name) {
>>
>> And tell me what happens here then. :)
>
>
> I will add an error message here.

Did you try what I asked you to? I wasn't talking about the message..
Though you better add it as well..

What I have asked you will result in kernel crash ..
