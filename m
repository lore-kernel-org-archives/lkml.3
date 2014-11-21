Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaKUEAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:00:23 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:39198 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbaKUEAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:00:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141120222650.GC7987@google.com>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
	<1416413091-13452-7-git-send-email-tomasz.nowicki@linaro.org>
	<2360791.Aj7tQ0nCJ3@wuerfel>
	<20141120222650.GC7987@google.com>
Date: Thu, 20 Nov 2014 21:00:17 -0700
Message-ID: <CAL-B5D3MqUa-=bzebo12DbZfczss2-MdGwQ8WKTbFH8H2AENXg@mail.gmail.com>
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
From: Myron Stowe <myron.stowe@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, lorenzo.pieralisi@arm.com, wangyijing@huawei.com,
        hanjun.guo@linaro.org, Liviu.Dudau@arm.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, rjw@rjwysocki.net,
        linaro-acpi@lists.linaro.org, linux-pci <linux-pci@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:26 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Nov 19, 2014 at 05:19:20PM +0100, Arnd Bergmann wrote:
>> On Wednesday 19 November 2014 17:04:51 Tomasz Nowicki wrote:
>> > +/*
>> > + * raw_pci_read/write - ACPI PCI config space accessors.
>> > + *
>> > + * ACPI spec defines MMCFG as the way we can access PCI config space,
>> > + * so let MMCFG be default (__weak).
>> > + *
>> > + * If platform needs more fancy stuff, should provides its own implementation.
>> > + */
>> > +int __weak raw_pci_read(unsigned int domain, unsigned int bus,
>> > +                       unsigned int devfn, int reg, int len, u32 *val)
>> > +{
>> > +       return pci_mmcfg_read(domain, bus, devfn, reg, len, val);
>> > +}
>> > +
>> > +int __weak raw_pci_write(unsigned int domain, unsigned int bus,
>> > +                        unsigned int devfn, int reg, int len, u32 val)
>> > +{
>> > +       return pci_mmcfg_write(domain, bus, devfn, reg, len, val);
>> > +}
>> > +
>> >
>>
>> I think it would be better to avoid __weak functions here, as they tend
>> to be hard to follow when trying to understand the code.
>
> That's interesting.  I would have said exactly the opposite -- I think the
> extra Kconfiggery is harder to follow than weak/strong functions :)
>
> But consistency is better than my personal opinion.  Is there a consensus
> that we should use the Kconfig strategy instead of __weak?

I too find weak/strong functions easier to follow than "Kconfiggery" (nice term
invention there).

>
>> How about using a Kconfig symbol like this:
>>
>> #ifdef CONFIG_ARCH_RAW_PCI_READWRITE
>> int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>>                  int reg, int len, u32 *val);
>> int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
>>                   int reg, int len, u32 val);
>> #else
>> static inline int raw_pci_read(unsigned int domain, unsigned int bus,
>>                              unsigned int devfn, int reg, int len, u32 *val)
>> {
>>       return pci_mmcfg_read(domain, bus, devfn, reg, len, val);
>> }
>>
>> static inline int raw_pci_write(unsigned int domain, unsigned int bus,
>>                                       unsigned int devfn, int reg, int len, u32 val)
>> {
>>        return pci_mmcfg_write(domain, bus, devfn, reg, len, val);
>> }
>> #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
