Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3JBCdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 22:33:46 -0400
Received: from ozlabs.org ([203.10.76.45]:37109 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3JBCdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 22:33:44 -0400
Date: Wed, 2 Oct 2013 12:33:38 +1000
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
Message-ID: <20131002023337.GB22748@concordia>
References: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20131001073548.GI17966@concordia>
 <20131001115503.GA23722@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001115503.GA23722@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 07:55:03AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 01, 2013 at 05:35:48PM +1000, Michael Ellerman wrote:
> > > > Roughly third of the drivers just do not care and bail out once
> > > > pci_enable_msix() has not succeeded. Not sure how many of these are
> > > > mandated by the hardware.
> > > 
> > > Yeah, I mean, this type of interface is a trap.  People have to
> > > actively resist to avoid doing silly stuff which is a lot to ask.
> > 
> > I really think you're overstating the complexity here.
> > 
> > Functions typically return a boolean   -> nothing to see here
> > This function returns a tristate value -> brain explosion!
> 
> It is an interface which forces the driver writers to write
> complicated fallback code which won't usually be excercised.  

It does not force anyone to do anything. That's just bull.

Code which is unwilling or unable to cope with the extra complexity
can simply do:

if (pci_enable_msix(..))
	goto fail;

It's as simple as that.

> > > * Determine the number of MSIs the controller wants.  Don't worry
> > >   about quotas or limits or anything.  Just determine the number
> > >   necessary to enable enhanced interrupt handling.
> > > 	
> > > * Try allocating that number of MSIs.  If it fails, then just revert
> > >   to single interrupt mode.  It's not the end of the world and mostly
> > >   guaranteed to work.  Let's please not even try to do partial
> > >   multiple interrupts.  I really don't think it's worth the risk or
> > >   complexity.
> > 
> > It will potentially break existing setups on our hardware.
> 
> I think it'd be much better to have a separate interface for the
> drivers which actually require it *in practice* rather than forcing
> everyone to go "oh this interface supports that, I don't know if I
> need it but let's implement fallback logic which I won't and have no
> means of testing".  

Sure, that's easy:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..48d0252 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -988,6 +988,18 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 }
 EXPORT_SYMBOL(pci_enable_msix);
 
+int pci_enable_msix_or_fail(struct pci_dev *dev, struct msix_entry *entries,
+                           int nvec)
+{
+       int rc;
+
+       rc = pci_enable_msix(dev, entries, nvec);
+       if (rc > 0)
+               rc = -ENOSPC;
+
+       return rc;
+}
+
 void pci_msix_shutdown(struct pci_dev *dev)
 {
        struct msi_desc *entry;


> Are we talking about some limited number of device drivers here?  

I don't have a list, but yeah there are certain drivers that folks care about.

> Also, is the quota still necessary for machines in production today?

As far as I know yes. The number of MSIs is growing on modern systems, but so
is the number of cpus and devices.

cheers
