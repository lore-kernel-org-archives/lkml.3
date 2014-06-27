Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaF0Aop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:44:45 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53550 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaF0Aon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:44:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140626085926.GB11244@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <20140405001953.GE15806@google.com> <20140407083120.GE17163@e106497-lin.cambridge.arm.com>
 <5183143.FxBNM0xTAV@wuerfel> <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
 <20140626085926.GB11244@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 26 Jun 2014 19:44:21 -0500
Message-ID: <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Michael Simek...

On Thu, Jun 26, 2014 at 3:59 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> (sorry for replying to a months old thread)
>
> On Mon, Apr 07, 2014 at 06:58:24PM +0100, Bjorn Helgaas wrote:
>> On Mon, Apr 7, 2014 at 5:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> > I think migrating other architectures to use the same code should be
>> > a separate effort from adding a generic implementation that can be
>> > used by arm64. It's probably a good idea to have patches to convert
>> > arm32 and/or microblaze.
>>
>> Let me reiterate that I am 100% in favor of replacing arch-specific
>> code with more generic implementations.
>>
>> However, I am not 100% in favor of doing it as separate efforts
>> (although maybe I could be convinced).  The reasons I hesitate are
>> that (1) if only one architecture uses a new "generic" implementation,
>> we really don't know whether it is generic enough, (2) until I see the
>> patches to convert other architectures, I have to assume that I'm the
>> one who will write them, and (3) as soon as we add the code to
>> drivers/pci, it becomes partly my headache to maintain it, even if
>> only one arch benefits from it.
>
> I agree and understand your point.
>
>> Please don't think I'm questioning anyone's intent or good will.  It's
>> just that I understand the business pressures, and I know how hard it
>> can be to justify this sort of work to one's management, especially
>> after the immediate problem has been solved.
>
> But, unfortunately, that's something we failed to address in reasonable
> time (even though I was one of the proponents of the generic PCIe
> implementation). This work is very likely to slip further into the late
> part of this year and I am aware that several ARM partners are blocked
> on the (upstream) availability of PCIe support for the arm64 kernel.
>
> Although a bit late, I'm raising this now and hopefully we'll come to a
> conclusion soon. Delaying arm64 PCIe support even further is not a real
> option, which leaves us with:
>
> 1. Someone else (with enough PCIe knowledge) volunteering to take over
>    soon or

Well, I might have 2 months ago, but now I'm pretty booked up.

> 2. Dropping Liviu's work and going for an arm64-specific implementation
>    (most likely based on the arm32 implementation, see below)

3. Keeping Liviu's patches leaving some of the architecture specific
bits. I know Arnd and I both commented on it still needing more common
pieces, but compared to option 2 that would be way better.

Let's look at the patches in question:

3e71867 pci: Introduce pci_register_io_range() helper function.
6681dff pci: OF: Fix the conversion of IO ranges into IO resources.

Both OF patches. I'll happily merge them.


2d5dd85 pci: Create pci_host_bridge before its associated bus in
pci_create_root_bus.
f6f2854 pci: Introduce a domain number for pci_host_bridge.
524a9f5 pci: Export find_pci_host_bridge() function.

These don't seem to be too controversial.


fb75718 pci: of: Parse and map the IRQ when adding the PCI device.

6 LOC. Hardly controversial.


920a685 pci: Add support for creating a generic host_bridge from device tree

This function could be moved to drivers/of/of_pci.c if having it in
drivers/pci is too much maintenance burden. However, nearly the same
code is already being duplicated in every DT enabled ARM PCI host
driver and will continue as more PCI hosts are added. So this isn't
really a question of converting other architectures to common PCI host
infrastructure, but converting DT based PCI hosts to common
infrastructure. ARM is the only arch moving host drivers to
drivers/pci ATM. Until other architectures start doing that,
converting them is pointless.

bcf5c10 Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.

Seems like an independent fix that should be applied regardless.


7cfde80 arm64: Add architecture support for PCI

What is here is really just a function of which option we pick.


> First option is ideal but there is work to do as laid out by Arnd here:
>
> http://article.gmane.org/gmane.linux.kernel/1679304

I don't agree arm32 is harder than microblaze. Yes, converting ALL of
arm would be, but that is not necessary. With Liviu's latest branch
the hacks I previously needed are gone (thanks!), and this is all I
need to get Versatile PCI working (under QEMU):

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 3d23418..22b7529 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -178,6 +178,7 @@ static inline void __iomem *__typesafe_io(unsigned
long addr)

 /* PCI fixed i/o mapping */
 #define PCI_IO_VIRT_BASE       0xfee00000
+#define PCI_IOBASE             PCI_IO_VIRT_BASE

 #if defined(CONFIG_PCI)
 void pci_ioremap_set_mem_type(int mem_type);

Hum, so I guess now I've converted ARM...

Here's a branch with my changes[1]. And BTW, it also has
multi-platform support for Versatile as moving the PCI host to DT (and
drivers/pci/host) is about the last remaining obstacle.

Rob

[1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
versatile-pci-v2
