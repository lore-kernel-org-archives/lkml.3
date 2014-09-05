Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIEVuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:50:05 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42355 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaIEVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1409052056400.5472@nanos>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
	<1409938218-9026-15-git-send-email-abrestic@chromium.org>
	<alpine.DEB.2.10.1409052056400.5472@nanos>
Date: Fri, 5 Sep 2014 14:50:02 -0700
X-Google-Sender-Auth: cLF84FfuQD-FvMMBU9HsOpviWVg
Message-ID: <CAL1qeaH5ZQA8Y=n3uVSy9e+vEweCi_RT2s-ZGRfyJTAcbguyoA@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] irqchip: mips-gic: Support local interrupts
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

On Fri, Sep 5, 2014 at 12:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 5 Sep 2014, Andrew Bresticker wrote:
>>  static void gic_mask_irq(struct irq_data *d)
>>  {
>> -     GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
>> +     unsigned int irq = d->irq - gic_irq_base;
>> +
>> +     if (gic_is_local_irq(irq)) {
>> +             GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK),
>> +                      1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
>> +     } else {
>> +             GIC_CLR_INTR_MASK(irq);
>> +     }
>>  }
>>
>>  static void gic_unmask_irq(struct irq_data *d)
>>  {
>> -     GIC_SET_INTR_MASK(d->irq - gic_irq_base);
>> +     unsigned int irq = d->irq - gic_irq_base;
>> +
>> +     if (gic_is_local_irq(irq)) {
>> +             GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK),
>> +                      1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
>> +     } else {
>> +             GIC_SET_INTR_MASK(irq);
>> +     }
>
> Why are you adding a conditional in all these functions instead of
> having two interrupt chips with separate callbacks and irqdata?

Ok, I'll use a separate irqchip.

> And looking at GIC_SET_INTR_MASK(irq) makes me shudder even more. The
> whole thing can be replaced with the generic interrupt chip functions.
>
> If you set it up proper, then there is not a single conditional or
> runtime calculation of bitmasks, address offsets etc.

Yes, I'd like to use the generic irqchip library here, but Malta and
SEAD-3 will need to be converted over to using irq domains.  Perhaps
I'll do that first - it should get rid of a lot of the other ugliness
here as well.
