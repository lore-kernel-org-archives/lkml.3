Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3JHEdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:33:37 -0400
Received: from ozlabs.org ([203.10.76.45]:34636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3JHEdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:33:33 -0400
Date: Tue, 8 Oct 2013 15:33:30 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
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
        VMware@dhcp-26-207.brq.redhat.com, "Inc." <pv-drivers@vmware.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
Message-ID: <20131008043330.GF31666@concordia>
References: <cover.1380703262.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:29:04PM +0200, Alexander Gordeev wrote:
> This series is against "next" branch in Bjorn's repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
> 
> Currently pci_enable_msi_block() and pci_enable_msix() interfaces
> return a error code in case of failure, 0 in case of success and a
> positive value which indicates the number of MSI-X/MSI interrupts
> that could have been allocated. The latter value should be passed
> to a repeated call to the interfaces until a failure or success:
> 
> 
> 	for (i = 0; i < FOO_DRIVER_MAXIMUM_NVEC; i++)
> 		adapter->msix_entries[i].entry = i;
> 
> 	while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
> 		rc = pci_enable_msix(adapter->pdev,
> 				     adapter->msix_entries, nvec);
> 		if (rc > 0)
> 			nvec = rc;
> 		else
> 			return rc;
> 	}
> 
> 	return -ENOSPC;
> 
> 
> This technique proved to be confusing and error-prone. Vast share
> of device drivers simply fail to follow the described guidelines.

To clarify "Vast share of device drivers":

 - 58 drivers call pci_enable_msix()
 - 24 try a single allocation and then fallback to MSI/LSI
 - 19 use the loop style allocation as above
 - 14 try an allocation, and if it fails retry once
 - 1  incorrectly continues when pci_enable_msix() returns > 0

So 33 drivers (> 50%) successfully make use of the "confusing and
error-prone" return value.

Another 24 happily ignore it, which is also entirely fine.

And yes, one is buggy, so obviously the interface is too complex. Thanks
drivers/ntb/ntb_hw.c

cheers
