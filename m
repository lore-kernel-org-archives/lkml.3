Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3GJW5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:57:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33025 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3GJW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:57:19 -0400
Date: Wed, 10 Jul 2013 16:57:15 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        linux-pci@vger.kernel.org
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130710225715.GA23171@google.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F90E999@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6264F90E999@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Jul 10, 2013 at 10:21:32PM +0000, Wyborny, Carolyn wrote:
> > -----Original Message-----
> > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> [..]
> 
> > Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
> > 3945ABG.  I'm pretty sure the problem he's reporting is with the 82573L.  Ping
> > times are bad (~100msec) when ASPM is enabled, as reported by lspci.
> > 
> > On Pavel's system, the FADT says we shouldn't enable OSPM control of ASPM
> > (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One effect is that
> > we don't blacklist the pre-1.1 82573L device, which I think results in it being left
> > with the BIOS configuration, which apparently has ASPM enabled.  (Pavel, could
> > you confirm the BIOS config, e.g., with "pci=earlydump"?)
> >
> > e1000e claims to disable ASPM, but because aspm_disabled is set, the driver's
> > call to pci_disable_link_state_locked() actually does nothing [1].
> 
> Yes, this is the problem we run into.  It would help if the call to pci_disable_link_state_locked() returned an error if ASPM is not disabled as requested so that drivers can then do the brute force disabling of it themselves.

I considered returning an error, but resisted because I think drivers
will just handle the error by doing the brute-force disable themselves,
and then we might as well drop the pci_disable_link_state() interface
completely.

I proposed a patch [3] a while ago that made pci_disable_link_state()
turn off ASPM unconditionally.  That would have the same effect as
returning failure and having drivers disable ASPM themselves.  But
Rafael and Matthew thought it was too risky [4] (and I think they're
probably right because it does not match the Windows behavior).

So by extension, I guess it would also be risky to return an error and
have the driver disable ASPM.

> > I experimented [2] with Windows and found that when a driver requests
> > PciASPMOptOut, Windows will not touch ASPM config if the _OSC method fails,
> > i.e., the BIOS declines to grant ASPM control to the OS.
> > However, I do not know if Windows similarly ignores PciASPMOptOut when the
> > FADT ACPI_FADT_NO_ASPM bit is set.
> > 
> > The PCI core has failed spectacularly at providing useful ASPM interfaces.  Do
> > you Intel folks have any suggestions about how to resolve this?  I assume that
> > the Windows driver for the 82573L must disable ASPM somehow, even though
> > ACPI_FADT_NO_ASPM is set.  Does it just use brute-force, as in the version of
> > __e1000e_disable_aspm() that's used when CONFIG_PCIEASPM is not set? 
> 
> My friends in our Windows development team told me that the driver doesn't try to disable  ASPM basically because we can't.  I'm not sure if the same issue presents in Windows the same way or not.

So the Windows driver *never* disables ASPM, not even with its own
register writes?  So on a machine like Pavel's, it would run with ASPM
enabled?  (I'm assuming his BIOS leaves ASPM enabled; hopefully Pavel
can confirm that.)

If the Windows driver works with ASPM enabled but the Linux driver on the
same hardware requires ASPM to be disabled, it sounds like the Linux
driver just needs to be fixed.

[3] https://lkml.kernel.org/r/20130510225257.GA10847@google.com
[4] https://lkml.kernel.org/r/20130516225535.GA27962@google.com
