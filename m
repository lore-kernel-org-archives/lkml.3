Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab3LFQil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:38:41 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:61693 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3LFQij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:38:39 -0500
Message-ID: <1386347911.7152.70.camel@host5.omatika.ru>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Fri, 06 Dec 2013 20:38:31 +0400
In-Reply-To: <201312060140.10376.arnd@arndb.de>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	 <201312060140.10376.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 01:40 +0100, Arnd Bergmann wrote:
> On Sunday 01 December 2013, Sergei Ianovich wrote:
> > 
> > diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
> > new file mode 100644
> > index 0000000..5cd6d38
> > --- /dev/null
> > +++ b/arch/arm/configs/lp8x4x_defconfig
> > @@ -0,0 +1,2320 @@
> > +#
> > +# Automatically generated file; DO NOT EDIT.
> > +# Linux/arm 3.13.0-rc1 Kernel Configuration
> > +#
> 
> Please use 'make savedefconfig' to generate a smaller version of this file.

Done. Updated in v2.

> Ideally we want shared defconfigs where you enable multiple (or all) pxa boards
> at once and end up with a kernel that works on all of them.
> 
> For most other platforms the goal is even to have a shared defconfig across
> SoC families, but PXA is one of the exceptions that I would make because
> it is both old and rather different from even the ARM9 or Marvell Feroceon
> based SoCs.

There is probably no in point sharing this config with most other
devices on PXA2xx SoC. This device is an industrial PC. Its config needs
to be optimized for low latency even by the cost of greater power
consumption. It is not supposed to run on batteries or enter any low
power mode anyway.

> > +#define LP8X4X_FPGA_PHYS     0x17000000
> > +#define LP8X4X_FPGA_VIRT     0xf1000000
> > +#define LP8X4X_P2V(x)                IOMEM((x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)
> > +#define LP8X4X_V2P(x)                ((x) - LP8X4X_FPGA_VIRT + LP8X4X_FPGA_PHYS)
> 
> I would recommend defining LP8X4X_FPGA_VIRT as "(void *)0xf1000000". Ideally

Done in v2. 

> we try to avoid hardwired virtual addresses entirely and instead use platform
> device resources, but I realize that there are limits to how far you get with
> that. Please make an effort to convert as many parts of the FPGA into platform
> devices with regular resources, but know that we would not enforce this as
> strictly as we do for new platforms.
> 
> > +
> > +static struct irq_chip lp8x4x_irq_chip = {
> > +     .name                   = "FPGA",
> > +     .irq_ack                = lp8x4x_ack_irq,
> > +     .irq_mask               = lp8x4x_mask_irq,
> > +     .irq_unmask             = lp8x4x_unmask_irq,
> > +};
> 
> Please try to move the irqchip code to drivers/irqchip/.

CONFIG_IRQCHIP depends on CONFIG_OF_IRQ which in turn depends on Open
Firmware.

The device is shipped with such a flash device partition table, which
makes migration to device tree rather difficult. The partition for
U-Boot is just 256kiB. This is a high aim already. U-Boot needs to be
compiled without command line help and USB support to fit into this
size. Otherwise the main flash needs to be repartitioned.

Could it be acceptable to accept the device without device tree support?

If so, FPGA irqchip could remain in the machine source file. It is
highly unlikely, it will ever be reused. In this case all fixed virtual
address definitions could be moved to the machine source file. The file
will be the only place where LP8X4X_FPGA_VIRT is used directly.

> > +static struct platform_device lp8x4x_flash_device[] = {
> 
> static platform_device definitions are no longer the way to do this. For
> modern platforms, you'd use a device tree, but here I think it is acceptable
> (because of the PXA exception) to use a hardcoded board file.
> 
> The correct way to create the devices is using platform_device_register_data()
> or a related function that returns a dynamically allocated platform device.

Done in v2. Allocation migrated to use
platform_device_register_resndata() and
platform_device_register_simple().


