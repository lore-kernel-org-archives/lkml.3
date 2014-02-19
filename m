Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaBSPir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:38:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50110 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaBSPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:38:45 -0500
Message-ID: <5304D063.90000@oracle.com>
Date: Wed, 19 Feb 2014 10:40:19 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: Use pci_enable_msix_range() instead of pci_enable_msix()
References: <1392804931-30671-10-git-send-email-agordeev@redhat.com> <5304CC49.7020000@oracle.com>
In-Reply-To: <5304CC49.7020000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 10:22 AM, Boris Ostrovsky wrote:
> On 02/19/2014 05:15 AM, Alexander Gordeev wrote:
>> As result of deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range() and pci_enable_msix_range()
>> interfaces.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: David Vrabel <david.vrabel@citrix.com>
>> Cc: linux-pci@vger.kernel.org
>> ---
>>   drivers/xen/xen-pciback/pciback_ops.c |   16 ++++++++++------
>>   1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/xen/xen-pciback/pciback_ops.c 
>> b/drivers/xen/xen-pciback/pciback_ops.c
>> index 64eb0cd..f5b4c3e 100644
>> --- a/drivers/xen/xen-pciback/pciback_ops.c
>> +++ b/drivers/xen/xen-pciback/pciback_ops.c
>> @@ -213,9 +213,15 @@ int xen_pcibk_enable_msix(struct 
>> xen_pcibk_device *pdev,
>>           entries[i].vector = op->msix_entries[i].vector;
>>       }
>>   -    result = pci_enable_msix(dev, entries, op->value);
>> +    result = pci_enable_msix_range(dev, entries, op->value, op->value);
>> +    if (result < op->value) {
>
>
> I think it would be better to have 'if (result != op->value)', in case 
> op->value is negative (which presumably it should never be).


Better yet, at the top of the routine we check 'if (op->value > 
SH_INFO_MAX_VEC)'. If you add '|| op->value < 0' we'd be all set.

-boris

>
>
> -boris
>
>
>> +        if (result > 0)
>> +            pci_disable_msix(dev);
>>   -    if (result == 0) {
>> +        pr_warn_ratelimited("%s: error enabling MSI-X for guest %u: 
>> err %d!\n",
>> +                    pci_name(dev), pdev->xdev->otherend_id,
>> +                    result);
>> +    } else {
>>           for (i = 0; i < op->value; i++) {
>>               op->msix_entries[i].entry = entries[i].entry;
>>               if (entries[i].vector)
>> @@ -227,10 +233,8 @@ int xen_pcibk_enable_msix(struct 
>> xen_pcibk_device *pdev,
>>                           pci_name(dev), i,
>>                           op->msix_entries[i].vector);
>>           }
>> -    } else
>> -        pr_warn_ratelimited("%s: error enabling MSI-X for guest %u: 
>> err %d!\n",
>> -                    pci_name(dev), pdev->xdev->otherend_id,
>> -                    result);
>> +    }
>> +
>>       kfree(entries);
>>         op->value = result;
>

