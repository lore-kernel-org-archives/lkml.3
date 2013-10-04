Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3JDI2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3JDI2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:28:04 -0400
Date: Fri, 4 Oct 2013 10:29:20 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
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
Message-ID: <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:49:45PM +0100, Ben Hutchings wrote:
> On Wed, 2013-10-02 at 12:48 +0200, Alexander Gordeev wrote:
> > This update converts pci_enable_msix() and pci_enable_msi_block()
> > interfaces to canonical kernel functions and makes them return a
> > error code in case of failure or 0 in case of success.
> [...]
> 
> I think this is fundamentally flawed: pci_msix_table_size() and
> pci_get_msi_cap() can only report the limits of the *device* (which the
> driver usually already knows), whereas MSI allocation can also be
> constrained due to *global* limits on the number of distinct IRQs.

Even the current implementation by no means addresses it. Although it
might seem a case for architectures to report the number of IRQs available
for a driver to retry, in fact they all just fail. The same applies to
*any* other type of resource involved: irq_desc's, CPU interrupt vector
space, msi_desc's etc. No platform cares about it and just bails out once
a constrain met (please correct me if I am wrong here). Given that Linux
has been doing well even on embedded I think we should not change it.

The only exception to the above is pSeries platform which takes advantage
of the current design (to implement MSI quota). There are indications we
can satisfy pSeries requirements, but the design proposed in this RFC
is not going to change drastically anyway. The start of the discusstion
is here: https://lkml.org/lkml/2013/9/5/293

> Currently pci_enable_msix() will report a positive value if it fails due
> to the global limit.  Your patch 7 removes that.  pci_enable_msi_block()
> unfortunately doesn't appear to do this.

pci_enable_msi_block() can do more than one MSI only on x86 (with IOMMU),
but it does not bother to return positive numbers, indeed.

> It seems to me that a more useful interface would take a minimum and
> maximum number of vectors from the driver.  This wouldn't allow the
> driver to specify that it could only accept, say, any even number within
> a certain range, but you could still leave the current functions
> available for any driver that needs that.

Mmmm.. I am not sure I am getting it. Could you please rephrase?

> Ben.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
