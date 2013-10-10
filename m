Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3JJXSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:18:33 -0400
Received: from mouse.start.ca ([64.140.120.56]:57475 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3JJXSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:18:30 -0400
Message-ID: <5257357E.8080506@start.ca>
Date: Thu, 10 Oct 2013 19:17:18 -0400
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
References: <cover.1380703262.git.agordeev@redhat.com> <5254D397.9030307@zytor.com> <1381292648.645.259.camel@pasglop> <20131010101704.GC11874@dhcp-26-207.brq.redhat.com> <5256D5AB.4050105@zytor.com> <20131010180704.GA15719@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20131010180704.GA15719@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to help us all understand "the loop" issue..

Here's an example of driver code which uses the existing MSI-X interfaces,
for a device which can work with either 16, 8, 4, 2, or 1 MSI-X interrupt.
This is from a new driver I'm working on right now:


static int xx_alloc_msix_irqs (struct xx_dev *dev, int nvec)
{
        xx_disable_all_irqs(dev);
        do {
                if (nvec < 2)
                        xx_prep_for_1_msix_vector(dev);
                else if (nvec < 4)
                        xx_prep_for_2_msix_vectors(dev);
                else if (nvec < 8)
                        xx_prep_for_4_msix_vectors(dev);
                else if (nvec < 16)
                        xx_prep_for_8_msix_vectors(dev);
                else
                        xx_prep_for_16_msix_vectors(dev);
                nvec = pci_enable_msix(dev->pdev, dev->irqs, dev->num_vectors);
        } while (nvec > 0);

        if (nvec) {
                kerr(dev->name, "pci_enable_msix() failed, err=%d", nvec);
                dev->num_vectors = 0;
                return nvec;
        }
        return 0;       /* success */
}
