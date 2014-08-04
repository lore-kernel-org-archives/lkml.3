Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaHDNNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:13:55 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42614 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752263AbaHDNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:13:54 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 7/9] KVM: arm: vgic: allow dynamic mapping of physical/virtual interrupts
In-Reply-To: <53DE0584.2040405@linaro.org> (Eric Auger's message of "Sun, 3
	Aug 2014 10:48:52 +0100")
Organization: ARM Ltd
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	<1403688530-23273-8-git-send-email-marc.zyngier@arm.com>
	<53DE0584.2040405@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 04 Aug 2014 14:13:35 +0100
Message-ID: <87bns0gzy8.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03 2014 at 10:48:52 am BST, Eric Auger <eric.auger@linaro.org> wrote:
> On 06/25/2014 11:28 AM, Marc Zyngier wrote:
>> In order to be able to feed physical interrupts to a guest, we need
>> to be able to establish the virtual-physical mapping between the two
>> worlds.
>> 
>> As we try to keep the injection interface simple, find out what the
>> physical interrupt is (if any) when we actually build the LR.
>> 
>> The mapping is kept in a rbtree, indexed by virtual interrupts.
>
> Hi Marc,
>
> I suspect there is a piece missing here related to bitmap state
> management. When using maintenance IRQ, in process_maintenance we cleared
> - dist->irq_pending (and new dist->irq_level)
> - vcpu->irq_queued
>
> Now this does not exist anymore for forwarded irqs, when a subsequent
> IRQ will be injected, vgic_update_irq_pending will fail in injecting the
> IRQ because the states are reflecting the IRQ is still in progress.
>
> Since I have a modified version of your code, using Christoffer patches
> I may have missed some modifications you did but at least on my side I
> was forced to add bitmap clearing.
>
> It is not clear to me where to put that code however. Since user-side
> can inject an IRQ while the previous one is not completed at guest and
> host level, it cannot be in update_irq_pending - or we shall prevent the
> user from injecting fwd IRQs - .

Interesting. Indeed, userspace shouldn't be allowed to inject a
forwarded interrupt (or actually the virtual interrupt that matches the
physical one). This interrupt is now under complete control of the
kernel, and shouldn't triggered by userspace.

Now, it is completely possible that we're missing something here (or
actually doing too much).

> In my case (VFIO/IRQFD), by construction I only inject a new forwarded
> IRQ when the previous one was completed so I could put it in the irqfd
> injection function. But even irqfd is injected through eventfd trigger.
> We shall forbid the user-side to trigger that eventfd in place of the
> VFIO driver. What do you think?

Yup. userspace can't interfere with a forwarded interrupt, that's way
too dangerous.

> A question related to guest kill. Cannot it happen the guest sometimes
> does not complete the vIRQ before exiting? Currently I observe cases
> where when I launch qemu-system after a kill, forwarded irqs do not work
> properly. I am not yet sure this is the cause of my problem but just in
> case, can the host write into GICV_EOIR in place of guest?

It is quite possible that the interrupt is left active when the guest is
killed, which would tend to indicate that we need a way to cleanup
behind us. It should be enough to clear the active bit, shouldn't it?

> Besides those problems, the patch works in my test environment

Thanks for testing!

	M.
-- 
Jazz is not dead. It just smells funny.
