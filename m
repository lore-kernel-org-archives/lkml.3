Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3LESP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:15:58 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34871 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab3LESPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:15:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAD6G_RSvrHGa=OEBgoD_iM68eOzb_2Dq9FneuNjSX_+iTj0_zA@mail.gmail.com>
References: <CAD6G_RT0S43BrOeXxJ6d3p1ALbXkGumZCSPBaK1Bz=2pX3hHYQ@mail.gmail.com>
 <CAErSpo4DNqUpA6Cb_tanW3uRJ3J-4utCQwtRz3eYZETCMtniUQ@mail.gmail.com>
 <CAD6G_RR=toq_6tCav6Y9=EprK9LC3YfGO=scvWpcGfDpWwJbRA@mail.gmail.com>
 <CAErSpo57gPPY73nCHbfGVynZRde0jj9_kjpR=FKwY-uTXzY2cw@mail.gmail.com>
 <CAD6G_RTHNGg7XSnDMQ-H+hUzmh1RPn9gYUDf7vRdeETmTmTdzw@mail.gmail.com>
 <CAErSpo5jLsvMwjuWMctwgvjUrP-RyzxykXG5AbAvTp8K0PezNg@mail.gmail.com> <CAD6G_RSvrHGa=OEBgoD_iM68eOzb_2Dq9FneuNjSX_+iTj0_zA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Dec 2013 11:15:33 -0700
Message-ID: <CAErSpo41ATgzfdew=2=X4ULkoENPRaW_PikDLcjWJqeCf5sPMA@mail.gmail.com>
Subject: Re: Need help on Linux PCIe
To: Jagan Teki <jagannadh.teki@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 11:30 PM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
> On Wed, Dec 4, 2013 at 11:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Dec 4, 2013 at 10:00 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>>> On Wed, Dec 4, 2013 at 8:41 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> On Tue, Dec 3, 2013 at 11:20 PM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>>>>> Thanks for your quick response.
>>>>> Please find my comments below.
>>>>>
>>>>> On Tue, Dec 3, 2013 at 11:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>>>> On Tue, Dec 3, 2013 at 4:24 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I have few question on Linux PCIe subsystem, I am trying to understand
>>>>>>> the PCIe on ARM platform.
>>>>>>> 1. Compared to PCI, PCIe have an extra port functionalists/services
>>>>>>> which is implemented drivers/pci/pcie/* is it true?
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>> 2. PCIe root complex is same as Host controller drivers in linux drivers/host/*
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>> 3. As individual endpoint drivers are registered to pci_core as
>>>>>>> pci_driver_register, then what is the common call for registering
>>>>>>> individual HC driver to pci-core?
>>>>>>
>>>>>> The host controller-PCI core interface is not as mature as the
>>>>>> pci_register_driver() interface.  The basic interface is
>>>>>> pci_scan_root_bus().  If you skim through the drivers in
>>>>>> drivers/pci/host/* and drivers/acpi/pci_root.c, the interface to the
>>>>>> PCI core will be fairly obvious.  And you'll learn what the existing
>>>>>> practices are in case you need to add or modify something.
>>>>>
>>>>> OK.
>>>>>
>>>>> I understand the flow as below - please correct if am wrong.
>>>>>
>>>>> From low level (hw) - HC driver has a platform registration using
>>>>> platform_driver_register() to lower layer
>>>>> and then pci_scan_root_bus() --> pci_common_init_dev() registration to
>>>>> upper layer as PCI - BIOS and then ends.
>>>>
>>>> Yes.  Sometime HC drivers use platform_driver_register(); other use
>>>> something else depending on how the HC device is enumerated.  For
>>>> example, drivers/acpi/pci_root.c uses something else to deal with host
>>>> bridges in the ACPI namespace.
>>>>
>>>>> From upper level (app) - each endpoint driver has
>>>>> pci_driver_register() call to PCI Core for lower level
>>>>
>>>> Yes.
>>>>
>>>>> and then the upper level registration is based on endpoint().
>>>>
>>>> I don't know what you mean here (I don't know of a function named
>>>> "endpoint()").  But the driver model matches drivers to PCI functions
>>>> based on vendor and device IDs.  A Linux "pci_dev" is what the PCI
>>>> specs refer to as a "function."
>>> Sorry it's typo - added ()
>>>
>>>>
>>>>> What is the connection here for PCI-BIOS and PCI-Core here, does these
>>>>> are two different entities means there is no common call for these?
>>>>> I see for ARM - "arch/arm/kernel/bios32.c" is PCI-BIOS is it correct?
>>>>> does we have separate BIOS codes for architectures?
>>>>
>>>> The "pcibios_*" functions are architecture-specific things called by
>>>> the generic PCI core.  Generally, things specified by the PCI specs
>>>> are architecture-independent and should be in the PCI core
>>>> (drivers/pci/*).
>>>
>>> I have some good information to discuss from this thread.
>>> Can you please verify this Linux PCIe subsystem stack - comment
>>> whether my understanding is correct/not.
>>> (I just draw this based on driver calls flow - to accommodate with in
>>> the Linux cores)
>>> http://jagannadhteki.blog.com/2013/12/04/linux-pcie-subsystem/
>>
>> Yes, that makes sense.  I wouldn't label the PCIBIOS - PCI core link
>> as "pci_bus_add_device()"; pci_bus_add_device() is part of the PCI
>> core's generic enumeration code and shouldn't be called by
>> arch-specific code.  The link going from PCI core to PCIBIOS is the
>> set of "pcibios_*()" functions.  Going from PCIBIOS to the PCI core,
>> it's mostly just pci_scan_root_bus().
> Yes - understand your point.
> I made few changes accordingly.
> http://jagannadhteki.blog.com/files/2013/12/Linux_PCIe_zynq.png

Why did you keep the pci_bus_add_device() label?  There are no calls
from arch code.  The only calls from outside the PCI core are from
i82875p_setup_overfl_dev(), asus_rfkill_hotplug(), and
eeepc_rfkill_hotplug().  These are all hacks that should not be
emulated.

Bjorn
