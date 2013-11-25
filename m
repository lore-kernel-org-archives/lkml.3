Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3KYQ1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:27:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab3KYQ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:27:25 -0500
Message-ID: <52937A51.6070603@redhat.com>
Date: Mon, 25 Nov 2013 17:26:57 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Yonan <james@openvpn.net>
CC: Cesar Eduardo Barros <cesarb@cesarb.eti.br>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: more robust crypto_memneq
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br> <529373C7.10201@openvpn.net>
In-Reply-To: <529373C7.10201@openvpn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:59 PM, James Yonan wrote:
> On 24/11/2013 14:12, Cesar Eduardo Barros wrote:
>> Disabling compiler optimizations can be fragile, since a new
>> optimization could be added to -O0 or -Os that breaks the assumptions
>> the code is making.
>>
>> Instead of disabling compiler optimizations, use a dummy inline assembly
>> (based on RELOC_HIDE) to block the problematic kinds of optimization,
>> while still allowing other optimizations to be applied to the code.
>>
>> The dummy inline assembly is added after every OR, and has the
>> accumulator variable as its input and output. The compiler is forced to
>> assume that the dummy inline assembly could both depend on the
>> accumulator variable and change the accumulator variable, so it is
>> forced to compute the value correctly before the inline assembly, and
>> cannot assume anything about its value after the inline assembly.
>>
>> This change should be enough to make crypto_memneq work correctly (with
>> data-independent timing) even if it is inlined at its call sites. That
>> can be done later in a followup patch.
>>
>> Compile-tested on x86_64.
>>
>> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
>
> This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to prevent compiler optimizations of var is interesting.
>
> I like the fact that it's finer-grained than -Os and doesn't preclude inlining.

Agreed. This looks much better than the Makefile workaround. Do we have
a hard guarantee that in future, this will not be detected and optimized
away by the compiler?

Otherwise, works fine, e.g.:
int main(void)
{
         int foo = 5;
         __asm__ __volatile__ ("" : "=r" (foo) : "0" (foo));
         if (foo == 5)
                 return 1;
         else
                 return 0;
}

gcc -O2 -Wall foo.c, w/ asm code:
Dump of assembler code for function main:
    0x0000000000400390 <+0>:	mov    $0x5,%eax
    0x0000000000400395 <+5>:	cmp    $0x5,%eax
    0x0000000000400398 <+8>:	sete   %al
    0x000000000040039b <+11>:	movzbl %al,%eax
    0x000000000040039e <+14>:	retq

gcc -O2 -Wall foo.c, w/o asm code:
Dump of assembler code for function main:
    0x0000000000400390 <+0>:	mov    $0x1,%eax
    0x0000000000400395 <+5>:	retq

> One concern would be that __asm__ could be optimized out unless __volatile__ is present.
>
> James
