Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIPIIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:08:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61248 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaIPIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:08:43 -0400
Message-ID: <5417EFFA.3090804@huawei.com>
Date: Tue, 16 Sep 2014 16:08:26 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part3 V5 1/8] iommu/vt-d: Introduce helper function dmar_walk_resources()
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-2-git-send-email-jiang.liu@linux.intel.com> <5412B9EE.3070708@huawei.com> <5417E322.9090201@linux.intel.com>
In-Reply-To: <5417E322.9090201@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.5417F003.002D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: dd0de5907e2d952bc56c1514f971fd2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  #include "irq_remapping.h"
>>>  
>>> +typedef int (*dmar_res_handler_t)(struct acpi_dmar_header *, void *);
>>> +struct dmar_res_callback {
>>> +	dmar_res_handler_t	cb[ACPI_DMAR_TYPE_RESERVED];
>>> +	void			*arg[ACPI_DMAR_TYPE_RESERVED];
>>> +	bool			ignore_unhandled;
>>> +	bool			print_entry;
>>
>> Why do we need a switch to control print ?
> We will walk DMAR entries several times during hotplug and only
> want to print once.

Fine, thanks for your explanation.

> 
>>
>>> +};
>>> +
>>>  
>>> +static int dmar_walk_resources(struct acpi_dmar_header *start, size_t len,
>>> +			       struct dmar_res_callback *cb)
>>
>> The name dmar_walk_resources easily make people think this is related with I/O or memory resources.
>> Do you have a better idea of this ?  What about dmar_walk_remapping_entry() or dmar_walk_remapping_structure() ?
> Good suggestion, I like dmar_walk_remapping_entries().
>>
>>> +{
>>> +	int ret = 0;
>>> +	struct acpi_dmar_header *iter, *next;
>>> +	struct acpi_dmar_header *end = ((void *)start) + len;
>>> +
>>> +	for (iter = start; iter < end && ret == 0; iter = next) {
>>> +		next = (void *)iter + iter->length;
>>> +		if (iter->length == 0) {
>>> +			/* Avoid looping forever on bad ACPI tables */
>>> +			pr_debug(FW_BUG "Invalid 0-length structure\n");
>>
>> What about use pr_warn() instead of pr_debug(), pr_debug() default is off.
> It seems a common practice for BIOS engineer to mark the last entry with
> zero length. So it will be annoying if we generate this debug message
> on product kernel.

OK.

> 
>>
>>> +			break;
>>> +		} else if (next > end) {
>>> +			/* Avoid passing table end */
>>> +			pr_warn(FW_BUG "record passes table end\n");
>>> +			ret = -EINVAL;
>>> +			break;
>>> +		}
>>> +
>>> +		if (cb->print_entry)
>>> +			dmar_table_print_dmar_entry(iter);
>>> +
>>> +		if (iter->type >= ACPI_DMAR_TYPE_RESERVED) {
>>> +			/* continue for forward compatibility */
>>> +			pr_debug("Unknown DMAR structure type %d\n",
>>> +				 iter->type);
>>
>> Same as above.
> This is typically caused by new DMAR specification. It will also be
> annoying too if  we also generate this debug message on an newer
> hardware platform with older linux kernel.

OK.

> 
>>
>>> +		} else if (cb->cb[iter->type]) {
>>> +			ret = cb->cb[iter->type](iter, cb->arg[iter->type]);
>>> +		} else if (!cb->ignore_unhandled) {
>>> +			pr_warn("No handler for DMAR structure type %d\n",

