Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3KYW2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:28:31 -0500
Received: from hm1480-38.locaweb.com.br ([201.76.49.169]:60533 "EHLO
	hm1480-38.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3KYW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:28:28 -0500
X-Greylist: delayed 1902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 17:28:27 EST
X-LocaWeb-COR: locaweb_2009_x-mail
Message-ID: <5293C79A.1070808@cesarb.eti.br>
Date: Mon, 25 Nov 2013 19:56:42 -0200
From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: James Yonan <james@openvpn.net>, linux-crypto@vger.kernel.org
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: more robust crypto_memneq
References: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br> <529373C7.10201@openvpn.net>
In-Reply-To: <529373C7.10201@openvpn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-locaweb-id: 5II90qkwcFl608adNSKU11Mhs1xf0MgAzPC-CIfMoteOMOLYZkorw41aZgtgCBGiz7JOWdNt-MIUbUFIqc5n_VfP5aYHWPJEum0HS-HjJOudheJEOo0glyZUwFEQ0VF7Hb1iC_FiZwJlaw2on6MVqu-sZgGntHakCCyowGVDvrnU8eDg5kZAsOGaxjl8apPjZLSCEFb2AeHznBcfQzGpZw==
x-locaweb-id2: NjM2NTczNjE3MjYyNDA2MzY1NzM2MTcyNjIyZTY1NzQ2OTJlNjI3Mg==
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=Jp5GWrEC c=1 sm=1 a=tcb3u+hY9f79lJG4QOZo8A==:17
	a=AizhB-pfR1kA:10 a=f6iRhsuteYIA:10 a=IkcTkHD0fZMA:10 a=DvNpxiHR-4UA:10
	a=iSdcpiP1XtS7Vl4A5jYA:9 a=QEXdDO2ut3YA:10 a=5wJahwOnDtq/teZFh2NP5A==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-11-2013 13:59, James Yonan escreveu:
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
> This approach using __asm__ ("" : "=r" (var) : "0" (var)) to try to
> prevent compiler optimizations of var is interesting.

It is not novel; I copied it from RELOC_HIDE.

> I like the fact that it's finer-grained than -Os and doesn't preclude
> inlining.
>
> One concern would be that __asm__ could be optimized out unless
> __volatile__ is present.

It cannot be optimized out, because the __asm__'s output is used. Of 
course, if the __asm__ output is never used, it could be optimized out, 
but that is the desired result in this case (it means the result of 
crypto_memneq is being ignored, so the whole function should be elided).

AFAIK, __volatile__ also has the side effect that it forces ordering 
with everything (this fact is used in the definition of the barrier() 
macro). This level of barrier is not needed for crypto_memneq; ordering 
on "neq" is more than enough.

-- 
Cesar Eduardo Barros
cesarb@cesarb.eti.br
