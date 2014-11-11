Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaKKPLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:11:46 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56118 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKKPLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:11:45 -0500
Message-ID: <1415718700.3929.11.camel@arm.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
From: Pawel Moll <pawel.moll@arm.com>
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "hangaohuai@huawei.com" <hangaohuai@huawei.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "remy.gauguey@cea.fr" <remy.gauguey@cea.fr>,
        "mst@redhat.com" <mst@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "n.nikolaev@virtualopensystems.com" 
	<n.nikolaev@virtualopensystems.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>
Date: Tue, 11 Nov 2014 15:11:40 +0000
In-Reply-To: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 09:35 +0000, Shannon Zhao wrote:
> As the current virtio-mmio only support single irq,
> so some advanced features such as vhost-net with irqfd
> are not supported. And the net performance is not
> the best without vhost-net and irqfd supporting.

Could you, please, help understanding me where does the main issue is?
Is it about:

1. The fact that the existing implementation blindly kicks all queues,
instead only of the updated ones?

or:

2. Literally having a dedicated interrupt line (remember, we're talking
"real" interrupts here, not message signalled ones) per queue, so they
can be handled by different processors at the same time?

Now, if it's only about 1, the simplest solution would be to extend the
VIRTIO_MMIO_INTERRUPT_STATUS register to signal up to 30 queues
"readiness" in bits 2-31, still keeping bit 0 as a "combined"
VIRTIO_MMIO_INT_VRING. In case when VIRTIO_MMIO_INT_VRING is set and
none of the "individual" bits is (a device which doesn't support this
feature or one that has more than 30 queues and of of those is ready) we
would fall back to the original "kick all queues" approach. This could
be a useful (and pretty simple) extension. In the worst case scenario it
could be a post-1.0 standard addition, as it would provide backward
compatibility.

However, if it's about 2, we're talking larger changes here. From the
device perspective, we can define it as having per-queue (plus one for
config) interrupt output *and* a "combined" output, being simple logical
"or" of all the others. Then, the Device Tree bindings would be used to
express the implementation choices (I'd keep the kernel parameter
approach supporting the single interrupt case only). This is a very
popular and well understood approach for memory mapped peripherals (for
example, see the . It allows the system integrator to make a decision
when it's coming to latency vs number interrupt lines trade off. The
main issue is that we can't really impose a limit on a number of queues,
therefore on a number of interrupts. This would require adding a new
"interrupt acknowledge" register, which would take a number of the queue
(or a symbolic value for the config one) instead of a bit mask. And I
must say that I'm not enjoying the idea of such substantial change to
the specification that late in the process... (in other words: you'll
have to put extra effort into convincing me :-)

> This patch support virtio-mmio to request multiple
> irqs like virtio-pci. With this patch and qemu assigning
> multiple irqs for virtio-mmio device, it's ok to use
> vhost-net with irqfd on arm/arm64.

Could you please tell me how many queues (interrupts) are we talking
about in this case? 5? A dozen? Hundreds?

Disclaimer: I have no personal experience with virtio and network (due
to the fact how our Fast Models are implemented, I mostly us block
devices and 9p protocol over virtio and I get enough performance from
them :-).

> As arm doesn't support msi-x now, 

To be precise: "ARM" does "support" MSI-X :-) (google for GICv2m)

The correct statement would be: "normal memory mapped devices have no
interface for message signalled interrupts (like MSI-X)"

> we use GSI for multiple irq. 

I'm not sure what GSI stands for, but looking at the code I assume it's
just a "normal" peripheral interrupt.

> In this patch we use "vm_try_to_find_vqs"
> to check whether multiple irqs are supported like
> virtio-pci.

Yeah, I can see that you have followed virtio-pci quite literally. I'm
particularly not convinced to the one interrupt for config, one for all
queues option. Doesn't make any sense to me here.

> Is this the right direction? is there other ways to
> make virtio-mmio support multiple irq? Hope for feedback.

One point I'd like to make is that the device was intentionally designed
with simplicity in mind first, performance later (something about
"embedded" etc" :-). Changing this assumption is of course possible, but
- I must say - makes me slightly uncomfortable... The extensions we're
discussing here seem doable, but I've noticed your other patches doing
with a shared memory region and I didn't like them at all, sorry.

I see the subject has been already touched in the discussions, but let
me bring PCI to the surface again. We're getting more server-class SOCs
in the market, which obviously bring PCI with them to both arm and arm64
world, something unheard of in the "mobile past". I believe the PCI
patches for the arm64 have been already merged in the kernel.

Therefore: I'm not your boss so, obviously, I can't tell you what to do,
but could you consider redirecting your efforts into getting the "ARM
PCI" up and running in qemu so you can simply use the existing
infrastructure? This would save us a lot of work and pain in doing late
functional changes to the standard and will be probably more
future-proof from your perspective (PCI will happen, sooner or later -
you can make it sooner ;-)

Regards

Pawel

