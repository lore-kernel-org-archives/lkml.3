Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaLVKYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:24:10 -0500
Received: from mail-bn1bon0135.outbound.protection.outlook.com ([157.56.111.135]:48224
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754176AbaLVKYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:24:08 -0500
X-WSS-ID: 0NGZBK1-07-6O8-02
X-M-MSG: 
Message-ID: <5497F130.7040508@amd.com>
Date: Mon, 22 Dec 2014 12:23:44 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, John Bridgman <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [PATCH] iommu/amd: Track when amd_iommu_v2 init is complete
References: <1419106352-6486-1-git-send-email-oded.gabbay@amd.com>
 <5495DB96.6070608@amd.com>
In-Reply-To: <5495DB96.6070608@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(51704005)(24454002)(55674003)(479174004)(189002)(199003)(31966008)(87936001)(97736003)(50986999)(59896002)(99396003)(101416001)(76176999)(21056001)(36756003)(77096005)(2950100001)(4396001)(33656002)(105586002)(86362001)(62966003)(106466001)(15975445007)(107046002)(77156002)(120916001)(23746002)(19580395003)(19580405001)(46102003)(80316001)(64126003)(68736005)(92566001)(87266999)(54356999)(84676001)(65956001)(65806001)(20776003)(50466002)(47776003)(64706001)(83506001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 10:24:04.2175
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/20/2014 10:27 PM, Oded Gabbay wrote:
>
>
> On 12/20/2014 10:12 PM, Oded Gabbay wrote:
>> This patch adds a new exported function to amd_iommu_v2, which returns 1 if the
>> amd_iommu_v2 initialization function has completed, and 0 otherwise.
>>
>> This is necessary for the case when amd_iommu_v2 is compiled inside the kernel
>> image (not as module) and another module (e.g. amdkfd), which is also compiled
>> inside the kernel image, is dependent on amd_iommu_v2 functionality.
>>
>> In that case, there is no mechanism in the kernel that enforces the order of
>> loading between the two modules. Therefore, If the amd_iommu_v2 is loaded
>> _after_ the other module, and the other module calls one of
>> amd_iommu_v2 exported functions _before_ amd_iommu_v2 is loaded, than that
>> function will fail, and as a result, the calling module may fail as well.
>>
>> Note that when the two modules are compiled as modules, this situation can't
>> occur as the kernel enforces the order of loading.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/iommu/amd_iommu_v2.c | 11 +++++++++++
>>   include/linux/amd-iommu.h    |  2 ++
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
>> index 1e6360e..2456f18 100644
>> --- a/drivers/iommu/amd_iommu_v2.c
>> +++ b/drivers/iommu/amd_iommu_v2.c
>> @@ -895,6 +895,14 @@ out_unlock:
>>   }
>>   EXPORT_SYMBOL(amd_iommu_set_invalidate_ctx_cb);
>>
>> +static int iommu_v2_init_completed;
>> +
>> +int amd_iommu_v2_is_init_completed(void)
>> +{
>> +	return iommu_v2_init_completed;
>> +}
>> +EXPORT_SYMBOL(amd_iommu_v2_is_init_completed);
>> +
>>   static int __init amd_iommu_v2_init(void)
>>   {
>>   	int ret;
>> @@ -903,6 +911,7 @@ static int __init amd_iommu_v2_init(void)
>>
>>   	if (!amd_iommu_v2_supported()) {
>>   		pr_info("AMD IOMMUv2 functionality not available on this system\n");
>> +		iommu_v2_init_completed = 1;
>>   		/*
>>   		 * Load anyway to provide the symbols to other modules
>>   		 * which may use AMD IOMMUv2 optionally.
>> @@ -919,6 +928,8 @@ static int __init amd_iommu_v2_init(void)
>>
>>   	amd_iommu_register_ppr_notifier(&ppr_nb);
>>
>> +	iommu_v2_init_completed = 1;
>> +
>>   	return 0;
>>
>>   out:
>> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
>> index 2b08e79..115c03a 100644
>> --- a/include/linux/amd-iommu.h
>> +++ b/include/linux/amd-iommu.h
>> @@ -169,6 +169,8 @@ typedef void (*amd_iommu_invalidate_ctx)(struct pci_dev *pdev, int pasid);
>>   extern int amd_iommu_set_invalidate_ctx_cb(struct pci_dev *pdev,
>>   					   amd_iommu_invalidate_ctx cb);
>>
>> +extern int amd_iommu_v2_is_init_completed(void);
>> +
>>   #else
>>
>>   static inline int amd_iommu_detect(void) { return -ENODEV; }
>>
>
> Hi Joerg,
> This patch follows our IRC conversations from the last week.
> Last update from me was that using subsys_initcall instead of module_init
> does enforce amd_iommu_v2 to load _before_ amdkfd (apparently I didn't check
> it correctly the first time). However, this won't help us because:
> 1. I don't know what effect this has when amd_iommu_v2 is compiled as module.
> 2. amd_iommu_v2 depends on amd_iommu which is not subsys, so amd_iommu_v2
> init function fails when it is called this early, and thus, amd_iommu_v2
> doesn't work.
>
> I want to fix this situation in rc1/2, so I'm sending the complementary
> patches to dri-devel in the meantime.
>
> 	Oded
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>

Hi,
The drm guys suggested we move iommu/ subsystem before gpu/ subsystem in 
drivers/Makefile instead of the above patch (and the complementing patch-set in 
amdkfd).

I did that and it works, so please see this patch as discarded for now.
I will send a new patch-set shortly.

	ODed
