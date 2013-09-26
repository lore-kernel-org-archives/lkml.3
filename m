Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3IZEbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:31:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41132 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3IZEbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:31:32 -0400
Message-ID: <5243B89C.9070207@ozlabs.ru>
Date: Thu, 26 Sep 2013 14:31:24 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, gleb@redhat.com, benh@kernel.crashing.org,
        bsd@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [RFC PATCH 3/3] kvm: Add VFIO device for handling IOMMU cache
 coherency
References: <20130912211401.8542.82932.stgit@bling.home>   <20130912212314.8542.9692.stgit@bling.home> <5232D186.6090701@ozlabs.ru>  <1379089544.19727.46.camel@ul30vt.home> <5235AAC2.7040207@ozlabs.ru> <1380140346.5197.38.camel@ul30vt.home>
In-Reply-To: <1380140346.5197.38.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 06:19 AM, Alex Williamson wrote:
> On Sun, 2013-09-15 at 22:40 +1000, Alexey Kardashevskiy wrote:
>> On 09/14/2013 02:25 AM, Alex Williamson wrote:
>>> On Fri, 2013-09-13 at 18:49 +1000, Alexey Kardashevskiy wrote:
>>>> On 09/13/2013 07:23 AM, Alex Williamson wrote:
>>>>> So far we've succeeded at making KVM and VFIO mostly unaware of each
>>>>> other, but there's any important point where that breaks down.  Intel
>>>>> VT-d hardware may or may not support snoop control.  When snoop
>>>>> control is available, intel-iommu promotes No-Snoop transactions on
>>>>> PCIe to be cache coherent.  That allows KVM to handle things like the
>>>>> x86 WBINVD opcode as a nop.  When the hardware does not support this,
>>>>> KVM must implement a hardware visible WBINVD for the guest.
>>>>>
>>>>> We could simply let userspace tell KVM how to handle WBINVD, but it's
>>>>> privileged for a reason.  Allowing an arbitrary user to enable
>>>>> physical WBINVD gives them a more access to the hardware.  Previously,
>>>>> this has only been enabled for guests supporting legacy PCI device
>>>>> assignment.  In such cases it's necessary for proper guest execution.
>>>>> We therefore create a new KVM-VFIO virtual device.  The user can add
>>>>> and remove VFIO groups to this device via file descriptors.  KVM
>>>>> makes use of the VFIO external user interface to validate that the
>>>>> user has access to physical hardware and gets the coherency state of
>>>>> the IOMMU from VFIO.  This provides equivalent functionality to
>>>>> legacy KVM assignment, while keeping (nearly) all the bits isolated.
>>>>>
>>>>> The one intrusion is the resulting flag indicating the coherency
>>>>> state.  For this RFC it's placed on the x86 kvm_arch struct, however
>>>>> I know POWER has interest in using the VFIO external user interface,
>>>>> and I'm hoping we can share a common KVM-VFIO device.  Perhaps they
>>>>> care about No-Snoop handling as well or the code can be #ifdef'd.
>>>>
>>>>
>>>> POWER does not support (at least boos3s - "server", not sure about others)
>>>> this cache-non-coherent stuff at all.
>>>
>>> Then it's easy for your IOMMU API interface to return always cache
>>> coherent or never cache coherent or whatever ;)
>>>
>>>> Regarding reusing this device with external API for POWER - I posted a
>>>> patch which introduces KVM device to link KVM with IOMMU but besides the
>>>> list of groups registered in KVM, it also provides the way to find a group
>>>> by LIOBN (logical bus number) which is used in DMA map/unmap hypercalls. So
>>>> in my case kvm_vfio_group struct needs LIOBN and it would be nice to have
>>>> there window_size too (for a quick boundary check). I am not sure we want
>>>> to mix everything here.
>>>>
>>>> It is in "[PATCH v10 12/13] KVM: PPC: Add support for IOMMU in-kernel
>>>> handling" if you are interested (kvmppc_spapr_tce_iommu_device).
>>>
>>> Yes, I stole the code to get the vfio symbols from your code.  The
>>> convergence I was hoping to achieve is that KVM doesn't really want to
>>> know about VFIO and vica versa.  We can therefore at least limit the
>>> intrusion by sharing a common device.  Obviously for you it will need
>>> some extra interfaces to associate an LIOBN to a group, but we keep both
>>> the kernel an userspace cleaner by avoiding duplication where we can.
>>> Is this really not extensible to your usage?
>>
>> Well, I do not have a good taste for this kind of stuff so I cannot tell
>> for sure. I can reuse this device and hack it to do whatever I need but how?
>>
>> There are 2 things I need from KVM device:
>> 1. associate IOMMU group with LIOBN
> 
> Does QEMU know this?  We could set another attribute to specify the
> LIOBN for a group.

QEMU knows as QEMU decides on LOIBN number. And yes, we could do that.


>> 2. get a pointer to an IOMMU group by LIOBN (used to get ppc's IOMMU table
>> pointer which is an IOMMU data of an IOMMU group so we could take a
>> shortcut here).
> 
> Once we have a VFIO device with a VFIO group added and the LIOBN
> attribute set, isn't this just a matter of some access code?


The lookup function will be called from what we call a realmode on PPC64,
i.e. when MMU is off and kvm.ko code is not available. So we will either
have to put this lookup function to a separate virt/kvm/vfio_rm.c or
compile the whole thing into the kernel image but this is not a big issue
anyway.

You can have a look for example at book3s_64_vio_hv.o vs. book3s_64_vio.o
to get a better picture if you like.


>> There are 3 possible interfaces to use:
>> A. set/get attributes
>> B. ioctl
>> C. additional API
> 
> I think we need to differentiate user interfaces from kernel interfaces.
> Within the kernel, we make no guarantees about interfaces and we can
> change them to meet our needs.  That includes the vfio external user
> interface.  For userspace, we need to be careful not to break things.  I
> suggest we use the set/get/has attribute interface that's already part
> of KVM for the user interface.
> 
>> What I posted a week ago uses A for 1 and C for 2. Now we move this to
>> virt/kvm/vfio.c.
> 
> I don't care where it lives, other than we both have a need for it, so
> it seems like the core of it should not live in architecture specific
> directories.
> 
>> A for 1 is more or less ok but how exactly? Yet another attribute? Platform
>> specific "bus ID"? In your patch attr->addr is not really an address (to be
>> accessed with get_user()) but just an fd.
> 
> Is that a problem?

Not for me but I have a bad taste :)


>> For 2 - there are already A and B interfaces so we do not want C, right?
>> What kind of a good device has a backdoor? :) But A and B do not have
>> access control to prevent the user space from receiving a IOMMU group
>> pointer (which it would not be able to use anyway but still). Do we care
>> about this (I do not)? And using B (ioctls) within the kernel - I cannot
>> say I saw many usages of this.
> 
> For kernel internal things we don't want to invent new ioctls or use the
> KVM device get_attr interface.  Note that I didn't provide a get_attr
> interface for anything there now.  I think we just want to create a
> kernel internal interface, ie. function calls.
> 
>> I am pretty sure we will spend some time (not much) arguing about these
>> things and when we agree on something, then some of KVM maintainers will
>> step in and say that there is 1001st way of doing this and - goto start.
>> And after all, this still won't be a device as it does not emulate anything
>> present in the real hardware, this is just yet another interface to KVM and
>> some ways of using it won't be natural for somebody. /me sighs.
> 
> And thus this RFC with somewhat rough code to try to get buyin.  Thanks,


Well, I do not see any big issue (including no-mmu real mode) with the VFIO
KVM device as you posted it.


-- 
Alexey
