Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3DKEUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:20:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30292 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3DKEUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:20:06 -0400
X-Spam-Score: -100.8
Message-ID: <516639D4.2090302@asianux.com>
Date: Thu, 11 Apr 2013 12:19:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: memory override issue, need check destination
 buffer length
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au>
In-Reply-To: <87eheh4sls.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 12:08, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>>   We don't export any symbols > 128 characters, but if we did then
>>   kallsyms_expand_symbol() would overflow the buffer handed to it.
>>   So we need check destination buffer length when copying.
>>
>>   the related test:
>>     if we define an EXPORT function which name more than 128.
>>     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>>     after check the length (provide this patch), it is ok.
>>
>>   Implementaion:
>>     add additional destination buffer length parameter (maxlen)
>>     if uncompressed string is too long (>= maxlen), it will be truncated.
>>     not check the parameters whether valid, since it is a static function.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> ??!!!  I never signed this off!  I've never seen it before!
> 

  ok, thanks. I did not quite understand the rule of it.

  originally, I think since you find it, I prefer to mention about you
in somewhere (e.g. mark as Reported-by ??)

  could you provide additional suggestions for it ?

  :-)


> Minor comments below:
> 

  I don't think they are 'minor comments'. I should improve them.

  thank you for your work.

  :-)


gchen.


>> -static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
>> +static unsigned int kallsyms_expand_symbol(unsigned int off,
>> +					   char *result, int maxlen)
> 
> 'size_t maxlen' would be more explicit.
> 
>>  {
>>  	int len, skipped_first = 0;
>>  	const u8 *tptr, *data;
>> +	char *begin = result;
>>   	/* Get the compressed symbol length from the first symbol byte. */
>>  	data = &kallsyms_names[off];
>> @@ -113,14 +116,16 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
>>   		while (*tptr) {
>>  			if (skipped_first) {
>> -				*result = *tptr;
>> -				result++;
>> +				*result++ = *tptr;
>> +				if (result - begin == maxlen - 1)
>> +					goto tail;
> 
> You could just decrement maxlen instead, and handle maxlen == 0 at the
> same time:
> 
>                 if (maxlen <= 1)
>                         goto tail;
>                 *result = *tptr;
>                 result++;
>                 maxlen--;
> 
>> @@ -176,7 +181,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>>  	unsigned int off;
>>   	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
>> -		off = kallsyms_expand_symbol(off, namebuf);
>> +		off = kallsyms_expand_symbol(off, namebuf, sizeof(namebuf));
>>   		if (strcmp(namebuf, name) == 0)
>>  			return kallsyms_addresses[i];
> 
> I prefer to use ARRAY_SIZE(namebuf) instead of sizeof(namebuf).  That
> way we break compile if the declaration is changed from an array to a
> pointer one day.
> 
> Same for the others.
> 
> Thanks,
> Rusty.
> 
> 


-- 
Chen Gang

Asianux Corporation
