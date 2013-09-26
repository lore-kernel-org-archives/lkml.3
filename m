Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3IZNMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:12:01 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:59973 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3IZNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:58 -0400
Date: Thu, 26 Sep 2013 09:11:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
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
Message-ID: <20130926131147.GA31249@mtj.dyndns.org>
References: <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
 <20130920122736.GD7630@mtj.dyndns.org>
 <20130925180220.GB26273@google.com>
 <20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
 <20130925210016.GA8926@htj.dyndns.org>
 <20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 26, 2013 at 09:46:46AM +0200, Alexander Gordeev wrote:
> > Can you please go into a bit of detail on that?  Why does it matter?
> 
> Because otherwise we will re-introduce a problem described by Michael:
> "We have a small number of MSIs available, limited by hardware &
> firmware, if we don't impose a quota then the first device that probes
> will get most/all of the MSIs and other devices miss out."

Still not following.  Why wouldn't just letting the drivers request
the optimal number they want and falling back to single interrupt mode
work?  ie. why can't we just have an all or nothing interface?

> > Is it because you're worried you might cause performance regression by
> > forcing prevoius partial multiple allocations to single interrupt
> > operation?
> 
> Well, not really. I think it won't be possible to force people not to use
> partial allocations anyway. Some controllers just do not care how many MSIs
> they are configured with. Some drivers derive the number of MSIs desired
> from the number of CPUs online - in such cases allocating more MSIs (i.e.
> a number the controller advertised) could cause a performance degradation
> even.

Yeah, sure thing but just let the *driver* decide that number without
worrying about how many they can actually get.  Ultimately, what we
want is removing this extra variable which can arbitrarily affect the
number of allocated interrupts so that we only have to worry about
either proper multiple MSI mode or single interrupt mode, not
something random inbetween.  It is possible that there exists a driver
which absolutely requires partial allocation on certain archs, but
that should be a very special case and the interface should look
accordingly ugly / special.  But do we actually have those?

Thanks.

-- 
tejun
