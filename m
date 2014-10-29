Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaJ2KLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:11:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56521 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaJ2KLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:11:48 -0400
Message-ID: <5450BD61.10102@arm.com>
Date: Wed, 29 Oct 2014 10:11:45 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com> <alpine.DEB.2.11.1410272158160.5308@nanos> <544FF183.9030705@arm.com> <alpine.DEB.2.11.1410282054490.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410282054490.5308@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 29 Oct 2014 10:11:46.0419 (UTC) FILETIME=[BF048C30:01CFF360]
X-MC-Unique: 114102910114609101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 20:14, Thomas Gleixner wrote:
> On Tue, 28 Oct 2014, Marc Zyngier wrote:
>> On 28/10/14 15:32, Thomas Gleixner wrote:
>>> Let me make a few assumptions and correct me if I'm wrong as usual.
>>>
>>> 1) The startup/shutdown procedure for such an interrupt is the
>>>    expensive mask/unmask which you want to avoid for the actual
>>>    handling case
>>
>> Indeed.
>>
>>> 2) In case of an actual interrupt the flow (ignoring locking) is:
>>>
>>>    handle_xxx_irq()
>>>
>>> 	mask_irq();	/* chip->irq_mask() maps to EOI */
>>>
>>> 	if (!action || irq_disabled())
>>> 	   return;
>>>
>>> 	handle_actions();
>>>
>>> 	if (irq_threads_active() || irq_disabled())
>>> 	   return;
>>>
>>> 	unmask_irq();	/* chip->irq_unmask() maps to DIR */
>>>
>>>   So that is handle_level_irq() with the chip callbacks being:
>>>
>>>    irq_startup  = gic_unmask
>>>    irq_shutdown = gic_mask
>>>    irq_unmask	= gic_dir
>>>    irq_mask	= gic_eoi
>>
>> So while this works really well for the interrupt handling part, it will
>> break [un]mask_irq(). This is because you can only write to EOI for an
>> interrupt that you have ACKed just before (anything else and the GIC
>> state machine goes crazy). Basically, any use for EOI/DIR outside of the
>> interrupt context itself (hardirq or thread) is really dangerous.
> 
> I really doubt that the DIR invocation is dangerous outside of
> interrupt context. Otherwise your threaded scheme would not work at
> all as the DIR invocation happens in thread context.

There is a small restriction in the use of DIR (quoting the spec):

"If the interrupt identified in the GICC_DIR is not active, and is not a
spurious interrupt, the effect of the register write is UNPREDICTABLE.
This means any GICC_DIR write must identify an interrupt for which there
has been a valid GICC_EOIR or GICC_AEOIR write."

I think that affect the irq_enable you describe below.

> The nice thing about the lazy irq disable code is that the irq_mask(),
> i.e. EOI, invocation actually happens always in hard interrupt
> context. We should never invoke irq_mask() from any other context if
> you supply a startup/shutdown function.
> 
>> If we had a flag like IRQCHIP_UNMASK_IS_STARTUP, we could distinguish
>> this particular case, but that's borderline ugly.
> 
> Indeed. But I don't think it is required. See also below.
> 
>>> 4) In the lazy irq disable case if the interrupt fires mask_irq()
>>>    [EOI] is good enough to silence it.
>>>
>>>    Though in the enable_irq() case you cannot rely on the automatic
>>>    resend of the interrupt when you unmask [DIR]. So we need to make
>>>    sure that even in the level case (dunno whether that's supported in
>>>    that mode) we end up calling the irq_retrigger() callback. But
>>>    that's rather simple to achieve with a new chip flag.
>>
>> I think this one breaks for the same reason as above. And an interrupt
>> masked with EOI cannot easily be restarted without clearing the ACTIVE
>> bit (and everything becomes even more of a complete madness).
> 
> So we already established that irq_mask()/EOI will only be called from
> the actual interrupt context and irq_unmask()/DIR must be safe to be
> called from any context in order to make the EOI/DIR based threaded
> optimization work.
> 
> So the only interesting code path is enable_irq() which invokes
> irq_enable() and then the resend/retrigger machinery. 
> 
> irq_enable() calls chip->irq_unmask(), i.e. DIR. So that clears the
> ACTIVE bit and then the IRQ either gets resent by hardware (in case of
> level as the device interrupt is still active) or retriggered by the
> irq_retrigger() callback.

The problem I see here is for an interrupt that has been flagged as
disabled with irq_disabled(), but that hasn't fired. We'd end up doing a
DIR on something that hasn't had an EOI first. I think that's the only
wrinkle in this scheme.

I'll implement something today, that will help me thinking.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

