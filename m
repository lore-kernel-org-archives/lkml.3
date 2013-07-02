Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3GBAAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:00:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:51016 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3GBAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:00:41 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1307020022570.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-5-git-send-email-james.hogan@imgtec.com> <alpine.DEB.2.02.1307012346320.4013@ionos.tec.linutronix.de> <CAAG0J9_fTNrKe7idPi3=O2kGRWBJmYSwMQuzGPiT2G+rXy4QuA@mail.gmail.com> <alpine.DEB.2.02.1307020022570.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 4/5] metag: kick: prevent nested kick handlers
From: James Hogan <james.hogan@imgtec.com>
Date: Tue, 02 Jul 2013 01:00:26 +0100
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, james.hogan@imgtec.com
Message-ID: <0095784b-d55b-4b14-8510-5c6bc3ea782b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

>On Mon, 1 Jul 2013, James Hogan wrote:
>> On 1 July 2013 22:51, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Mon, 1 Jul 2013, James Hogan wrote:
>> >
>> >> The main kick trigger handler iterates a list of kick handlers and
>calls
>> >> each one. This is done with the kick_handlers_lock spin lock held,
>but
>> >> this causes a problem on SMP where IPIs are implemented with
>kicks. A
>> >> reschedule IPI calls scheduler_ipi() which uses irq_enter() and
>> >> irq_exit(). This results in the scheduler being invoked with
>> >> kick_handlers_lock held which can result in a nested kick trigger
>> >> attempting to acquire the lock, resulting in deadlock.
>> >>
>> >> irq_enter() and irq_exit() can nest, so call them from the main
>kick
>> >> interrupt handler so that softirqs are only handled after
>> >> kick_handlers_lock is released.
>> >
>> > This changelog is confusing. What I decode from the patch is, that
>you
>> > are adding a missing irq_enter/exit pair to the kick_handler, right
>?
>> 
>> Yes. Previously the outermost pair of irq_enter/exit was inside the
>> spin lock critical section (inside scheduler_ipi). so soft-irqs
>> (apparently including the scheduler) would run from irq_exit with the
>> spinlock still held. Now it waits until the new outermost irq_exit(),
>> after the spin lock is released.
>> 
>> I should probably have increased the number of lines of diff context.
>> http://lxr.linux.no/#linux+v3.10/arch/metag/kernel/kick.c#L66
>
>No, you should have written the changelog less confusing. I can see
>the context by just looking at the current and the patched code.

Yes, i agree, sorry it wasn't clear.

>The explanation you provided right now that the outermost pair of
>irq_enter/exit was inside the spin locked section matches the patch
>and makes sense.
>
>So the real issue is, that all of your various interrupts come from

Only kicks, which are the hardware IPI mechanism (in practice only used for SMP IPIs and for communication with non-linux hw threads). Timer/peripheral interrupts come via different handlers.

>the same place, i.e. kick_handler. The kick_handler locks a global
>lock and calls the handlers which have registered. These handlers
>(partially calling generic code) might invoke irq_enter/exit pairs,
>which leads to the underlying problem.
>
>If irq_exit() results in a nest count of hard interrupts = 0, then it
>invokes eventually pending soft interrupts. The softirq callbacks can
>issue an IPI of some sorts and because this IPI will end up in the
>kick handler, the systems livelocks on the already held global lock
>which protects the kick_handler list. This can happen from any invoked
>handler, because the kick_handler is missing an irq_enter/pair
>preventing a kick_handler invocation recursion.

Yes, that's my understanding of the problem.

>
>The obvious fix for now is to add an irq_enter/exit() pair around the
>spin locked section in the kick handler, so irq_exit() invocations of
>subhandlers wont lead to softirq execution.
>
>The more elegant fix would be to replace that global lock which is not
>really scalable with an RCU protected list of subscribed handlers.

Yes, I considered switching it to an RCU list (thanks for confirming that), but this patch looks sensible to me even with rcu, so I figured that can be a separate patch.

>The most elegant fix would be to have separate entry points for
>various exceptions, but that seems to be an architectural issue.

thanks for taking the time to review and for the other acks. i'll rewrite the commit message of this patch and resend.

cheers
James

