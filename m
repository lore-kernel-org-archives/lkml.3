Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbbASNIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:08:51 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63874 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbASNIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <8467440.C7CR1EqfOe@wuerfel>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org>
	<1418812486-12394-4-git-send-email-gabriel.fernandez@linaro.org>
	<8467440.C7CR1EqfOe@wuerfel>
Date: Mon, 19 Jan 2015 14:08:48 +0100
Message-ID: <CAG374jDDn9OWZm0=46zmk5MwYbX-orwJ=_k=mR-33dFPFMjdLw@mail.gmail.com>
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 17 December 2014 at 23:14, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 17 December 2014 11:34:44 Gabriel FERNANDEZ wrote:
>> sti pcie is built around a Synopsis Designware PCIe IP.
>>
>> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> ---
>>  drivers/pci/host/Kconfig  |   5 +
>>  drivers/pci/host/Makefile |   1 +
>>  drivers/pci/host/pci-st.c | 713 ++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 719 insertions(+)
>>  create mode 100644 drivers/pci/host/pci-st.c
>>
>> diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
>> index c4b6568..999d2b9 100644
>> --- a/drivers/pci/host/Kconfig
>> +++ b/drivers/pci/host/Kconfig
>> @@ -102,4 +102,9 @@ config PCI_LAYERSCAPE
>>       help
>>         Say Y here if you want PCIe controller support on Layerscape SoCs.
>>
>> +config PCI_ST
>> +     bool "ST STiH41x PCIe controller"
>> +     depends on ARCH_STI
>> +     select PCIE_DW
>
> I'd use 'depends on ARCH_STI || (ARM && COMPILE_TEST)' to enable
> building this on other platforms for test purposes.
>
ok

>> +
>> +#define to_st_pcie(x)        container_of(x, struct st_pcie, pp)
>> +
>> +/**
>> + * struct st_pcie_ops - SOC dependent data
>> + * @init: reference to controller power & reset init routine
>> + * @enable_ltssm: reference to controller link enable routine
>> + * @disable_ltssm:  reference to controller link disable routine
>> + * @phy_auto: flag when phy automatically configured
>> + */
>> +struct st_pcie_ops {
>> +     int (*init)(struct pcie_port *pp);
>> +     int (*enable_ltssm)(struct pcie_port *pp);
>> +     int (*disable_ltssm)(struct pcie_port *pp);
>> +     bool phy_auto;
>> +};
>
ok, i will fix it.

> It would be better not to invent another level of indirection. Try
> turning this around so you have a driver that binds to the specific
> SoC compatible string for the PCIe port while calling into a common
> library module for things that are shared.
>
>> +/*
>> + * On ARM platforms, we actually get a bus error returned when the PCIe IP
>> + * returns a UR or CRS instead of an OK.
>> + */
>> +static int st_pcie_abort_handler(unsigned long addr, unsigned int fsr,
>> +                              struct pt_regs *regs)
>> +{
>> +     return 0;
>> +}
>
> You should check that it's actually PCI that caused the abort. Don't
> just ignore a hard error condition.
>
> Usually there are registers in the PCI core that let you identify what
> happened.
>
We return 0 because abort handler is not activated during boot.

