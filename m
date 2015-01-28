Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbbA1VtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:49:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45509 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760160AbbA1UdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:13 -0500
Date: Wed, 28 Jan 2015 11:05:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Robin Murphy <Robin.Murphy@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 3/6] of: fix size when dma-range is not used
Message-ID: <20150128110523.GC6646@e104818-lin.cambridge.arm.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
 <1422052359-12384-4-git-send-email-m-karicheri2@ti.com>
 <54C77616.80301@arm.com>
 <54C7DF13.20402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C7DF13.20402@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 06:55:15PM +0000, Murali Karicheri wrote:
> On 01/27/2015 06:27 AM, Robin Murphy wrote:
> > On 23/01/15 22:32, Murali Karicheri wrote:
> >> Fix the dma-range size when the DT attribute is missing. i.e set size to
> >> dev->coherent_dma_mask + 1 instead of dev->coherent_dma_mask. To detect
> >> overflow when mask is set to max of u64, add a check, log error and
> >> return.
> >> Some platform use mask format for size in DTS. So add a work around to
> >> catch this and fix.
> >>
> >> Cc: Joerg Roedel <joro@8bytes.org>
> >> Cc: Grant Likely <grant.likely@linaro.org>
> >> Cc: Rob Herring <robh+dt@kernel.org>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Will Deacon <will.deacon@arm.com>
> >> Cc: Russell King <linux@arm.linux.org.uk>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> >>
> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> >> ---
> >> drivers/of/device.c | 14 +++++++++++++-
> >> 1 file changed, 13 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/of/device.c b/drivers/of/device.c
> >> index 2de320d..0a5ff54 100644
> >> --- a/drivers/of/device.c
> >> +++ b/drivers/of/device.c
> >> @@ -105,12 +105,24 @@ void of_dma_configure(struct device *dev, struct
> >> device_node *np)
> >> ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
> >> if (ret < 0) {
> >> dma_addr = offset = 0;
> >> - size = dev->coherent_dma_mask;
> >> + size = dev->coherent_dma_mask + 1;
> >> } else {
> >> offset = PFN_DOWN(paddr - dma_addr);
> >> + /*
> >> + * Add a work around to treat the size as mask + 1 in case
> >> + * it is defined in DT as a mask.
> >> + */
> >> + if (size & 1)
> >> + size = size + 1;
> >> dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
> >> }
> >>
> >> + /* if size is 0, we have an overflow of u64 */
> >> + if (!size) {
> >> + dev_err(dev, "invalid size\n");
> >> + return;
> >> + }
> >> +
> >
> > This seems potentially fragile to dodgy DTs given that we might also be
> > using size to make a mask later. Would it make sense to double-up a
> > sanity check as mask-format detection? Something like:
> >
> > if is_power_of_2(size)
> > // use size
> > else if is_power_of_2(size + 1)
> > // use size + 1
> > else
> > // cry
> 
> How about having the logic like this?
> 
> 	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
> 	if (ret < 0) {
> 		dma_addr = offset = 0;
> 		size = dev->coherent_dma_mask + 1;
> 	} else {
> 		offset = PFN_DOWN(paddr - dma_addr);
> 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
> 	}
> 
> 	if (is_power_of_2(size + 1))
> 		size = size + 1;
> 	else if (!is_power_of_2(size))
> 	{
> 		dev_err(dev, "invalid size\n");
> 		return;
> 	}

In of_dma_configure(), we currently assume that the default coherent
mask is 32-bit. In this thread:

http://article.gmane.org/gmane.linux.kernel/1835096

we talked about setting the coherent mask based on size automatically.
I'm not sure about the size but I think we can assume is 32-bit mask + 1
if it is not specified in the DT. Instead of just assuming a default
mask, let's assume a default size and create the mask based on this
(untested):

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 5b33c6a21807..9ff8d1286b44 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -170,10 +170,10 @@ static void of_dma_configure(struct device *dev)
 	struct iommu_ops *iommu;
 
 	/*
-	 * Set default dma-mask to 32 bit. Drivers are expected to setup
-	 * the correct supported dma_mask.
+	 * Set default size to cover the 32-bit. Drivers are expected to setup
+	 * the correct size and dma_mask.
 	 */
-	dev->coherent_dma_mask = DMA_BIT_MASK(32);
+	size = 1ULL << 32;
 
 	/*
 	 * Set it to coherent_dma_mask by default if the architecture
@@ -185,13 +185,24 @@ static void of_dma_configure(struct device *dev)
 	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
 	if (ret < 0) {
 		dma_addr = offset = 0;
-		size = dev->coherent_dma_mask;
 	} else {
 		offset = PFN_DOWN(paddr - dma_addr);
 		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
 	}
 	dev->dma_pfn_offset = offset;
 
+	/*
+	 * Workaround for DTs setting the size to a mask or 0.
+	 */
+	if (is_power_of_2(size + 1))
+		size += 1;
+
+	/*
+	 * Coherent DMA masks larger than 32-bit must be explicitly set by the
+	 * driver.
+	 */
+	dev->coherent_dma_mask = min(DMA_BIT_MASK(32), DMA_BIT_MASK(ilog2(size)));
+
 	coherent = of_dma_is_coherent(dev->of_node);
 	dev_dbg(dev, "device is%sdma coherent\n",
 		coherent ? " " : " not ");

-- 
Catalin
