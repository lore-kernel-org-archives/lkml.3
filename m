Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbaCTQqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:46:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36518 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaCTQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
References: <20140224162400.GE16457@pd.tnic> <4205942.Tp8ltEsv6e@vostro.rjw.lan>
 <532A514C.5010106@intel.com> <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Mar 2014 10:45:52 -0600
Message-ID: <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "Lu, Aaron" <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 9:03 PM, Zhang, Rui <rui.zhang@intel.com> wrote:

> I've talked with Yan Zheng, and I was told that this resource "0xfed10000 - 0xfed15fff"
> is got from PCI device register directly, which is not in its BAR range.
> Thus IMO, it is impossible for PNP layer to be aware of this resource.

Slow down, this isn't quite correct.  The *base* address (0xfed10000)
is from a PCI config register (MCHBAR, at PCI config offset 0x48) [1].
 This is a device-dependent register, so the PCI core knows neither
the base nor the size.

The device consumes address space that is not reported via the
architected PCI mechanism, so the only way to report that space is via
the PNP0C02 ACPI device.  The BIOS has to determine the base and size
based on its knowledge of the hardware.  On this hardware, per the
spec in [1], the region described by MCHBAR is 32KB in size.

The 0x6000 (24KB) size of the region above comes from the driver and
is actually less than what the device consumes.  It is legal for a
driver to request only the area it requires, but the entire area
consumed by the device should be reported via the PNP0C02 device.  The
fact that PNP0C02 reports 16KB but the device actually consumes 32KB
is a BIOS defect.  This probably happened because previous versions of
this chip consumed only 16KB, and the BIOS didn't get updated for the
change.

> BTW, about drivers/pnp/system.c, if its ONLY purpose is to prevent those
> resources from being allocated to uninitialized PCI devices, then IMO,
> the best way to do this is make PCI bus handle those PNP0C01/PNP0C02
> resources directly, probably via a platform callback, say,
> 1. make drivers/pnp/system.c a no-op for PNPACPI, by checking pnp_dev->protocol.
> 2. introduce acpi_check_reserved_resource() to parsing PNP0C01/PNP0C02 resources.
> 3. in PCI bus, invoke acpi_check_reserved_resource() when assigning
>    resources to PCI devices.

The purpose of system.c is indeed to prevent resources from being
allocated to other devices.  This is really a question for Rafael, but
in my opinion this function (reserving resources of PNP/ACPI devices
to prevent their allocation to other devices) should be done for *all*
PNP and ACPI devices, not just the PNP0C01/PNP0C02 devices handled by
system.c.

So I think the best solution would be to move that into the ACPI core
somehow so it happens for all devices.  If we had that, we could get
rid of system.c altogether, and we wouldn't have to do anything
special in PCI.  This is much easier to say than to do, however,
because there are all kinds of issues with legacy resource
reservations, and we currently can't really deal with overlapping
resources.

Bjorn

[1] https://www-ssl.intel.com/content/www/us/en/processors/core/4th-gen-core-family-desktop-vol-2-datasheet,
sec. 3.1.2 on p. 61
