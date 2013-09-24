Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3IXNQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:16:32 -0400
Received: from 8bytes.org ([85.214.48.195]:45450 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3IXNQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:16:31 -0400
Date: Tue, 24 Sep 2013 15:16:23 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, bhe@redhat.com
Subject: Re: [PATCH v2] intel-iommu: Quiesce devices before disabling IOMMU
Message-ID: <20130924131621.GC5150@8bytes.org>
References: <1379484541-4496-1-git-send-email-indou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379484541-4496-1-git-send-email-indou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 24 15:16:26 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 524190aa20861568317175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 03:09:01PM +0900, Takao Indoh wrote:
> +	/*
> +	 *  In the case of kdump, ioremap is needed because root-entry table
> +	 *  exists in first kernel's memory area which is not mapped in second
> +	 *  kernel
> +	 */
> +	root = (struct root_entry *)ioremap(addr, PAGE_SIZE);
> +	if (!root)
> +		return;
> +
> +	for (bus = 0; bus < ROOT_ENTRY_NR; bus++) {
> +		if (!root_present(&root[bus]))
> +			continue;
> +
> +		context = (struct context_entry *)ioremap(
> +			root[bus].val & VTD_PAGE_MASK, PAGE_SIZE);
> +		if (!context)
> +			continue;
> +
> +		for (devfn = 0; devfn < CONTEXT_ENTRY_NR; devfn++) {
> +			if (!context_present(&context[devfn]))
> +				continue;
> +
> +			dev = pci_get_domain_bus_and_slot(segment, bus, devfn);
> +			if (!dev)
> +				continue;
> +
> +			if (!pci_reset_bus(dev->bus)) /* go to next bus */
> +				break;
> +			else /* Try per-function reset */
> +				pci_reset_function(dev);
> +
> +		}
> +		iounmap(context);
> +	}
> +	iounmap(root);

I am not convinced that this is the right approach. If a device wasn't
translated by VT-d in the old kernel doesn't mean it will not be
translated in the new kernel. How about unconditionally resetting all
PCI busses and/or functions here before IOMMU initialization proceeds?


	Joerg


