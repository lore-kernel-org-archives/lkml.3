Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaCEAAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:00:21 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63407 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaCEAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140304000904.GA6623@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org> <20140304000904.GA6623@srcf.ucam.org>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Wed, 5 Mar 2014 00:59:54 +0100
Message-ID: <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 1:09 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Actually, turns out there's a much easier way. Can you try this patch?
> I see the Thunderbolt controller after resume, although it doesn't seem
> to be in a working state.
>
> commit 102547d63e2cbbda42a25f650df9a33cf929a385
> Author: Matthew Garrett <matthew.garrett@nebula.com>
> Date:   Mon Mar 3 18:49:28 2014 -0500
>
>     ACPI: Support _OSI("Darwin") correctly
>
>     Apple hardware queries _OSI("Darwin") in order to determine whether the
>     system is running OS X, and changes firmware behaviour based on the answer.
>     The most obvious difference in behaviour is that Thunderbolt hardware is
>     forcibly powered down unless the system is running OS X. The obvious solution
>     would be to simply add Darwin to the list of supported _OSI strings, but this
>     causes problems.
>
>     Recent Apple hardware includes two separate methods for checking _OSI
>     strings. The first will check whether Darwin is supported, and if so will
>     exit. The second will check whether Darwin is supported, but will then
>     continue to check for further operating systems. If a further operating
>     system is found then later firmware code will assume that the OS is not OS X.
>     This results in the unfortunate situation where the Thunderbolt controller is
>     available at boot time but remains powered down after suspend.
>
>     The easiest way to handle this is to special-case it in the Linux-specific
>     OSI handling code. If we see Darwin, we should answer true and then disable
>     all other _OSI vendor strings.
>
>     Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 54a20ff..ef8656c 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -156,6 +156,16 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
>                         osi_linux.dmi ? " via DMI" : "");
>         }
>
> +       if (!strcmp("Darwin", interface)) {
> +               /*
> +                * Apple firmware will behave poorly if it receives positive
> +                * answers to "Darwin" and any other OS. Respond positively
> +                * to Darwin and then disable all other vendor strings.
> +                */
> +               acpi_update_interfaces(ACPI_DISABLE_ALL_VENDOR_STRINGS);
> +               supported = ACPI_UINT32_MAX;
> +       }
> +
>         return supported;
>  }
>
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org


I belive that the patch has the same effect as passing
    acpi_osi=! acpi_osi=Darwin
to the kernel. The problem with that approach is that it changes the
firmware behaviour quite a lot. In particular it prevents Linux from
taking over pci hotplug control:

acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 1f 0
acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM

Booting with just acpi_osi=Darwin (or without acpi_osi) gives:
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
acpi PNP0A08:00: _OSC: platform does not support [PME]
acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug AER PCIeCapability]


The end result is that that pci hotplog events are not handled. If I
unplug the Thunderbolt Ethernet adapter the device is not removed from
lspci.

I would prefer to find a solution that boots without acpi_osi=Darwin
as seems to trigger quite a lot of ACPI code. My current approach is
to inject a custom OSDW method somewhere into the NHI namespace and to
replace _PTS and _WAK from my driver. I can then wake the controller
with the XRPE method. The last problem is that the PCI code does not
allocate enough (or any) bus numbers below the hotplug ports. I'm
trying to add some quirks to it but the code is not really made for
that...


Andreas