>> +static int st_pcie_rd_other_conf(struct pcie_port *pp, struct pci_bus *bus,
>> +                              unsigned int devfn, int where, int size,
>> +                              u32 *val)
>> +{
>> +     u32 data;
>> +     u32 bdf;
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +     int is_root_bus = pci_is_root_bus(bus);
>> +     int retry_count = 0;
>> +     int ret;
>> +     void __iomem *addr;
>> +
>> +     /*
>> +      * Prerequisite
>> +      * PCI express devices will respond to all config type 0 cycles, since
>> +      * they are point to point links. Thus to avoid probing for multiple
>> +      * devices on the root, dw-pcie already check for us if it is on the
>> +      * root bus / other slots. Also, dw-pcie checks for the link being up
>> +      * as we will hang if we issue a config request and the link is down.
>> +      * A switch will reject requests for slots it knows do not exist.
>> +      */
>> +     bdf = bdf_num(bus->number, devfn, is_root_bus);
>> +     addr = pcie->config_area + config_addr(where,
>> +                     bus->parent->number == pp->root_bus_nr);
>> +retry:
>> +     /* Set the config packet devfn */
>> +     writel_relaxed(bdf, pp->dbi_base + FUNC0_BDF_NUM);
>> +     readl_relaxed(pp->dbi_base + FUNC0_BDF_NUM);
>> +
>> +     ret = dw_pcie_cfg_read(addr, where, size, &data);
>> +
>> +     /*
>> +      * This is intended to help with when we are probing the bus. The
>> +      * problem is that the wrapper logic doesn't have any way to
>> +      * interrogate if the configuration request failed or not.
>> +      * On the ARM we actually get a real bus error.
>> +      *
>> +      * Unfortunately this means it is impossible to tell the difference
>> +      * between when a device doesn't exist (the switch will return a UR
>> +      * completion) or the device does exist but isn't yet ready to accept
>> +      * configuration requests (the device will return a CRS completion)
>> +      *
>> +      * The result of this is that we will miss devices when probing.
>> +      *
>> +      * So if we are trying to read the dev/vendor id on devfn 0 and we
>> +      * appear to get zero back, then we retry the request.  We know that
>> +      * zero can never be a valid device/vendor id. The specification says
>> +      * we must retry for up to a second before we decide the device is
>> +      * dead. If we are still dead then we assume there is nothing there and
>> +      * return ~0
>> +      *
>> +      * The downside of this is that we incur a delay of 1s for every pci
>> +      * express link that doesn't have a device connected.
>> +      */
>> +     if (((where & ~3) == 0) && devfn == 0 && (data == 0 || data == ~0)) {
>> +             if (retry_count++ < 1000) {
>> +                     mdelay(1);
>> +                     goto retry;
>> +             } else {
>> +                     *val = ~0;
>> +                     return PCIBIOS_DEVICE_NOT_FOUND;
>> +             }
>> +     }
>> +
>> +     *val = data;
>> +     return ret;
>> +}
>
> A busy-loop is extremely nasty. If this is only during the initial bus
> scan, could you use an msleep instead?
>
yes it's during the initial bus scan.
But we can't use msleep because we are under raw_spin_lock_irqsave()
see PCI_OP_READ() macro in drivers/pci/access.c

> Also, it sounds like the error you get is actually the fault that you
> are catching above. If this is correct, then use the fault handler to
> communicate this to the probe function.
>
Same as above the handler is not activated during the boot and initial bus scan.


>> +
>> +static void st_pcie_board_reset(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     if (!gpio_is_valid(pcie->reset_gpio))
>> +             return;
>> +
>> +     if (gpio_direction_output(pcie->reset_gpio, 0)) {
>> +             dev_err(pp->dev, "Cannot set PERST# (gpio %u) to output\n",
>> +                     pcie->reset_gpio);
>> +             return;
>> +     }
>> +
>> +     /* From PCIe spec */
>> +     usleep_range(1000, 2000);
>> +     gpio_direction_output(pcie->reset_gpio, 1);
>> +
>> +     /*
>> +      * PCIe specification states that you should not issue any config
>> +      * requests until 100ms after asserting reset, so we enforce that here
>> +      */
>> +     usleep_range(100000, 150000);
>> +}
>
> This seems hardly performance critical, just use msleep(2) and
> msleep(100) instead of the usleep_range().
>

ok i will fix it.


>> +static void st_msi_init_one(struct pcie_port *pp)
>> +{
>> +     struct st_pcie *pcie = to_st_pcie(pp);
>> +
>> +     /*
>> +      * Set the magic address the hardware responds to. This has to be in
>> +      * the range the PCI controller can write to.
>> +      */
>> +     dw_pcie_msi_init(pp);
>> +
>> +     if ((virt_to_phys((void *)pp->msi_data) < pcie->lmi->start) ||
>> +         (virt_to_phys((void *)pp->msi_data) > pcie->lmi->end))
>> +             dev_err(pp->dev, "MSI addr miss-configured\n");
>> +}
>
> Why do you call virt_to_phys() here? Isn't msi_data a physical address?
>
msi_data is a virtual address, it's obtained through a
__get_free_pages() function in dw_pcie_msi_init() procedure.

>> +static int __init st_pcie_probe(struct platform_device *pdev)
>
> I'd suggest removing the __init here, as discussed in the review for
> the qualcomm driver.
>
ok

>         Arnd

BR

Gabriel.
