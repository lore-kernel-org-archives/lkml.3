Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161124Ab3JKUa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:30:59 -0400
Received: from mouse.start.ca ([64.140.120.56]:58986 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab3JKUay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:30:54 -0400
Message-ID: <52585FB3.7080508@start.ca>
Date: Fri, 11 Oct 2013 16:29:39 -0400
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
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
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
References: <cover.1380703262.git.agordeev@redhat.com> <5254D397.9030307@zytor.com> <1381292648.645.259.camel@pasglop> <20131010101704.GC11874@dhcp-26-207.brq.redhat.com> <5256D5AB.4050105@zytor.com> <20131010180704.GA15719@dhcp-26-207.brq.redhat.com> <5257357E.8080506@start.ca> <20131011084108.GA25702@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20131011084108.GA25702@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-10-11 04:41 AM, Alexander Gordeev wrote:
> On Thu, Oct 10, 2013 at 07:17:18PM -0400, Mark Lord wrote:
>> Just to help us all understand "the loop" issue..
>>
>> Here's an example of driver code which uses the existing MSI-X interfaces,
>> for a device which can work with either 16, 8, 4, 2, or 1 MSI-X interrupt.
>> This is from a new driver I'm working on right now:
..
> Now, this is a loop-free alternative:
> 
> static int xx_alloc_msix_irqs(struct xx_dev *dev, int nvec)
> {
> 	nvec = roundup_pow_of_two(nvec);	/* assume 0 > nvec <= 16 */
> 
> 	xx_disable_all_irqs(dev);
> 
> 	pci_lock_msi(dev->pdev);
> 
> 	rc = pci_get_msix_limit(dev->pdev, nvec);
> 	if (rc < 0)
> 		goto err;
> 
> 	nvec = min(nvec, rc);		/* if limit is more than requested */
> 	nvec = rounddown_pow_of_two(nvec);	/* (a) */
> 
> 	xx_prep_for_msix_vectors(dev, nvec);
> 
> 	rc = pci_enable_msix(dev->pdev, dev->irqs, nvec);	/* (b)	*/
> 	if (rc < 0)
> 		goto err;
> 
> 	pci_unlock_msi(dev->pdev);
> 
> 	dev->num_vectors = nvec;		/* (b) */
> 	return 0;
> 
> err:
> 	pci_unlock_msi(dev->pdev);
> 
>         kerr(dev->name, "pci_enable_msix() failed, err=%d", rc);
>         dev->num_vectors = 0;
>         return rc;
> }

That would still need a loop, to handle the natural race between
the calls to pci_get_msix_limit() and pci_enable_msix() -- the driver and device
can and should fall back to a smaller number of vectors when pci_enable_msix() fails.
