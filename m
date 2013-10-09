Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3JID5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:57:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46300 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab3JID5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:57:40 -0400
Message-ID: <5254D397.9030307@zytor.com>
Date: Tue, 08 Oct 2013 20:55:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
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
        VMware@dhcp-26-207.brq.redhat.com, "Inc." <pv-drivers@vmware.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
References: <cover.1380703262.git.agordeev@redhat.com>
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 03:29 AM, Alexander Gordeev wrote:
> 
> As result, device drivers will cease to use the overcomplicated
> repeated fallbacks technique and resort to a straightforward
> pattern - determine the number of MSI/MSI-X interrupts required
> before calling pci_enable_msi_block() and pci_enable_msix()
> interfaces:
> 
> 
> 	rc = pci_msix_table_size(adapter->pdev);
> 	if (rc < 0)
> 		return rc;
> 
> 	nvec = min(nvec, rc);
> 	if (nvec < FOO_DRIVER_MINIMUM_NVEC) {
> 		return -ENOSPC;
> 
> 	for (i = 0; i < nvec; i++)
> 		adapter->msix_entries[i].entry = i;
> 
> 	rc = pci_enable_msix(adapter->pdev,
> 			     adapter->msix_entries, nvec);
> 	return rc;
> 

Why not add a minimum number to pci_enable_msix(), i.e.:

pci_enable_msix(pdev, msix_entries, nvec, minvec)

... which means "nvec" is the number of interrupts *requested*, and
"minvec" is the minimum acceptable number (otherwise fail).

	-hpa

