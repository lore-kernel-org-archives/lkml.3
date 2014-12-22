Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaLVToF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:44:05 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62578 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaLVToC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:44:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Subject: Re: [RFC v1 PATCH 1/2] of/pci: add of_pci_dma_configure() update dma configuration
Date: Mon, 22 Dec 2014 20:43:24 +0100
Message-ID: <11285984.OK9CqQGmjZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <549858E4.4050500@ti.com>
References: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com> <21520995.3ITgVmVTeV@wuerfel> <549858E4.4050500@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:qI4ZW+L00w1Xn6GKVzJPf9TFet87HxpbDJg3mX9Xms/MJOBTBip
 BwsXLO2YQ4ueAIJxfUxah2CkrMtpy3ewW/Rc8NxncZBW+SC1cSBCtzwMUo+f4ua+0Q1+b/i
 jgYfVsmvrCb6ruAZBV90XOmOQnJ72tcfRbv4NshTVg2asps6l82fJ2a/QZLRUq/ecj31SUP
 UBDAtdmMzT2acRzoO2DtQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 12:46:12 Murali Karicheri wrote:
> On 12/18/2014 05:29 PM, Arnd Bergmann wrote:
> > On Thursday 18 December 2014 17:07:04 Murali Karicheri wrote:
> >> Add of_pci_dma_configure() to allow updating the dma configuration
> >> of the pci device using the configuration from the parent of
> >> the root bridge device.
> >> +	/*
> >> +	 * Set it to coherent_dma_mask by default if the architecture
> >> +	 * code has not set it.
> >> +	 */
> >> +	if (!dev->dma_mask)
> >> +		dev->dma_mask =&dev->coherent_dma_mask;
> >> +
> >> +	ret = of_dma_get_range(parent_np,&dma_addr,&paddr,&size);
> >> +	if (ret<  0) {
> >> +		dma_addr = offset = 0;
> >> +		size = dev->coherent_dma_mask;
> >
> > Can you check one thing here? I believe the size argument as returned
> > from of_dma_get_range is inclusive (e.g. 0x100000000), while the coherent
> > mask by definition is exlusive (e.g. 0xffffffff), so the size needs to
> > be adapted here. I haven't checked all the code here though, so I may
> > be wrong.
> 
> size returned by of_dma_get_range() is inclusive as you indicated. Fromt 
> the grep of dma-ranges in arch/arm/boot/dts, I see
> 
> arch/arm/boot/dts/keystone.dtsi:		dma-ranges = <0x80000000 0x8 
> 0x00000000 0x80000000>;
> arch/arm/boot/dts/keystone.dtsi:			dma-ranges;
> arch/arm/boot/dts/r8a7790.dtsi:		dma-ranges = <0x42000000 0 0x40000000 0 
> 0x40000000 0 0x80000000
> arch/arm/boot/dts/integratorap.dts:	dma-ranges = <0x80000000 0x0 
> 0x80000000>;
> arch/arm/boot/dts/r8a7791.dtsi:		dma-ranges = <0x42000000 0 0x40000000 0 
> 0x40000000 0 0x80000000
> 
> So I guess I need to change the code to
> 
>  >> +	ret = of_dma_get_range(parent_np,&dma_addr,&paddr,&size);
>  >> +	if (ret<  0) {
>  >> +		dma_addr = offset = 0;
>  >> +		size = dev->coherent_dma_mask + 1;

Right.

> >> +	} else {
> >> +		offset = PFN_DOWN(paddr - dma_addr);
> >> +		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> >> +	}
> >> +	dev->dma_pfn_offset = offset;
> >> +
> >> +	coherent = of_dma_is_coherent(parent_np);
> >> +	dev_dbg(dev, "device is%sdma coherent\n",
> >> +		coherent ? " " : " not ");
> >> +
> >> +	arch_setup_dma_ops(dev, dma_addr, size, NULL, coherent);
> >
> > Basically, I would use limit the size argument we pass into
> > arch_setup_dma_ops to the minimum of 'size' and 'dma_mask' here,
> > after converting into the same format. We should make sure we do the
> > same thing for platform_device as well, so it might be better to do
> > it inside of arch_setup_dma_ops instead.
> 
> Do you think following changes will work?
> 
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -2052,9 +2052,10 @@ void arch_setup_dma_ops(struct device *dev, u64 
> dma_base, u64 size,
>                          struct iommu_ops *iommu, bool coherent)
>   {
>          struct dma_map_ops *dma_ops;
> +       u64 temp_size = min((*(dev->dma_mask) + 1), size);
> 
>          dev->archdata.dma_coherent = coherent;
> -       if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
> +       if (arm_setup_iommu_dma_ops(dev, dma_base, temp_size, iommu))
> 
> If you agree, I will post v1 of the patch with these updates. Let me 
> know. I did some basic tests on Keystone with these changes and it works 
> fine.

It's not exactly what I meant. My main point was that we need to limit
dev->dma_mask to (size-1) here, but you are not touching that. We can
either change the two functions in which we first assign the dma_mask
(platform and pci bus), or set it again in arch_setup_dma_ops (on each
architecture implementing it), either way would work. Someone else
might have a stronger opinion on that matter.

For arm_setup_iommu_dma_ops, passing the original size is probably
best.

	Arnd
