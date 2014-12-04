Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaLDMDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:03:08 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36910 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaLDMDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:03:06 -0500
Message-ID: <54804D27.1020901@linaro.org>
Date: Thu, 04 Dec 2014 13:01:43 +0100
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
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org> <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com> <547DFCD6.3000406@linaro.org> <CAFEAcA_pSiMXX52xUhNBCwiNdZomspFhr_Y+9+F2yb7P_D26bg@mail.gmail.com>
In-Reply-To: <CAFEAcA_pSiMXX52xUhNBCwiNdZomspFhr_Y+9+F2yb7P_D26bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 11:02 AM, Peter Maydell wrote:
> On 2 December 2014 at 17:54, Eric Auger <eric.auger@linaro.org> wrote:
>> as soon as VFIO signaling is set up (the device IRQ index is linked to
>> an eventfd, the physical IRQ VFIO handler is installed and the physical
>> IRQ is enabled at interrupt controller level), virtual IRQs are likely
>> to be injected. With current QEMU code, we setup this VFIO signaling
>> *before* the vgic readiness (either on machine init done or reset
>> notifier) and we face that issue of early injection. QEMU related
>> patches to follow ...
> 
> So can you describe in QEMU terms how the lifecycle of these
> things works? How do we ensure that we don't start trying
> to inject VFIO IRQs before we've even created the vgic, for
> instance?

Hi Peter,

Here is the sequence:
1) The VGIC early initialization is initiated in a machine init done
notifier. This notifier is registered in kvm_arm_gic_realize
(http://lists.gnu.org/archive/html/qemu-devel/2014-12/msg00220.html). It
executes after vcpu instantiations + dist/cpu interface base address
setting + nb irq setting.
2) the VFIO signaling and irqfd setup is done in a reset notifier
http://lists.gnu.org/archive/html/qemu-devel/2014-11/msg04365.html

Besides https://lkml.org/lkml/2014/12/3/601 now prevents the irqfd setup
if the vgic is not initialized.

QEMU tear down:
in kvm_vm_release, kvm_irqfd_release is called before kvm_vgic_destroy.
This means the irqfd injection is stopped before vgic initialization.
VFIO driver will also will be released by QEMU process, independently on
KVM life cycle. If it still exist while KVM has been released, VFIO
signaling may still be up, meaning eventfd can be signaled but there is
no registered handler anymore, hence no risk of virtual IRQ injection.

Best Regards

Eric


> 
> thanks
> -- PMM
> 

