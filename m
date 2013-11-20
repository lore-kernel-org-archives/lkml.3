Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3KTBkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:40:37 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:35350 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3KTBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:40:35 -0500
Message-ID: <528C12B9.60506@huawei.com>
Date: Wed, 20 Nov 2013 09:39:05 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
References: <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com> <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com> <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com> <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com> <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com> <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com> <20131115115235.GA2281@intel.com> <20131119013343.GA17294@google.com> <528AC4F2.40708@huawei.com> <20131119171850.GA4261@google.com> <528C0CF9.3020906@huawei.com> <CAErSpo7nKXR9NBbjs8K__T2TCONW6N76ytevTH-bxcs-NH3+Zg@mail.gmail.com>
In-Reply-To: <CAErSpo7nKXR9NBbjs8K__T2TCONW6N76ytevTH-bxcs-NH3+Zg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/20 9:20, Bjorn Helgaas wrote:
> On Tue, Nov 19, 2013 at 6:14 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>>>>> [bhelgaas: changelog, tag for stable]
>>>>> Reported-by: David Bulkow <David.Bulkow@stratus.com>
>>>>> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>>> CC: stable@vger.kernel.org  # v2.6.32+
>>>>
>>>> Hi Bjorn,
>>>>    This issue in X86 seems to be introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed"
>>>> So this patch needs to back port to 2.6.32+ ?
>>>
>>> 928bea9 might have made it more visible, but the underlying problem is that
>>> we enable the device once in the probe path, and disable it twice in the
>>> remove path.  That problem exists in 2.6.32.61:
>>>
>>>   pcie_portdrv_probe                # .probe() method
>>>     pcie_port_device_register
>>>       pci_enable_device             <-- enable
>>>
>>>   pcie_portdrv_remove               # .remove() method
>>>     pcie_port_device_remove
>>>       pci_disable_device            <-- disable #1
>>>     pci_disable_device              <-- disable #2
>>
>> During assign unassigned resources, we also enable the port device,
>>
>> fs_initcall(pcibios_assign_resources);
>>   pci_assign_unassigned_resources;
>>     pci_enable_bridges()
>>       pci_enable_device()
>>
>>
>> So I think before the commit 928bea9 , the pci bridge device enable and disable is symmetrical.
>> After the commit 928bea9, we only enable bridge once, but still remove twice.
> 
> The port driver should be symmetrical, regardless of what happens
> outside it.  We have to be able to bind/unbind/bind/unbind
> indefinitely.
> 
> Do you think the patch is a problem for current upstream, or are you
> just saying it doesn't need to be backported as far as 2.6.32?  I
> frankly don't care that much if those old kernels pick it up or not.
> All I'm saying is that the problem this fixes is present that far
> back.
> 
> I'm not really interested in doing a lot more digging about ancient
> kernels, unless you think it's going to break something if applied to
> them.

As you said, this is not a big problem, it's ok for current upstream,
and for 3.4 3.5 3.10 stable tree, it seems just a enable and disable symmetry problem.
I don't find anything unsafe about this even though when we unbind pcie port driver,
the pcie port maybe still enable. I have no objection to backport it to ancient kernels. :)

Thanks!
Yijing.


> 
> Bjorn
> 
> 


-- 
Thanks!
Yijing

