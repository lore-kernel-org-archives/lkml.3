Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaDDS40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:56:26 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:64367 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaDDS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:56:24 -0400
Message-ID: <533F0076.4090407@linaro.org>
Date: Fri, 04 Apr 2014 13:56:54 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
References: <1396577891-2713-1-git-send-email-elder@linaro.org>	<1396577891-2713-3-git-send-email-elder@linaro.org> <CAAYSxhqOh4F=vSDJYUwFE85og-Tgc9Hi8c79biEZYYjb8z1Qkg@mail.gmail.com>
In-Reply-To: <CAAYSxhqOh4F=vSDJYUwFE85og-Tgc9Hi8c79biEZYYjb8z1Qkg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 10:30 AM, Tim Kryger wrote:
> On Thu, Apr 3, 2014 at 7:18 PM, Alex Elder <elder@linaro.org> wrote:
> 
>> diff --git a/arch/arm/mach-bcm/platsmp.c b/arch/arm/mach-bcm/platsmp.c
>> new file mode 100644
>> index 0000000..46a64f2
>> --- /dev/null
>> +++ b/arch/arm/mach-bcm/platsmp.c
> 
>> +/* Size of mapped Cortex A9 SCU address space */
>> +#define SCU_SIZE               0x58
> 
>> +/*
>> + * Enable the Cortex A9 Snoop Control Unit
>> + *
>> + * By the time this is called we already know there are multiple
>> + * cores present.  We assume we're running on a Cortex A9 processor,
>> + * so any trouble getting the base address register or getting the
>> + * SCU base is a problem.
>> + *
>> + * Return 0 if successful or an error code otherwise.
>> + */
>> +static int __init scu_a9_enable(void)
>> +{
>> +       unsigned long config_base;
>> +       void __iomem *scu_base;
>> +
>> +       if (!scu_a9_has_base()) {
>> +               pr_err("no configuration base address register!\n");
>> +               return -ENXIO;
>> +       }
>> +
>> +       /* Config base address register value is zero for uniprocessor */
>> +       config_base = scu_a9_get_base();
>> +       if (!config_base) {
>> +               pr_err("hardware reports only one core; disabling SMP\n");
>> +               return -ENOENT;
>> +       }
>> +
>> +       scu_base = ioremap((phys_addr_t)config_base, SCU_SIZE);
>> +       if (!scu_base) {
>> +               pr_err("failed to remap config base (%lu/%u) for SCU\n",
>> +                       config_base, SCU_SIZE);
>> +               return -ENOMEM;
>> +       }
>> +
>> +       scu_enable(scu_base);
>> +
>> +       iounmap(scu_base);      /* That's the last we'll need of this */
>> +
>> +       return 0;
>> +}
> 
> This function seems useful for Cortex A9 MPCore in general.
> 
> While you gave it a generic name, you put it in a Broadcom file.
> 
> Is there a better location for this code?

I think it belongs in arch/arm/kernel/smp_scu.c.  I was thinking
it might be generally useful when I wrote it (hence the more
complete header comment, for example).  And I'll gladly move
it there, I just didn't want anybody to get hung up on that.

					-Alex


