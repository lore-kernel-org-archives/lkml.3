Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaFEP15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:27:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaFEP1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:27:55 -0400
Message-ID: <53908C66.20600@redhat.com>
Date: Thu, 05 Jun 2014 17:27:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Nadav Amit <nadav.amit@gmail.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] KVM: x86: smsw emulation is incorrect in 64-bit mode
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il> <1401723251-8034-10-git-send-email-namit@cs.technion.ac.il> <53908467.8030100@redhat.com> <CB894343-EC15-4A5D-B461-B012FC19FC3A@gmail.com> <539086F6.8000004@zytor.com>
In-Reply-To: <539086F6.8000004@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/06/2014 17:04, H. Peter Anvin ha scritto:
> On 06/05/2014 08:02 AM, Nadav Amit wrote:
>>> I'm sorry, I'm missing the place where 64-bit mode is taken into account?
>> It is not, since on 32-bit mode the high-order 16 bits of a register destination are undefined.
>> If I recall correctly, in this case the high-order 16-bits on native
> system actually reflect the high-order 16-bits of CR0.
>
> This sounds like something that really should be verified
> experimentally.  The above claim seems... odd.

Here is a test program:

#if __SIZEOF_LONG__ == 4
#define V "12345678"
#define R "e"
#else
#define V "1234567812345678"
#define R "r"
#endif

#include <stdio.h>
int main()
{
	register volatile unsigned long ecx asm("ecx");

#if __SIZEOF_LONG__ > 4
	asm volatile("mov $0x" V ", %%" R "cx; smswq %%rcx": : :"ecx");
	printf("smswq: %lx\n", ecx);
#endif

	asm volatile("mov $0x" V ", %%" R "cx; smswl %%ecx": : :"ecx");
	printf("smswl: %lx\n", ecx);

	asm volatile("mov $0x" V ", %%" R "cx; smsww %%cx": : :"ecx");
	printf("smsww: %lx\n", ecx);
}

Output in 32-bit mode:
smswq: 80050033
smswl: 12340033

Output in 64-bit mode:
smswq: 80050033
smswl: 80050033
smsww: 1234567812340033

Can you please make a test case for kvm-unit-tests (x86/emulator.c), in 
order to check the validity of the patch?

Paolo
