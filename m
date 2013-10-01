Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3JAHfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:35:54 -0400
Received: from ozlabs.org ([203.10.76.45]:55183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3JAHfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:35:51 -0400
Date: Tue, 1 Oct 2013 17:35:48 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Tejun Heo <tj@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131001073548.GI17966@concordia>
References: <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918142231.GA21650@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 09:22:31AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 18, 2013 at 11:48:00AM +0200, Alexander Gordeev wrote:
> > On Wed, Sep 18, 2013 at 12:30:23AM +1000, Michael Ellerman wrote:
> > > How about no?
> > > 
> > > We have a small number of MSIs available, limited by hardware &
> > > firmware, if we don't impose a quota then the first device that probes
> > > will get most/all of the MSIs and other devices miss out.
> > 
> > Out of curiosity - how pSeries has had done it without quotas before
> > 448e2ca ("powerpc/pseries: Implement a quota system for MSIs")?
> 
> Hmmm... do we need to treat this any differently?  If the platform
> can't allocate full range of requested MSIs, just failing should be
> enough regardless of why such allocation can't be met, no?
> 
> > > Anyway I don't see what problem you're trying to solve? I agree the
> > > -ve/0/+ve return value pattern is ugly, but it's hardly the end of the
> > > world.
> > 
> > Well, the interface recently has been re-classified from "ugly" to
> > "unnecessarily complex and actively harmful" in Tejun's words ;)
> 
> LOL. :)
> 
> > Indeed, I checked most of the drivers and it is incredible how people
> > are creative in misusing the interface: from innocent pci_disable_msix()
> > calls when if pci_enable_msix() failed to assuming MSI-Xs were enabled
> > if pci_enable_msix() returned a positive value (apparently untested).
> > 
> > Roughly third of the drivers just do not care and bail out once
> > pci_enable_msix() has not succeeded. Not sure how many of these are
> > mandated by the hardware.
> 
> Yeah, I mean, this type of interface is a trap.  People have to
> actively resist to avoid doing silly stuff which is a lot to ask.

I really think you're overstating the complexity here.

Functions typically return a boolean   -> nothing to see here
This function returns a tristate value -> brain explosion!


> > 	/*
> > 	 * Retrieving 'nvec' by means other than pci_msix_table_size()
> > 	 */
> > 
> > 	rc = pci_get_msix_limit(pdev);
> > 	if (rc < 0)
> > 		return rc;
> > 
> > 	/*
> > 	 * nvec = min(rc, nvec);
> > 	 */
> > 
> > 	for (i = 0; i < nvec; i++)
> > 		msix_entry[i].entry = i;
> > 
> > 	rc = pci_enable_msix(pdev, msix_entry, nvec);
> > 	if (rc)
> > 		return rc;
> 
> I really think what we should do is
> 
> * Determine the number of MSIs the controller wants.  Don't worry
>   about quotas or limits or anything.  Just determine the number
>   necessary to enable enhanced interrupt handling.
> 	
> * Try allocating that number of MSIs.  If it fails, then just revert
>   to single interrupt mode.  It's not the end of the world and mostly
>   guaranteed to work.  Let's please not even try to do partial
>   multiple interrupts.  I really don't think it's worth the risk or
>   complexity.

It will potentially break existing setups on our hardware.

Can I make that any clearer?

cheers
