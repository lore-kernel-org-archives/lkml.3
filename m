Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3IZHox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3IZHov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:44:51 -0400
Date: Thu, 26 Sep 2013 09:46:46 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
References: <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
 <20130920122736.GD7630@mtj.dyndns.org>
 <20130925180220.GB26273@google.com>
 <20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
 <20130925210016.GA8926@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925210016.GA8926@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 05:00:16PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 25, 2013 at 10:58:05PM +0200, Alexander Gordeev wrote:
> > Unfortunately, pSeries is a shows-topper here :( It seems we have to
> > introduce pci_get_msi{,x}_limit() interfaces to honour the quota
> > thing.  I just hope the hardware set for pSeries is limited and we
> > won't need to use it for all drivers.
> 
> Can you please go into a bit of detail on that?  Why does it matter?

Because otherwise we will re-introduce a problem described by Michael:
"We have a small number of MSIs available, limited by hardware &
firmware, if we don't impose a quota then the first device that probes
will get most/all of the MSIs and other devices miss out."

> Is it because you're worried you might cause performance regression by
> forcing prevoius partial multiple allocations to single interrupt
> operation?

Well, not really. I think it won't be possible to force people not to use
partial allocations anyway. Some controllers just do not care how many MSIs
they are configured with. Some drivers derive the number of MSIs desired
from the number of CPUs online - in such cases allocating more MSIs (i.e.
a number the controller advertised) could cause a performance degradation
even.

So when driver authors will know/measure/believe their hardware performs
better with partial allocations they will stand for it. What we can do is
to prevent those try-and-decrease fallbacks.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
