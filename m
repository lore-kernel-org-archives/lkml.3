Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3JHMVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:21:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab3JHMVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:21:13 -0400
Date: Tue, 8 Oct 2013 14:22:16 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
Message-ID: <20131008122215.GA14389@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
 <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
 <1380922156.3214.49.camel@bwh-desktop.uk.level5networks.com>
 <20131005142054.GA11270@dhcp-26-207.brq.redhat.com>
 <1381009586.645.141.camel@pasglop>
 <20131006060243.GB28142@dhcp-26-207.brq.redhat.com>
 <1381040386.645.143.camel@pasglop>
 <20131006071027.GA29143@dhcp-26-207.brq.redhat.com>
 <20131007180111.GC2481@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007180111.GC2481@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 02:01:11PM -0400, Tejun Heo wrote:
> > What about introducing pci_lock_msi() and pci_unlock_msi() and let device
> > drivers care about their ranges and specifics in race-safe manner?
> > I do not call to introduce it right now (since it appears pSeries has not
> > been hitting the race for years) just as a possible alternative to Ben's
> > proposal.
> 
> I don't think the same race condition would happen with the loop.

We need to distinguish the contexts we're discussing.

If we talk about pSeries quota, then the current pSeries pci_enable_msix()
implementation is racy internally and could fail if the quota went down
*while* pci_enable_msix() is executing. In this case the loop will have to
exit rather than retry with a lower number (what number?).

In this regard the new scheme does not bring anything new and relies on
the fact this race does not hit and therefore does not worry.

If we talk about quota as it has to be, then yes - the loop scheme seems
more preferable.

Overall, looks like we just need to fix the pSeries implementation,
if the guys want it, he-he :)

> The problem case is where multiple msi(x) allocation fails completely
> because the global limit went down before inquiry and allocation.  In
> the loop based interface, it'd retry with the lower number.

I am probably missing something here. If the global limit went down before
inquiry then the inquiry will get what is available and try to allocate with
than number.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
