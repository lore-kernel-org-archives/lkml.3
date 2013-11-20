Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3KTBPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:15:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:13271 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3KTBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:15:08 -0500
Message-ID: <528C0CF9.3020906@huawei.com>
Date: Wed, 20 Nov 2013 09:14:33 +0800
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
References: <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com> <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com> <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com> <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com> <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com> <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com> <20131115115235.GA2281@intel.com> <20131119013343.GA17294@google.com> <528AC4F2.40708@huawei.com> <20131119171850.GA4261@google.com>
In-Reply-To: <20131119171850.GA4261@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> [bhelgaas: changelog, tag for stable]
>>> Reported-by: David Bulkow <David.Bulkow@stratus.com>
>>> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>> CC: stable@vger.kernel.org	# v2.6.32+
>>
>> Hi Bjorn,
>>    This issue in X86 seems to be introduced after commit 928bea9 "PCI: Delay enabling bridges until they're needed"
>> So this patch needs to back port to 2.6.32+ ?
> 
> 928bea9 might have made it more visible, but the underlying problem is that
> we enable the device once in the probe path, and disable it twice in the
> remove path.  That problem exists in 2.6.32.61:
> 
>   pcie_portdrv_probe                # .probe() method
>     pcie_port_device_register
>       pci_enable_device             <-- enable
> 
>   pcie_portdrv_remove               # .remove() method
>     pcie_port_device_remove
>       pci_disable_device            <-- disable #1
>     pci_disable_device              <-- disable #2

During assign unassigned resources, we also enable the port device,

fs_initcall(pcibios_assign_resources);
  pci_assign_unassigned_resources;
    pci_enable_bridges()
      pci_enable_device()


So I think before the commit 928bea9 , the pci bridge device enable and disable is symmetrical.
After the commit 928bea9, we only enable bridge once, but still remove twice.

Thanks!
Yijing.


-- 
Thanks!
Yijing

