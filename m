Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3JKHai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:30:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:17227 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3JKHah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:30:37 -0400
Message-ID: <5257A882.1070809@huawei.com>
Date: Fri, 11 Oct 2013 15:28:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gavin Shan <shangw@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Paul Mackerras <paulus@samba.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 3/6] powerpc/pci: use pci_is_pcie() to simplify code
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com> <1378367730-25996-3-git-send-email-wangyijing@huawei.com> <20130906203035.GA27940@google.com> <1381470596.5630.61.camel@pasglop> <20131011061654.GA561@shangw.(null)> <52579BD6.40802@huawei.com> <20131011065329.GA5013@shangw.(null)>
In-Reply-To: <20131011065329.GA5013@shangw.(null)>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/11 14:53, Gavin Shan wrote:
> On Fri, Oct 11, 2013 at 02:33:58PM +0800, Yijing Wang wrote:
>> On 2013/10/11 14:16, Gavin Shan wrote:
>>> On Fri, Oct 11, 2013 at 04:49:56PM +1100, Benjamin Herrenschmidt wrote:
>>>> On Fri, 2013-09-06 at 14:30 -0600, Bjorn Helgaas wrote:
>>>>> On Thu, Sep 05, 2013 at 03:55:27PM +0800, Yijing Wang wrote:
> 
> .../...
> 
>>>>>> Use pci_is_pcie() to simplify code.
>>>>>> diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
>>>>>> index 55593ee..6ebbe54 100644
>>>>>> --- a/arch/powerpc/kernel/eeh.c
>>>>>> +++ b/arch/powerpc/kernel/eeh.c
>>>>>> @@ -189,8 +189,7 @@ static size_t eeh_gather_pci_data(struct eeh_dev *edev, char * buf, size_t len)
>>>>>>  	}
>>>>>>  
>>>>>>  	/* If PCI-E capable, dump PCI-E cap 10, and the AER */
>>>>>> -	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
>>>>>> -	if (cap) {
>>>>>> +	if (pci_is_pcie(dev)) {
>>>>>>  		n += scnprintf(buf+n, len-n, "pci-e cap10:\n");
>>>>>>  		printk(KERN_WARNING
>>>>>>  		       "EEH: PCI-E capabilities and status follow:\n");
>>>>
>>>> So we remove reading of "cap", but slightly further down the code does:
>>>>
>>>> 		for (i=0; i<=8; i++) {
>>>> 			eeh_ops->read_config(dn, cap+4*i, 4, &cfg);
>>>> 			n += scnprintf(buf+n, len-n, "%02x:%x\n", 4*i, cfg);
>>>> 			printk(KERN_WARNING "EEH: PCI-E %02x: %08x\n", i, cfg);
>>>> 		}
>>>>
>>>> Which actually *uses* the value of "cap" ... oops :-)
>>>>
>>>
>>> It's my fault and I should have looked into the changes more closely.
>>> How about changing it like this:
>>>
>>> 	cap = pci_is_pcie(dev) ? pci_pcie_cap(dev) :
>>> 	      pci_find_capability(dev, PCI_CAP_ID_EXP);
>>> 	if (cap) {
>>> 		...
>>> 	}
>>>
>>> It would save some PCI-CFG access cycles for most cases :-)
>>
>> Hi Gavin,  it's not your fault, it's my fault. :)
>>
>> Because pci_pcie_cap(dev) == dev->pcie_cap == pci_find_capability(dev, PCI_CAP_ID_EXP);
>>
>> so I think it's ok to use dev->pcie_cap instead of stale "cap".
>>
> 
> Yijing, There has one exception: dev->pcie_cap isn't updated yet.

In my idea, dev->pcie_cap(here is pci_dev->pcie_cap) will update in set_pcie_port_type() function,
and this function always be called after allocate pci device. We get pci_dev by eeh_dev_to_pci_dev(),
I think pci_dev has been initialized completely.

> This function has possibility to be invoked before that. However,
> we don't have the binding (eeh device <-> PCI device) for the case.
> So the piece of code shouldn't be running

In PCI core, I knew

pci_scan_device()
   pci_setup_device()
       set_pcie_port_type()
            pci_dev->pcie_cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);

In powerpc, I also found

of_scan_pci_dev()
   of_create_pci_dev()
       set_pcie_port_type()
	    pci_dev->pcie_cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);
> 
> However, it's a bit safer to have pci_find_capability(dev, PCI_CAP_ID_EXP)
> as well even though we needn't it for 99.9% cases if you agree :-)

I agree, this function is not the performance bottleneck,
safety is more important. :)
So if Bjorn and Benjamin think it's not safe, it's ok to drop it. :)

Thanks!
Yijing.

> 
> Thanks,
> Gavin
> 
> 
> .
> 


-- 
Thanks!
Yijing

