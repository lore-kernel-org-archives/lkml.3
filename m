Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3GLLEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:04:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3GLLEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:04:04 -0400
Date: Fri, 12 Jul 2013 13:03:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bjorn Helgaas <bhelgaas@google.com>
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
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130712110349.GA3515@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [+cc Jeff, Jesse, et al, e1000-devel]
> 
> Holy cow, you guys have a lot of folks listed in MAINTAINERS for Intel
> drivers :)  This is an ASPM question, if that helps narrow down the
> folks interested.
> 
> On Wed, Jul 10, 2013 at 7:29 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> But:
> >> >> 1) it should not list unavailable options
> >> >>
> >> >> 2) operation not permitted seems like wrong error code for
> >> >> operation not supported.
> >> >
> >> > So I forcibly enabled ASPM, and now ping latencies are in normal
> >> > range... no matter how I set
> >> > /sys/module/pcie_aspm/parameters/policy. Strange.
> >> >
> >> > Any ideas what correct solution is?
> >> >                                                                         Pavel
> >> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >> > (but don't apply)
> > ...
> >> > diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> >> > index e4b1fb2..9a1b63e 100644
> >> > --- a/drivers/pci/pci-acpi.c
> >> > +++ b/drivers/pci/pci-acpi.c
> >> > @@ -382,7 +382,7 @@ static int __init acpi_pci_init(void)
> >> >
> >> >         if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
> >> >                 printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
> >> > -               pcie_no_aspm();
> >> > +//             pcie_no_aspm();
> >> >         }
> >> >
> >> >         ret = register_acpi_bus_type(&acpi_pci_bus);
> >>
> >> Hi Pavel,
> >>
> >> Interesting.  Can you collect dmesg and "lspci -vvv" output for both
> >> cases (high ping latency and normal ping latency)?
> >
> > Will do. Results are in attachment (200KB...)
> >
> >> Also, how much
> >> difference does this make in ping latency?
> >
> > The ping latency goes from 100msec range to <2msec.
> >
> >> If ASPM is enabled for a
> >> device, e.g., your NIC, the link may be put in a low power state when
> >> the device is idle.  It takes time to exit that low power state, of
> >> course, but I would expect that time to be in the microsecond time and
> >> probably not observable via ping.
> >
> > I'd hope so. 100msec ping makes ssh unpleasant to use.
> 
> Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
> 3945ABG.  I'm pretty sure the problem he's reporting is with the
> 82573L.  Ping times are bad (~100msec) when ASPM is enabled, as
> reported by lspci.
> 
> On Pavel's system, the FADT says we shouldn't enable OSPM control of
> ASPM (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One
> effect is that we don't blacklist the pre-1.1 82573L device, which I
> think results in it being left with the BIOS configuration, which
> apparently has ASPM enabled.  (Pavel, could you confirm the BIOS
> config, e.g., with "pci=earlydump"?)

Here you go. It has the "aspm-disable-forced" change, so that ethernet
is usable, but that only affects boot later...


nitializing cgroup subsys cpu
Linux version 3.10.0+ (pavel@amd) (gcc version 4.4.5 (Debian 4.4.5-8) ) #290 SMP Fri Jul 12 12:37:00 CEST 2013
Disabled fast string operations
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000d2000-0x00000000000d3fff] reserved
BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000007f6cffff] usable
BIOS-e820: [mem 0x000000007f6d0000-0x000000007f6defff] ACPI data
BIOS-e820: [mem 0x000000007f6df000-0x000000007f6fffff] ACPI NVS
BIOS-e820: [mem 0x000000007f700000-0x000000007fffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
pci 0000:00:00.0 config space:
  00: 86 80 a0 27 06 01 90 20 03 00 00 06 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 17 20
  30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
  40: 01 90 d1 fe 01 40 d1 fe 05 00 00 f0 01 80 d1 fe
  50: 00 00 30 00 19 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 10 11 11 01 30 11 11 00 ff 03 00 00 80 1a 39 00
  a0: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 04 01 00 00
  e0: 09 00 09 51 02 04 0a 90 0e 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 03 00 10 00 00 00
pci 0000:00:02.0 config space:
  00: 86 80 a2 27 03 00 90 00 03 00 00 03 00 00 80 00
  10: 00 00 10 ee 01 18 00 00 08 00 00 d0 00 00 20 ee
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 1a 20
  30: 00 00 00 00 90 00 00 00 00 00 00 00 0b 01 00 00
  40: 00 00 00 00 48 00 00 00 09 00 09 51 02 04 0a 90
  50: 0e 00 30 00 19 00 00 00 00 00 00 00 00 00 80 7f
  60: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 05 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 03 00 64 34 ff 00 00 00 86 0f 03 00 00 00 00 00
pci 0000:00:02.1 config space:
  00: 86 80 a6 27 03 00 90 00 03 00 80 03 00 00 80 00
  10: 00 00 18 ee 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 1a 20
  30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00
  40: 00 00 00 00 48 00 00 00 09 00 09 51 02 04 0a 90
  50: 0e 00 30 00 19 00 00 00 00 00 00 00 00 00 80 7f
  60: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 03 00 64 34 ff 00 00 00 86 0f 03 00 00 00 00 00
pci 0000:00:1b.0 config space:
  00: 86 80 d8 27 06 01 10 00 02 00 03 04 10 00 00 00
  10: 04 00 24 ee 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 10 20
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 02 00 00
  40: 03 00 00 03 07 00 00 00 00 00 00 00 00 80 00 00
  50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
  60: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 10 00 91 00 00 00 00 00 00 08 10 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1c.0 config space:
  00: 86 80 d0 27 07 01 10 00 02 00 04 06 10 00 81 00
  10: 00 00 00 00 00 00 00 00 00 02 02 00 20 20 00 20
  20: 00 ee 00 ee f1 ff 01 00 00 00 00 00 00 00 00 00
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 04 00
  40: 10 80 41 01 c0 0f 00 00 00 00 11 00 11 2c 11 01
  50: 42 00 11 30 e0 a0 10 00 00 00 48 01 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 0d a0 00 00 aa 17 11 20 00 00 00 00 00 00 00 00
  a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 80 00 11 00 00 00 00 00
  e0: 00 0f c7 00 06 07 08 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1c.1 config space:
  00: 86 80 d2 27 07 01 10 00 02 00 04 06 10 00 81 00
  10: 00 00 00 00 00 00 00 00 00 03 03 00 30 40 00 20
  20: 00 ec f0 ed 01 e4 01 e4 00 00 00 00 00 00 00 00
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 04 00
  40: 10 80 41 01 c0 0f 00 00 00 00 10 00 11 2c 11 02
  50: 42 00 11 30 e0 a0 18 00 00 00 48 01 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 0d a0 00 00 aa 17 11 20 00 00 00 00 00 00 00 00
  a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 80 00 11 00 00 00 00 00
  e0: 00 0f c7 00 06 07 08 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1c.2 config space:
  00: 86 80 d4 27 07 01 10 00 02 00 04 06 10 00 81 00
  10: 00 00 00 00 00 00 00 00 00 04 0b 00 50 60 00 20
  20: 00 e8 f0 e9 11 e4 11 e4 00 00 00 00 00 00 00 00
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 03 04 00
  40: 10 80 41 01 c0 0f 00 00 00 00 10 00 11 4c 11 03
  50: 00 00 01 10 e0 a0 20 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 0d a0 00 00 aa 17 11 20 00 00 00 00 00 00 00 00
  a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 80 00 11 00 00 00 00 00
  e0: 00 00 c7 00 06 07 08 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1c.3 config space:
  00: 86 80 d6 27 07 01 10 00 02 00 04 06 10 00 81 00
  10: 00 00 00 00 00 00 00 00 00 0c 13 00 70 80 00 20
  20: 00 ea f0 eb 21 e4 21 e4 00 00 00 00 00 00 00 00
  30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 04 04 00
  40: 10 80 41 01 c0 0f 00 00 00 00 10 00 11 4c 11 04
  50: 00 00 01 10 e0 a0 28 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 90 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 0d a0 00 00 aa 17 11 20 00 00 00 00 00 00 00 00
  a0: 01 00 02 c8 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 80 00 11 00 00 00 00 00
  e0: 00 00 c7 00 06 07 08 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1d.0 config space:
  00: 86 80 c8 27 05 00 80 02 02 00 03 0c 00 00 80 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 21 18 00 00 00 00 00 00 00 00 00 00 aa 17 0a 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 3b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1d.1 config space:
  00: 86 80 c9 27 05 00 80 02 02 00 03 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 41 18 00 00 00 00 00 00 00 00 00 00 aa 17 0a 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1d.2 config space:
  00: 86 80 ca 27 05 00 80 02 02 00 03 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 61 18 00 00 00 00 00 00 00 00 00 00 aa 17 0a 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1d.3 config space:
  00: 86 80 cb 27 05 00 80 02 02 00 03 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 81 18 00 00 00 00 00 00 00 00 00 00 aa 17 0a 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1d.7 config space:
  00: 86 80 cc 27 06 01 90 02 02 20 03 0c 00 00 00 00
  10: 00 40 44 ee 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 0b 20
  30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 01 58 c2 c9 00 00 00 00 0a 00 a0 20 00 00 00 00
  60: 20 20 ff 01 00 00 00 00 01 00 00 00 00 00 0c c0
  70: 00 00 d5 3f 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 11 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 aa ff 00 ff 00 ff 00 20 00 00 88
  e0: 00 00 00 00 db b6 6d 00 00 00 00 00 00 00 00 00
  f0: 00 80 00 09 88 85 40 00 86 0f 02 00 06 17 02 20
pci 0000:00:1e.0 config space:
  00: 86 80 48 24 05 00 10 00 e2 01 04 06 00 00 01 00
  10: 00 00 00 00 00 00 00 00 00 15 18 20 90 c0 80 22
  20: 30 e4 f0 e7 01 e0 f1 e3 00 00 00 00 00 00 00 00
  30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 12 00 00
  50: 0d 00 00 00 aa 17 13 20 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1f.0 config space:
  00: 86 80 b9 27 07 00 10 02 02 00 01 06 00 00 80 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 09 20
  30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
  40: 01 10 00 00 80 00 00 00 81 11 00 00 10 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 0b 0b 0b 0b d2 00 00 00 0b 0b 0b 0b 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 10 02 0f 1f 01 16 7c 00 e1 15 0c 00 81 16 1c 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 24 02 02 00 00 00 00 00 13 00 00 e7 00 03 00 00
  b0: 00 00 f0 00 00 00 00 00 00 00 00 01 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 44 12 11 00 67 45 00 00 c0 ff 00 00 01 00 00 00
  e0: 09 00 0c 10 b4 02 24 17 00 00 00 00 00 00 00 00
  f0: 01 c0 d1 fe 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1f.1 config space:
  00: 86 80 df 27 05 00 88 02 02 8a 01 01 00 00 00 00
  10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
  20: 11 18 00 00 00 00 00 00 00 00 00 00 aa 17 0c 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 03 00 00
  40: 00 81 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1f.2 config space:
  00: 86 80 c5 27 07 00 b0 02 02 01 06 01 00 00 00 00
  10: d1 18 00 00 c5 18 00 00 c9 18 00 00 c1 18 00 00
  20: b1 18 00 00 00 44 44 ee 00 00 00 00 aa 17 0d 20
  30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 02 00 00
  40: 07 a3 00 80 00 00 00 00 01 00 02 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 01 00 02 40 00 00 00 00 00 00 00 00 00 00 00 00
  80: 05 70 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 40 00 11 10 80 01 00 4a 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 05 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:00:1f.3 config space:
  00: 86 80 da 27 01 01 80 02 02 00 05 0c 00 00 00 00
  10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  20: e1 18 00 00 00 00 00 00 00 00 00 00 aa 17 0f 20
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00
  40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
pci 0000:02:00.0 config space:
  00: 86 80 9a 10 07 01 10 00 00 00 00 02 10 00 00 00
  10: 00 00 00 ee 00 00 00 00 01 20 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 7e 20
  30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 20 00 0f
  d0: 05 e0 80 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 10 00 01 00 c1 0c 00 00 10 28 1a 00 11 1c 07 00
  f0: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:03:00.0 config space:
  00: 86 80 27 42 06 01 10 00 02 00 80 02 10 00 00 00
  10: 00 00 f0 ed 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 10 10
  30: 00 00 00 00 c8 00 00 00 00 00 00 00 0b 01 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 01 d0 22 c8 00 00 00 0d
  d0: 05 e0 80 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 10 00 11 00 c0 0e 00 00 10 08 1b 00 11 1c 07 00
  f0: 42 01 11 10 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:15:00.0 config space:
  00: 80 11 76 04 07 00 10 02 b4 00 07 06 00 00 82 00
  10: 00 00 30 e4 dc 00 00 02 15 16 18 b0 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 80 07
  40: aa 17 1c 20 e1 03 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 01 00 a0 04 00 00 00 00 63 04 63 04 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 f0 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 b2 00 30 00 00 00 00 00 00
  c0: aa 17 1c 20 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 0a fe
  e0: 00 40 c0 24 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:15:00.1 config space:
  00: 80 11 52 05 06 00 10 02 09 10 00 0c 00 00 80 00
  10: 00 10 30 e4 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 1e 20
  30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 02 02 04
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 80 80 16 00 00 00 00 00 20 00 00 66 66 32 12
  90: 48 60 66 10 00 00 02 00 50 00 00 00 00 01 18 00
  a0: 00 00 00 00 00 00 00 00 20 00 00 00 aa 17 1e 20
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 04
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 c8
  e0: 00 40 00 48 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
pci 0000:15:00.2 config space:
  00: 80 11 22 08 06 00 10 02 18 00 05 08 00 00 80 00
  10: 00 18 30 e4 00 00 00 00 00 00 00 00 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 1d 20
  30: 00 00 00 00 80 00 00 00 00 00 00 00 0b 03 00 00
  40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 01 00 02 fe 00 40 00 48 00 00 00 00 00 00 00 00
  90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  a0: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 1d 20
  b0: 00 00 02 00 00 00 00 00 00 00 00 00 a0 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: a1 21 80 01 00 00 00 00 40 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 c3 00 20 02 00 00 00 00
SMBIOS 2.4 present.
DMI: LENOVO 17097HU/17097HU, BIOS 7BETD3WW (2.14 ) 10/04/2007
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
initial memory mapped: [mem 0x00000000-0x017fffff]
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x37000000-0x373fffff]
 [mem 0x37000000-0x373fffff] page 4k
