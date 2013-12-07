Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120Ab3LGBQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:16:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60950 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753918Ab3LGBQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:16:43 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "David E. Box" <david.e.box@linux.intel.com>, mjg59@srcf.ucam.org
Cc: linux-kernel@vger.kernel.org, bin.gao@linux.intel.com,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] X86 platform: New BayTrail IOSF-SB MBI driver
Date: Sat, 07 Dec 2013 02:29:44 +0100
Message-ID: <3820154.fYNMC1ZXku@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386363573-2008-1-git-send-email-david.e.box@linux.intel.com>
References: <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com> <1386363573-2008-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 06, 2013 12:59:33 PM David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> Current Intel SOC cores use a MailBox Interface (MBI) to provide access to unit
> devices connected to the system fabric. This driver implements access to this
> interface on BayTrail platforms. This is a requirement for drivers that need
> access to unit registers on the platform (e.g. accessing the PUNIT for power
> management features such as RAPL). Serialized access is handled by all exported
> routines with spinlocks.
> 
> The API includes 3 functions for access to unit registers:
> 
> u32 bt_mbi_read(u8 port, u8 opcode, u32 offset)
> void bt_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
> void bt_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
> 
> port:	indicating the unit being accessed
> opcode:	the read or write port specific opcode
> offset:	the register offset within the port
> mdr:	the register data to be written, or modified
> mask:	bit locations in mdr to change
> 
> Note: GPU code handles access to the GFX unit. Therefore access to that unit
> with this driver is disallowed to avoid conflicts.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>

Matthew, if you're going to take this:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Or if you prefer me to take it, please let me know (unless you have objections
against the patch, of course).

Thanks!

