Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaIEVCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:02:41 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36425 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaIEVCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1409052051240.5472@nanos>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
	<1409938218-9026-2-git-send-email-abrestic@chromium.org>
	<alpine.DEB.2.10.1409052051240.5472@nanos>
Date: Fri, 5 Sep 2014 14:02:38 -0700
X-Google-Sender-Auth: 67k7QKQ6EBz33I-QO04y6ucKRcc
Message-ID: <CAL1qeaFDBU6bB-OmSW8DqMWGtpNDL9H-WB6F0ZBg7hEz6c1vBQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] MIPS: Provide a generic plat_irq_dispatch
From: Andrew Bresticker <abrestic@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 11:51 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 5 Sep 2014, Andrew Bresticker wrote:
>> For platforms which boot with device-tree and use the MIPS CPU interrupt
>> controller binding, a generic plat_irq_dispatch() can be used since all
>> CPU interrupts should be mapped through the CPU IRQ domain.  Implement a
>> plat_irq_dispatch() which simply handles the highest pending interrupt.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Tested-by: Jonas Gorski <jogo@openwrt.org>
>> ---
>> No changes from v1.
>> ---
>>  arch/mips/kernel/irq_cpu.c | 28 +++++++++++++++++++++++-----
>>  1 file changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
>> index e498f2b..9cf8459 100644
>> --- a/arch/mips/kernel/irq_cpu.c
>> +++ b/arch/mips/kernel/irq_cpu.c
>> @@ -116,6 +116,24 @@ void __init mips_cpu_irq_init(void)
>>  }
>>
>>  #ifdef CONFIG_IRQ_DOMAIN
>> +static struct irq_domain *mips_intc_domain;
>> +
>> +asmlinkage void __weak plat_irq_dispatch(void)
>> +{
>> +     unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
>> +     unsigned int hw;
>> +     int irq;
>> +
>> +     if (!pending) {
>> +             spurious_interrupt();
>> +             return;
>> +     }
>> +
>> +     hw = fls(pending) - CAUSEB_IP - 1;
>> +     irq = irq_linear_revmap(mips_intc_domain, hw);
>> +     do_IRQ(irq);
>
> Why are you not handling all pending interrupts in a loop?

Nearly all of the existing plat_irq_dispatch()es handle only a single
pending interrupt.  I suppose it doesn't hurt to handle all pending
interrupts though.
