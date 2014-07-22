Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaGVIJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaGVIJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:09:06 -0400
Message-ID: <53CE1C10.8070400@redhat.com>
Date: Tue, 22 Jul 2014 10:08:48 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: x86: Function for determining exception type
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942650-22589-3-git-send-email-namit@cs.technion.ac.il> <53CD0514.8040308@redhat.com> <53CD866A.9020704@gmail.com>
In-Reply-To: <53CD866A.9020704@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/07/2014 23:30, Nadav Amit ha scritto:
> Few comments to see we are on the same page:
> 
> On 7/21/14, 3:18 PM, Paolo Bonzini wrote:
>> Il 21/07/2014 13:37, Nadav Amit ha scritto:
>>> +int kvm_exception_type(unsigned int nr)
>>
>> The manual calls this the exception class.
> Yes, but it also calls it exception "type" (see table 6-1
> "Protected-Mode Exceptions and Interrupts" on the SDM).
> I called it exception type, since there is a function exception_class
> that is used to handle nested exceptions.

Ok.

>>> +    case VE_VECTOR:
>>> +        return EXCPT_FAULT;
>>> +    case DB_VECTOR:
>>> +        return EXCPT_FAULT_OR_TRAP;
>>
>> It is only a fault for instruction fetch breakpoints.  You can modify
>> kvm_vcpu_check_breakpoint to set RF, add a comment here that fault
>> handling is done elsewhere, and return EXCPT_TRAP.
> Unless I am mistaken, kvm_vcpu_check_breakpoint checks only for
> instruction breakpoint. Since instruction breakpoint should not cause RF
> to be set, this function should not be changed.

You're right ("For any fault-class exception except a debug exception
generated in response to an instruction breakpoint, the
value pushed for RF is 1").  It's the debug exception handler that has
to set RF (and then iretd/iretq will modify RF).

> Anyhow, I would return EXCPT_TRAP on DB_VECTOR.

Yeah, just add a comment that it can be a fault for instruction fetch
breakpoints, but we treat it as a trap for the purposes of (not) setting RF.

Alternatively, just rename the function to exception_sets_rf and return
true/false.

Paolo
