Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab3GLLLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:11:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41470 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab3GLLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:11:23 -0400
Date: Fri, 12 Jul 2013 13:11:21 +0200
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
Message-ID: <20130712111121.GB3515@amd.pavel.ucw.cz>
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

Yep. Wired ethernet has the problems.

> On Pavel's system, the FADT says we shouldn't enable OSPM control of
> ASPM (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One
> effect is that we don't blacklist the pre-1.1 82573L device, which I
> think results in it being left with the BIOS configuration, which
> apparently has ASPM enabled.  (Pavel, could you confirm the BIOS
> config, e.g., with "pci=earlydump"?)

Dump sent in another mail.

> e1000e claims to disable ASPM, but because aspm_disabled is set, the
> driver's call to pci_disable_link_state_locked() actually does nothing
> [1].
> 
> I experimented [2] with Windows and found that when a driver requests
> PciASPMOptOut, Windows will not touch ASPM config if the _OSC method
> fails, i.e., the BIOS declines to grant ASPM control to the OS.
> However, I do not know if Windows similarly ignores PciASPMOptOut when
> the FADT ACPI_FADT_NO_ASPM bit is set.

Ok, so we get copy of Windows, including the problem :-(.

> [1] We just merged 2add0ec1, which adds a "can't disable ASPM; OS
> doesn't have ASPM control" message in this case, but I don't think
> Pavel's kernel has this change.  It doesn't change the behavior
> anyway.

Oops.

Ok, so we have BIOS on x60 that sets up hardware in a way that does
not work... and then tells us we must not do ASPM, so we don't fix it.
 
One option would be "always disable ASPM, even if BIOS tells us it is
not supported".

Other option would be "add explicit blacklist for x60, disable ASPM
there.".

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
