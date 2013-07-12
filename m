Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab3GLCT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:19:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36932 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3GLCTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:19:24 -0400
Message-ID: <51DF679D.2000000@huawei.com>
Date: Fri, 12 Jul 2013 10:19:09 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH -v2 2/3] PCI,pciehp: avoid add a device already exist
 before suspend during resume
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>  <1373535825-49972-3-git-send-email-wangyijing@huawei.com> <1373552859.1349.9.camel@x61.thuisdomein>
In-Reply-To: <1373552859.1349.9.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> ---
>>  drivers/pci/hotplug/pciehp_core.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
>> index 7d72c5e..1542735 100644
>> --- a/drivers/pci/hotplug/pciehp_core.c
>> +++ b/drivers/pci/hotplug/pciehp_core.c
> [...]
>> @@ -311,10 +312,12 @@ static int pciehp_resume (struct pcie_device *dev)
>>  
>>  	/* Check if slot is occupied */
>>  	pciehp_get_adapter_status(slot, &status);
>> -	if (status)
>> -		pciehp_enable_slot(slot);
>> -	else
>> +	if (status) {
>> +		if (list_empty(&pbus->devices))
>> +			pciehp_enable_slot(slot);
>> +	} else if (!list_empty(&pbus->devices))
>>  		pciehp_disable_slot(slot);
>> +
> 
> Coding style: braces for the "else if" branch too? Or change the first
> test to "if (status && list_empty([...]))" and drop the braces?

Hmmm, I will add the braces for "else if "

Change the first test "if (status && list_empty([...]))" is not a good idea,
because this change will modify the code logic, for example
if a device was present before suspend and still there during resume, we should do nothing,
but after the logic change, we may disable it.

> 
>>  	return 0;
>>  }
>>  #endif /* PM */
> 
> 
> Paul Bolle
> 
> 
> .
> 


-- 
Thanks!
Yijing

