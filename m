Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3JALzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:55:10 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41572 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JALzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:55:07 -0400
Date: Tue, 1 Oct 2013 07:55:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
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
Message-ID: <20131001115503.GA23722@mtj.dyndns.org>
References: <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20131001073548.GI17966@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001073548.GI17966@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 01, 2013 at 05:35:48PM +1000, Michael Ellerman wrote:
> > > Roughly third of the drivers just do not care and bail out once
> > > pci_enable_msix() has not succeeded. Not sure how many of these are
> > > mandated by the hardware.
> > 
> > Yeah, I mean, this type of interface is a trap.  People have to
> > actively resist to avoid doing silly stuff which is a lot to ask.
> 
> I really think you're overstating the complexity here.
> 
> Functions typically return a boolean   -> nothing to see here
> This function returns a tristate value -> brain explosion!

It is an interface which forces the driver writers to write
complicated fallback code which won't usually be excercised.  The same
goes for the hardware.  In isolation, it doesn't look like much but
things like this are bound to lead to subtle bugs which are diffiuclt
to trigger.

> > * Determine the number of MSIs the controller wants.  Don't worry
> >   about quotas or limits or anything.  Just determine the number
> >   necessary to enable enhanced interrupt handling.
> > 	
> > * Try allocating that number of MSIs.  If it fails, then just revert
> >   to single interrupt mode.  It's not the end of the world and mostly
> >   guaranteed to work.  Let's please not even try to do partial
> >   multiple interrupts.  I really don't think it's worth the risk or
> >   complexity.
> 
> It will potentially break existing setups on our hardware.

I think it'd be much better to have a separate interface for the
drivers which actually require it *in practice* rather than forcing
everyone to go "oh this interface supports that, I don't know if I
need it but let's implement fallback logic which I won't and have no
means of testing".  Are we talking about some limited number of device
drivers here?  Also, is the quota still necessary for machines in
production today?

Thanks.

-- 
tejun
