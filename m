Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3JAKde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 06:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3JAKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:33:31 -0400
Date: Tue, 1 Oct 2013 12:35:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
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
Message-ID: <20131001103526.GA5053@dhcp-26-207.brq.redhat.com>
References: <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20131001075133.GJ17966@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001075133.GJ17966@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:51:33PM +1000, Michael Ellerman wrote:
> The disadvantage is that any restriction imposed on us above the quota
> can only be reported as an error from pci_enable_msix().
> 
> The quota code, called from pci_get_msix_limit(), can only do so much to
> interogate firmware about the limitations. The ultimate way to check if
> firmware will give us enough MSIs is to try and allocate them. But we
> can't do that from pci_get_msix_limit() because the driver is not asking
> us to enable MSIs, just query them.

If things are this way then pci_enable_msix() already exposed to this
problem internally on pSeries.

I see that even successful quota checks in rtas_msi_check_device() and
rtas_setup_msi_irqs() do not guarantee (as you say) that firmware will
give enough MSIs. Hence, pci_enable_msix() might fail even though the
its quota checks succeeded.

Therefore, nothing will really change if we make pci_get_msix_limit() check
quota and hope the follow-up call to pci_enable_msix() succeeded.

(Of course, we could allocate-deallocate MSIs at check time, but I think it
is an overkill).

> You'll also need to add another arch hook, for the quota check, and
> we'll have to add it to our per-platform indirection as well.

Already, in a branch, hidden from Bjorn & Tejun eyes ;)

> All a lot of bother for no real gain IMHO.

Well, I do not have a strong opinion here. I leave it to the ones who have :)
But few drivers have became clearer as result of this change (and messy ones
are still messy).

> cheers

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
