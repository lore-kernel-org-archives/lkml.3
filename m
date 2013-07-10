Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3GJT53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:57:29 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:65166 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3GJT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130710132950.GA3684@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz> <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz> <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com> <20130710132950.GA3684@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Jul 2013 13:57:02 -0600
Message-ID: <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Jeff, Jesse, et al, e1000-devel]

Holy cow, you guys have a lot of folks listed in MAINTAINERS for Intel
drivers :)  This is an ASPM question, if that helps narrow down the
folks interested.

On Wed, Jul 10, 2013 at 7:29 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> But:
>> >> 1) it should not list unavailable options
>> >>
>> >> 2) operation not permitted seems like wrong error code for
>> >> operation not supported.
>> >
>> > So I forcibly enabled ASPM, and now ping latencies are in normal
>> > range... no matter how I set
>> > /sys/module/pcie_aspm/parameters/policy. Strange.
>> >
>> > Any ideas what correct solution is?
>> >                                                                         Pavel
>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> > (but don't apply)
> ...
>> > diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>> > index e4b1fb2..9a1b63e 100644
>> > --- a/drivers/pci/pci-acpi.c
>> > +++ b/drivers/pci/pci-acpi.c
>> > @@ -382,7 +382,7 @@ static int __init acpi_pci_init(void)
>> >
>> >         if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
>> >                 printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
>> > -               pcie_no_aspm();
>> > +//             pcie_no_aspm();
>> >         }
>> >
>> >         ret = register_acpi_bus_type(&acpi_pci_bus);
>>
>> Hi Pavel,
>>
>> Interesting.  Can you collect dmesg and "lspci -vvv" output for both
>> cases (high ping latency and normal ping latency)?
>
> Will do. Results are in attachment (200KB...)
>
>> Also, how much
>> difference does this make in ping latency?
>
> The ping latency goes from 100msec range to <2msec.
>
>> If ASPM is enabled for a
>> device, e.g., your NIC, the link may be put in a low power state when
>> the device is idle.  It takes time to exit that low power state, of
>> course, but I would expect that time to be in the microsecond time and
>> probably not observable via ping.
>
> I'd hope so. 100msec ping makes ssh unpleasant to use.

Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
3945ABG.  I'm pretty sure the problem he's reporting is with the
82573L.  Ping times are bad (~100msec) when ASPM is enabled, as
reported by lspci.

On Pavel's system, the FADT says we shouldn't enable OSPM control of
ASPM (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One
effect is that we don't blacklist the pre-1.1 82573L device, which I
think results in it being left with the BIOS configuration, which
apparently has ASPM enabled.  (Pavel, could you confirm the BIOS
config, e.g., with "pci=earlydump"?)

e1000e claims to disable ASPM, but because aspm_disabled is set, the
driver's call to pci_disable_link_state_locked() actually does nothing
[1].

I experimented [2] with Windows and found that when a driver requests
PciASPMOptOut, Windows will not touch ASPM config if the _OSC method
fails, i.e., the BIOS declines to grant ASPM control to the OS.
However, I do not know if Windows similarly ignores PciASPMOptOut when
the FADT ACPI_FADT_NO_ASPM bit is set.

The PCI core has failed spectacularly at providing useful ASPM
interfaces.  Do you Intel folks have any suggestions about how to
resolve this?  I assume that the Windows driver for the 82573L must
disable ASPM somehow, even though ACPI_FADT_NO_ASPM is set.  Does it
just use brute-force, as in the version of __e1000e_disable_aspm()
that's used when CONFIG_PCIEASPM is not set?

Bjorn

[1] We just merged 2add0ec1, which adds a "can't disable ASPM; OS
doesn't have ASPM control" message in this case, but I don't think
Pavel's kernel has this change.  It doesn't change the behavior
anyway.

[2] https://bugzilla.kernel.org/show_bug.cgi?id=57331
