Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaG0LL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:11:56 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:13793
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbaG0LLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:11:54 -0400
X-WSS-ID: 0N9DB36-07-VF4-02
X-M-MSG: 
Message-ID: <53D4DE50.9030707@amd.com>
Date: Sun, 27 Jul 2014 14:11:12 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 12/25] amdkfd: Add binding/unbinding calls to amd_iommu
 driver
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-13-git-send-email-oded.gabbay@amd.com>
 <20140720230426.GH3068@gmail.com>
In-Reply-To: <20140720230426.GH3068@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(189002)(199002)(24454002)(65806001)(19580395003)(36756003)(65956001)(80022001)(83506001)(85306003)(21056001)(65816999)(54356999)(110136001)(83322001)(85852003)(79102001)(80316001)(76176999)(77982001)(87266999)(50986999)(92566001)(74662001)(50466002)(20776003)(92726001)(83072002)(46102001)(19580405001)(106466001)(33656002)(81342001)(97736001)(47776003)(68736004)(105586002)(107046002)(23746002)(31966008)(87936001)(44976005)(99396002)(76482001)(102836001)(74502001)(84676001)(64706001)(81542001)(86362001)(101416001)(4396001)(95666004)(64126003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 02:04, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:19PM +0300, Oded Gabbay wrote:
>> This patch adds the functions to bind and unbind pasid from a device through the amd_iommu driver.
>>
>> The unbind function is called when the mm_struct of the process is released.
>>
>> The bind function is not called here because it is called only in the IOCTLs which are not yet implemented at this stage of the patchset.
>
> Commit message should follow the 80 char per line rules too IIRC
> No other comment than apply the 80char for the patch too.
Done in v3 for commit msg.
For the patch, I tried to minimize the lines above 80 char as much as I could 
without harming readability of the code.

	Oded
>
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/radeon/amdkfd/kfd_device.c  | 80 ++++++++++++++++++++++++++++-
>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |  1 +
>>   drivers/gpu/drm/radeon/amdkfd/kfd_process.c | 12 +++++
>>   3 files changed, 92 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> index f6a7cf7..7c4c836 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> @@ -95,6 +95,59 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
>>   	return kfd;
>>   }
>>
>> +static bool device_iommu_pasid_init(struct kfd_dev *kfd)
>> +{
>> +	const u32 required_iommu_flags = AMD_IOMMU_DEVICE_FLAG_ATS_SUP | AMD_IOMMU_DEVICE_FLAG_PRI_SUP
>> +					| AMD_IOMMU_DEVICE_FLAG_PASID_SUP;
>> +
>> +	struct amd_iommu_device_info iommu_info;
>> +	pasid_t pasid_limit;
>> +	int err;
>> +
>> +	err = amd_iommu_device_info(kfd->pdev, &iommu_info);
>> +	if (err < 0) {
>> +		dev_err(kfd_device, "error getting iommu info. is the iommu enabled?\n");
>> +		return false;
>> +	}
>> +
>> +	if ((iommu_info.flags & required_iommu_flags) != required_iommu_flags) {
>> +		dev_err(kfd_device, "error required iommu flags ats(%i), pri(%i), pasid(%i)\n",
>> +		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_ATS_SUP) != 0,
>> +		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PRI_SUP) != 0,
>> +		       (iommu_info.flags & AMD_IOMMU_DEVICE_FLAG_PASID_SUP) != 0);
>> +		return false;
>> +	}
>> +
>> +	pasid_limit = min_t(pasid_t, (pasid_t)1 << kfd->device_info->max_pasid_bits, iommu_info.max_pasids);
>> +	/*
>> +	 * last pasid is used for kernel queues doorbells
>> +	 * in the future the last pasid might be used for a kernel thread.
>> +	 */
>> +	pasid_limit = min_t(pasid_t, pasid_limit, kfd->doorbell_process_limit - 1);
>> +
>> +	err = amd_iommu_init_device(kfd->pdev, pasid_limit);
>> +	if (err < 0) {
>> +		dev_err(kfd_device, "error initializing iommu device\n");
>> +		return false;
>> +	}
>> +
>> +	if (!kfd_set_pasid_limit(pasid_limit)) {
>> +		dev_err(kfd_device, "error setting pasid limit\n");
>> +		amd_iommu_free_device(kfd->pdev);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static void iommu_pasid_shutdown_callback(struct pci_dev *pdev, int pasid)
>> +{
>> +	struct kfd_dev *dev = kfd_device_by_pci_dev(pdev);
>> +
>> +	if (dev)
>> +		kfd_unbind_process_from_device(dev, pasid);
>> +}
>> +
>>   bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>   			 const struct kgd2kfd_shared_resources *gpu_resources)
>>   {
>> @@ -102,8 +155,15 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>
>>   	kfd_doorbell_init(kfd);
>>
>> -	if (kfd_topology_add_device(kfd) != 0)
>> +	if (!device_iommu_pasid_init(kfd))
>> +		return false;
>> +
>> +	if (kfd_topology_add_device(kfd) != 0) {
>> +		amd_iommu_free_device(kfd->pdev);
>>   		return false;
>> +	}
>> +
>> +	amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
>>
>>   	kfd->init_complete = true;
>>   	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
>> @@ -118,18 +178,36 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
>>
>>   	BUG_ON(err != 0);
>>
>> +	if (kfd->init_complete)
>> +		amd_iommu_free_device(kfd->pdev);
>> +
>>   	kfree(kfd);
>>   }
>>
>>   void kgd2kfd_suspend(struct kfd_dev *kfd)
>>   {
>>   	BUG_ON(kfd == NULL);
>> +
>> +	if (kfd->init_complete)
>> +		amd_iommu_free_device(kfd->pdev);
>>   }
>>
>>   int kgd2kfd_resume(struct kfd_dev *kfd)
>>   {
>> +	pasid_t pasid_limit;
>> +	int err;
>> +
>>   	BUG_ON(kfd == NULL);
>>
>> +	pasid_limit = kfd_get_pasid_limit();
>> +
>> +	if (kfd->init_complete) {
>> +		err = amd_iommu_init_device(kfd->pdev, pasid_limit);
>> +		if (err < 0)
>> +			return -ENXIO;
>> +		amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
>> +	}
>> +
>>   	return 0;
>>   }
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index af5a5e4..604c317 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -195,6 +195,7 @@ struct kfd_process {
>>   struct kfd_process *kfd_create_process(const struct task_struct *);
>>   struct kfd_process *kfd_get_process(const struct task_struct *);
>>
>> +void kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid);
>>   struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
>>   							struct kfd_process *p);
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>> index 5efbce0..908b3b7 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>> @@ -24,6 +24,7 @@
>>   #include <linux/log2.h>
>>   #include <linux/sched.h>
>>   #include <linux/slab.h>
>> +#include <linux/amd-iommu.h>
>>   #include <linux/notifier.h>
>>   struct mm_struct;
>>
>> @@ -97,6 +98,7 @@ static void free_process(struct kfd_process *p)
>>   	BUG_ON(p == NULL);
>>
>>   	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
>> +		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
>>   		list_del(&pdd->per_device_list);
>>   		kfree(pdd);
>>   	}
>> @@ -199,6 +201,7 @@ struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
>>   							struct kfd_process *p)
>>   {
>>   	struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p);
>> +	int err;
>>
>>   	if (pdd == NULL)
>>   		return ERR_PTR(-ENOMEM);
>> @@ -206,6 +209,15 @@ struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
>>   	if (pdd->bound)
>>   		return pdd;
>>
>> +	err = amd_iommu_bind_pasid(dev->pdev, p->pasid, p->lead_thread);
>> +	if (err < 0)
>> +		return ERR_PTR(err);
>> +
>> +	if (err < 0) {
>> +		amd_iommu_unbind_pasid(dev->pdev, p->pasid);
>> +		return ERR_PTR(err);
>> +	}
>> +
>>   	pdd->bound = true;
>>
>>   	return pdd;
>> --
>> 1.9.1
>>

