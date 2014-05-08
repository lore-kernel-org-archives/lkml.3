Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaEHM16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:27:58 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46716 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaEHM14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:27:56 -0400
Message-ID: <536B7846.7080102@gmail.com>
Date: Thu, 08 May 2014 15:27:50 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>,
        mtosatti@redhat.com, hpa@zytor.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: Wrong register masking in 64-bit mode
References: <1399465972-4026-1-git-send-email-namit@cs.technion.ac.il> <1399465972-4026-5-git-send-email-namit@cs.technion.ac.il> <536A56C3.7050907@redhat.com>
In-Reply-To: <536A56C3.7050907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/14, 6:52 PM, Paolo Bonzini wrote:
> Il 07/05/2014 14:32, Nadav Amit ha scritto:
>> 32-bit operations are zero extended in 64-bit mode. Currently, the
>> code does
>> not handle them correctly and keeps the high bits. In 16-bit mode, the
>> high
>> 32-bits are kept intact.
>>
>> In addition, although it is not well-documented, when address override
>> prefix
>> is used with REP-string instruction, RCX high half is zeroed even if
>> ECX was
>> zero on the first iteration (as if an assignment was performed to ECX).
>
> Is this true even for REPZ and ZF=0 or REPNZ and ZF=1?
>
> Paolo
The REPZ and REPNZ condition is checked on the end of an iteration (see 
the REP instruction description on the SDM), so it does not matter. So 
even REPZ/RENZ would zero RCX high half.

This "feature" is not well-documented, but can be observed. Here is a 
small code you can try.

---
#include <stdio.h>
unsigned long src, dst;
int main()
{
	unsigned long long rsi, rdi, rcx;
	rcx = 0xffffffff00000000ull;
	rsi = (unsigned long long)&src | 0xffffffff00000000ull;
	rdi = (unsigned long long)&dst | 0xffffffff00000000ull;
	printf("before: rsi %llx rdi %llx rcx %llx\n", rsi, rdi ,rcx);
	asm volatile (  ".byte 0x67\n\t"
			"repne cmpsd\n\t"
			: "+S" (rsi), "+D" (rdi), "+c" (rcx)
			: : "memory", "cc" );
	printf("after: rsi %llx rdi %llx rcx %llx\n", rsi, rdi ,rcx);
	return 0;
}
---

Nadav

