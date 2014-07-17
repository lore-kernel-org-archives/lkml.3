Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaGQMS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:18:56 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:41879 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaGQMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:18:53 -0400
Message-ID: <53C7BF2E.4070705@linaro.org>
Date: Thu, 17 Jul 2014 07:18:54 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: honor LOG_PREFIX in msg_print_text()
References: <1405531620-9983-1-git-send-email-elder@linaro.org> <1405531620-9983-4-git-send-email-elder@linaro.org> <20140717094031.GQ6774@pathway.suse.cz>
In-Reply-To: <20140717094031.GQ6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 04:40 AM, Petr Mládek wrote:
> On Wed 2014-07-16 12:26:59, Alex Elder wrote:
>> This patch fixes a problem similar to what was addressed in the
>> previous patch.
>>
>> All paths that read and format log records (for consoles, and for
>> reading via syslog and /dev/kmsg) go through msg_print_text().  That
>> function starts with some logic to determine whether the given log
>> record when formatted should begin with a "prefix" string, and
>> whether it should end with a newline.  That logic has a bug.
>>
>> The LOG_PREFIX flag in a log record indicates that when it's
>> formatted, a log record should include a prefix.  This is used to
>> force a record to begin a new line--even if its preceding log record
>> contained LOG_CONT (indicating its content should be combined with
>> the next record).
>>
>> Like the previous patch, the problem occurs when these flags are
>> all set:
>>     prev & LOG_CONT
>>     msg->flags & LOG_PREFIX
>>     msg->flags & LOG_CONT
>> In that case, "prefix" should be true but it is not.
> 
> You are right.

That's great news.

>> The fix involves checking LOG_PREFIX when a message has its LOG_CONT
>> flag set, and in that case allowing "prefix" to become false only
>> if LOG_PREFIX is not set.  I.e., the logic for "prefix" would become:
>>
>>     if (prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
>>         prefix = false;
>>     if (msg->flags & LOG_CONT)
>>         if (prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
>>             prefix = false;
>>
>> However, note that this makes the (msg->flags & LOG_CONT) block
>> redunant--it's handled by the test just above it.  The result
>> becomes quite a bit simpler than before.
>>
>> The following table concisely defines the problem:
>>
>>      prev | msg  | msg  ||
>>      CONT |PREFIX| CONT ||prefix
>>     ------+------+------++------
>>      clear| clear| clear|| true
>>      clear| clear|  set || true
>>      clear|  set | clear|| true
>>      clear|  set |  set || true
>>       set | clear| clear||false
>>       set |  set |  set ||false
               clear

(Same problem you pointed out in the next patch.)

>>       set |  set | clear|| true
>>       set |  set |  set ||false      <-- should be true
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  kernel/printk/printk.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 9e9cf93..3f15d95 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -1003,14 +1003,11 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>  	bool newline = true;
>>  	size_t len = 0;
>>  
>> -	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
>> +	if (prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
>>  		prefix = false;
> 
> I would personaly keep the brackets there. For me.
> 
>   ( & ) && !( & )

That's fine.  I tend to be minimalist unless the compiler suggests
otherwise, but I'll keep the parentheses.

> is easier to parse than
> 
>   & && !( & )
> 
>> -	if (msg->flags & LOG_CONT) {
>> -		if (prev & LOG_CONT)
>> -			prefix = false;
>> +	if (msg->flags & LOG_CONT)
>>  		newline = false;
>> -	}
> 
> You are right. The check before "prefix = false" did not make much
> sense. We should not remove prefix just because the previous line was
> continuous. Also it does not make sense to do this only when the new line
> is continuous.

I came at this trying to understand what was intended by
reading the code.  And it is not easy.  These patches and
the set that I'll post soon simplify things enormously.

> But I think that the fix is not complete. IMHO, we should finish the
> previous continuous line with '\n' before we print the prefix. I mean something
> like:

I will re-post a new version of this patch.  When I do so
I will look at this and--unless I find I disagree--will
implement your suggestion.

Thanks.

					-Alex

> 
> if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && (len < size)) {
> 	/* finish the incomplete continuous line */
> 	if (buf) {
> 		buf[len++] = '\n';
> 	} else {
> 		len++;
> 	}
> }
> 
> Best Regards,
> Petr
> 
> 
>>  
>>  	do {
>>  		const char *next = memchr(text, '\n', text_size);
>> -- 
>> 1.9.1
>>

