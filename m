Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3GSWZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 18:25:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48815 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3GSWZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 18:25:21 -0400
Message-ID: <51E9BCC9.7070909@zytor.com>
Date: Fri, 19 Jul 2013 15:25:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.10.0 i386 uniprocessor panic
References: <20130719210036.5543.qmail@science.horizon.com>
In-Reply-To: <20130719210036.5543.qmail@science.horizon.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:00 PM, George Spelvin wrote:
>>> EIP is at 0xc143a091
>>> EAX: c143a090 EBX: 00000100 ECX: f3150000 EDX: c143a090
>>> ESI: c143a090 EDI: c143a090 EBP: c143a090 ESP: f3151eec
>>>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>>> CR0: 80050033 CR2: a090c143 CR3: 331c6000 CR4: 000007d0
>>> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>>> DR6: ffff0ff0 DR7: 00000400
> 
>>> (The CR2 value looks particularly odd.)
> 
>> Indeed it does; it is a user space value, but it doesn't look like
>> either a normal user space value nor really as a trivially buggered-up
>> kernel pointer value, unless the 0xc143... at the bottom is the upper
>> half of a kernel pointer, in which case we probably obtained this value
>> from a corrupt, misaligned pointer.
> 
> Er... I assumed you'd see instantly that it was the 0xc143a090 value
> that's in 5 registers (EAX/EDX/ESI/EDI/EBP), and IP-1, but with the
> halves swapped.

That would have requiring me to actually pay attention.  I claim
undercaffeination.

> How the heck the halves got swapped is confusing me...

Disassembling the "code" (which is really data) makes it kind of obvious:

C143A090  90                nop
C143A091  A043C190A0        mov al,[0xa090c143]	 ; fault here

We jumped into data which contained a series of self-pointers
(presumably empty double-linked lists), and the first two bytes became
opcodes...

Unfortunately the disassembly of call_timer_fn.isra.37 doesn't really
tell us anything other than that the passed-in value of %eax was bogus.
 It is *very* interesting, though, that that value is present in so many
registers (in fact, the ONLY GPRs which didn't have that value are %ebx
and %ecx, which are set by that function itself.)

A disassembly of the calling function, i.e.:

 [<c1024524>] ? run_timer_softirq+0x150/0x165

... would be a good idea, at least.

	-hpa

