Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305AbaGPOsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:48:22 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61953 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbaGPOsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:48:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sinan Kaya <okaya@codeaurora.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Will Deacon <Will.Deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Wed, 16 Jul 2014 16:47:41 +0200
Message-ID: <9785692.7QoVkhofSt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKaR=SYtM7BKTgO_AN5Vb0GCjaiKbA=9Zr7qGB29R9-5Q@mail.gmail.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <201407091031.50402.arnd@arndb.de> <CAL_JsqKaR=SYtM7BKTgO_AN5Vb0GCjaiKbA=9Zr7qGB29R9-5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o2K9OoQvLnFLSVuWDseeThpKGRzB4XQq9rVlfqIzwz8
 otfLBVi33/DBF5hduurDsJh3kYgD/4rjQ1iZat6+dSWSsZgU9u
 nwzUB8/ogVNAZMSEnzMNIc+37BDlKZjarSZRhbplc9UmHhFoMr
 TqEJ+m+OTIdSRYbGc+3YYs7h3gnTBXEE3woqKaahVq7LZMCSzT
 pJy6ObCR9Z86LBBLfd4aYMi1ss3IQ3b5fT59ABSdourWlCfGk1
 VgH7nTkLIrMQH7fyWpjSzP/Dd1ZndammOmR6C2oJNah2dLXlbu
 QzvXse9SUchkEtO1u1C7QyPkhJTDtWUP3uu+krCJrifzq65sFn
 xr+b7Rq2E9t5LUp3yuW8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 09:35:37 Rob Herring wrote:
> On Wed, Jul 9, 2014 at 3:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 08 July 2014, Liviu Dudau wrote:
> >> On Mon, Jul 07, 2014 at 10:22:00PM +0100, Arnd Bergmann wrote:
> >> >
> >> > I looked at the other drivers briefly, and I think you indeed fix the Tegra
> >> > driver with this but break the integrator driver as mentioned above.
> >> > The other callers of of_pci_range_to_resource() are apparently not
> >> > impacted as they recalculate the values they get.
> >>
> >> I would argue that integrator version is having broken assumptions. If it would
> >> try to allocate that IO range or request the resource as returned currently by
> >> of_pci_range_to_resource (without my patch) it would fail. I know because I did
> >> the same thing in my host bridge driver and it failed miserably. That's why I
> >> tried to patch it.
> >
> > The integrator code was just introduced and the reason for how it does things
> > is the way that of_pci_range_to_resource() works today. We tried to cope with
> > it and not change the existing behavior in order to not break any other drivers.
> >
> > It's certainly not fair to call the integrator version broken, it just works
> > around the common code having a quirky interface. We should probably have
> > done of_pci_range_to_resource better than it is today (I would have argued
> > for it to return an IORESOURCE_MEM with the CPU address), but it took long
> > enough to get that merged and I was sick of arguing about it.
> >
> >> If the IO space is memory mapped, then we use the port number, the io_offset
> >> and the PCI_IOBASE to get to the virtual address that, when accessed, will
> >> generate the correct addresses on the bus, based on what the host bridge has
> >> been configured.
> >>
> >> This is the current level of my understanding of PCI IO.
> 
> What is io_offset supposed to be and be based on?

(you probably know most of this, but I'll explain it the long way
to avoid ambiguity).

io_offset is a concept used internally to translate bus-specific I/O port
numbers into Linux-global ports.

A simple example would be having two PCI host bridges each with a
(hardware) port range from 0 to 0xffff. These numbers are programmed
into "BARs" in PCI device config space and they are used on the physical
address lines in PCI or in the packet header on PCIe.

In Linux, we have a single logical port range that is seen by device
drivers, in the example the first host bridge would use ports 0-0xfffff
and the second one would use ports 0x10000-0x1ffff.

The PCI core uses the io_offset to translate between the two address
spaces when it does the resource allocation during bus probe, so a device
that gets Linux I/O port 0x10100 has its BAR programmed with 0x100 and
the struct resource filled as 0x10000.

When a PCI host bridge driver registers its root bus with the PCI core,
it passes the io_offset using the last argument to pci_add_resource_offset()
along with the Linux I/O port resource, so in the example the first
io_offset is zero, while the second one is 0x10000.

Note that there is no requirement for the I/O port range on the bus to
start at zero, and you can even have negative io_offset values to
deal with that, but this is the exception.

> >> Now, I believe Rob has switched entirely to using my series in some test that
> >> he has run and he hasn't encountered any issues, as long as one remembers in
> >> the host bridge driver to add the io_base offset to the .start resource. If
> >> not then I need to patch pci_v3.c.
> >
> > The crazy part of all these discussions is that basically nobody ever uses
> > I/O port access, so it's very hard to test and we don't even notice when
> > we get it wrong, but we end up spending most of the time for PCI host controller
> > reviews trying to get these right.
> 
> FWIW, I test i/o accesses with Versatile QEMU. The LSI53xxxx device in
> the model has a kconfig option to use i/o accesses. However, I have
> seen in the past this is an area where 2 wrongs can make a right.

Can you point me to a git tree with your kernel and dts?

	Arnd
