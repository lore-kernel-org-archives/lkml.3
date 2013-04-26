Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3DZJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:42:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11524 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3DZJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:42:18 -0400
Message-ID: <517A4BB0.30608@huawei.com>
Date: Fri, 26 Apr 2013 17:41:04 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        David Bulkow <David.Bulkow@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
References: <1366940820-15302-1-git-send-email-yinghai@kernel.org> <5179FC4A.4080000@huawei.com> <CAE9FiQXOQJRxqAW4q8G1OsiHAgFqz8=oD6-f-gvizSL0fR60hQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXOQJRxqAW4q8G1OsiHAgFqz8=oD6-f-gvizSL0fR60hQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/26 14:20, Yinghai Lu wrote:
> On Thu, Apr 25, 2013 at 9:02 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Hi Yinghai,
>>    We should not remove this additional pci_disable_device().
>> Because we enable pcie port device twice before. The first is pci_enable_brides(),
>> in x86, it was called in pci_assign_unassigned_resources(). The second in pcie_port_device_register().
>> So we should call pci_disable_device() twice for pci_dev->enable_cnt balance.
>>
>> But there is still a problem here. If we unbind a pcie port device pcie port driver, we can not
>> use its child devices again, because this pcie port device was disabled absolutely.
>>
>> So I think we should move the second pci_disable_device() to remove.c.
>>
>> I sent this patch to Bjorn and following is Bjorn reply
>> "And it's not clear to me whether unbinding the
>> pcie port driver should disable the bridge at all.  I think one could
>> argue that the bridge should remain functional even if the driver is
>> unloaded, because the PCI core *enables* the bridge even if the driver
>> is never loaded."
>>
>> Yinghai, how do you think about this issue?
> 

Hi Yinghai,
   Thanks for your comment!
We enable_bridges in PCI core code, so I think we should disable device in remove.c(PCI core level),
another reason is call second pci_disable_device() in pci_stop_bus_device() is safe, because all child device
has been stopped(unbind driver already).

> 1. we always enable bridges after assign unassigned resource for boot path
> and hotplug path.
> we should never call disable for that.

I agree "we should never call second disable" unless we stop this sub pci-tree().

Maybe the attached patch last letter is not safe enough, should wait pci bridge complete
to stop itself, then call the second pci_disable_device().

> 
> 2. driver should be keep enable/disable during probe/remove

I agree, use enable/disable balance is better.

> 
> looks like we need to rethink pci enable bridge.
> 
> if we want to enable one pci device, we should go up  to enable all bridges till
> root.

Yes, now we enable pci bridges from root to end. like in pci_assign_unassigned_resources().

> 
> let if we disable one pci device, we need to go up to disable bridge if its all
> pci device children get disabled.

Yes, This is what I think too. It seems like we only can do this in remove.c

> 
> if there is pci driver is bound with bridge device, those
> disable/enable bridge should be skipped.

Hmm, currently system achieve this by checking pci_dev->enable_cnt.

> 
> Thanks
> 
> Yinghai
> 
> .
> 


-- 
Thanks!
Yijing

