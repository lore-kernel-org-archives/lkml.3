Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3FLAxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 20:53:55 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36830 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3FLAxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 20:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <875D89B79D1D86448A583A7302C022A054E844AA@G9W0337.americas.hpqcorp.net>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com> <875D89B79D1D86448A583A7302C022A054E844AA@G9W0337.americas.hpqcorp.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Jun 2013 18:53:32 -0600
Message-ID: <CAErSpo6wDNfeHE+5pVo1nCNVGEyU18PxPk_xnCjy0Pe0jx1tyw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: "Sumner, William" <bill.sumner@hp.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Your quoting is messed up below]
>> This is Takao's text
> This is Bill's text

On Tue, Jun 11, 2013 at 5:19 PM, Sumner, William <bill.sumner@hp.com> wrote:
>>(2013/06/11 11:20), Bjorn Helgaas wrote:
>>> On Fri, Jun 7, 2013 at 2:46 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:

>>Actually Vivek Goyal, kdump maintainer said same thing. He proposed using
>>reset_devices instead of adding new one, and using quirk or something to
>>avoid such a buggy devices.
>
> With respect to "and using quirk or something to avoid such buggy devices",
> I believe that it will be necessary to provide a mechanism for devices that
> need special handling to do the reset ...

You mean something like pci_dev_specific_reset()?

>>So, basically I agree with using reset_devices, but I want to prepare
>>workaround in case this reset causes something wrong.
>>
> I like the ability to specify the original "reset_devices" separately from
> invoking this new mechanism.  With so many different uses for Linux in
> so many different environments and with so many different device drivers
> it seems reasonable to keep the ability to tell the device drivers to
> reset their devices -- instead of pulling the reset line on all devices.

The problem with adding new options for this and that is it confuses
users and fragments testing.  Users already randomly try options and
publish combinations that happen to work as "solutions."  Then we
don't get problem reports and don't get a chance to fix things
properly.  The ideal OS would have zero options and be able to figure
everything out by itself.  So that's my bias about giving users
flexibility by adding new options -- I don't like it, and I think we
have to accept some lack of flexibility to keep the system complexity
tractable  :)

> ...
> Thinking out of the box:
> Much of the discussion about dealing with the ongoing DMA leftover
> from the system kernel has assumed that the crash kernel will reset
> the IOMMU -- which causes various problems if done while there is any DMA
> still active -- which leads to the idea of stopping all of the DMA.
>
> Suppose the crash kernel does not reset the hardware IOMMU, but simply
> detects that it is active, resets only the devices that are necessary
> for the crash kernel to operate, and re-programs only the translations
> for those devices.  All other translations remain the same (and remain valid)
> so all leftover DMA continues into its buffer in the system kernel area
> where it is harmless.  New translations needed by the kdump kernel are
> added to the existing tables.
>
> I have not yet tried this, so I am not ready to propose it as anything more
> than a discussion topic at this time.
>
> It might work this way: (A small modification to case 3a above)
>
> IOMMU on in system kernel, kdump kernel accepts active IOMMU
>    system kernel enables IOMMU
>       DMA targets IOMMU-mapped system-kernel memory
>    kexec to kdump kernel (IOMMU on, devices untouched)
>       DMA targets IOMMU-mapped system-kernel memory
>    kdump kernel detects active IOMMU and doesn't touch it
>       DMA targets IOMMU-mapped system-kernel memory
>    kdump kernel does not re-initialize IOMMU hardware
>    kdump kernel initializes IOMMU in-memory management structures
>    kdump kernel calls device drivers' standard initialization functions
>       Drivers initialize their own devices -- DMA from that device stops
>       When drivers request new DMA mappings, the kdump IOMMU driver:
>       1. Updates its in-memory mgt structures for that device & range
>       2. Updates IOMMU translate tables for that device & range
>          . Translations for all other devices & ranges are unchanged
>       3. Flushes IOMMU TLB to force IOMMU hardware update

This is certainly an interesting idea.

It would require some additional smarts in the IOMMU driver to take
over existing page tables.  Those data structures from the system
kernel are outside the memory map known to the kdump kernel, so
there'd likely be VM issues there.  The IOMMU driver would also have
to be able to reconstruct the state for the bus address space
allocator, e.g., use the I/O page tables to rebuild a bitmap of
allocated space.

We'll end up with a bunch of dma_map() calls from the system kernel
that don't have corresponding dma_unmap()s.  I guess when a driver
initializes its device, there might have to be a new interface to
"unmap any existing mappings for this device, even though I don't know
what they are."

I think it's possible, but it sounds like quite a lot of work and I'm
not sure it's worth it for this relatively limited use case.  And it's
more IOMMU-specific than a "reset devices" strategy, so most of it
would have to be done in each IOMMU driver.

Bjorn
