Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3GLLw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:52:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab3GLLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:52:55 -0400
Date: Fri, 12 Jul 2013 13:52:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>, Greg KH <greg@kroah.com>,
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
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        mjg59@srcf.ucam.org
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130712115253.GA4585@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F90E999@ORSMSX102.amr.corp.intel.com>
 <20130710225715.GA23171@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710225715.GA23171@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Pavel's ThinkPad X60 has two NICs: Intel 82573L and Intel PRO/Wireless
> > > 3945ABG.  I'm pretty sure the problem he's reporting is with the 82573L.  Ping
> > > times are bad (~100msec) when ASPM is enabled, as reported by lspci.
> > > 
> > > On Pavel's system, the FADT says we shouldn't enable OSPM control of ASPM
> > > (ACPI_FADT_NO_ASPM is set), so we set "aspm_disabled = 1".  One effect is that
> > > we don't blacklist the pre-1.1 82573L device, which I think results in it being left
> > > with the BIOS configuration, which apparently has ASPM enabled.  (Pavel, could
> > > you confirm the BIOS config, e.g., with "pci=earlydump"?)
> > >
> > > e1000e claims to disable ASPM, but because aspm_disabled is set, the driver's
> > > call to pci_disable_link_state_locked() actually does nothing [1].
> > 
> > Yes, this is the problem we run into.  It would help if the call to pci_disable_link_state_locked() returned an error if ASPM is not disabled as requested so that drivers can then do the brute force disabling of it themselves.
> 
> I considered returning an error, but resisted because I think drivers
> will just handle the error by doing the brute-force disable themselves,
> and then we might as well drop the pci_disable_link_state() interface
> completely.

What is that? Yes, if function does not perform what it was asked to
do, it should return an error. Anything else is antisocial.

If drivers will attempt to do something _more_ antisocial (like doing
PCI bit banging) we can surely catch it during review.

[Actually, the functions seem to have "force" parameter. Should we
just let e1000e/iwlwifi set the force? They _know_ hardware will not
work properly with the ASPM.] 

> I proposed a patch [3] a while ago that made pci_disable_link_state()
> turn off ASPM unconditionally.  That would have the same effect as
> returning failure and having drivers disable ASPM themselves.  But
> Rafael and Matthew thought it was too risky [4] (and I think they're
> probably right because it does not match the Windows behavior).

Well, I believe "patch might be risky" is trumped by "this ethernet
card is not usable". 

> So by extension, I guess it would also be risky to return an error and
> have the driver disable ASPM.

It does not seem like clean conclusion to me.

Doing force-disabling on selected hardware that needs it (x60+e1000e)
is certainly less risky than changing behaviour for all the 1000
notebooks out there.

So yes, you should be returning error.

At the very least, e1000e and iwlwifi could warn the user loudly and
maybe even disable the interface.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
