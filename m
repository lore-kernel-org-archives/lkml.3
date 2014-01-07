Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaAGAyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:54:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:27253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbaAGAyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:54:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,615,1384329600"; 
   d="scan'208";a="434794667"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH] iommu/intel: SNP bit is not dependent on iommu domain
 coherency
Thread-Topic: [PATCH] iommu/intel: SNP bit is not dependent on iommu domain
 coherency
Thread-Index: AQHPAAgPvhMDfmuDwEKcJmWuy3ksQ5p4g63A
Date: Tue, 7 Jan 2014 00:54:03 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0A9A31C2@SHSMSX104.ccr.corp.intel.com>
References: <20131029162126.23362.58786.stgit@bling.home>
 <1387821199.30327.107.camel@bling.home>
In-Reply-To: <1387821199.30327.107.camel@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s070sQLw013945

Alex Williamson wrote on 2013-12-24:
> David,
> 
> Any comments on this patch?  Thanks,
> 

Hi Alex,

There do have some IOMMUs will treat SNP bit in the PTE as reserved (0) and will cause a reserved field violation fault if it is set but hardware not support snoop-control(bit 7 in ECAP_REG is 0). So your patch seems wrong to me.

> Alex
> 
> On Tue, 2013-10-29 at 10:21 -0600, Alex Williamson wrote:
>> The setting of the SNP bit in the intel-iommu page tables should not
>> be dependent on the current capability of the iommu domain.  The
>> current VT-d spec (2.2) indicates the SNP bit is "treated as
>> reserved[0] by hardware implementations not supporting Snoop Control".
>> Furthermore, section 3.7.3 indicates:
>> 
>>   If the Snoop Control (SC) field in extended capability Register is
>>   reported as 0, snoop behavior for access to the page mapped through
>>   second-level translation is determined by the no-snoop attribute in
>>   the request.
>> This all seems to indicate that hardware incapable of Snoop Control
>> will handle the SNP bit as zero regardless of the value stored in
>> the PTE.
>> 
>> The trouble with the current implementation is that mapping flags
>> depend on the state of the iommu domain at the time of the mapping,
>> yet no attempt is made to update existing mappings when the iommu
>> domain composition changes.  This leaves the iommu domain in a state
>> where some mappings may enforce coherency, others do not, and the
>> user of the IOMMU API has no ability to later enable the desired
>> flags atomically with respect to DMA.
>> 
>> If we always honor the IOMMU_CACHE flag then an IOMMU API user who
>> specifies IOMMU_CACHE for all mappings can assume that the coherency
>> of the mappings within a domain follow the coherency capability of
>> the domain itself.
>> 
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>  drivers/iommu/intel-iommu.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> diff --git a/drivers/iommu/intel-iommu.c
>> b/drivers/iommu/intel-iommu.c index 15e9b57..c46c6a6 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -4084,7 +4084,7 @@ static int intel_iommu_map(struct iommu_domain
> *domain,
>>  		prot |= DMA_PTE_READ;
>>  	if (iommu_prot & IOMMU_WRITE)
>>  		prot |= DMA_PTE_WRITE;
>> -	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
>> +	if (iommu_prot & IOMMU_CACHE)
>>  		prot |= DMA_PTE_SNP;
>>  
>>  	max_addr = iova + size;
> 
>


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
