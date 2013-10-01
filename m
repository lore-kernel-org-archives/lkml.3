Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3JAHvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:51:39 -0400
Received: from ozlabs.org ([203.10.76.45]:55641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab3JAHvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:51:37 -0400
Date: Tue, 1 Oct 2013 17:51:33 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131001075133.GJ17966@concordia>
References: <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 11:48:00AM +0200, Alexander Gordeev wrote:
> On Wed, Sep 18, 2013 at 12:30:23AM +1000, Michael Ellerman wrote:
> > How about no?
> > 
> > We have a small number of MSIs available, limited by hardware &
> > firmware, if we don't impose a quota then the first device that probes
> > will get most/all of the MSIs and other devices miss out.
> 
> Out of curiosity - how pSeries has had done it without quotas before
> 448e2ca ("powerpc/pseries: Implement a quota system for MSIs")?
> 
> > Anyway I don't see what problem you're trying to solve? I agree the
> > -ve/0/+ve return value pattern is ugly, but it's hardly the end of the
> > world.
> 
> Well, the interface recently has been re-classified from "ugly" to
> "unnecessarily complex and actively harmful" in Tejun's words ;)
> 
> Indeed, I checked most of the drivers and it is incredible how people
> are creative in misusing the interface: from innocent pci_disable_msix()
> calls when if pci_enable_msix() failed to assuming MSI-Xs were enabled
> if pci_enable_msix() returned a positive value (apparently untested).

OK, but we have the source to the drivers, we could just fix them.

We could even add:

  pci_enable_msix_i_am_stupid()

Which swallows the positive return and just gives back -ve/0.

> Roughly third of the drivers just do not care and bail out once
> pci_enable_msix() has not succeeded. Not sure how many of these are
> mandated by the hardware.

Sure, that's fine if those drivers do that, it's up to the drivers after
all.

> Another quite common pattern is a call to pci_enable_msix() to figure out
> the number of MSI-Xs available and a repeated call of pci_enable_msix()
> to enable those MSI-Xs, this time.

Also fine, though as the documentation suggests a loop is the best
construct rather than two explicit calls.

> The recommended practice would be:
> 
> 	/*
> 	 * Retrieving 'nvec' by means other than pci_msix_table_size()
> 	 */
> 
> 	rc = pci_get_msix_limit(pdev);
> 	if (rc < 0)
> 		return rc;
> 
> 	/*
> 	 * nvec = min(rc, nvec);
> 	 */
> 
> 	for (i = 0; i < nvec; i++)
> 		msix_entry[i].entry = i;
> 
> 	rc = pci_enable_msix(pdev, msix_entry, nvec);
> 	if (rc)
> 		return rc;
> 
> Thoughts?

We could probably make that work.

The disadvantage is that any restriction imposed on us above the quota
can only be reported as an error from pci_enable_msix().

The quota code, called from pci_get_msix_limit(), can only do so much to
interogate firmware about the limitations. The ultimate way to check if
firmware will give us enough MSIs is to try and allocate them. But we
can't do that from pci_get_msix_limit() because the driver is not asking
us to enable MSIs, just query them.

You'll also need to add another arch hook, for the quota check, and
we'll have to add it to our per-platform indirection as well.

All a lot of bother for no real gain IMHO.

cheers
