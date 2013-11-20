Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3KTBVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:21:15 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54032 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3KTBVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <528C0CF9.3020906@huawei.com>
References: <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com>
 <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
 <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
 <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
 <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
 <20131115115235.GA2281@intel.com> <20131119013343.GA17294@google.com>
 <528AC4F2.40708@huawei.com> <20131119171850.GA4261@google.com> <528C0CF9.3020906@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Nov 2013 18:20:51 -0700
Message-ID: <CAErSpo7nKXR9NBbjs8K__T2TCONW6N76ytevTH-bxcs-NH3+Zg@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: Yijing Wang <wangyijing@huawei.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 6:14 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>>>> [bhelgaas: changelog, tag for stable]
>>>> Reported-by: David Bulkow <David.Bulkow@stratus.com>
>>>> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>>> CC: stable@vger.kernel.org  # v2.6.32+
>>>
>>> Hi Bjorn,
>>>    This issue in X86 seems to be introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed"
>>> So this patch needs to back port to 2.6.32+ ?
>>
>> 928bea9 might have made it more visible, but the underlying problem is that
>> we enable the device once in the probe path, and disable it twice in the
>> remove path.  That problem exists in 2.6.32.61:
>>
>>   pcie_portdrv_probe                # .probe() method
>>     pcie_port_device_register
>>       pci_enable_device             <-- enable
>>
>>   pcie_portdrv_remove               # .remove() method
>>     pcie_port_device_remove
>>       pci_disable_device            <-- disable #1
>>     pci_disable_device              <-- disable #2
>
> During assign unassigned resources, we also enable the port device,
>
> fs_initcall(pcibios_assign_resources);
>   pci_assign_unassigned_resources;
>     pci_enable_bridges()
>       pci_enable_device()
>
>
> So I think before the commit 928bea9 , the pci bridge device enable and disable is symmetrical.
> After the commit 928bea9, we only enable bridge once, but still remove twice.

The port driver should be symmetrical, regardless of what happens
outside it.  We have to be able to bind/unbind/bind/unbind
indefinitely.

Do you think the patch is a problem for current upstream, or are you
just saying it doesn't need to be backported as far as 2.6.32?  I
frankly don't care that much if those old kernels pick it up or not.
All I'm saying is that the problem this fixes is present that far
back.

I'm not really interested in doing a lot more digging about ancient
kernels, unless you think it's going to break something if applied to
them.

Bjorn
