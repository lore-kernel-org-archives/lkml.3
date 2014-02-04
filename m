Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaBDLyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:54:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:54:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Tue, 04 Feb 2014 12:54:11 +0100
Message-ID: <27019203.VEiCA8u8iI@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140204110922.GA27975@e106497-lin.cambridge.arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <3277167.UhkSU8Sf56@wuerfel> <20140204110922.GA27975@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9npF5bVAxc+U0bKnX1fobepK5G1aVnW/rbVSvsAPrTg
 fV2RMTQg0T8npXSryvWxZeZL3lCgweng8wOxa2k7Ucn02+4J5K
 NqaWpFAZeUHbqjDV7XPdPahyWdvl880MgUg14IYlC/ACultQbH
 ZRJzON3OUCWuJH6L6VbQLzz9w3AqxMeXZrK03UT+t91iwK/8Cp
 cUiuHL5u0gGJDOPEotKixXXhLAPdC0+LCmk8qUcwQlDDR4ytNd
 pCaOHKVLxl0Qq00c+SrNFLDSQLbAGsqyReF3+d38v/3LjR+4vd
 0IITI3ptfy4zvvhNWTPJqXhljNiScT/lu/PJ2ciy7fPAp6swnI
 ns1sAB9O+hbt4jYo5cgI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014 11:09:22 Liviu Dudau wrote:
> On Tue, Feb 04, 2014 at 08:44:36AM +0000, Arnd Bergmann wrote:

> > Well, I/O space never starts at physical zero in reality, so it is
> > broken in practice. The CONFIG_GENERIC_IOMAP option tries to solve
> > the problem of I/O spaces that are not memory mapped, which is
> > actually quite rare (x86, ia64, some rare powerpc bridges, and possibly
> > Alpha). The norm is that if you have I/O space, it is memory mapped
> > and you don't need GENERIC_IOMAP. I think most of the architectures
> > selecting GENERIC_IOMAP have incorrectly copied that from x86.
> 
> If you are talking about CPU addresses for I/O space, then you are (mostly?) right.
> I've seen some code in powerpc that tries to handle the case where I/O starts at zero.
>
> For MMIO, yes, it would be crazy to start at CPU address zero. But,
> the ioport_map takes a port number, and those do start at zero, right?

What I meant is that asm-generic/io.h assumes that the I/O ports are
mapped at /virtual/ address zero, which is even more crazy, since that
is normally in user space. Sorry for confusing it with physical address
zero.

Now the GENERIC_IOMAP uses a similar fiction by defining that virtual
address token 0x10000-0x1ffff are used to access I/O space when calling
inb/outb, but that is something you only need to do when you have
no memory mapped I/O port.

Some older ARM platforms (PXA for instance) also defined the I/O space
to start at virtual address zero, and use a per-bus io_offset that was
equal to the ioremapped I/O window. This actually works, but it means
that the logical port numbers are all high, and you have to set
IO_SPACE_LIMIT to ULONG_MAX, and it breaks horribly for any driver that
tries to store a port number in a type that is shorter than 'unsigned
long'. We definitely don't want to do this for new code.

> > > My main concern with the existing API is the requirement to have a subsys_initcall
> > > in your host bridge or mach code, due to the way the initialisation is done (you
> > > need the DT code to probe your driver, but you cannot start the scanning of the
> > > PCI bus until the arch code is initialised, so it gets deferred via
> > > subsys_initcall when it calls pci_common_init). I bet that if one tries to
> > > instantiate a Tegra PCI host bridge controller on a Marvell platform things will
> > > break pretty quickly (random example here).
> >
> > I'm not following here. All the new host controller drivers should
> > be platform drivers that only bind to the host devices in DT
> > that are present. Both mvebu and tegra use a normal "module_platform_driver"
> > for initialization, not a "subsys_initcall".
> 
> I was actually looking at mach-dove, I thought that was Marvell as well.

mach-dove is going away soon, it will get merged into mach-mvebu and
then use drivers/pci/host/pci-mvebu.c
 
> But both mvebu and tegra call pci_common_init_dev. The busnr gets assigned based on
> the registration order. I wonder if any of the host bridge code copes with having
> assigned a bus number other than zero for its "root bus".

I think all "new" host bridges now use nr_controllers=1, which means
that you always start at but number zero and use PCI domain if
you have multiple independent root bridges.

> >
> > Right. I guess we can support both interfaces on ARM32 for the forseeable
> > future (renaming the new one) and just change the existing implementation
> > to update the bitmap. Any cross-platform host controller driver would
> > have to use the new interface however.
> 
> OK, I can try to add the function to my patch. Call it pci_ioremap_iores?

Sounds ok, I can't think of anything better at least.

	Arnd
