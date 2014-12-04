Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaLDM2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:28:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53543 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLDM2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:28:08 -0500
Message-ID: <54805305.9070105@linaro.org>
Date: Thu, 04 Dec 2014 13:26:45 +0100
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
References: <1417541251-20761-1-git-send-email-eric.auger@linaro.org> <CAFEAcA9YmAVYAOFbmV53Y3zBdcmK9MGSVR4gaLCjKxbyrZ6Xaw@mail.gmail.com> <547DFCD6.3000406@linaro.org> <CAFEAcA_pSiMXX52xUhNBCwiNdZomspFhr_Y+9+F2yb7P_D26bg@mail.gmail.com> <54804D27.1020901@linaro.org> <CAFEAcA_moz=PBJX23Ghj53oYTObNN-Hh8DGZ1Oa=mMKWgM7Emw@mail.gmail.com>
In-Reply-To: <CAFEAcA_moz=PBJX23Ghj53oYTObNN-Hh8DGZ1Oa=mMKWgM7Emw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 01:07 PM, Peter Maydell wrote:
> On 4 December 2014 at 12:01, Eric Auger <eric.auger@linaro.org> wrote:
>> Here is the sequence:
>> 1) The VGIC early initialization is initiated in a machine init done
>> notifier. This notifier is registered in kvm_arm_gic_realize
>> (http://lists.gnu.org/archive/html/qemu-devel/2014-12/msg00220.html). It
>> executes after vcpu instantiations + dist/cpu interface base address
>> setting + nb irq setting.
>> 2) the VFIO signaling and irqfd setup is done in a reset notifier
>> http://lists.gnu.org/archive/html/qemu-devel/2014-11/msg04365.html
> 
> OK. And on x86 VFIO how does this work? Obviously x86's GIC just
> initializes as soon as it's created, but do we do the irqfd setup
> in a reset notifier there too?

This is what I understand from PCI intx init sequence: the vfio
signaling and irqfd setup happens in the vfio_initfn function instead.
first vfio signaling with user-side eventfd handlers is setup
(vfio_enable_intx). if KVM is enabled, vfio_enable_intx then tears the
user-side handlers down and replace them by irqfd kernel-side handlers
(IRQFD setup). the virtual IRQ to be injected to the guest is set to
vdev->intx.route.irq. This obviously requires this routing to be set
before the QEMU PCI VFIO device instantiation.

On ARM case, VFIO device are bound to be dynamically instantiated from
command line using dynamic sysbus device instantiation. Binding of IRQ
is done by a platform bus machine init done notifier. Only at that stage
we know the gsi. hence doing the irqfd init in a reset notifier.

Eric


> 
> thanks
> -- PMM
> 

