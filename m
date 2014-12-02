Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbaLBAGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:06:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:33468 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaLBAGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:06:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,497,1413270000"; 
   d="scan'208";a="631057933"
Message-ID: <547D0271.4040009@linux.intel.com>
Date: Tue, 02 Dec 2014 08:06:09 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: Fix an off-by-one bug in __domain_mapping()
References: <1416966130-866-1-git-send-email-jiang.liu@linux.intel.com> <20141201162740.GK3762@8bytes.org>
In-Reply-To: <20141201162740.GK3762@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/12/2 0:27, Joerg Roedel wrote:
> On Wed, Nov 26, 2014 at 09:42:10AM +0800, Jiang Liu wrote:
>> There's an off-by-one bug in function __domain_mapping(), which may
>> trigger the BUG_ON(nr_pages < lvl_pages) when
>> 	(nr_pages + 1) & superpage_mask == 0
> 
> What is the superpage_mask?
Hi Joerg,
	Sorry for the confusion. The really story is:
1) sg_res is set to nr_pages + 1 at the beginning of __domain_mapping()
2) then sg_res is used to choose super page by function
   hardware_largepage_caps(domain, iov_pfn, phys_pfn, sg_res).
The condition to trigger the issue is:
__domain_mapping is called by domain_pfn_mapping() with nr_pages
of 511, so sg_res is 512 and hardware_largepage_caps() will
choose a wrong super page size of 2M, which then trigger
BUG_ON(sg_res < lvl_pages).

So it's not only a BUG_ON() issue, but also causes incorrect super page
selection.
Thanks!
Gerry

> 
>> The issue was introduced by commit 9051aa0268dc "intel-iommu: Combine
>> domain_pfn_mapping() and domain_sg_mapping()", which sets sg_res to
>> "nr_pages + 1" to avoid some of the 'sg_res==0' code paths.
>>
>> It's safe to remove extra "+1" because sg_res is only used to calculate
>> page size now.
> 
> From your description and the (hard to read) code in __domain_mapping I
> don't really understand the issue yet. Can you please elaborate on this
> issue can be triggered?
> 
> Is the BUG_ON the only issue and, if yes, can that be fixed by just
> changing the BUG_ON condition?
> 
>> 	This issue was introduced in v2.6.31, but intel-iommu.c has
>> been moved into drivers/iommu in v3.1. So what's the preferred way
>> to deal with stable kernels between v2.6.31 and v3.1?
> 
> Just remove the kernel version marker from the stable tag. The stable
> kernel maintainers for kernels >3.1 will ask you to backport the patch
> or just backport it by themselfes.
> 
> 
> 	Joerg
> 
