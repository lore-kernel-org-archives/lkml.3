Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3IRQsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3IRQsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:48:51 -0400
Date: Wed, 18 Sep 2013 18:50:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
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

That depends from what "full range of requested MSIs" is. If that is
a maximum number of MSIs the controller advertised, then no. As MSI
design essentially allows devices to operate in lower-than-maximum
modes it is responsibility of a caller to decide how many vectors to
request. So in case of pSeries I think it is completely legitimate to
request lessers to overcome the platform limitation and let all devices
work.

> I really think what we should do is
> 
> * Determine the number of MSIs the controller wants.  Don't worry
>   about quotas or limits or anything.  Just determine the number
>   necessary to enable enhanced interrupt handling.

Actually, I do not see much contradiction with what I proposed. The
key words here "determine the number of MSIs the controller wants".

In general case it is not what pci_msix_table_size() returns (or at
least we should not limit ourselves to it) - there could be non-
standard means to report number of MSIs: hardcoded, version-dependant,
device-specific registers etc.

Next, if we opt to determine the number of MSIs by non-MSI standard
means then there is no reason not to call pci_get_msix_limit() (or
whatever) at this step.

The question how I see it - do we want pci_get_msix_limit() interface
as part of the MSI framework or do we want it pSeries-specific?

> * Try allocating that number of MSIs.  If it fails, then just revert
>   to single interrupt mode.  It's not the end of the world and mostly
>   guaranteed to work.  Let's please not even try to do partial
>   multiple interrupts.  I really don't think it's worth the risk or
>   complexity.

Being Captain Obvious here, but it is up to the device driver to handle
a failure. There could be no such option as single MSI mode after all :)

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
