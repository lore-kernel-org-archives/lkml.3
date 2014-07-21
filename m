Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaGUMcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:32:15 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41819 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaGUMcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:32:13 -0400
Message-ID: <53CD0852.2030706@linaro.org>
Date: Mon, 21 Jul 2014 07:32:18 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] printk: insert newline for truncated records
References: <1405718885-11227-1-git-send-email-elder@linaro.org> <1405718885-11227-7-git-send-email-elder@linaro.org> <20140721115706.GC20751@pathway.suse.cz>
In-Reply-To: <20140721115706.GC20751@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 06:57 AM, Petr Mládek wrote:
> On Fri 2014-07-18 16:28:04, Alex Elder wrote:
>> If a log record has LOG_PREFIX set, its predecessor record should be
>> terminated if it was marked LOG_CONT.
>>
>> In devkmsg_read(), this condition was being ignored, which would
>> lead to such records showing up combined when reading /dev/kmsg.
>> Fix this oversight.
>>
>> We should similarly insert a newline in msg_print_text() in this
>> case, to avoid formatted records getting merged.
>>
>> Suggested-by: Petr Mládek <pmladek@suse.cz>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  kernel/printk/printk.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index e9f0632..a5ad81c 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>>  	char cont;
>>  	size_t len;
>>  	ssize_t ret;
>> +	bool insert_newline;
>>  
>>  	if (!user)
>>  		return -EBADF;
>> @@ -626,7 +627,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>>  	else
>>  		cont = '-';
>>  
>> -	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
>> +	/* Insert a newline if the previous line was not terminated properly */
>> +	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
>> +	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
>> +		      insert_newline ? "\n" : "",
>>  		      (msg->facility << 3) | msg->level,
>>  		      user->seq, ts_usec, cont);
>>  	user->prev = msg->flags;
>> @@ -999,10 +1003,12 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>  {
>>  	const char *text = log_text(msg);
>>  	size_t text_size = msg->text_len;
>> +	size_t len = 0;
>> +	bool insert_newline;
>>  	bool prefix = true;
>>  	bool newline = true;
>> -	size_t len = 0;
>>  
>> +	insert_newline = (prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
>>  	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
>>  		prefix = false;
>>  
>> @@ -1023,9 +1029,13 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>  
>>  		if (buf) {
>>  			if (print_prefix(msg, syslog, NULL) +
>> -			    text_len + 1 >= size - len)
>> +			    text_len + 2 >= size - len)
> 
> It counts the '\n' even when it is not used.
> I think that it is even wrong that it calculates prefix when it is not used.

That's true, and I have yet another un-posted patch that
addresses this problem (well the second one).  I am not
going to fix this problem in this patch, but the fix is
coming.

Now that you're looking at the code I'm touching, you're
seeing the same things I did...

I think I'll start posting that series later today or
tomorrow.   I just hate to get too far ahead of myself.

>>  				break;
>>  
>> +			if (insert_newline) {
>> +				insert_newline = false;
>> +				buf[len++] = '\n';
>> +			}
>>  			if (prefix)
>>  				len += print_prefix(msg, syslog, buf + len);
>>  			memcpy(buf + len, text, text_len);
>> @@ -1034,6 +1044,8 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>>  				buf[len++] = '\n';
>>  		} else {
>>  			/* SYSLOG_ACTION_* buffer size only calculation */
>> +			if (insert_newline)
>> +				len++;
> 
> You forgot "insert_newline = false" here.

Yes you're right.  It's good that you're reviewing this.
(The patches I have not yet posted affect this area of
code, and should eliminate this block...)

>>  			if (prefix)
>>  				len += print_prefix(msg, syslog, NULL);
>>  			len += text_len;
> 
> It is just matter of personal style but I would suggest to do this
> before the do-while cycle:
> 
> 	/* Force newline if the previous text was not properly finished */
> 	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && (len < size)) {
> 		if (buf)
> 			buf[len++] = '\n';
> 		else
> 			len++;
> 	}
> 
> IMHO, it is more clear. The do-while cycle already is complex enough.

I agree with this.  It's a one-time thing and doesn't belong in
the loop.  When you suggested inserting the newline I think I
didn't think it through completely.  I will do this.

> BTW: This is relared to the first patch. I would either patch all
> three locations in one patch or better split it into three patches.

I am keeping the first patch separate from this one.  I think
the first is related (in that we improve readability by inserting
some newlines) but it's really addressing a different problem.

Meanwhile, this patch is addressing essentially the same problem
in two spots, so I'd like to keep these together rather than
splitting it in two.

I will move this patch earlier in the series, however, making
it follow patch 1.

I may be misunderstanding what you mean though.  Is what I
propose OK with you?

Thank you.

					-Alex


> 
> Best Regards,
> Petr
> 

