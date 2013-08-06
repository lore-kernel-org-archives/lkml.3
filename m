Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3HFRAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:00:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:47213 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HFRAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:00:08 -0400
Message-ID: <52012B96.9000207@tilera.com>
Date: Tue, 6 Aug 2013 13:00:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 06/20] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
References: <cover.1375733180.git.cmetcalf@tilera.com> <a8a7d279ad8633c6aa3b5031aa9da4a76f2487c3.1375733180.git.cmetcalf@tilera.com> <20130805205235.GB24122@phenom.dumpdata.com>
In-Reply-To: <20130805205235.GB24122@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/2013 4:52 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 05, 2013 at 04:06:20PM -0400, Chris Metcalf wrote:
>> The LSI MEGARAID SAS HBA suffers from the problem where it can do
>> 64-bit DMA to streaming buffers but not to consistent buffers.
>> In other words, 64-bit DMA is used for disk data transfers and 32-bit
>> DMA must be used for control message transfers. According to LSI,
>> the firmware is not fully functional yet. This change implements a
>> kind of hybrid dma_ops to support this.
> If this is generic to LSI MegaRAID HBA shouldn't this change also be
> done for the other platforms?
>
> Or perhaps some other changes to make it work with other devices?

No, it's really specific to how tilegx maps the 64-bit PCI space, 32-bit PCI space, and memory.  I'll add more commentary to the git commit message to make this clearer.

>> @@ -573,6 +573,11 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
>>  	if (((dma_ops == gx_pci_dma_map_ops) ||
>>  	    (dma_ops == gx_legacy_pci_dma_map_ops)) &&
>>  	    (mask <= DMA_BIT_MASK(32))) {
>> +		if (dma_ops == gx_pci_dma_map_ops) {
>> +			dma_ops->alloc = tile_swiotlb_alloc_coherent;
>> +			dma_ops->free = tile_swiotlb_free_coherent;
>> +		}
>> +
> So.. that would change it for all of the devices on the host, not just
> for this specific one. That is not good is it?

Yes, good point; doing it this way might have some performance impact on other devices on the same host.  See following email for a revised change that updates the dma_ops pointer for that single device instead.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

