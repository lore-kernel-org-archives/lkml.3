Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaDYWYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:24:34 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54679 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaDYWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140420075936.GA19672@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
	<20140419025323.2408.88764.stgit@amt.stowe>
	<20140419135219.GC8109@pd.tnic>
	<20140420075936.GA19672@pd.tnic>
Date: Fri, 25 Apr 2014 16:24:31 -0600
Message-ID: <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
From: Myron Stowe <myron.stowe@gmail.com>
To: Borislav Petkov <bp@suse.de>
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, daniel@numascale.com,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        x86 <x86@kernel.org>, sp@numascale.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 1:59 AM, Borislav Petkov <bp@suse.de> wrote:
> Drop Andreas' old email address from CC as it keeps bouncing.
>
> On Sat, Apr 19, 2014 at 03:52:20PM +0200, Borislav Petkov wrote:
>> > -static void __init pci_enable_pci_io_ecs(void)
>> > +static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
>> >  {
>> >  #ifdef CONFIG_AMD_NB
>> >     unsigned int i, n;
>> > +   u8 limit;
>> >
>> >     for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
>> > -           u8 bus = amd_nb_bus_dev_ranges[i].bus;
>> > -           u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
>> > -           u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
>> > +           /* Try matching for the bus range */
>> > +           if ((bus != amd_nb_bus_dev_ranges[i].bus) ||
>> > +               (slot != amd_nb_bus_dev_ranges[i].dev_base))
>> > +                   continue;
>> > +
>> > +           limit = amd_nb_bus_dev_ranges[i].dev_limit;
>> >
>> > +           /* Setup all northbridges within the range */
>> >             for (; slot < limit; ++slot) {
>> >                     u32 val = read_pci_config(bus, slot, 3, 0);
>> > -
>> > -                   if (!early_is_amd_nb(val))
>> > +                   if (!val)
>> >                             continue;
>> >
>> >                     val = read_pci_config(bus, slot, 3, 0x8c);
>> > @@ -375,13 +457,14 @@ static void __init pci_enable_pci_io_ecs(void)
>> >                             val |= ENABLE_CF8_EXT_CFG >> 32;
>>
>> What a fun shifting!
>>
>> Maybe you should do
>>
>> #define ENABLE_CF8_EXT_CFG    BIT(46 - 32)
>>
>> to show exactly what you mean and how the bit is defined in MSR NB_CFG1
>> and also show how the high 32-bits are mapped into F3x8c, while at it.
>>
>> And then you can drop the shifting at the call site.
>
> Ok, I see another fun with this ECS enabling:
>
> There's a enable_pci_io_ecs() which enables ECS through the NB_CFG MSR
> which is called as part of the notifier *and* there's a PCI write to
> that same bit in pci_enable_pci_io_ecs() which iterates over all NBs.
>
> So, AFAICT, we do it twice and the second time is not needed. Which
> means, you probably can drop pci_enable_pci_io_ecs() completely and use
> solely the notifier?

It does look as if there is some duplication with respect to setting
MSR_AMD64_NB_CFG's (which is aliased at D18F3x8c [1])
ENABLE_CF8_EXT_CFG enable bit but there are at least a couple of
differences.

enable_pci_io_ecs() only sets the bit on one NB whereas
pci_enable_pci_io_ecs iterates over all the NBs (as you mentioned
above).  The other difference has something to do with Xen; see the
origin of pci_enable_pci_io_ecs - commit 24d9b70b8.

>
> Yes, no?

Suravee, Kim - either of you want to chime in here?


[1] Read-write; Per-node. MSRC001_001F[31:0] is an alias of D18F3x88.
MSRC001_001F[63:32] is an alias of
D18F3x8C.

Myron
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