BRK [0x01212000, 0x01212fff] PGTABLE
init_memory_mapping: [mem 0x30000000-0x36ffffff]
 [mem 0x30000000-0x36ffffff] page 4k
BRK [0x01213000, 0x01213fff] PGTABLE
BRK [0x01214000, 0x01214fff] PGTABLE
BRK [0x01215000, 0x01215fff] PGTABLE
BRK [0x01216000, 0x01216fff] PGTABLE
init_memory_mapping: [mem 0x00100000-0x2fffffff]
 [mem 0x00100000-0x2fffffff] page 4k
init_memory_mapping: [mem 0x37400000-0x377fdfff]
 [mem 0x37400000-0x377fdfff] page 4k
ACPI: RSDP 000f67c0 00024 (v02 LENOVO)
ACPI: XSDT 7f6d191c 00084 (v01 LENOVO TP-7B    00002140  LTP 00000000)
ACPI: FACP 7f6d1a00 000F4 (v03 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI BIOS Bug: Warning: 32/64X length mismatch in FADT/Gpe1Block: 0/32 (20130328/tbfadt-572)
ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20130328/tbfadt-603)
ACPI: DSDT 7f6d1d90 0CFB9 (v01 LENOVO TP-7B    00002140 MSFT 0100000E)
ACPI: FACS 7f6f4000 00040
ACPI: SSDT 7f6d1bb4 001DC (v01 LENOVO TP-7B    00002140 MSFT 0100000E)
ACPI: ECDT 7f6ded49 00052 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: TCPA 7f6ded9b 00032 (v02 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: APIC 7f6dedcd 00068 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: MCFG 7f6dee35 0003C (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: HPET 7f6dee71 00038 (v01 LENOVO TP-7B    00002140 LNVO 00000001)
ACPI: BOOT 7f6defd8 00028 (v01 LENOVO TP-7B    00002140  LTP 00000001)
ACPI: SSDT 7f6f2645 0025F (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f28a4 000A6 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f294a 004F7 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: SSDT 7f6f2e41 001D8 (v01 LENOVO TP-7B    00002140 INTL 20050513)
ACPI: Local APIC address 0xfee00000
1150MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  Normal   [mem 0x01000000-0x377fdfff]
  HighMem  [mem 0x377fe000-0x7f6cffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0x7f6cffff]
On node 0 totalpages: 521838
free_area_init_node: node 0, pgdat c0c7cec0, node_mem_map f613f024
  DMA zone: 36 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3998 pages, LIFO batch:0
  Normal zone: 1962 pages used for memmap
  Normal zone: 223230 pages, LIFO batch:31
  HighMem zone: 2590 pages used for memmap
  HighMem zone: 294610 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
e820: [mem 0x80000000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 13 pages/cpu @f77c2000 s28992 r0 d24256 u53248
pcpu-alloc: s28992 r0 d24256 u53248 alloc=13*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519840
Kernel command line: BOOT_IMAGE=(hd0,2)/l/linux-good/arch/x86/boot/bzImage root=/dev/sda3 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps acpi_sleep=s3_bios,s3_mode no_console_suspend i915.modeset=1 video=inteldrmfb:mode=1024x768 fbcon=scrollback:64k pci=earlydump
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0007f6d0)
Memory: 2050576k/2087744k available (7550k kernel code, 36776k reserved, 3294k data, 452k init, 1178440k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0c98000 - 0xc0d09000   ( 452 kB)
      .data : 0xc095f932 - 0xc0c97500   (3294 kB)
      .text : 0xc0200000 - 0xc095f932   (7550 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=f5c1a000 soft=f5c1c000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3551 kB
 per task-struct memory footprint: 1152 bytes
ODEBUG: 10 of 10 active objects replaced
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 1828.779 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.55 BogoMIPS (lpj=7315116)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
tlb_flushall_shift: 6
debug: unmapping init [mem 0xc0d09000-0xc0d0ffff]
ACPI: Core revision 20130328
ACPI: All ACPI Tables successfully acquired
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz (fam: 06, model: 0e, stepping: 08)
Performance Events: Core events, core PMU driver.
... version:                1
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   0
... event mask:             0000000000000003
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
SMP alternatives: lockdep: fixing up alternatives
CPU 1 irqstacks, hard=f5dce000 soft=f5dd0000
smpboot: Booting Node   0, Processors  #1 OK
Initializing CPU#1
Disabled fast string operations
TSC synchronization [CPU#0 -> CPU#1]:
Measured 579909 cycles TSC warp between CPUs, turning off TSC clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
smpboot: Total of 2 processors activated (7315.11 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x7f6df000-0x7f6fffff] (135168 bytes)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: EC description table is found, configuring boot EC
ACPI: SSDT 7f6f1d26 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1feb 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 7f6f1c5e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 7f6f1f66 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: ACPI Dock Station Driver: 3 docks/bays found
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
acpi PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
acpi PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
acpi PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
acpi PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
acpi PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
acpi PNP0A08:00: host bridge window [mem 0xfed40000-0xfed40fff] (ignored)
PCI: root bus 00: using default resources
acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
pci 0000:00:00.0: [8086:27a0] type 00 class 0x060000
pci 0000:00:02.0: [8086:27a2] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
pci 0000:00:02.1: [8086:27a6] type 00 class 0x038000
pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1c.2: [8086:27d4] type 01 class 0x060400
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: System wakeup disabled by ACPI
pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.1: System wakeup disabled by ACPI
pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.2: System wakeup disabled by ACPI
pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: System wakeup disabled by ACPI
pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
pci 0000:00:1e.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.2: [8086:27c5] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: [8086:109a] type 00 class 0x020000
pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
acpiphp: Slot [1] registered
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.1: [1180:0552] type 00 class 0x0c0010
pci 0000:15:00.1: reg 10: [mem 0xe4301000-0xe43017ff]
pci 0000:15:00.1: PME# supported from D0 D3hot D3cold
pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
pci 0000:15:00.2: reg 10: [mem 0xe4301800-0xe43018ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] (conflicts with (null) [bus 15-18])
pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
pci_bus 0000:00: on NUMA node 0
acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x0f)
ACPI: Enabled 2 GPEs in block 00 to 1F
acpi root: \_SB_.PCI0 notify handler is installed
Found 1 acpi root devices
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
ACPI: bus type ATA registered
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
e820: reserve RAM buffer [mem 0x7f6d0000-0x7fffffff]
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
------------[ cut here ]------------
WARNING: at net/wireless/reg.c:434 regulatory_init+0x92/0xff()
db.txt is empty, you should update it...
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0+ #290
Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD3WW (2.14 ) 10/04/2007
 000001b2 f5d31e98 c095a48c f5d31ec0 c022c96f c0bd2964 f5d31eec 000001b2
 c0ccb800 c0ccb800 00000000 c0ccb6a3 f5d31f14 f5d31ed8 c022ca0e 00000009
 f5d31ed0 c0bd2964 f5d31eec f5d31f18 c0ccb800 c0bc9760 000001b2 c0bd2964
Call Trace:
 [<c095a48c>] dump_stack+0x16/0x18
 [<c022c96f>] warn_slowpath_common+0x5f/0x80
 [<c0ccb800>] ? regulatory_init+0x92/0xff
 [<c0ccb800>] ? regulatory_init+0x92/0xff
 [<c0ccb6a3>] ? cache_initialize+0x86/0x86
 [<c022ca0e>] warn_slowpath_fmt+0x2e/0x30
 [<c0ccb800>] regulatory_init+0x92/0xff
 [<c0ccb6fe>] cfg80211_init+0x5b/0xcb
 [<c0ccad9f>] ? bt_init+0x5d/0x87
 [<c0200182>] do_one_initcall+0xb2/0x170
 [<c0c9857f>] kernel_init_freeable+0xec/0x18c
 [<c0c9861f>] ? kernel_init_freeable+0x18c/0x18c
 [<c094c7cb>] kernel_init+0xb/0xd0
 [<c095e437>] ret_from_kernel_thread+0x1b/0x28
 [<c094c7c0>] ? rest_init+0xb0/0xb0
---[ end trace 081613cec593b52e ]---
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed41000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:01: [io  0x164e-0x164f] has been reserved
system 00:01: [io  0x1000-0x107f] has been reserved
system 00:01: [io  0x1180-0x11bf] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x15e0-0x15ef] has been reserved
system 00:01: [io  0x1600-0x165f] could not be reserved
system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
pnp 00:09: [dma 3]
pnp 00:09: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 11 devices
ACPI: bus type PNP unregistered
pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
pci 0000:00:1c.0: BAR 9: assigned [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
pci 0000:15:00.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
pci 0000:15:00.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
pci 0000:15:00.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:15:00.0: BAR 7: assigned [io  0x9000-0x90ff]
pci 0000:15:00.0: BAR 8: assigned [io  0x9400-0x94ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0xffff]
pci_bus 0000:15: resource 5 [mem 0x00000000-0xffffffff]
pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
pci_bus 0000:16: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.0: power state changed by ACPI to D0
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: power state changed by ACPI to D0
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.3: Performing full reset
PCI: CLS 64 bytes, default 64
Simple Boot Flag at 0x35 set to 0x1
bounce pool size: 64 pages
NTFS driver 2.1.30 [Flags: R/W].
fuse init (API version 7.22)
msgmni has been set to 1703
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
intel_idle: does not run on family 6 model 14
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (off-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
acpi device:02: registered as cooling_device0
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
ACPI: Requesting acpi_cpufreq
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (68 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (68 C)
GHES: HEST is not enabled!
ERST DBG: ERST support is disabled.
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Memory usable by graphics device = 256M
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 102x42
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
usbcore: registered new interface driver udl
loop: module loaded
nbd: registered device at major 43
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata6: port disabled--ignoring
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
e1000e 0000:02:00.0: Disabling ASPM L0s L1
e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
e1000e 0000:02:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:16:d3:25:19:04
e1000e 0000:02:00.0 eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:02:00.0 eth0: MAC: 2, PHY: 2, PBA No: 005302-003
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver cdc_ncm
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:201c]
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: ST9500325AS, 0001SDM1, max UDMA/133
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9500325AS      0001 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff:
 excluding 0xe4300000-0xe46cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff:
 excluding 0xe0000000-0xe3ffffff
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1d.7: setting latency timer to 64
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci-pci 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci-pci 0000:00:1d.7: reset command 0080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: supports USB remote wakeup
ehci-pci 0000:00:1d.7: irq 19, io mem 0xee444000
ehci-pci 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.10.0+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.10.0+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.0: FS/LS companion for 0000:00:1d.7
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: udev 1, busnum 3, minor = 256
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.10.0+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.1: FS/LS companion for 0000:00:1d.7
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
ehci-pci 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 1-0:1.0: port 7: status 0501 change 0001
ehci-pci 0000:00:1d.7: GetStatus port:8 status 001803 0  ACK POWER sig=j CSC CONNECT
hub 1-0:1.0: port 8: status 0501 change 0001
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: default language 0x0409
usb usb4: udev 1, busnum 4, minor = 384
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.10.0+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.2: FS/LS companion for 0000:00:1d.7
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend, wakeup 1
usb usb2: suspend_rh
usb usb5: default language 0x0409
usb usb5: udev 1, busnum 5, minor = 512
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.10.0+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.3: FS/LS companion for 0000:00:1d.7
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver ums-sddr09
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend, wakeup 1
usb usb3: suspend_rh
usbcore: registered new interface driver usbserial
hub 1-0:1.0: state 7 ports 8 chg 0180 evt 0000
hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
ehci-pci 0000:00:1d.7: port 7 full speed --> companion
ehci-pci 0000:00:1d.7: GetStatus port:7 status 003801 0  ACK POWER OWNER sig=j CONNECT
hub 1-0:1.0: port_wait_reset: err = -16
hub 1-0:1.0: port 7 not enabled, trying reset again...
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input4
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
uhci_hcd 0000:00:1d.3: port 1 portsc 009b,00
hub 5-0:1.0: port 1: status 0101 change 0003
uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
md: raid0 personality registered for level 0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
usbcore: registered new interface driver btusb
lguest: mapped switcher at ffe68000
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 18)
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:15:00.2: setting latency timer to 64
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD3WW (2.14 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
thinkpad_acpi: ACPI backlight control delay disabled
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
ehci-pci 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
thinkpad_acpi: warning: userspace override of important firmware LEDs is enabled
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input6
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
thinkpad_acpi: volume: disabled as there is no ALSA support in this kernel
ehci-pci 0000:00:1d.7: port 8 full speed --> companion
ehci-pci 0000:00:1d.7: GetStatus port:8 status 003801 0  ACK POWER OWNER sig=j CONNECT
hub 1-0:1.0: port_wait_reset: err = -16
hub 1-0:1.0: port 8 not enabled, trying reset again...
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input7
hda_intel: probe_mask set to 0x1 for device 17aa:2010
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
usbcore: registered new interface driver snd-usb-audio
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 17
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
Using IPI No-Shortcut mode
PM: Checking hibernation image partition /dev/sda1
PM: Hibernation image partition 8:1 present
PM: Looking for hibernation image.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
ehci-pci 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0180
ehci-pci 0000:00:1d.7: GetStatus port:7 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 7, status 0100, change 0001, 12 Mb/s
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend, wakeup 1
usb usb4: suspend_rh
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
rtc_cmos 00:06: setting system clock to 2013-07-12 10:58:37 UTC (1373626717)
ALSA device list:
  #0: HDA Intel at 0xee240000 irq 17
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
hub 1-0:1.0: debounce: port 7: total 100ms stable 100ms status 0x100
ehci-pci 0000:00:1d.7: GetStatus port:8 status 003002 0  ACK POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 8, status 0100, change 0001, 12 Mb/s
devtmpfs: mounted
debug: unmapping init [mem 0xc0c98000-0xc0d08fff]
Write protecting the kernel text: 7552k
Write protecting the kernel read-only data: 2772k
hub 1-0:1.0: debounce: port 8: total 100ms stable 100ms status 0x100
hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0004
hub 5-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend, wakeup 1
ehci-pci 0000:00:1d.7: suspend root hub
hub 5-0:1.0: port_wait_reset: err = -16
hub 5-0:1.0: port 1 not enabled, trying reset again...
usb 5-1: new full-speed USB device number 2 using uhci_hcd
usb 5-1: skipped 1 descriptor after interface
usb 5-1: default language 0x0409
usb 5-1: udev 2, busnum 5, minor = 513
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
btusb 5-1:1.0: usb_probe_interface
btusb 5-1:1.0: usb_probe_interface - got id
usb 5-1: adding 5-1:1.1 (config #1, interface 1)
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
usb 5-1: adding 5-1:1.2 (config #1, interface 2)
btusb 5-1:1.2: usb_probe_interface
btusb 5-1:1.2: usb_probe_interface - got id
usb 5-1: adding 5-1:1.3 (config #1, interface 3)
btusb 5-1:1.3: usb_probe_interface
btusb 5-1:1.3: usb_probe_interface - got id
uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 5-2: new full-speed USB device number 3 using uhci_hcd
usb 5-2: ep0 maxpacket = 8
usb 5-2: default language 0x0409
usb 5-2: udev 3, busnum 5, minor = 514
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
udev[1721]: starting version 164
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
 excluding 0xc0000-0xd3fff 0xdc000-0xfffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
 clean.
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
 excluding 0x60000000-0x60ffffff
uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0, 23 us
Adding 779148k swap on /dev/sda1.  Priority:-1 extents:1 across:779148k 
EXT3-fs (sda3): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (sda3): using internal journal
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): using internal journal
EXT3-fs (sda2): mounted filesystem with ordered data mode
EXT3-fs (sda4): error: can't find ext3 filesystem on dev sda4.
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input8
iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
sshd (3273): /proc/3273/oom_adj is deprecated, please use /proc/3273/oom_score_adj instead.
wlan0: authenticate with 00:11:95:05:30:d7
wlan0: send auth to 00:11:95:05:30:d7 (try 1/3)
wlan0: authenticated
iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
wlan0: associate with 00:11:95:05:30:d7 (try 1/3)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0 aid=3)
wlan0: associated

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
