Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3IZKn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab3IZKnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:43:53 -0400
Date: Thu, 26 Sep 2013 12:45:48 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130926104548.GB16774@dhcp-26-207.brq.redhat.com>
References: <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
 <20130920122736.GD7630@mtj.dyndns.org>
 <20130925180220.GB26273@google.com>
 <20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
 <20130925210016.GA8926@htj.dyndns.org>
 <20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B735D@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B735D@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 09:58:53AM +0100, David Laight wrote:
> Would it be possible to do some kind of 2-stage allocation.
> In the first pass the driver would pass a minimum and desired
> number of MSI-X interrupts, but not actually be given any.

Repeated calls to msi_enable_msi/msix() is what we are trying to avoid.

> Interrupts could then be allocated after it is known how many
> are required and how many are available.

Yep, that what we are heading to. So basic pattern I see would be like this:

	int foo_driver_enable_msix(struct pci_dev *pdev, int nvec)
	{
		...

		rc = pci_msix_table_size(pdev);
		if (rc < 0)
			return rc;

		nvec = min(nvec, rc);
		if (nvec < FOO_DRIVER_MINIMUM_NVEC)
			goto single_msi;

		for (i = 0; i < nvec; i++)
			entries[i].entry = i;

		rc = pci_enable_msix(pdev, entries, nvec);
		if (rc)
			goto single_msi;

		return 0;

	single_msi:
		...

	}

But this will break pSeries and we might end up with something like this:

	int foo_driver_enable_msix(struct pci_dev *pdev, int nvec)
	{
		...

		rc = pci_msix_table_size(pdev);
		if (rc < 0)
			return rc;

		nvec = min(nvec, rc);
		if (nvec < FOO_DRIVER_MINIMUM_NVEC)
			goto single_msi;

		rc = pci_get_msix_limit(pdev, nvec);
		if (rc < 0)
			return rc;

		nvec = min(nvec, rc);
		if (nvec < FOO_DRIVER_MINIMUM_NVEC)
			goto single_msi;

		for (i = 0; i < nvec; i++)
			entries[i].entry = i;

		rc = pci_enable_msix(pdev, entries, nvec);
		if (rc)
			goto single_msi;

		return 0;

	single_msi:
		...

	}

> 	David

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
