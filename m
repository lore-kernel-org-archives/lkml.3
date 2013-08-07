Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3HGFJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:09:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48590 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3HGFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:08:59 -0400
X-Spam-Score: -100.8
Message-ID: <5201D62B.6080905@asianux.com>
Date: Wed, 07 Aug 2013 13:07:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>
In-Reply-To: <8761vibihw.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 05:46 AM, Eric W. Biederman wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
> Have you tested this code?  Do you have anything that actually the
> uses sysctl binary interface?
> 

No, I only compile about it, not give a test. It is really better to
give a test, but it seems not quite necessary to must give a test
(since it is a simple change).


> If you do have code that actually uses this interface please fix it not
> to use it.  This code is fundamentally a stop gap measure and will
> bit-rot in time and then we will remove it.
> 

OK, since these code will be removed, and this patch is not for bug
fixing, so at least, this patch is useless.

The next reply below is only for current discussing, it has no effect
with the global result above (it is a useless patch).


>> Improve the usage of return value 'result', so not only can make code
>> clearer to readers, but also can improve the performance.
>>
>> Assign the return error code only when error occurs, so can save some
>> instructions (some of them are inside looping).
> 
> That actually is a code pessimization, not an optimization.  As are most
> of your proposed changes.  Only assigning the error code simply can not
> generate better assembly code.
> 

Excuse me, my English is not quite well, I don't know about the meaning
of 'pessimization' (I can not find it in my English-Chinese dictionary,
in Thunderbird Spell Check, it is not a correct word either).

But it seems it doesn't matter, what you want to say is only "it is not
an optimization", is it correct ?

And after check the assembly code, really it is (it is only for 2
styles which both are commonly used, not for optimization).


>> Rewrite the sysctl_getname() to make code clearer to readers, and also
>> can save some instructions (it is mainly related with the usage of the
>> variable 'result').
> 
> Again you are introducing branches and pessimizing the code in the name
> of optimization.
> 

Hmm... it is useless for optimization.

But in my opinion, at least, it can make code more clearer for C code
readers, although it may make performance a litter lower.

Please see the 2 implementations below, I feel 2nd is clearer than 1st,
how about your feeling ?

static char *sysctl_getname(const int *name, int nlen, const struct bin_table **tablep)
{
        char *tmp, *result;

        result = ERR_PTR(-ENOMEM);
        tmp = __getname();
        if (tmp) {
                const struct bin_table *table = get_sysctl(name, nlen, tmp);
                result = tmp; 
                *tablep = table;
                if (IS_ERR(table)) {
                        __putname(tmp);
                        result = ERR_CAST(table);
                }    
        }    
        return result;
}

static char *sysctl_getname(const int *name, int nlen, const struct bin_table **tablep)
{
        char *result;
        const struct bin_table *table;

        result = __getname();
        if (!result)
                return ERR_PTR(-ENOMEM);

        table = get_sysctl(name, nlen, result);
        if (IS_ERR(table)) {
                __putname(result);
                return ERR_CAST(table);
        }    
        *tablep = table;	/* If error occurs, need not set this value */

        return result;
}


>> Remove useless variable 'result' for sysctl() and compat sysctl(), when
>> do_sysctl() fails, it is meaningless to assign 'oldlenp ' with original
>> same value.
> 
>> Also modify the related code to pass "./scripts/checkpatch.pl" checking.
> 
> I really don't care about checpatch.pl at this point.
> 

Do you mean: you don't care about "checkpatch.pl", because some of
another reasons which in fact not related with "checkpatch.pl" though ?


> The right answer to the code is to config it out and then you don't have
> to worry about it one way or another.
> 

Pardon?

Excuse me, my English is not quite well, I don't quite understand your
meaning, could you please repeat again in details or say more clearly ?


> The sysctl binary path has never been properly maintained and I don't
> intend to start.   But I will spend 5 minutes to say this patch seems to
> make the code worse not better.
>

I guess no one ever invited you to maintain this file (for just as you
said, this file will be removed), so don't worry about it.

Hmm... do you mean you spend 5 minutes to get a conclusion ? if so,
better not use word 'seems' which is not a suitable word appeared in
the results, proofs or conclusions.

At least, one conclusion is: this patch switches from old-style to
new-style, not for optimization.

But for sysctl_getname() and "checkpatch.pl" of this patch, better to
get more discussion.

Is it OK ?

> Eric
> 
> 

Thanks.
-- 
Chen Gang
