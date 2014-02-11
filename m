Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaBKBuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:50:13 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:42973 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaBKBuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:50:10 -0500
Message-ID: <52F981C1.8010706@huawei.com>
Date: Tue, 11 Feb 2014 09:49:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH part1 v5 5/7] PCI: Add pci_dummy_ops to isolate pci device
 temporarily
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>		 <1392005051-54508-6-git-send-email-wangyijing@huawei.com>	 <1392015399.21271.9.camel@linux-fkkt.site> <52F886ED.7040603@huawei.com> <1392026834.2082.10.camel@linux-fkkt.site>
In-Reply-To: <1392026834.2082.10.camel@linux-fkkt.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +	spin_lock_irqsave(&pci_freeze_lock, flags);
>>>> +	ops = pci_bus_set_ops(bus, &pci_dummy_ops);
>>>> +	bus->save_ops = ops;
>>>> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);
>>>
>>> Against what exactly are you locking here?
>>
>> I want to use this spin lock to serialize freeze device and unfreeze device.
> 
> Yes, but against what? I am sorry I should have been more explicit.
> You are using these functions only in pci_scan_single_device()


Hi Oliver, thanks very much for your detailed analysis. My original intention to use
pci_freeze_lock to serialize pci_bus_freeze_device() and pci_bus_unfreeze_device(),
because I think these two functions maybe used in other places, although currently
only used in pci_scan_single_device().
Like:

CPU A         					         CPU B
pci_bus_freeze_device()                                pci_bus_unfreeze_device()
  pci_bus_set_ops(bus, &pci_dummy_ops);
  							 pci_bus_set_ops(bus, bus->save_ops);   ---> here, save_ops is NULL, it's bad.
  bus->save_ops = ops;


> 
> 
> CPU A					CPU B
> pci_bus_freeze_device()			wait
> bus->save_ops = ops {valid}		wait
> ...					pci_bus_freeze_device()
> wait					bus->save_ops = ops
> 					{pci_dummy_ops !}
> pci_bus_unfreeze_device()		wait
> pci_bus_set_ops(bus, bus->save_ops)
> 
> You see the problem?
> 

Yes, this is a issue, good catch. I should add a refcount to avoid this situation.

> If this function ever races with itself, the locking is useless.
> If it doesn't race with itself, the locking is not needed.
> If this function can really race with itself, you need a refcount
> for freezing.

Thanks again!




> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

