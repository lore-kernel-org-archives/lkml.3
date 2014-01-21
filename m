Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaAUOfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:35:34 -0500
Received: from thoth.sbs.de ([192.35.17.2]:20982 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaAUOfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:35:31 -0500
Message-ID: <52DE8592.9090807@siemens.com>
Date: Tue, 21 Jan 2014 15:34:58 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
References: <52DE6FCE.2050708@siemens.com> <20140121140113.GL30183@twins.programming.kicks-ass.net> <52DE8009.9010902@siemens.com>
In-Reply-To: <52DE8009.9010902@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-21 15:11, Jan Kiszka wrote:
> On 2014-01-21 15:01, Peter Zijlstra wrote:
>> On Tue, Jan 21, 2014 at 02:02:06PM +0100, Jan Kiszka wrote:
>>> Hi all,
>>>
>>> while trying to plug a race in the CPU hotplug code on xAPIC systems, I
>>> was analyzing IPI transmission patterns. The handlers in
>>> arch/x86/include/asm/ipi.h first wait for ICR, then send. In contrast,
>>> arch_irq_work_raise sends the self-IPI directly and then waits. This
>>> looks inconsistent. Is it intended?
>>>
>>> BTW, the races are in wakeup_secondary_cpu_via_init and
>>> wakeup_secondary_cpu_via_nmi (lacking IRQ disable around ICR accesses).
>>> There we also send first, then wait for completion. But I guess that is
>>> due to the code originally only being used during boot. Will send fixes
>>> for those once the sync pattern is clear to me.
>>
>> Could be I had no clue what I was doing and copy/pasted the code until
>> it compiled and ran.
>>
>> In fact, I've got no clue what an ICR is.
> 
> Old xAPIC requires you to only send IPIs, when the APIC signals it is
> done with sending the previous one. Therefore we wait for availability
> in the other IPI transmission services before writing to ICR.
> 
> OK, then I will write a separate patch for arch_irq_work_raise to switch
> the ordering.

Hmm, missed that we do have synchronization already via
apic->send_IPI_self -> default_send_IPI_self ->
__default_send_IPI_shortcut. So the closing wait would only be relevant
if we need to settle the APIC because we may have interrupted a
wait_icr_idle + write_icr sequence. But shouldnt those sequences be
atomic (except for the problematic wakeup_secondary path)?

Still confused: What is the official locking model around wait_icr_idle,
write(ICR), and also write(IRC2)? IRQ disable around ICR2+ICR accesses
and preempt_disable around wait + write? That is also important to fix
the SMP boot-up code properly.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
