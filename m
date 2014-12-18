Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaLRWaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:30:11 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:51526 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaLRWaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:30:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Thu, 18 Dec 2014 23:29:25 +0100
Message-ID: <21520995.3ITgVmVTeV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418940425-2017-2-git-send-email-m-karicheri2@ti.com>
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <1418940425-2017-2-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tri+b03zHEGRGu1GZ1Zq7n7ZBem5xEKOtMYAypK9PFX7cZLHsnt
 vjnOZ9RbFcITLa3U3EtBa61a2P9DFbBeb8MRxaJOB7uqkbuGev/PuTevYA5n0VOof079sFv
 zthYT6wCN/F3yxpFhv+6BlfFdE1t9gSNAEK7EI5O2hN/XVwBWyKdNtXmE7iI0rcT30OoNKN
 D73rrAYdkqICLqcI9Xfug==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 17:07:04 Murali Karicheri wrote:
> Add of_pci_dma_configure() to allow updating the dma configuration
> of the pci device using the configuration from the parent of
> the root bridge device.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Much better!

There is one detail that we should get right from the start here,
which is currently wrong in the platform device code, but I have so
far not dared change it:

> +	/*
> +	 * Set default dma-mask to 32 bit. Drivers are expected to setup
> +	 * the correct supported dma_mask.
> +	 */
> +	dev->coherent_dma_mask = DMA_BIT_MASK(32);

The 32-bit mask is indeed correct as the default for almost all cases,
and we must not set it larger than DMA_BIT_MASK(32). There is one
corner case though, which happens on some shmobile machines that have
a 31-bit mask on the PCI host, and I think we should use that as the
default.

> +	/*
> +	 * Set it to coherent_dma_mask by default if the architecture
> +	 * code has not set it.
> +	 */
> +	if (!dev->dma_mask)
> +		dev->dma_mask = &dev->coherent_dma_mask;
> +
> +	ret = of_dma_get_range(parent_np, &dma_addr, &paddr, &size);
> +	if (ret < 0) {
> +		dma_addr = offset = 0;
> +		size = dev->coherent_dma_mask;

Can you check one thing here? I believe the size argument as returned
from of_dma_get_range is inclusive (e.g. 0x100000000), while the coherent
mask by definition is exlusive (e.g. 0xffffffff), so the size needs to
be adapted here. I haven't checked all the code here though, so I may
be wrong.

> +	} else {
> +		offset = PFN_DOWN(paddr - dma_addr);
> +		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> +	}
> +	dev->dma_pfn_offset = offset;
> +
> +	coherent = of_dma_is_coherent(parent_np);
> +	dev_dbg(dev, "device is%sdma coherent\n",
> +		coherent ? " " : " not ");
> +
> +	arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);

Basically, I would use limit the size argument we pass into
arch_setup_dma_ops to the minimum of 'size' and 'dma_mask' here,
after converting into the same format. We should make sure we do the
same thing for platform_device as well, so it might be better to do
it inside of arch_setup_dma_ops instead.

	Arnd
