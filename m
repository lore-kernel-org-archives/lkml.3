Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbaGQMLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:11:44 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63547 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaGQMLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:11:39 -0400
Message-ID: <53C7BD7B.50007@linaro.org>
Date: Thu, 17 Jul 2014 07:11:39 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 1/4] printk: LOG_CONT and LOG_NEWLINE are separate
References: <1405531620-9983-1-git-send-email-elder@linaro.org> <1405531620-9983-2-git-send-email-elder@linaro.org> <20140717083918.GP6774@pathway.suse.cz>
In-Reply-To: <20140717083918.GP6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 03:39 AM, Petr Mládek wrote:
> On Wed 2014-07-16 12:26:57, Alex Elder wrote:
>> Two log record flags--LOG_CONT and LOG_NEWLINE--are never both set
>> at the same time in a log record flags field.  What follows is a
>> great deal of explanation that aims to prove this assertion.

Thank you so much for reviewing these patches.

Your confirmation of the fact that LOG_CONT and LOG_NEWLINE
should not go together is very valuable to me.  I have a set
of follow-on patches that rely on this, and I didn't want to
go ahead with proposing them until I knew this was right.

I have some responses to your feedback below.

> It makes perfect sense. If you found a situation where both flags were
> set together, it would mean a bug. If a record ends with new line, it
> is not continuous and vice versa.

At an abstract level this makes sense to me too, but the code
is written to handle many combinations of flags that simply will
never happen.  It obscures what's going on, or is supposed to be
going on.  So to the reader, this appears much more complicated than
it really is.

> [...]
> 
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  kernel/printk/printk.c | 12 +++++-------
>>  1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 13e839d..301ade3 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -1006,11 +1006,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>  		prefix = false;
>>  
>>  	if (msg->flags & LOG_CONT) {
>> -		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
>> +		if (prev & LOG_CONT)
>>  			prefix = false;
>> -
>> -		if (!(msg->flags & LOG_NEWLINE))
>> -			newline = false;
>> +		newline = false;
>>  	}
> 
> Makes sense. I like it.
> 
>>  	do {
>> @@ -1642,7 +1640,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>>  	/* mark and strip a trailing newline */
>>  	if (text_len && text[text_len-1] == '\n') {
>>  		text_len--;
>> -		lflags |= LOG_NEWLINE;
>> +		lflags = LOG_NEWLINE;
>>  	}
>>  
>>  	/* strip kernel syslog prefix and extract log level or control flags */
>> @@ -1672,7 +1670,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>>  		level = default_message_loglevel;
>>  
>>  	if (dict)
>> -		lflags |= LOG_PREFIX|LOG_NEWLINE;
>> +		lflags = LOG_PREFIX|LOG_NEWLINE;
>>  
>>  	if (!(lflags & LOG_NEWLINE)) {
>>  		/*
>> @@ -1688,7 +1686,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>>  		else
>>  			printed_len += log_store(facility, level,
>>  						 lflags | LOG_CONT, 0,
>> -						 dict, dictlen, text, text_len);
>> +						 NULL, 0, text, text_len);
>>  	} else {
>>  		bool stored = false;
>>  
> 
> I am not sure that I like the last three changes. The logic is
> correct. But I think that these micro-optimizations makes the code less
> readable and prone to errors with reordering and other changes.

It is not an optimization.  I don't care about that.

It is replacing a variable with a constant, because I
know by static analysis that the variable will always
have constant value.  This makes it completely obvious
that "dict" will *never* be NULL in this case, and as
above, makes it more obvious what's happening.

(You'll see in my follow-on series that I rely on the
assignment rather than |= in order to do some refactoring.)

If someone chooses to reorder the code in a way that
makes |= necessary (for example) will put that back
again, because not doing so would introduce a bug.

> The original code does not harm. The new code is less obvious and will
> force many people to think why it is correct. Even you might be in
> doubts if you see it after few months :-)

Actually I think it's the opposite.

> Well, I do not have strong opinion here. Other people might see it
> different. Forcing people to think is not a bad idea after all :-)

I may be naive, but I think it's a requirement if you're going
to change code.

Thanks again for the review.  If you're willing after reading my
explanations, please offer an ACK or Reviewed-by (or further
questions and suggestions).  I'll have responses to your others
shortly.

					-Alex

> Best Regards,
> Petr
> 

