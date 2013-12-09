Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3LILvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:51:13 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59256 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933133Ab3LILvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:51:10 -0500
Date: Mon, 9 Dec 2013 11:50:50 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core
 running without PCI on ARM64
Message-ID: <20131209115050.GA19163@arm.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312052304.22302.arnd@arndb.de>
 <52A1E794.1040008@linaro.org>
 <201312061823.26481.arnd@arndb.de>
 <52A54328.3000709@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52A54328.3000709@linaro.org>
Thread-Topic: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core
 running without PCI on ARM64
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:12:24AM +0000, Hanjun Guo wrote:
> On 2013-12-7 1:23, Arnd Bergmann wrote:
> > On Friday 06 December 2013, Tomasz Nowicki wrote:
> >> On 05.12.2013 23:04, Arnd Bergmann wrote:
> >>> On Wednesday 04 December 2013, Hanjun Guo wrote:
> >>>> On 2013年12月04日 00:41, Matthew Garrett wrote:
> >>>>> Given the number of #ifdefs you're adding, wouldn't it make more sense
> >>>>> to just add stub functions to include/linux/pci.h?
> >>>>
> >>>> Thanks for the suggestion :)
> >>>>
> >>>> I can add stub functions in include/linux/pci.h for raw_pci_read()/
> >>>> raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().
> >>>
> >>> Actually I wonder about the usefulness of this patch in either form: Since ACPI
> >>> on ARM64 is only for servers, I would very much expect them to always come with
> >>> PCI, either physical host bridges with attached devices, or logical PCI functions
> >>> used to describe the on-SoC I/O devices. Even in case of virtual machines, you'd
> >>> normally use PCI as the method to communicate data about the virtio channels.
> >>>
> >>> Can you name a realistic use-case where you'd want ACPI but not PCI?
> >>
> >> Yes you can describe SoC I/O devices using logical PCI functions only if 
> >> they are on PCI, correct me if I am wrong. Also, devices can be placed 
> >> only on IOMEM (like for ARM SoC) and it is hard to predict which way 
> >> vendors chose. So way don't let it be configurable? ACPI spec says 
> >> nothing like PCI is needed for ACPI, AFAIK.
> > 
> > You are right that today's ARM SoCs basically never use PCI to describe
> > internal devices (IIRC VIA VT8500 is an exception, but their PCI was
> > just a software fabrication).
> > 
> > However, when we're talking about ACPI on ARM64, that is nothing like classic
> > ARM SoCs: As Jon Masters mentioned, this is about new server hardware following
> > a (still secret, but hopefully not much longer) hardware specification that is
> > explicitly designed to allow interoperability between vendors, so they
> > must have put some thought into how to make the hardware discoverable. It
> > seems that they are modeling things after how it's done on x86, and the
> > only sensible way to have discoverable hardware there is PCI. This is
> > also what all x86 SoCs do.
> 
> I think the concern here is that ACPI is only for server platform or not.
> 
> Since ACPI has lots of content related to power management, I think ACPI
> can be used for mobile devices and other platform too, not only for ARM
> servers, and with this patch, we can support both requirement.

'Can be used' is one thing, will it really be used is another? I don't
think so, it was (well, is) difficult enough to make the transition to
FDT, I don't see how ACPI would solve the current issues.

I see ACPI as a server distro requirement and there are indeed benefits
in abstracting the hardware behind standard description, AML. Of course,
this would work even better with probe-able buses like PCIe and I'm
pretty sure this would be the case on high-end servers. But even if a
server distro like RHEL supports a SoC without PCIe, I would expect them
to only provide a single binary Image with CONFIG_PCI enabled.

This patch is small enough and allows ACPI build with !CONFIG_PCI for
the time being but longer term I would expect such SoCs without PCI to
be able to run on a kernel with CONFIG_PCI enabled.

-- 
Catalin
