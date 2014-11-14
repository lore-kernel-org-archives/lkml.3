Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161593AbaKNRyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:54:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58403 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbaKNRyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:54:37 -0500
Message-ID: <1415987658.3929.58.camel@arm.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
From: Pawel Moll <pawel.moll@arm.com>
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "remy.gauguey@cea.fr" <remy.gauguey@cea.fr>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "Paul.Mundt@huawei.com" <Paul.Mundt@huawei.com>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Fri, 14 Nov 2014 17:54:18 +0000
In-Reply-To: <54647C3A.6050106@huawei.com>
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
	 <1415718700.3929.11.camel@arm.com> <54631B0F.7080804@huawei.com>
	 <1415817209.3929.31.camel@arm.com> <54647C3A.6050106@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 09:39 +0000, Shannon Zhao wrote:
> When we use only virtio-mmio or vhost-net without irqfd, the device uses qemu_set_irq(within qemu)
> to inject interrupt and at the same time qemu update "VIRTIO_MMIO_INTERRUPT_STATUS" to tell guest
> driver whom this interrupt to. All these things are done by qemu. Though qemu_set_irq will call
> kvm_set_irq to do the real interrupt inject, but the trigger is qemu and it can update the
> "VIRTIO_MMIO_INTERRUPT_STATUS" register before injecting the interrupt.
> 
> But if we use vhost-net with irqfd, the device uses ioeventfd mechanism to inject interrupt.
> When an interrupt happened, it doesn't transfer to qemu, while the irqfd finally call kvm_set_irq
> to inject the interrupt directly. All these things are done in kvm and it can't update the
> "VIRTIO_MMIO_INTERRUPT_STATUS" register.
> So if the guest driver still uses the old interrupt handler, it has to read the
> "VIRTIO_MMIO_INTERRUPT_STATUS" register to get the interrupt reason and run different handlers
> for different reasons. But the register has nothing and none of handlers will be called.
> 
> I make myself clear? :-)

I see... (well, at least I believe I see ;-)

Of course this means that with irqfd, the device is simply non-compliant
with the spec. And that extending the status register doesn't help you
at all, so we can drop this idea.

Paradoxically, it's a good news (of a sort :-) because I don't think we
should be doing such a fundamental change in the spec at this date. I'll
discuss it with others in the TC and I'm open to be convinced otherwise,
but I believe the spec should stay as it is.

Having said that, I see no problem with experimenting with the device
model so the next version of the standard is extended. Two suggestions I
have would be:

1. Drop the virtio-pci like case with two interrupts (one for config
changes, one for all queues), as it doesn't bring anything new. Just
make it all interrupts individual.

2. Change the way the interrupts are acknowledge - instead of a bitmask,
have a register which takes a queue number to ack the queue's interrupt
and ~0 to ack the config interrupt.

3. Change the version of the device to (intially) 0x80000003 - I've just
made an executive decision :-) that non-standard compliant devices
should have the MSB of the version number set (I'll propose to reserve
this range of versions in future version of the spec). We'll consider it
a "prototype of the version 3". Then make the driver behave in the new
way when (and only when) such device version is observed.

Also, I remembered I haven't addressed one of your previous comments:

On Wed, 2014-11-12 at 08:32 +0000, Shannon Zhao wrote:
> > One point I'd like to make is that the device was intentionally designed
> > with simplicity in mind first, performance later (something about
> > "embedded" etc" :-). Changing this assumption is of course possible, but
> Ah, I think ARM is not only about embedded things. Maybe it could has
> a wider application > such as micro server. Just my personal opinion.

By all means, I couldn't agree more. But there's one thing you have to
keep in mind - it doesn't matter whether the real hardware has got PCI
or not, but what is emulated by qemu/KVM. Therefore, if only you can get
the PCI host controller working in the qemu virt machine (which should
be much simpler now, as we have generic support for PCI
controllers/bridges in the kernel now), you'll be able to forget the
issue of virtio-mmio and multiple interrupts and still enjoy your
performance gains :-)

Does it all make sense?

Pawel


