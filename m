Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3FQIv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:51:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55329 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3FQIvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:51:14 -0400
Message-ID: <51BECDF9.2020701@ozlabs.ru>
Date: Mon, 17 Jun 2013 18:51:05 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-2-git-send-email-aik@ozlabs.ru> <0A6C24DE-1422-4ABA-A516-2B864F4714F8@suse.de> <51BEC0FE.4020805@ozlabs.ru> <F3AAE42F-F325-462B-AD22-F3E568C39A8C@suse.de> <51BECA2B.60401@ozlabs.ru> <5BDDB985-B0A2-476C-B6E5-76E88E3FB182@suse.de>
In-Reply-To: <5BDDB985-B0A2-476C-B6E5-76E88E3FB182@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 06:40 PM, Alexander Graf wrote:
> 
> On 17.06.2013, at 10:34, Alexey Kardashevskiy wrote:
> 
>> On 06/17/2013 06:02 PM, Alexander Graf wrote:
>>> 
>>> On 17.06.2013, at 09:55, Alexey Kardashevskiy wrote:
>>> 
>>>> On 06/17/2013 08:06 AM, Alexander Graf wrote:
>>>>> 
>>>>> On 05.06.2013, at 08:11, Alexey Kardashevskiy wrote:
>>>>> 
>>>>>> This adds real mode handlers for the H_PUT_TCE_INDIRECT and 
>>>>>> H_STUFF_TCE hypercalls for QEMU emulated devices such as
>>>>>> IBMVIO devices or emulated PCI.  These calls allow adding
>>>>>> multiple entries (up to 512) into the TCE table in one call
>>>>>> which saves time on transition to/from real mode.
>>>>>> 
>>>>>> This adds a tce_tmp cache to kvm_vcpu_arch to save valid TCEs 
>>>>>> (copied from user and verified) before writing the whole list
>>>>>> into the TCE table. This cache will be utilized more in the
>>>>>> upcoming VFIO/IOMMU support to continue TCE list processing in
>>>>>> the virtual mode in the case if the real mode handler failed
>>>>>> for some reason.
>>>>>> 
>>>>>> This adds a guest physical to host real address converter and
>>>>>> calls the existing H_PUT_TCE handler. The converting function 
>>>>>> is going to be fully utilized by upcoming VFIO supporting
>>>>>> patches.
>>>>>> 
>>>>>> This also implements the KVM_CAP_PPC_MULTITCE capability, so
>>>>>> in order to support the functionality of this patch, QEMU 
>>>>>> needs to query for this capability and set the
>>>>>> "hcall-multi-tce" hypertas property only if the capability is
>>>>>> present, otherwise there will be serious performance
>>>>>> degradation.
>>>>>> 
>>>>>> Cc: David Gibson <david@gibson.dropbear.id.au> Signed-off-by:
>>>>>> Alexey Kardashevskiy <aik@ozlabs.ru> Signed-off-by: Paul
>>>>>> Mackerras <paulus@samba.org>
>>>>> 
>>>>> Only a few minor nits. Ben already commented on implementation
>>>>> details.
>>>>> 
>>>>>> 
>>>>>> --- Changelog: 2013/06/05: * fixed mistype about IBMVIO in the
>>>>>> commit message * updated doc and moved it to another section *
>>>>>> changed capability number
>>>>>> 
>>>>>> 2013/05/21: * added kvm_vcpu_arch::tce_tmp * removed cleanup
>>>>>> if put_indirect failed, instead we do not even start writing
>>>>>> to TCE table if we cannot get TCEs from the user and they are 
>>>>>> invalid * kvmppc_emulated_h_put_tce is split to
>>>>>> kvmppc_emulated_put_tce and kvmppc_emulated_validate_tce (for
>>>>>> the previous item) * fixed bug with failthrough for H_IPI *
>>>>>> removed all get_user() from real mode handlers *
>>>>>> kvmppc_lookup_pte() added (instead of making lookup_linux_pte
>>>>>> public) --- Documentation/virtual/kvm/api.txt       |   17 ++ 
>>>>>> arch/powerpc/include/asm/kvm_host.h     |    2 + 
>>>>>> arch/powerpc/include/asm/kvm_ppc.h      |   16 +- 
>>>>>> arch/powerpc/kvm/book3s_64_vio.c        |  118 ++++++++++++++ 
>>>>>> arch/powerpc/kvm/book3s_64_vio_hv.c     |  266
>>>>>> +++++++++++++++++++++++++++---- arch/powerpc/kvm/book3s_hv.c
>>>>>> |   39 +++++ arch/powerpc/kvm/book3s_hv_rmhandlers.S |    6 + 
>>>>>> arch/powerpc/kvm/book3s_pr_papr.c       |   37 ++++- 
>>>>>> arch/powerpc/kvm/powerpc.c              |    3 + 
>>>>>> include/uapi/linux/kvm.h                |    1 + 10 files
>>>>>> changed, 473 insertions(+), 32 deletions(-)
>>>>>> 
>>>>>> diff --git a/Documentation/virtual/kvm/api.txt
>>>>>> b/Documentation/virtual/kvm/api.txt index 5f91eda..6c082ff
>>>>>> 100644 --- a/Documentation/virtual/kvm/api.txt +++
>>>>>> b/Documentation/virtual/kvm/api.txt @@ -2362,6 +2362,23 @@
>>>>>> calls by the guest for that service will be passed to
>>>>>> userspace to be handled.
>>>>>> 
>>>>>> 
>>>>>> +4.83 KVM_CAP_PPC_MULTITCE + +Capability:
>>>>>> KVM_CAP_PPC_MULTITCE +Architectures: ppc +Type: vm + +This
>>>>>> capability tells the guest that multiple TCE entry add/remove
>>>>>> hypercalls +handling is supported by the kernel. This
>>>>>> significanly accelerates DMA +operations for PPC KVM guests. 
>>>>>> + +Unlike other capabilities in this section, this one does
>>>>>> not have an ioctl. +Instead, when the capability is present,
>>>>>> the H_PUT_TCE_INDIRECT and +H_STUFF_TCE hypercalls are to be
>>>>>> handled in the host kernel and not passed to +the guest.
>>>>>> Othwerwise it might be better for the guest to continue using
>>>>>> H_PUT_TCE +hypercall (if KVM_CAP_SPAPR_TCE or
>>>>>> KVM_CAP_SPAPR_TCE_IOMMU are present).
>>>>> 
>>>> 
>>>>> While this describes perfectly well what the consequences are of
>>>>> the patches, it does not describe properly what the CAP actually
>>>>> expresses. The CAP only says "this kernel is able to handle
>>>>> H_PUT_TCE_INDIRECT and H_STUFF_TCE hypercalls directly". All
>>>>> other consequences are nice to document, but the semantics of
>>>>> the CAP are missing.
>>>> 
>>>> 
>>>> ? It expresses ability to handle 2 hcalls. What is missing?
>>> 
>>> You don't describe the kvm <-> qemu interface. You describe some
>>> decisions qemu can take from this cap.
>> 
>> 
>> This file does not mention qemu at all. And the interface is - qemu
>> (or kvmtool could do that) just adds "hcall-multi-tce" to 
>> "ibm,hypertas-functions" but this is for pseries linux and AIX could
>> always do it (no idea about it). Does it really have to be in this
>> file?
> 

> Ok, let's go back a step. What does this CAP describe? Don't look at the
> description you wrote above. Just write a new one.

The CAP means the kernel is capable of handling hcalls A and B without
passing those into the user space. That accelerates DMA.


> What exactly can user space expect when it finds this CAP?

The user space can expect that its handlers for A and B are not going to be
called if it configures the guest appropriately.

Any better? :)


-- 
Alexey
