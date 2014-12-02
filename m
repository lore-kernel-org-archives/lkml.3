Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaLBSEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:04:10 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33099 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBSEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:04:08 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 13:04:08 EST
Message-ID: <547DFCD6.3000406@linaro.org>
Date: Tue, 02 Dec 2014 18:54:30 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: eric.auger@st.com, Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: add init entry to VGIC KVM device
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org> <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com>
In-Reply-To: <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 06:50 PM, Peter Maydell wrote:
> On 2 December 2014 at 17:27, Eric Auger <eric.auger@linaro.org> wrote:
>> Since the advent of dynamic initialization of VGIC, this latter is
>> initialized very late, on the first vcpu run. This initialization
>> could be initiated much earlier by the user, as soon as it has
>> provided the requested dimensioning parameters:
>> - number of IRQs and number of vCPUs,
>> - DIST and CPU interface base address.
>>
>> One motivation behind being able to initialize the VGIC sooner is
>> related to the setup of IRQ injection in VFIO use case. The VFIO
>> signaling, especially when used along with irqfd must be set *after*
>> vgic initialization to prevent any virtual IRQ injection before
>> VGIC initialization. If virtual IRQ injection occurs before the VGIC
>> init, the IRQ cannot be injected and subsequent injection is blocked
>> due to VFIO completion mechanism (unmask/mask or forward/unforward).
> 
> This implies that you're potentially injecting virtual IRQs
> (and changing the state of the VGIC) before we actually
> start running the VM (ie before userspace calls KVM_RUN).
> Is that right? It seems odd, but maybe vfio works that way?

Hi Peter,

as soon as VFIO signaling is set up (the device IRQ index is linked to
an eventfd, the physical IRQ VFIO handler is installed and the physical
IRQ is enabled at interrupt controller level), virtual IRQs are likely
to be injected. With current QEMU code, we setup this VFIO signaling
*before* the vgic readiness (either on machine init done or reset
notifier) and we face that issue of early injection. QEMU related
patches to follow ...

Best Regards

Eric
> 
> -- PMM
> 

