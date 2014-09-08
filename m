Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaIHM0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:26:01 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63475 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaIHMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:25:57 -0400
Message-ID: <540DA051.2030701@converseincode.com>
Date: Mon, 08 Sep 2014 07:25:53 -0500
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: zohar@linux.vnet.ibm.com, james.l.morris@oracle.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com> <alpine.DEB.2.10.1409060131260.5472@nanos> <540A590F.1030407@converseincode.com> <alpine.DEB.2.10.1409061152090.5472@nanos> <540BBD9E.6050708@converseincode.com> <540D73C9.3000906@samsung.com>
In-Reply-To: <540D73C9.3000906@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 04:15, Dmitry Kasatkin wrote:
> On 07/09/14 05:06, Behan Webster wrote:
>> On 09/06/14 03:11, Thomas Gleixner wrote:
>>> On Fri, 5 Sep 2014, Behan Webster wrote:
>>>> On 09/05/14 17:18, Thomas Gleixner wrote:
>>>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>>>>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>>>>>> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
>>>>> This SOB chain is completely ass backwards. See Documentation/...
>>>> "The Signed-off-by: tag indicates that the signer was involved in the
>>>> development of the patch, or that he/she was in the patch's delivery
>>>> path."
>>>>
>>>> All three of us were involved. Does that not satisfy this rule?
>>> No. Read #12
>>>
>>> The sign-off is a simple line at the end of the explanation for the
>>> patch, which certifies that you wrote it or otherwise have the right to
>>> pass it on as an open-source patch.
>>>
>>> So the above chain says:
>>>
>>>      Written-by:   Behan
>>>      Passed-on-by: Mark
>>>      Passed-on-by: Jan
>>>
>>> That would be correct if you sent the patch to Mark, Mark sent it to
>>> Jan and Jan finally submitted it to LKML.
>> I suppose "Reviewed-by" is probably more appropriate for the last 2
>> then. Will fix.
>>
>>>>>> -    struct {
>>>>>> -        struct shash_desc shash;
>>>>>> -        char ctx[crypto_shash_descsize(tfm)];
>>>>>> -    } desc;
>>>>>> +    char desc[sizeof(struct shash_desc) +
>>>>>> +        crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
>>>>>> +    struct shash_desc *shash = (struct shash_desc *)desc;
>>>>> That anon struct should have never happened in the first place.
>>>> Sadly this is a design pattern used in many places through out the
>>>> kernel, and
>>>> appears to be fundamental to the crypto system. I was advised *not*
>>>> to change
>>>> it, so we haven't.
>>>>
>>>> I agree that it's not a good practice.
>>>>
>>>>>     Not
>>>>> your problem, but you are not making it any better. You replace open
>>>>> coded crap with even more unreadable crap.
>>>>>
>>>>> Whats wrong with
>>>>>
>>>>>          SHASH_DESC_ON_STACK(shash, tfm);
>>>> Nothing is wrong with that. I would have actually preferred that.
>>>> But it would
>>>> have fundamentally changed a lot more code.
>>> Errm. Why is
>>>
>>> #define SHASH_DESC_ON_STACK(shash, tfm)                \
>>>      char __shash[sizeof(.....)];                \
>>>      struct shash_desc *shash = (struct shash_desc *) __shash
>>>
>>> requiring more fundamental than open coding the same thing a gazillion
>>> times. You still need to change ALL usage sides of the anon struct.
>>>
>>> So in fact you could avoid the whole code change by making it
>>>
>>>      SHASH_DESC_ON_STACK(desc, tfm);
>>>
>>> and do the anon struct or a proper struct magic in the macro.
>> I see. I thought you meant a more fundamental change to the crypto
>> system API. My misunderstanding.
>>
>> Ironically we tried to stay away from macros since the last time we
>> tried to replace VLAIS using macros (we've attempted patches to remove
>> VLAIS a few times) we were told *not* to hide the implementation with
>> macro magic. Though, to be fair, we were using more pointer math in
>> our other macro-based effort, and the non-crypto uses of VLAIS are a
>> lot more complex to replace.
>>
>> Like I said I'm actually a fan of hiding ugliness in macros. Will fix.
>>
>> Again, thanks for the feedback,
>>
>> Behan
>>
> Hi,
>
> Despite if it is crap or not, it was said already in this thread,
> following "design pattern" is heavily used through out the kernel - by
> crypto core itself and by many widely used clients.
>
>      struct {
>          struct shash_desc shash;
>          char ctx[crypto_shash_descsize(tfm)];
>      } desc;
>
>
> My question why do you want to change this particular piece of code?
Because it employs Variable Length Arrays in Structs. A construct which 
is explicitly forbidden by the C standard (C89, C99, C11). Because the 
vast majority of kernel developers I've talked to about this have been 
unaware of the use of VLAIS in the kernel and most find its use 
objectionable (there is a similar objection to the use of nested 
functions). Because implementing VLAIS in a compiler can severely impact 
the generated instructions surrounding its use, which is why most 
compilers don't implement VLAIS as a feature. Because using such a 
construct precludes standards based compilers from competing with the 
incumbent (my interest is enabling the use of clang and LLVM based 
technologies as a toolchain choice to compile and develop the kernel).

> What about rest of the kernel?
The LLVMLinux project is systematically working to remove the use of 
VLAIS from the kernel (already removed from ext4, USB Gadget, netfilter, 
mac802.11, apparmor, bluetooth, etc). Users of the crpyto subsystem are 
one of the last and heaviest users of VLAIS.

> To solve your problem you probably need to change everything.
Essentially yes. Though I like to think of it as finding alternatives to 
where ever it is still used. "Changing everything" implies much larger 
changes which aren't necessary in most cases. Sometimes the alternative 
is merely using a flexible member (zero length array at the end of the 
struct, instead of a VLA in the struct). In several places several VLAs 
are used in the same struct. And recently we found that exofs is using a 
VLAIS inside VLAIS (second order VLAIS) in one of its structures. So not 
finished yet.

> If we are going to change it and introduce any macros, it is better to
> do with the guidance from crypto folks.
Absolutely. Most of the crypto related patches have been sent to them. I 
am absolutely looking for their input.

> I added CC:linux-crypto@vger.kernel.org mailing list and Herbert Xu,
> crypto maintainer.
I suppose this specific patch may not have CC that list. However, most 
of the other VLAIS removal patches were copied to linux-crypto, Herbert 
Xu and David Miller.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