> ---
> v4: Define driver as platform specific to BayTrail as some platforms cannot
>     enumerate the MBI using ACPI as noted by Bin Gao <bin.gao@linux.intel.com>
>     Renamed register macros and API funcitons to platform specific names.
>     Changed dependency to PNPACPI as sugessted by Rafael Wysocki <rjw@rjwysocki.net>
> 
> v3: Converted to PNP ACPI driver as sugessted by Rafael Wysocki <rjw@rjwysocki.net>
>     Removed config visibility to user as suggested by Andi Kleen <andi@firstfloor.org>
> 
> v2: Made modular since there was no longer a reason not to
>     Moved to x86 platform as suggested by Mathhew Garrett <mjg59@srcf.ucam.org>
>     Added probe to init to cause driver load to fail if device not detected.
> 
>  drivers/platform/x86/Kconfig          |    8 ++
>  drivers/platform/x86/Makefile         |    1 +
>  drivers/platform/x86/intel_baytrail.c |  188 +++++++++++++++++++++++++++++++++
>  drivers/platform/x86/intel_baytrail.h |   89 ++++++++++++++++
>  4 files changed, 286 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_baytrail.c
>  create mode 100644 drivers/platform/x86/intel_baytrail.h
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index b51a746..830f915 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -819,4 +819,12 @@ config PVPANIC
>  	  a paravirtualized device provided by QEMU; it lets a virtual machine
>  	  (guest) communicate panic events to the host.
>  
> +config INTEL_BAYTRAIL_MBI
> +	tristate
> +	depends on PNPACPI
> +	---help---
> +	  Needed on Baytrail platforms for access to the IOSF Sideband Mailbox
> +	  Interface. This is a requirement for systems that need to configure
> +	  the PUNIT for power management features such as RAPL.
> +
>  endif # X86_PLATFORM_DEVICES
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index 5dbe193..b3d4cfd 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -55,3 +55,4 @@ obj-$(CONFIG_INTEL_RST)		+= intel-rst.o
>  obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
>  
>  obj-$(CONFIG_PVPANIC)           += pvpanic.o
> +obj-$(CONFIG_INTEL_BAYTRAIL_MBI)	+= intel_baytrail.o
> diff --git a/drivers/platform/x86/intel_baytrail.c b/drivers/platform/x86/intel_baytrail.c
> new file mode 100644
> index 0000000..265ab39
> --- /dev/null
> +++ b/drivers/platform/x86/intel_baytrail.c
> @@ -0,0 +1,188 @@
> +/*
> + * Baytrail IOSF-SB MailBox Interface Driver
> + * Copyright (c) 2013, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + *
> + * The IOSF-SB is a fabric bus available on Atom based SOC's that uses a
> + * mailbox interface (MBI) to communicate with mutiple devices. This
> + * driver implements BayTrail-specific access to this interface.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/spinlock.h>
> +#include <linux/pnp.h>
> +
> +#include "intel_baytrail.h"
> +
> +static DEFINE_SPINLOCK(iosf_mbi_lock);
> +
> +static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
> +{
> +	return (op << 24) | (port << 16) | (offset << 8) | BT_MBI_ENABLE;
> +}
> +
> +static struct {
> +	void __iomem *addr;
> +	bool probed;
> +} iosf_mbi_data;
> +
> +/* Hold lock before calling */
> +static u32 iosf_mbi_read_mdr(u32 mcrx, u32 mcr, void __iomem *addr)
> +{
> +	if (mcrx)
> +		iowrite32(mcrx, addr + BT_MBI_MCRX_OFFSET);
> +	iowrite32(mcr, addr + BT_MBI_MCR_OFFSET);
> +	return ioread32(addr + BT_MBI_MDR_OFFSET);
> +}
> +
> +/* Hold lock before calling */
> +static void iosf_mbi_write_mdr(u32 mcrx, u32 mcr, u32 mdr, void __iomem *addr)
> +{
> +
> +	iowrite32(mdr, addr + BT_MBI_MDR_OFFSET);
> +	if (mcrx)
> +		iowrite32(mcrx, addr + BT_MBI_MCRX_OFFSET);
> +	iowrite32(mcr, addr + BT_MBI_MCR_OFFSET);
> +}
> +
> +u32 bt_mbi_read(u8 port, u8 opcode, u32 offset)
> +{
> +	u32 mcr, mcrx;
> +	u32 ret;
> +	unsigned long flags;
> +
> +	/*Access to the GFX unit is handled by GPU code */
> +	BUG_ON(port == BT_MBI_UNIT_GFX);
> +
> +	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
> +	mcrx = offset & BT_MBI_MASK_HI;
> +
> +	spin_lock_irqsave(&iosf_mbi_lock, flags);
> +	ret = iosf_mbi_read_mdr(mcrx, mcr, iosf_mbi_data.addr);
> +	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(bt_mbi_read);
> +
> +void bt_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr)
> +{
> +	u32 mcr, mcrx;
> +	unsigned long flags;
> +
> +	/*Access to the GFX unit is handled by GPU code */
> +	BUG_ON(port == BT_MBI_UNIT_GFX);
> +
> +	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
> +	mcrx = offset & BT_MBI_MASK_HI;
> +
> +	spin_lock_irqsave(&iosf_mbi_lock, flags);
> +	iosf_mbi_write_mdr(mcrx, mcr, mdr, iosf_mbi_data.addr);
> +	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
> +}
> +EXPORT_SYMBOL(bt_mbi_write);
> +
> +void bt_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask)
> +{
> +	u32 mcr, mcrx;
> +	u32 value;
> +	unsigned long flags;
> +
> +	/*Access to the GFX unit is handled by GPU code */
> +	BUG_ON(port == BT_MBI_UNIT_GFX);
> +
> +	mcr = iosf_mbi_form_mcr(opcode, port, offset & BT_MBI_MASK_LO);
> +	mcrx = offset & BT_MBI_MASK_HI;
> +
> +	spin_lock_irqsave(&iosf_mbi_lock, flags);
> +
> +	/* Read current mdr value */
> +	value = iosf_mbi_read_mdr(mcrx, mcr & BT_MBI_RD_MASK,
> +				  iosf_mbi_data.addr);
> +
> +	/* Apply mask */
> +	value &= ~mask;
> +	mdr &= mask;
> +	value |= mdr;
> +
> +	/* Write back */
> +	iosf_mbi_write_mdr(mcrx, mcr | BT_MBI_WR_MASK, value,
> +			   iosf_mbi_data.addr);
> +
> +	spin_unlock_irqrestore(&iosf_mbi_lock, flags);
> +}
> +EXPORT_SYMBOL(bt_mbi_modify);
> +
> +static int iosf_mbi_pnp_probe(struct pnp_dev *pnp,
> +			      const struct pnp_device_id *dev_id)
> +{
> +	struct resource *mem;
> +
> +	/* Get and map MBI address space */
> +	mem = pnp_get_resource(pnp, IORESOURCE_MEM, 0);
> +	if (!mem)
> +		return -ENOMEM;
> +
> +	iosf_mbi_data.addr = devm_ioremap_resource(&pnp->dev, mem);
> +	if (IS_ERR(iosf_mbi_data.addr))
> +		return PTR_ERR(iosf_mbi_data.addr);
> +
> +	iosf_mbi_data.probed = true;
> +	return 0;
> +}
> +
> +static void iosf_mbi_pnp_remove(struct pnp_dev *pdev)
> +{
> +	return;
> +}
> +
> +static const struct pnp_device_id iosf_mbi_dev_table[] = {
> +	{ "INT33BD", 0},
> +	{ "", 0},
> +};
> +MODULE_DEVICE_TABLE(pnp, iosf_mbi_dev_table);
> +
> +static struct pnp_driver iosf_mbi_pnp_driver = {
> +	.name		= "bt_iosf_mbi",
> +	.probe		= iosf_mbi_pnp_probe,
> +	.remove		= iosf_mbi_pnp_remove,
> +	.id_table	= iosf_mbi_dev_table,
> +};
> +
> +static int __init iosf_mbi_init(void)
> +{
> +	int ret;
> +
> +	iosf_mbi_data.probed = false;
> +
> +	ret = pnp_register_driver(&iosf_mbi_pnp_driver);
> +	if (!ret && !iosf_mbi_data.probed) {
> +		pnp_unregister_driver(&iosf_mbi_pnp_driver);
> +		return -ENODEV;
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit iosf_mbi_exit(void)
> +{
> +	pnp_unregister_driver(&iosf_mbi_pnp_driver);
> +}
> +
> +module_init(iosf_mbi_init);
> +module_exit(iosf_mbi_exit);
> +
> +MODULE_AUTHOR("David E. Box <david.e.box@linux.intel.com>");
> +MODULE_DESCRIPTION("BayTrail Mailbox Interface accessor");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/platform/x86/intel_baytrail.h b/drivers/platform/x86/intel_baytrail.h
> new file mode 100644
> index 0000000..dac3de6
> --- /dev/null
> +++ b/drivers/platform/x86/intel_baytrail.h
> @@ -0,0 +1,89 @@
> +/*
> + * intel_baytrail.h: MailBox access support for Intel BayTrail platforms
> + */
> +
> +#ifndef INTEL_BAYTRAIL_MBI_SYMS_H
> +#define INTEL_BAYTRAIL_MBI_SYMS_H
> +
> +#define BT_MBI_MCR_OFFSET	0x0
> +#define BT_MBI_MDR_OFFSET	0x4
> +#define BT_MBI_MCRX_OFFSET	0x8
> +
> +#define BT_MBI_RD_MASK		0xFEFFFFFF
> +#define BT_MBI_WR_MASK		0X01000000
> +
> +#define BT_MBI_MASK_HI		0xFFFFFF00
> +#define BT_MBI_MASK_LO		0x000000FF
> +#define BT_MBI_ENABLE		0xF0
> +
> +#define BT_MBI_MAX_PORTS	0xFF
> +
> +/* BT-SB unit access methods */
> +#define BT_MBI_UNIT_AUNIT	0x00
> +#define BT_MBI_UNIT_SMC		0x01
> +#define BT_MBI_UNIT_CPU		0x02
> +#define BT_MBI_UNIT_BUNIT	0x03
> +#define BT_MBI_UNIT_PMC		0x04
> +#define BT_MBI_UNIT_GFX		0x06
> +#define BT_MBI_UNIT_SMI		0x0C
> +#define BT_MBI_UNIT_USB		0x43
> +#define BT_MBI_UNIT_SATA	0xA3
> +#define BT_MBI_UNIT_PCIE	0xA6
> +
> +/* Read/write opcodes */
> +#define BT_MBI_AUNIT_READ	0x10
> +#define BT_MBI_AUNIT_WRITE	0x11
> +#define BT_MBI_SMC_READ		0x10
> +#define BT_MBI_SMC_WRITE	0x11
> +#define BT_MBI_CPU_READ		0x10
> +#define BT_MBI_CPU_WRITE	0x11
> +#define BT_MBI_BUNIT_READ	0x10
> +#define BT_MBI_BUNIT_WRITE	0x11
> +#define BT_MBI_PMC_READ		0x06
> +#define BT_MBI_PMC_WRITE	0x07
> +#define BT_MBI_GFX_READ		0x00
> +#define BT_MBI_GFX_WRITE	0x01
> +#define BT_MBI_SMIO_READ	0x06
> +#define BT_MBI_SMIO_WRITE	0x07
> +#define BT_MBI_USB_READ		0x06
> +#define BT_MBI_USB_WRITE	0x07
> +#define BT_MBI_SATA_READ	0x00
> +#define BT_MBI_SATA_WRITE	0x01
> +#define BT_MBI_PCIE_READ	0x00
> +#define BT_MBI_PCIE_WRITE	0x01
> +
> +/**
> + * bt_mbi_read() - MailBox Interface read command
> + * @port:	port indicating subunit being accessed
> + * @opcode:	port specific read or write opcode
> + * @offset:	register address offset
> + *
> + * Locking is handled by spinlock - cannot sleep.
> + * Return: 32 bit value of mdr register
> + */
> +u32 bt_mbi_read(u8 port, u8 opcode, u32 offset);
> +
> +/**
> + * bt_mbi_write() - MailBox unmasked write command
> + * @port:	port indicating subunit being accessed
> + * @opcode:	port specific read or write opcode
> + * @offset:	register address offset
> + * @mdr:	register data to be written
> + *
> + * Locking is handled by spinlock - cannot sleep.
> + */
> +void bt_mbi_write(u8 port, u8 opcode, u32 offset, u32 mdr);
> +
> +/**
> + * bt_mbi_modify() - MailBox masked write command
> + * @port:	port indicating subunit being accessed
> + * @opcode:	port specific read or write opcode
> + * @offset:	register address offset
> + * @mdr:	register data being modified
> + * @mask:	mask indicating bits in mdr to be modified
> + *
> + * Locking is handled by spinlock - cannot sleep.
> + */
> +void bt_mbi_modify(u8 port, u8 opcode, u32 offset, u32 mdr, u32 mask);
> +
> +#endif /* INTEL_BAYTRAIL_MBI_SYMS_H */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
