Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaKLSdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:33:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56985 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaKLSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:33:38 -0500
Message-ID: <1415817209.3929.31.camel@arm.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
From: Pawel Moll <pawel.moll@arm.com>
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "remy.gauguey@cea.fr" <remy.gauguey@cea.fr>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "Paul.Mundt@huawei.com" <Paul.Mundt@huawei.com>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 12 Nov 2014 18:33:29 +0000
In-Reply-To: <54631B0F.7080804@huawei.com>
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
	 <1415718700.3929.11.camel@arm.com> <54631B0F.7080804@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 08:32 +0000, Shannon Zhao wrote:
> On 2014/11/11 23:11, Pawel Moll wrote:
> > On Tue, 2014-11-04 at 09:35 +0000, Shannon Zhao wrote:
> >> As the current virtio-mmio only support single irq,
> >> so some advanced features such as vhost-net with irqfd
> >> are not supported. And the net performance is not
> >> the best without vhost-net and irqfd supporting.
> > 
> > Could you, please, help understanding me where does the main issue is?
> > Is it about:
> > 
> > 1. The fact that the existing implementation blindly kicks all queues,
> > instead only of the updated ones?
> > 
> > or:
> > 
> > 2. Literally having a dedicated interrupt line (remember, we're talking
> > "real" interrupts here, not message signalled ones) per queue, so they
> > can be handled by different processors at the same time?
> > 
> The main issue is that current virtio-mmio only support one interrupt which is shared by
> config and queues. 

Yes.

Additional question: is your device changing the configuration space
often? Other devices (for example block devices) change configuration
very rarely (eg. change of the media size, usually meaning
hot-un-plugging), so unless you tell me that the config space is
frequently changes, I'll consider the config event irrelevant from the
performance point of view.

> Therefore the virtio-mmio driver should read the
> "VIRTIO_MMIO_INTERRUPT_STATUS" to get the interrupt reason and check whom this interrupt is to.

Correct.

> If we use vhost-net which uses irqfd to inject interrupt, the
> vhost-net doesn't update "VIRTIO_MMIO_INTERRUPT_STATUS", then the
> guest driver can't read the interrupt reason and doesn't call a
> handler to process.

Ok, so this is the bit I don't understand. Explain, please how does this
whole thing work. And keep in mind that I've just looked up "irqfd" for
the first time in my life, so know nothing about its implementation. The
same applies to "vhost-net". I'm simply coming from a completely
different background, so bear with me on this.

Now, the virtio-mmio device *must* behave in a certain way, as specified
in both the old and the new version of the spec. If a Used Ring of *any*
of the queues has been updated the device *must* set bit 0 of the
interrupt status register, and - in effect - generate the interrupt.

But you are telling me that in some circumstances the interrupt is *not*
generated when a queue requires handling. Sounds like a bug to me, as it
is not following the requirements of the device specification.

It is quite likely that I simply don't see some facts which are obvious
for you, so please - help me understand.

> So we can assign a dedicated interrupt line per queue for virtio-mmio
> and it can work with irqfd.
> 
If my reasoning above is correct, I'd say that you are just working
around a functional bug, not improving performance. And this is a wrong
way of solving the problem.

> Theoretically the number of interrupts has no limit, but as the limit
> of ARM interrupt line, the number should  be less than ARM interrupt
> lines. 

Let me just emphasize the fact that virtio-mmio is not related to ARM in
any way, it's just a memory mapped device with a generic interrupt
output. Any limitations of a particular hardware platform (I guess
you're referring to the maximum number of peripheral interrupts a GIC
can take) are irrelevant - if we go with multiple interrupts, it must
cater for as many interrupt lines as one wishes... :-)

> In the real situation, I think, the number
> is generally less than 17 (8 pairs of vring interrupts and one config
> interrupt).

... but of course we could optimize for the real scenarios. And I'm glad
to hear that the number you quoted is less then 30 :-)

> >> we use GSI for multiple irq. 
> > 
> > I'm not sure what GSI stands for, but looking at the code I assume it's
> > just a "normal" peripheral interrupt.
> > 
> >> In this patch we use "vm_try_to_find_vqs"
> >> to check whether multiple irqs are supported like
> >> virtio-pci.
> > 
> > Yeah, I can see that you have followed virtio-pci quite literally. I'm
> > particularly not convinced to the one interrupt for config, one for all
> > queues option. Doesn't make any sense to me here.
> > 
> About one interrupt for all queues, it's not a typical case. But just offer
> one more choice for users. Users should configure the number of interrupts
> according to their situation.


> >> Is this the right direction? is there other ways to
> >> make virtio-mmio support multiple irq? Hope for feedback.
> > 
> > One point I'd like to make is that the device was intentionally designed
> > with simplicity in mind first, performance later (something about
> > "embedded" etc" :-). Changing this assumption is of course possible, but
> Ah, I think ARM is not only about embedded things. Maybe it could has a wider application
> such as micro server. Just my personal opinion.
> 
> > - I must say - makes me slightly uncomfortable... The extensions we're
> > discussing here seem doable, but I've noticed your other patches doing
> > with a shared memory region and I didn't like them at all, sorry.
> > 
> The approach with a shared memory region is dropped as you can see from the mailing list.

Glad to hear that :-)

> The approach of this patch get a net performance improvement about 30%.
> This maybe makes sense to the paltform without MSI support(e.g ARM with GICv2).

I appreciate the improvement. I'm just cautions when it comes to
significant changes to the standard so late in the process.

Pawel

