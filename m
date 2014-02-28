Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaB1SeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:34:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaB1SeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:34:21 -0500
Message-ID: <5310D71A.6050507@oracle.com>
Date: Fri, 28 Feb 2014 13:36:10 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] xen: add support for MSI message groups
References: <530F68BE.2070505@oracle.com> <1393524935-4216-1-git-send-email-roger.pau@citrix.com> <530F87CC.8090000@oracle.com> <5310C54A.1080906@oracle.com> <5310CB6F.1070706@citrix.com> <5310CEB6.4010604@oracle.com> <5310D118.2090302@citrix.com>
In-Reply-To: <5310D118.2090302@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 01:10 PM, Roger Pau Monné wrote:
> On 28/02/14 19:00, Boris Ostrovsky wrote:
>> On 02/28/2014 12:46 PM, Roger Pau Monné wrote:
>>> On 28/02/14 18:20, Boris Ostrovsky wrote:
>>>> On 02/27/2014 01:45 PM, Boris Ostrovsky wrote:
>>>>> On 02/27/2014 01:15 PM, Roger Pau Monne wrote:
>>>>>> Add support for MSI message groups for Xen Dom0 using the
>>>>>> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
>>>>>>
>>>>>> In order to keep track of which pirq is the first one in the group all
>>>>>> pirqs in the MSI group except for the first one have the newly
>>>>>> introduced PIRQ_MSI_GROUP flag set. This prevents calling
>>>>>> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
>>>>>> first pirq in the group.
>>>>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>>>>
>>>>>
>>>> I was just looking at xen_setup_msi_irqs() (for a different reason) and
>>>> I am no longer sure this patch does anything:
>>>>
>>>> static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>>>> {
>>>>           int irq, ret, i;
>>>>           struct msi_desc *msidesc;
>>>>           int *v;
>>>>
>>>>           if (type == PCI_CAP_ID_MSI && nvec > 1)
>>>>                   return 1;
>>>> ....
>>>>
>>>> Same thing for xen_hvm_setup_msi_irqs().
>>> As said in the commit message this is only for Dom0, so the function
>>> modified is xen_initdom_setup_msi_irqs (were this check is removed).
>> Then what is the reason for these changes:
>>
>> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
>> index 103e702..905956f 100644
>> --- a/arch/x86/pci/xen.c
>> +++ b/arch/x86/pci/xen.c
>> @@ -178,6 +178,7 @@ static int xen_setup_msi_irqs(struct pci_dev *dev,
>> int nvec, int type)
>>       i = 0;
>>       list_for_each_entry(msidesc, &dev->msi_list, list) {
>>           irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],
>> +                           (type == PCI_CAP_ID_MSI) ? nvec : 1,
>>                              (type == PCI_CAP_ID_MSIX) ?
>>                              "pcifront-msi-x" :
>>                              "pcifront-msi",
>> @@ -245,6 +246,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev
>> *dev, int nvec, int type)
>>                   "xen: msi already bound to pirq=%d\n", pirq);
>>           }
>>           irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,
>> +                           (type == PCI_CAP_ID_MSI) ? nvec : 1,
>>                              (type == PCI_CAP_ID_MSIX) ?
>>                              "msi-x" : "msi",
>>                              DOMID_SELF);
>>
>> Should you simply pass 1?
> Yes, but then if we implement MSI message groups for those cases we will
> need to modify this line again, this way it's already correctly setup.
> If you think it's best to hardcode it to 1, I can change it (I was also
> in doubt about which way was better when modifying those lines).


I think passing 1 explicitly this would be better. If we extend support 
for non-dom0 we would have to modify these routines anyway so making 
changes in both places simultaneously would make the commit more clear 
(IMO).

-boris

