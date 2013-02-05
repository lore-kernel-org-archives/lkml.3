Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3BEKmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:42:16 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42808 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3BEKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:42:14 -0500
Date: Tue, 05 Feb 2013 19:42:09 +0900 (JST)
Message-Id: <20130205.194209.52400155.hdk@igel.co.jp>
To: joro@8bytes.org
Cc: lethal@linux-sh.org, magnus.damm@gmail.com, linux@arm.linux.org.uk,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        matsu@igel.co.jp, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dhobsong@igel.co.jp, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] iommu/shmobile: Add iommu driver for Renesas
 IPMMU modules
From: Hideki EIRAKU <hdk@igel.co.jp>
In-Reply-To: <20130201135456.GG25591@8bytes.org>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
	<1358765669-14567-2-git-send-email-hdk@igel.co.jp>
	<20130201135456.GG25591@8bytes.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel,

From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v6 1/4] iommu/shmobile: Add iommu driver for Renesas IPMMU modules
Date: Fri, 1 Feb 2013 14:54:57 +0100

> On Mon, Jan 21, 2013 at 07:54:26PM +0900, Hideki EIRAKU wrote:
>> This is the Renesas IPMMU driver and IOMMU API implementation.
>> 
>> The IPMMU module supports the MMU function and the PMB function.  The
>> MMU function provides address translation by pagetable compatible with
>> ARMv6.  The PMB function provides address translation including
>> tile-linear translation.  This patch implements the MMU function.
>> 
>> The iommu driver does not register a platform driver directly because:
>> - the register space of the MMU function and the PMB function
>>   have a common register (used for settings flush), so they should ideally
>>   have a way to appropriately share this register.
>> - the MMU function uses the IOMMU API while the PMB function does not.
>> - the two functions may be used independently.
>> 
>> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> 
> The patch looks good in general. Just one question inline.
> 
>> +static int pgtable_alloc(struct shmobile_iommu_domain_pgtable *pgtable,
>> +			 struct kmem_cache *cache, size_t size)
>> +{
>> +	pgtable->pgtable = kmem_cache_zalloc(cache, GFP_ATOMIC);
>> +	if (!pgtable->pgtable)
>> +		return -ENOMEM;
>> +	pgtable->handle = dma_map_single(NULL, pgtable->pgtable, size,
>> +					 DMA_TO_DEVICE);
>> +	return 0;
>> +}
> 
> Why is it necessary to call dma_map_single() for IOMMU page-tables?
> usually the dma_* functions call into IOMMU drivers, so why are they
> used inside an IOMMU driver?

I use dma_map_single() for flushing the page table to the IOMMU
device.  The dma_map_ops set by arch/arm/mm/dma-mapping.c are
per-device (unlike the intel-iommu).  The dma_* functions call into
IOMMU drivers if the device is attached by arm_iommu_attach_device(),
but I am using a NULL device here, so that shouldn't happen.

-- 
Hideki EIRAKU <hdk@igel.co.jp>
