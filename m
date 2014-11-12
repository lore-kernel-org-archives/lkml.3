Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaKLIdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:33:33 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46248 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaKLIdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:33:32 -0500
Message-ID: <54631B0F.7080804@huawei.com>
Date: Wed, 12 Nov 2014 16:32:15 +0800
From: Shannon Zhao <zhaoshenglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>,
        <Paul.Mundt@huawei.com>
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com> <1415718700.3929.11.camel@arm.com>
In-Reply-To: <1415718700.3929.11.camel@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.16.142]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54631B1D.016B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 2861ad683b822a2148dc389ccaad509c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/11 23:11, Pawel Moll wrote:
> On Tue, 2014-11-04 at 09:35 +0000, Shannon Zhao wrote:
>> As the current virtio-mmio only support single irq,
>> so some advanced features such as vhost-net with irqfd
>> are not supported. And the net performance is not
>> the best without vhost-net and irqfd supporting.
> 
> Could you, please, help understanding me where does the main issue is?
> Is it about:
> 
> 1. The fact that the existing implementation blindly kicks all queues,
> instead only of the updated ones?
> 
> or:
> 
> 2. Literally having a dedicated interrupt line (remember, we're talking
> "real" interrupts here, not message signalled ones) per queue, so they
> can be handled by different processors at the same time?
> 

The main issue is that current virtio-mmio only support one interrupt which is shared by
config and queues. Therefore the virtio-mmio driver should read the
"VIRTIO_MMIO_INTERRUPT_STATUS" to get the interrupt reason and check whom this interrupt is to.

If we use vhost-net which uses irqfd to inject interrupt, the vhost-net doesn't update
"VIRTIO_MMIO_INTERRUPT_STATUS", then the guest driver can't read the interrupt reason and
doesn't call a handler to process.

So we can assign a dedicated interrupt line per queue for virtio-mmio and it can work with
irqfd.

> Now, if it's only about 1, the simplest solution would be to extend the
> VIRTIO_MMIO_INTERRUPT_STATUS register to signal up to 30 queues
> "readiness" in bits 2-31, still keeping bit 0 as a "combined"
> VIRTIO_MMIO_INT_VRING. In case when VIRTIO_MMIO_INT_VRING is set and
> none of the "individual" bits is (a device which doesn't support this
> feature or one that has more than 30 queues and of of those is ready) we
> would fall back to the original "kick all queues" approach. This could
> be a useful (and pretty simple) extension. In the worst case scenario it
> could be a post-1.0 standard addition, as it would provide backward
> compatibility.
> 
> However, if it's about 2, we're talking larger changes here. From the
> device perspective, we can define it as having per-queue (plus one for
> config) interrupt output *and* a "combined" output, being simple logical
> "or" of all the others. Then, the Device Tree bindings would be used to
> express the implementation choices (I'd keep the kernel parameter
> approach supporting the single interrupt case only). This is a very
> popular and well understood approach for memory mapped peripherals (for
> example, see the . It allows the system integrator to make a decision
> when it's coming to latency vs number interrupt lines trade off. The
> main issue is that we can't really impose a limit on a number of queues,
> therefore on a number of interrupts. This would require adding a new
> "interrupt acknowledge" register, which would take a number of the queue
> (or a symbolic value for the config one) instead of a bit mask. And I

Yes, maybe should add a new "interrupt acknowledge" register for backend and frontend to
consult the number of queues.

> must say that I'm not enjoying the idea of such substantial change to
> the specification that late in the process... (in other words: you'll
> have to put extra effort into convincing me :-)
> 
>> This patch support virtio-mmio to request multiple
>> irqs like virtio-pci. With this patch and qemu assigning
>> multiple irqs for virtio-mmio device, it's ok to use
>> vhost-net with irqfd on arm/arm64.
> 
> Could you please tell me how many queues (interrupts) are we talking
> about in this case? 5? A dozen? Hundreds?
> 

Theoretically the number of interrupts has no limit, but as the limit of ARM interrupt line,
the number should  be less than ARM interrupt lines. In the real situation, I think, the number
is generally less than 17 (8 pairs of vring interrupts and one config interrupt).

> Disclaimer: I have no personal experience with virtio and network (due
> to the fact how our Fast Models are implemented, I mostly us block
> devices and 9p protocol over virtio and I get enough performance from
> them :-).
> 
>> As arm doesn't support msi-x now, 
> 
> To be precise: "ARM" does "support" MSI-X :-) (google for GICv2m)

Sorry, I mean ARM with GICv2.
> 
> The correct statement would be: "normal memory mapped devices have no
> interface for message signalled interrupts (like MSI-X)"
> 
Yes, that's right.

>> we use GSI for multiple irq. 
> 
> I'm not sure what GSI stands for, but looking at the code I assume it's
> just a "normal" peripheral interrupt.
> 
>> In this patch we use "vm_try_to_find_vqs"
>> to check whether multiple irqs are supported like
>> virtio-pci.
> 
> Yeah, I can see that you have followed virtio-pci quite literally. I'm
> particularly not convinced to the one interrupt for config, one for all
> queues option. Doesn't make any sense to me here.
> 
About one interrupt for all queues, it's not a typical case. But just offer
one more choice for users. Users should configure the number of interrupts
according to their situation.

>> Is this the right direction? is there other ways to
>> make virtio-mmio support multiple irq? Hope for feedback.
> 
> One point I'd like to make is that the device was intentionally designed
> with simplicity in mind first, performance later (something about
> "embedded" etc" :-). Changing this assumption is of course possible, but
Ah, I think ARM is not only about embedded things. Maybe it could has a wider application
such as micro server. Just my personal opinion.

> - I must say - makes me slightly uncomfortable... The extensions we're
> discussing here seem doable, but I've noticed your other patches doing
> with a shared memory region and I didn't like them at all, sorry.
> 
The approach with a shared memory region is dropped as you can see from the mailing list.

The approach of this patch get a net performance improvement about 30%.
This maybe makes sense to the paltform without MSI support(e.g ARM with GICv2).

> I see the subject has been already touched in the discussions, but let
> me bring PCI to the surface again. We're getting more server-class SOCs
> in the market, which obviously bring PCI with them to both arm and arm64
> world, something unheard of in the "mobile past". I believe the PCI
> patches for the arm64 have been already merged in the kernel.
> 
> Therefore: I'm not your boss so, obviously, I can't tell you what to do,
> but could you consider redirecting your efforts into getting the "ARM
> PCI" up and running in qemu so you can simply use the existing
> infrastructure? This would save us a lot of work and pain in doing late
> functional changes to the standard and will be probably more
> future-proof from your perspective (PCI will happen, sooner or later -
> you can make it sooner ;-)
> 
> Regards
> 
> Pawel
> 
> 
> .
> 


-- 
Shannon

