Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDOMao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:30:44 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:57392 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaDOMak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:30:40 -0400
Message-ID: <534D2671.4030101@linaro.org>
Date: Tue, 15 Apr 2014 07:30:41 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@linaro.org>
CC: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, sboyd@codeaurora.org,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ARM: add SMP support for Broadcom mobile SoCs
References: <1396577891-2713-1-git-send-email-elder@linaro.org>	<1396577891-2713-3-git-send-email-elder@linaro.org> <CAAYSxhqOh4F=vSDJYUwFE85og-Tgc9Hi8c79biEZYYjb8z1Qkg@mail.gmail.com> <533F0076.4090407@linaro.org>
In-Reply-To: <533F0076.4090407@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 01:56 PM, Alex Elder wrote:
> On 04/04/2014 10:30 AM, Tim Kryger wrote:
>> On Thu, Apr 3, 2014 at 7:18 PM, Alex Elder <elder@linaro.org> wrote:
>>
>>> diff --git a/arch/arm/mach-bcm/platsmp.c b/arch/arm/mach-bcm/platsmp.c
>>> new file mode 100644
>>> index 0000000..46a64f2
>>> --- /dev/null
>>> +++ b/arch/arm/mach-bcm/platsmp.c
>>
>>> +/* Size of mapped Cortex A9 SCU address space */
>>> +#define SCU_SIZE               0x58
>>
>>> +/*
>>> + * Enable the Cortex A9 Snoop Control Unit
>>> + *
>>> + * By the time this is called we already know there are multiple
>>> + * cores present.  We assume we're running on a Cortex A9 processor,
>>> + * so any trouble getting the base address register or getting the
>>> + * SCU base is a problem.
>>> + *
>>> + * Return 0 if successful or an error code otherwise.
>>> + */
>>> +static int __init scu_a9_enable(void)
>>> +{
>>> +       unsigned long config_base;
>>> +       void __iomem *scu_base;
>>> +
>>> +       if (!scu_a9_has_base()) {
>>> +               pr_err("no configuration base address register!\n");
>>> +               return -ENXIO;
>>> +       }
>>> +
>>> +       /* Config base address register value is zero for uniprocessor */
>>> +       config_base = scu_a9_get_base();
>>> +       if (!config_base) {
>>> +               pr_err("hardware reports only one core; disabling SMP\n");
>>> +               return -ENOENT;
>>> +       }
>>> +
>>> +       scu_base = ioremap((phys_addr_t)config_base, SCU_SIZE);
>>> +       if (!scu_base) {
>>> +               pr_err("failed to remap config base (%lu/%u) for SCU\n",
>>> +                       config_base, SCU_SIZE);
>>> +               return -ENOMEM;
>>> +       }
>>> +
>>> +       scu_enable(scu_base);
>>> +
>>> +       iounmap(scu_base);      /* That's the last we'll need of this */
>>> +
>>> +       return 0;
>>> +}
>>
>> This function seems useful for Cortex A9 MPCore in general.
>>
>> While you gave it a generic name, you put it in a Broadcom file.
>>
>> Is there a better location for this code?
> 
> I think it belongs in arch/arm/kernel/smp_scu.c.  I was thinking
> it might be generally useful when I wrote it (hence the more
> complete header comment, for example).  And I'll gladly move
> it there, I just didn't want anybody to get hung up on that.

I'm going to re-submit this series this morning.  I looked at
where this function might be used, and it looks like only one
other platform could use it (in hi3xxx_smp_prepare_cpus()).
Man of the others define get their scu base address some
other way (using a fixed constant or using device tree).

For now I'm going to keep it where it is.  If you or someone else
reiterate the suggestion I'll move it to arch/arm/kernel/smp_scu.c.

					-Alex

