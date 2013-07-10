Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3GJWVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:21:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:63112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3GJWVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1038,1363158000"; 
   d="scan'208";a="266643369"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        "Joe Lawrence" <joe.lawrence@stratus.com>,
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
	<e1000-devel@lists.sourceforge.net>
Subject: RE: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Topic: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Index: AQHOfae/YJf6t4xSdkSmx+6rM4DMuJleeTOQ
Date: Wed, 10 Jul 2013 22:21:32 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F90E999@ORSMSX102.amr.corp.intel.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
In-Reply-To: <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
[..]

> Holy cow, you guys have a lot of folks listed in MAINTAINERS for Intel drivers :)
> This is an ASPM question, if that helps narrow down the folks interested.

Well, we try to have everyone involved, I guess.  I work on the server parts in the e1000e driver which includes 82573/4 and 82583.

[..]
> Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
> 3945ABG.  I'm pretty sure the problem he's reporting is with the 82573L.  Ping
> times are bad (~100msec) when ASPM is enabled, as reported by lspci.
> 
> On Pavel's system, the FADT says we shouldn't enable OSPM control of ASPM
> (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One effect is that
> we don't blacklist the pre-1.1 82573L device, which I think results in it being left
> with the BIOS configuration, which apparently has ASPM enabled.  (Pavel, could
> you confirm the BIOS config, e.g., with "pci=earlydump"?)
>
> e1000e claims to disable ASPM, but because aspm_disabled is set, the driver's
> call to pci_disable_link_state_locked() actually does nothing [1].

Yes, this is the problem we run into.  It would help if the call to pci_disable_link_state_locked() returned an error if ASPM is not disabled as requested so that drivers can then do the brute force disabling of it themselves.

> 
> I experimented [2] with Windows and found that when a driver requests
> PciASPMOptOut, Windows will not touch ASPM config if the _OSC method fails,
> i.e., the BIOS declines to grant ASPM control to the OS.
> However, I do not know if Windows similarly ignores PciASPMOptOut when the
> FADT ACPI_FADT_NO_ASPM bit is set.
> 
> The PCI core has failed spectacularly at providing useful ASPM interfaces.  Do
> you Intel folks have any suggestions about how to resolve this?  I assume that
> the Windows driver for the 82573L must disable ASPM somehow, even though
> ACPI_FADT_NO_ASPM is set.  Does it just use brute-force, as in the version of
> __e1000e_disable_aspm() that's used when CONFIG_PCIEASPM is not set? 

My friends in our Windows development team told me that the driver doesn't try to disable  ASPM basically because we can't.  I'm not sure if the same issue presents in Windows the same way or not.

Hope this helps.

Carolyn

Carolyn Wyborny 
Linux Development 
Networking Division 
Intel Corporation 

> 
> Bjorn
> 
> [1] We just merged 2add0ec1, which adds a "can't disable ASPM; OS doesn't
> have ASPM control" message in this case, but I don't think Pavel's kernel has this
> change.  It doesn't change the behavior anyway.
> 
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=57331
