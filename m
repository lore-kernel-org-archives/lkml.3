Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaIFApN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:45:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52233 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaIFApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:45:09 -0400
Message-ID: <540A590F.1030407@converseincode.com>
Date: Fri, 05 Sep 2014 17:45:03 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        james.l.morris@oracle.com, linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org, Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>
Subject: Re: [PATCH] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
References: <1409958360-8061-1-git-send-email-behanw@converseincode.com> <alpine.DEB.2.10.1409060131260.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409060131260.5472@nanos>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 17:18, Thomas Gleixner wrote:
> On Fri, 5 Sep 2014, behanw@converseincode.com wrote:
>
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
>> compliant equivalent. This patch allocates the appropriate amount of memory
>> using an char array.
>>
>> The new code can be compiled with both gcc and clang.
>>
>> struct shash_desc contains a flexible array member member ctx declared with
>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
>> of the array declared after struct shash_desc with long long.
>>
>> No trailing padding is required because it is not a struct type that can
>> be used in an array.
>>
>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
>> as would be the case for a struct containing a member with
>> CRYPTO_MINALIGN_ATTR.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> This SOB chain is completely ass backwards. See Documentation/...
"The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path."

All three of us were involved. Does that not satisfy this rule?

>> ---
>>   security/integrity/ima/ima_crypto.c | 53 +++++++++++++++++--------------------
>>   1 file changed, 25 insertions(+), 28 deletions(-)
>>
>> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>> index 0bd7328..a6aa2b0 100644
>> --- a/security/integrity/ima/ima_crypto.c
>> +++ b/security/integrity/ima/ima_crypto.c
>> @@ -380,17 +380,16 @@ static int ima_calc_file_hash_tfm(struct file *file,
>>   	loff_t i_size, offset = 0;
>>   	char *rbuf;
>>   	int rc, read = 0;
>> -	struct {
>> -		struct shash_desc shash;
>> -		char ctx[crypto_shash_descsize(tfm)];
>> -	} desc;
>> +	char desc[sizeof(struct shash_desc) +
>> +		crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR;
>> +	struct shash_desc *shash = (struct shash_desc *)desc;
> That anon struct should have never happened in the first place.
Sadly this is a design pattern used in many places through out the 
kernel, and appears to be fundamental to the crypto system. I was 
advised *not* to change it, so we haven't.

I agree that it's not a good practice.

>   Not
> your problem, but you are not making it any better. You replace open
> coded crap with even more unreadable crap.
>
> Whats wrong with
>
>        SHASH_DESC_ON_STACK(shash, tfm);
Nothing is wrong with that. I would have actually preferred that. But it 
would have fundamentally changed a lot more code.

I'm not sure making fundamental changes to the crypto code in order to 
make "my favourite compiler happy" is really a better plan. I prefer 
smaller more measured steps.

> or something along that line and hide all the stack allocation, type
> conversion crap and make my favourite compiler happy in a single
> place?
At this point it is less about making a particular compiler happy, and 
more about making the code at least C99 compliant which enables a 
different compiler so that more people can use it to make more 
fundamental changes like you are suggesting.

I appreciate your feedback,

Behan

-- 
Behan Webster
behanw@converseincode.com

