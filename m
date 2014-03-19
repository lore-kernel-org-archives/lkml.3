Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaCSEw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:52:28 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57340 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaCSEw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:52:26 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNbzjYa7dJpH+k-F02Cap7yBBi7TkngjVu_KthXw-WKJA@mail.gmail.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
	<CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
	<CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
	<20140318002700.GA22356@google.com>
	<CACVXFVNbzjYa7dJpH+k-F02Cap7yBBi7TkngjVu_KthXw-WKJA@mail.gmail.com>
Date: Wed, 19 Mar 2014 12:52:25 +0800
Message-ID: <CACVXFVO2rR+H7X2Xv_d-U0NeikT4dR97ffQ7PuV7+i0fN=_k3w@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
From: Ming Lei <tom.leiming@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks Sasha fixed the problem in lkvm tool[1].

Sasha, looks we both saw the problem, but from technical
view, I am wondering if the fix is correct, because PCI spec.
requires that the IO/MMIO bits in COMMAND register should
be cleared after reset, maybe there are some potential problem
in lkvm pci emulation.


[1],  commit 6478ce1416aacf1ce35530f79ea035f89fb21e90
Author: Sasha Levin <sasha.levin@oracle.com>
Date:   Wed Mar 5 23:08:16 2014 -0500

    kvm tools: mark our PCI card as PIO and MMIO able


Thanks,
--
Ming Lei

On Wed, Mar 19, 2014 at 11:32 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 8:27 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Mar 14, 2014 at 09:48:35AM +0800, Ming Lei wrote:
>>> On Fri, Mar 14, 2014 at 12:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> > On Thu, Mar 13, 2014 at 2:51 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>>> >> Hi Bjorn,
>>> >>
>>> >> I found this patch broke virtio-pci devices.
>>> >
>>> > Thanks a lot for testing this.
>>> >
>>> >> On Thu, Feb 27, 2014 at 3:37 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> >>> Don't rely on BAR contents when the command register says the BAR is
>>> >>> disabled.
>>> >>>
>>> >>> If we receive a PCI device from firmware (or a hot-added device that was
>>> >>> just powered up) with the MEMORY or IO enable bits in the PCI command
>>> >>> register cleared, there's no reason to believe the BARs contain valid
>>> >>> addresses.
>>> >>
>>> >> From PCI LOCAL BUS SPECIFICATION, REV. 3.0, both
>>> >> PCI_COMMAND_IO and PCI_COMMAND_MEM should be
>>> >> cleared after reset, so looks the patch sets IORESOURCE_UNSET
>>> >> too early because PCI drivers may call pci_enable_device()
>>> >> (->pci_enable_resources()) to enable the two bits of
>>> >> PCI_COMMAND explicitly.
>>> >
>>> > The point is that it's not safe to enable those two bits unless we're
>>> > certain that the BARs they control contain valid values that don't
>>> > conflict with anything else in the system.
>>> >
>>> > Maybe we should only set IORESOURCE_UNSET when we find a conflict or a
>>> > BAR that's not contained by an upstream bridge window, and we should
>>> > try to reallocate then.  I'm pretty sure we do that at least in some
>>> > cases, but it would probably simplify things if we did it more
>>> > consistently, and maybe we shouldn't set it at all here in
>>> > __pci_read_base().
>>>
>>> I think so because __pci_read_base() is called in device emulation
>>> path.
>>
>> Which path is this?  I don't know anything about virtio-pci, and I only see
>> calls to __pci_read_base() from:
>>
>>   sriov_init()
>>   pci_sriov_resource_alignment()
>>   pci_read_bases()
>>
>>> > But I'd like to understand your situation better, so can you provide
>>> > more details, please?  Complete before/after dmesg logs would go a
>>> > long way toward illustrating the problem you're seeing.
>>>
>>> Please see the two attachment log. The memory allocation failure
>>> is caused by mistaken value read from pci address after the device
>>> is failed to enable.
>>
>> Your logs are harder than necessary to compare because one has a lot more
>> debug turned on than the other.
>>
>> In the failing case, we ignore all the initial BAR values, but we do assign
>> values to all of them later:
>>
>>   pci 0000:00:00.0: can't claim BAR 0 [mem size 0x00000400]: no address assigned
>>   pci 0000:00:00.0: can't claim BAR 1 [io  size 0x0400]: no address assigned
>>   ...
>>   pci 0000:00:00.0: BAR 0: assigned [mem 0x40000000-0x400003ff]
>>   pci 0000:00:00.0: BAR 1: assigned [io  0x1000-0x13ff]
>>   ...
>>
>> The newly-assigned values look valid, and as far as I can tell, they should
>> work.  Do you know why they don't?  Is there an assumption somewhere that
>> we never change BAR values?
>
> I don't know the cause, maybe it is related with the hypervisor
> implementation.
>
>>
>> Even if we don't need to ignore BAR values in as many cases as we do, it
>> should be legal to ignore them and reassign them, so I want to understand
>> what's going on here before reverting this.
>>
>> Is there an easy way I can reproduce the problem on my own box?
>
> It is not quite difficult, you can build a lkvm following the README in
> below link and test -next tree on the small kvm hypervisor:
>
>      https://github.com/penberg/linux-kvm/blob/master/tools/kvm/README
>
> Thanks,
> --
> Ming Lei



-- 
Ming Lei
