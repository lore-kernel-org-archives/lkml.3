Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaLSBqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:46:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:36438 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaLSBqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:46:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="656797077"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "Wu, Feng" <feng.wu@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
CC: "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Topic: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Index: AQHQFiFw/2wcwNXVUk6mLzPIG8E78JyVcJswgAC8KvCAAAEAoA==
Date: Fri, 19 Dec 2014 01:46:06 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-7-git-send-email-feng.wu@intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>
 <E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Feng wrote on 2014-12-19:
> 
> 
> Zhang, Yang Z wrote on 2014-12-18:
>> jiang.liu@linux.intel.com
>> Cc: eric.auger@linaro.org; linux-kernel@vger.kernel.org;
>> iommu@lists.linux-foundation.org; kvm@vger.kernel.org; Wu, Feng
>> Subject: RE: [v3 06/26] iommu, x86: No need to migrating irq for
>> VT-d Posted-Interrupts
>> 
>> Feng Wu wrote on 2014-12-12:
>>> We don't need to migrate the irqs for VT-d Posted-Interrupts here.
>>> When 'pst' is set in IRTE, the associated irq will be posted to
>>> guests instead of interrupt remapping. The destination of the
>>> interrupt is set in Posted-Interrupts Descriptor, and the
>>> migration happens during vCPU scheduling.
>>> 
>>> However, we still update the cached irte here, which can be used
>>> when changing back to remapping mode.
>>> 
>>> Signed-off-by: Feng Wu <feng.wu@intel.com>
>>> Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
>>> ---
>>>  drivers/iommu/intel_irq_remapping.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-) diff --git
>>> a/drivers/iommu/intel_irq_remapping.c
>>> b/drivers/iommu/intel_irq_remapping.c index 48c2051..ab9057a
>>> 100644
>>> --- a/drivers/iommu/intel_irq_remapping.c +++
>>> b/drivers/iommu/intel_irq_remapping.c @@ -977,6 +977,7 @@
>>> intel_ir_set_affinity(struct irq_data *data, const struct cpumask
>>> *mask,  {
>>>  	struct intel_ir_data *ir_data = data->chip_data; 	struct irte *irte =
>>>  &ir_data->irte_entry; +	struct irte_pi *irte_pi = (struct irte_pi
>>>  *)irte; 	struct irq_cfg *cfg = irqd_cfg(data); 	struct irq_data *parent
>>>  = data->parent_data; 	int ret;
>>> @@ -991,7 +992,10 @@ intel_ir_set_affinity(struct irq_data *data,
>>> const struct cpumask *mask,
>>>  	 */
>>>  	irte->vector = cfg->vector;
>>>  	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
>>> -	modify_irte(&ir_data->irq_2_iommu, irte);
>>> +
>>> +	/* We don't need to modify irte if the interrupt is for posting. */
>>> +	if (irte_pi->pst != 1)
>>> +		modify_irte(&ir_data->irq_2_iommu, irte);
>> 
>> What happens if user changes the IRQ affinity manually?
> 
> If the IRQ is posted, its affinity is controlled by guest (irq <--->
> vCPU <----> pCPU), it has no effect when host changes its affinity.

That's the problem: User is able to changes it in host but it never takes effect since it is actually controlled by guest. I guess it will break the IRQ balance too.

> 
> Thanks,
> Feng
> 
>> 
>>> 
>>>  	/*
>>>  	 * After this point, all the interrupts will start arriving
>> 
>> 
>> Best regards,
>> Yang
>>


Best regards,
Yang


