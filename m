Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3HGF36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:29:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50036 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3HGF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:29:56 -0400
Message-ID: <5201DB0D.7080200@gmail.com>
Date: Wed, 07 Aug 2013 13:28:45 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Chen Gang <gang.chen@asianux.com>, Al Viro <viro@zeniv.linux.org.uk>,
        xi.wang@gmail.com, nicolas.dichtel@6wind.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com> <20130806144339.182beb0a2abddc0782015487@linux-foundation.org> <87zjsu5uy1.fsf@xmission.com>
In-Reply-To: <87zjsu5uy1.fsf@xmission.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:13 AM, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Tue, 06 Aug 2013 15:29:42 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>>
>>> Improve the usage of return value 'result', so not only can make code
>>> clearer to readers, but also can improve the performance.
>>
>> It used to be pervasive kernel style do to
>>
>> 	ret = -ENOMEM;
>> 	foo = alloc(...);
>> 	if (!foo)
>> 		goto out;
>>
>> whereas nowadays people usually do the more straightforward
>>
>> 	foo = alloc(...);
>> 	if (!foo) {
>> 		ret = -ENOMEM;
>> 		goto out;
>> 	}
>>
>> The thinking was that the old style generated better code, but for the
>> life of me I can't remember why :(
> 
> Because doing the assignment outside of the if() goto .  Allows the
> compiler to emit the if() goto as a single branch.
> 
> While a smart compiler may perform the code motion across the branch,
> it is much easier for the compiler to branch to somewhere else perform
> the assignment and then branch out.
> 

For my opinion, for assembly code, the old style is clearer than the new
style. And commonly, the old style will be faster than new style.

Thanks.

> Eric
> 
> 
>> Your patch switches from old-style to new-style.  And it appears to
>> have increased the text size.  I did this, to switch three sites back
>> to old-style:
>>
>> --- a/kernel/sysctl_binary.c~kernel-sysctl_binaryc-improve-the-usage-of-return-value-result-fix
>> +++ a/kernel/sysctl_binary.c
>> @@ -941,17 +941,15 @@ static ssize_t bin_string(struct file *f
>>  		copied = result;
>>  		lastp = oldval + copied - 1;
>>  
>> -		if (get_user(ch, lastp)) {
>> -			result = -EFAULT;
>> +		result = -EFAULT;
>> +		if (get_user(ch, lastp))
>>  			goto out;
>> -		}
>>  
>>  		/* Trim off the trailing newline */
>>  		if (ch == '\n') {
>> -			if (put_user('\0', lastp)) {
>> -				result = -EFAULT;
>> +			result = -EFAULT;
>> +			if (put_user('\0', lastp))
>>  				goto out;
>> -			}
>>  			copied -= 1;
>>  		}
>>  	}
>> @@ -976,11 +974,10 @@ static ssize_t bin_intvec(struct file *f
>>  	char *buffer;
>>  	ssize_t result;
>>  
>> +	result = -ENOMEM;
>>  	buffer = kmalloc(BUFSZ, GFP_KERNEL);
>> -	if (!buffer) {
>> -		result = -ENOMEM;
>> +	if (!buffer)
>>  		goto out;
>> -	}
>>  
>>  	if (oldval && oldlen) {
>>  		unsigned __user *vec = oldval;
>> _
>>
>> and kernel/sysctl_binary.o's .text got six bytes smaller.
>>
>> Now, smaller text doesn't mean faster code.  But it probably means
>> larger cache footprint, which can mean slower code.
>>
>> IOW, it isn't obvious that this was an improvement.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Chen Gang
