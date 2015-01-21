Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbbAUPsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:48:00 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:39161 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbbAUPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <1682713.ac5OoTJoOr@wuerfel>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<8467440.C7CR1EqfOe@wuerfel>
	<CAG374jDmUyEX0_iu4wG8LjM6YGMjsB-3PjnyZy_0Se=nLcn16g@mail.gmail.com>
	<1682713.ac5OoTJoOr@wuerfel>
Date: Wed, 21 Jan 2015 16:47:36 +0100
Message-ID: <CAG374jCRByNZuuYxi5+-mKvV7p5-tCf2G+8mTYfzU4rRV4yfYQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] PCI: st: Provide support for the sti PCIe controller
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 January 2015 at 14:49, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 19 January 2015 13:37:33 Gabriel Fernandez wrote:
>> On 17 December 2014 at 23:14, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Wednesday 17 December 2014 11:34:44 Gabriel FERNANDEZ wrote:
>> > > +/*
>> > > + * On ARM platforms, we actually get a bus error returned when the PCIe
>> > IP
>> > > + * returns a UR or CRS instead of an OK.
>> > > + */
>> > > +static int st_pcie_abort_
>> >
>> > handler(unsigned long addr, unsigned int fsr,
>> > > +                              struct pt_regs *regs)
>> > > +{
>> > > +     return 0;
>> > > +}
>> >
>> > You should check that it's actually PCI that caused the abort. Don't
>> > just ignore a hard error condition.
>> >
>> > Usually there are registers in the PCI core that let you identify what
>> > happened.
>> >
>>
>>
>> We return 0 because abort handler is not activated during boot.
>>
>
> Can you just remove the handler then? We should never have exception
> handlers that unconditionally return 0.
>

Ah sorry, we need the handler because we can received aborts from
user-land after the boot.

I have 2 solutions, the first to simplify we can only return 0.
The second is to manage handler during boot. Then i need for that a
new patch from Fabrice
https://lkml.org/lkml/2014/2/7/631

>> > > +      * we must retry for up to a second before we decide the device is
>> > > +      * dead. If we are still dead then we assume there is nothing
>> > there and
>> > > +      * return ~0
>> > > +      *
>> > > +      * The downside of this is that we incur a delay of 1s for every
>> > pci
>> > > +      * express link that doesn't have a device connected.
>> > > +      */
>> > > +     if (((where & ~3) == 0) && devfn == 0 && (data == 0 || data ==
>> > ~0)) {
>> > > +             if (retry_count++ < 1000) {
>> > > +                     mdelay(1);
>> > > +                     goto retry;
>> > > +             } else {
>> > > +                     *val = ~0;
>> > > +                     return PCIBIOS_DEVICE_NOT_FOUND;
>> > > +             }
>> > > +     }
>> > > +
>> > > +     *val = data;
>> > > +     return ret;
>> > > +}
>> >
>> > A busy-loop is extremely nasty. If this is only during the initial bus
>> > scan, could you use an msleep instead?
>> >
>> > yes it's during the initial bus scan.
>> But we can't use msleep because we are under raw_spin_lock_irqsave()
>> see PCI_OP_READ() macro in drivers/pci/access.c
>
> Ah, I see. Better use a loop with 'time_before()' and a much shorter
> delay then. Even a single mdelay(1) with irqs disabled can be annoying,
> so try to make the time as short as possible.
>
>> > Also, it sounds like the error you get is actually the fault that you
>> > are catching above. If this is correct, then use the fault handler to
>> > communicate this to the probe function.
>> >
>>
>> Same as above the handler is not activated during the boot and initial bus
>> scan.
>
> Maybe you could enable the handler during boot to catch this case, and
> then disable it later?
>
>> >
>> > > +static void st_msi_init_one(struct pcie_port *pp)
>> > > +{
>> > > +     struct st_pcie *pcie = to_st_pcie(pp);
>> > > +
>> > > +     /*
>> > > +      * Set the magic address the hardware responds to. This has to be
>> > in
>> > > +      * the range the PCI controller can write to.
>> > > +      */
>> > > +     dw_pcie_msi_init(pp);
>> > > +
>> > > +     if ((virt_to_phys((void *)pp->msi_data) < pcie->lmi->start) ||
>> > > +         (virt_to_phys((void *)pp->msi_data) > pcie->lmi->end))
>> > > +             dev_err(pp->dev, "MSI addr miss-configured\n");
>> > > +}
>> >
>> > Why do you call virt_to_phys() here? Isn't
>> >
>> > msi_data a physical address?
>> >
>> ?
>>
>>
>> msi_data is a virtual address, it's obtained through a   __get_free_pages()
>> function in dw_pcie_msi_init() procedure.
>
> I guess you need dma_map_single() then, or use dma_alloc_coherent instead
> of __get_free_pages(). There is no guarantee that the page you allocate
> there is actually visible to the PCI host at the same address that the CPU
> uses, so you need to map from a CPU address to a DMA address that the PCI
> host bridge uses.
>
>         Arnd

This is only to check the msi magic address given to ip, we never read
or write in this area.
this code is only a check

BR

Gabriel
