Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3G2OR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:17:56 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47936 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3G2ORy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:17:54 -0400
MIME-Version: 1.0
In-Reply-To: <51F5B966.9080405@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
 <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
 <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
 <51B93221.2040505@jp.fujitsu.com> <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
 <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com>
 <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com> <51F5B966.9080405@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Jul 2013 08:17:33 -0600
Message-ID: <CAErSpo4JtG5qVJb-nCywe3vkft=-cDeRDKn_V92RCZ-sGXpwbg@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 6:37 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> (2013/07/26 2:00), Bjorn Helgaas wrote:
>> On Wed, Jul 24, 2013 at 12:29 AM, Takao Indoh
>> <indou.takao@jp.fujitsu.com> wrote:
>>> Sorry for letting this discussion slide, I was busy on other works:-(
>>> Anyway, the summary of previous discussion is:
>>> - My patch adds new initcall(fs_initcall) to reset all PCIe endpoints on
>>>    boot. This expects PCI enumeration is done before IOMMU
>>>    initialization as follows.
>>>      (1) PCI enumeration
>>>      (2) fs_initcall ---> device reset
>>>      (3) IOMMU initialization
>>> - This works on x86, but does not work on other architecture because
>>>    IOMMU is initialized before PCI enumeration on some architectures. So,
>>>    device reset should be done where IOMMU is initialized instead of
>>>    initcall.
>>> - Or, as another idea, we can reset devices in first kernel(panic kernel)
>>>
>>> Resetting devices in panic kernel is against kdump policy and seems not to
>>> be good idea. So I think adding reset code into iommu initialization is
>>> better. I'll post patches for that.
>>
>> Of course nobody *wants* to do anything in the panic kernel.  But
>> simply saying "it's against kdump policy and seems not to be a good
>> idea" is not a technical argument.  There are things that are
>> impractical to do in the kdump kernel, so they have to be done in the
>> panic kernel even though we know the kernel is unreliable and the
>> attempt may fail.
>
> Accessing kernel data in panic kernel causes panic again, so
> - Don't touch kernel data in panic situation
> - Jump to kdump kernel as quickly as possible, and do things in safe
>   kernel
> These are basic "kdump policy". Of course if there are any works which
> we cannot do in kdump kernel and can do only in panic kernel, for
> example saving registers or stopping cpus, we should do them in panic
> kernel.
>
> Resetting devices in panic kernel is worth considering if we can safely
> find pci_dev and reset it, but I have no idea how to do that because
> for example struct pci_dev may be borken.

Nobody can guarantee that the panic kernel can do *anything* safely
because any arbitrary kernel data or text may be corrupted.  But if
you consider any specific data structure, e.g., CPU or PCI device
lists, it's not very likely that it will be corrupted.

>> My point about IOMMU and PCI initialization order doesn't go away just
>> because it doesn't fit "kdump policy."  Having system initialization
>> occur in a logical order is far more important than making kdump work.
>
> My next plan is as follows. I think this is matched to logical order
> on boot.
>
> drivers/pci/pci.c
> - Add function to reset bus, for example, pci_reset_bus(struct pci_bus *bus)
>
> drivers/iommu/intel-iommu.c
> - On initialization, if IOMMU is already enabled, call this bus reset
>   function before disabling and re-enabling IOMMU.

I raised this issue because of arches like sparc that enumerate the
IOMMU before the PCI devices that use it.  In that situation, I think
you're proposing this:

  panic kernel
    enable IOMMU
    panic
  kdump kernel
    initialize IOMMU (already enabled)
      pci_reset_bus
      disable IOMMU
      enable IOMMU
    enumerate PCI devices

But the problem is that when you call pci_reset_bus(), you haven't
enumerated the PCI devices, so you don't know what to reset.

Bjorn
