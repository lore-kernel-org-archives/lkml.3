Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaAWSwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:52:38 -0500
Received: from thoth.sbs.de ([192.35.17.2]:57314 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaAWSwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:52:37 -0500
Message-ID: <52E164BC.1080302@siemens.com>
Date: Thu, 23 Jan 2014 19:51:40 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
References: <52DE6FCE.2050708@siemens.com> <20140121140113.GL30183@twins.programming.kicks-ass.net> <20140121145105.GE3694@twins.programming.kicks-ass.net> <1390346420.23634.5.camel@yhuang-dev> <20140122184325.GY20765@two.firstfloor.org>
In-Reply-To: <20140122184325.GY20765@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-22 19:43, Andi Kleen wrote:
>>> Huang Ying, can you explain to Jan why you do the wait afterwards?
>>
>> I borrow the code from the original MCE report event code.
>>
>> Andi, could you help us to explain it?
> 
> I don't recall all the details, but I believe i also just copied 
> it from the APIC code. I don't think I did any particular ordering
> intentionally.

OK, then let me summarize my current understanding so that we can derive
a consistent usage:

The xAPIC requires us to only write to ICR (both low and high part) if
ICR.DS is cleared - correct? ICR.DS checking as well as ICR writing must
only work against the same CPU, naturally.

Both __default_send_IPI_shortcut and __default_send_IPI_dest_field check
ICR.DS first, then write, but do not wait for ICR.DS to become 0 again -
not needed if this pattern is used consistently. Moreover,
default_send_IPI_mask* disables interrupts around these steps, thus
ensure atomicity. But shorthand IPI transmitters
(default_send_IPI_allbutself, default_send_IPI_all,
default_send_IPI_self) do not disable interrupts themselves. I didn't
check their call sites yet, maybe it's there.

Next we have x86's arch_irq_work_raise which does wait-write-wait,
either by chance or in order to work around a missing atomicity of
wait+write somewhere else. Preemption is off, interrupts remain on.

And then there is apic_icr_write, used while onlining CPUs, not only
during boot, that runs without any protection - that's the race I
originally stumbled over (INIT/SIPI or "just" NMI signals can end up on
the wrong CPU).

So now I'm looking for consistent locking rules (which type of lock, who
is responsible when issuing IPIs?) and a good (ie. also efficient) way
to apply them.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
