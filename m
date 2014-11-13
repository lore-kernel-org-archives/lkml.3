Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbaKMPN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:13:26 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62506 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbaKMPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <CADDJ2=OLkE36N_QyW==qL5oWu=t4YY0BZ1ekUPv_-Y7gga7xVw@mail.gmail.com>
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
	<1394726249-1547-2-git-send-email-a.motakis@virtualopensystems.com>
	<20140328190913.GJ25519@cbox>
	<CADDJ2=Opx2d5ex0hWSXYJjs6uLifR9wZVsahUHzZ7zytSj7ZSg@mail.gmail.com>
	<20141110162736.GA16054@cbox>
	<CADDJ2=PTM0fJ0RFfWdVQ1-471xqaJmj0vP1f5-pf57xOV5jgig@mail.gmail.com>
	<5464BD30.7040702@linaro.org>
	<5464BEC9.1050401@linaro.org>
	<CADDJ2=OLkE36N_QyW==qL5oWu=t4YY0BZ1ekUPv_-Y7gga7xVw@mail.gmail.com>
Date: Thu, 13 Nov 2014 16:13:21 +0100
Message-ID: <CAMJs5B9Z42y3=VTAk5XWo070z0oRLorMaO_h_s2wzb8_PePWzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] ARM: KVM: on unhandled IO mem abort, route the
 call to the KVM MMIO bus
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
Cc: Eric Auger <eric.auger@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "moderated list:ARM PORT <linux-arm-kernel@lists.infradead.org>, Andre
	Przywara" <Andre.Przywara@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikolay,

On Thu, Nov 13, 2014 at 4:02 PM, Nikolay Nikolaev
<n.nikolaev@virtualopensystems.com> wrote:
[...]

>>>>>>
>>>>>>
>>>>>> We're reconsidering ioeventfds patchseries and we tried to evaluate
>>>>>> what you suggested here.
>>>>>>
>>>>>>>
>>>>>>> this special-casing of the vgic is now really terrible.  Is there
>>>>>>> anything holding you back from doing the necessary restructure of the
>>>>>>> kvm_bus_io_*() API instead?
>>>>>>
>>>>>> Restructuring the kvm_io_bus_ API is not a big thing (we actually did
>>>>>> it), but is not directly related to the these patches.
>>>>>> Of course it can be justified if we do it in the context of removing
>>>>>> vgic_handle_mmio and leaving only handle_kernel_mmio.
>>>>>>
>>>>>>>
>>>>>>> That would allow us to get rid of the ugly
>>>>>>> Fix it! in the vgic driver as well.
>>>>>>
>>>>>> Going through the vgic_handle_mmio we see that it will require large
>>>>>> refactoring:
>>>>>>  - there are 15 MMIO ranges for the vgic now - each should be
>>>>>> registered as a separate device
>> Re-correcting Andre's address, sorry:
>> Hi Nikolay, Andre,
>>
>> what does mandate to register 15 devices? Isn't possible to register a
>> single kvm_io_device covering the whole distributor range [base, base +
>> KVM_VGIC_V2_DIST_SIZE] (current code) and in associated
>> kvm_io_device_ops read/write locate the addressed range and do the same
>> as what is done in current vgic_handle_mmio? Isn't it done that way for
>
> Well, then we'll actually get slower mmio processing. Instead of calling
> vgic_handle_mmio in io_mem_abort, we'll be calling kvm_io_bus_write.
> This just adds another level of translation (i.e. find the kvm_io_ device)
> and the underlying vgic code will remain almost the same.
>

Define slower please.  Have you measured this?  With my ideas about
where we are spending overhead on a world-switch in this system,
looping through a few ranges is going to be infinitesimal, but as I
said, we would need to measure it before using it as an argument to
structure the code in a certain way, unless of course we're obviously
doing O(n^2) operations or something idiotic like that.

-Christoffer
