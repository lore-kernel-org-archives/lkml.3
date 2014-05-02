Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaEBOX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:23:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37865 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752233AbaEBOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:23:58 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Mj Embd <mj.embd@gmail.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux Interrupt Context maps to ARM CPSR.mode = IRQ
In-Reply-To: <CAPUj1OMks1tY9KyFsBQizVnq1H+nyjgB6OUHagtKyoknYaMiow@mail.gmail.com>
	(Mj Embd's message of "Fri, 2 May 2014 15:07:55 +0100")
Organization: ARM Ltd
References: <CAPUj1OMJ8cE1cNTe8CjgBP2GTCXzi__Yg0+OoomME6=TShgqJg@mail.gmail.com>
	<CAPUj1OML_Rag3gxxBzswS6yaqFciuq2hKrV9BthL2OwU+wNj3A@mail.gmail.com>
	<14abe1165b144fe3d1139ad3b631eddd@www.loen.fr>
	<CAPUj1OMks1tY9KyFsBQizVnq1H+nyjgB6OUHagtKyoknYaMiow@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 02 May 2014 15:23:53 +0100
Message-ID: <87d2fw6yyu.fsf@sofa.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02 2014 at  3:07:55 pm BST, Mj Embd <mj.embd@gmail.com> wrote:
> On Fri, May 2, 2014 at 7:17 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 2014-05-02 13:34, Mj Embd wrote:
>>>
>>> Adding Marc to comment
>>> Marc Please clarify the doubt
>>>
>>>
>>>
>>> On Fri, May 2, 2014 at 5:15 PM, Mj Embd <mj.embd@gmail.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> As per a lot of linux documentation some components work in process
>>>> context and some work in interrupt context.
>>>>
>>>> If we try to map these contexts to ARM processor modes then is it
>>>> safely to assume that
>>>> Process Context : CPSR.mode = SVC
>>>> Interrupt Context : CPSR.mode = IRQ
>>>>
>>>> If not how to define interrupt context properly. Confusing at times.
>>
>>
>> Well, none of this is completely true.
>>
>> Process context exists both in USR (process in user mode) and SVC (process
>> in kernel mode, executing a syscall for example).
>>
>> As for interrupts, the processor indeed starts executing the interrupt in
>> IRQ mode, but this is a useless complication as far as Linux is concerned,
>
> I didn't understood the term useless here, I hope it is not about the
> question itself.

Not about the question at all. The IRQ mode itself is a useless
complication for Linux.

>> and we quickly switch to SVC (see the definition of the vector_stub
>> macro in arch/arm/kernel/entry-armv.S).
>>
> So what is the mode of the processor when Linux is executing in the
> Academic / Bookish Term "Interrupt Context"

As I said above, Linux runs mostly in SVC when the interrupt code is
executed.

> There is a function called in_interrupt which tells if linux is in
> interrupt context.
> But How to define/quantify Interrupt Context as a whole

You're in "Interrupt Context" when executing an interrupt. That's the
very definition. Interrupts are disabled, you cannot sleep, you cannot
be preempted. The mode the processor is in at that time is an orthogonal
issue, and different architectures implement this requirement
differently.

> Also, Some texts say there are two contexts Hard IRQ Context , Soft IRQ Context.
> HardIRQ = interrupts Disabled , (possibly CPSR.I=1, mode=IRQ)
> SoftIRQ = interrupts Enabled , (possibly CPSR.I=0, mode=IRQ)

Again, it you care to *read* the code, you'll notice that we're in IRQ
mode for about 12 instructions per interrupt. The actual interrupt
handling code runs in SVC.

> SoftIRQs when executed from Ksoftirqd daemon  (possibly CPSR.I=0, mode=SVC)
>
> We have a client query on this.

Awesome!

	M.
-- 
AAAFNRAA
