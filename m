Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaGQMTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:19:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36777 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbaGQMTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:19:44 -0400
Message-ID: <53C7BF60.5070800@linaro.org>
Date: Thu, 17 Jul 2014 07:19:44 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] printk: honor LOG_PREFIX in devkmsg_read()
References: <1405531620-9983-1-git-send-email-elder@linaro.org> <1405531620-9983-3-git-send-email-elder@linaro.org> <20140717101413.GR6774@pathway.suse.cz>
In-Reply-To: <20140717101413.GR6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 05:14 AM, Petr Mládek wrote:
> On Wed 2014-07-16 12:26:58, Alex Elder wrote:
>> In devkmsg_read(), a variable "cont" holds a character that's used
>> to indicate whether a given log line is a "continuation", that is,
>> whether a log record should be merged with the one before or after
>> it.  If a record should be merged with its successor (but not its
>> predecessor) that character is 'c'.  And the line following such a
>> 'c' log record is normally marked with a '+' to show it is continues
>> its predecessor.  Any other cases are marked '-', indicating the
>> log record stands on its own.
>>
>> There is an exception.  If a log record is marked LOG_PREFIX, it
>> indicates that this record represents a new log entry, implicitly
>> terminating the predecessor--even if the predecessor would otherwise
>> have been continued.  So a record marked LOG_PREFIX (that is not
>> also marked LOG_CONT) should have '-' for its "cont" variable.
>>
>> The logic that determines this "continuation" character has a bug
>> that gets that exceptional case wrong.
>>
>> The specific case that produces the wrong result is when all of
>> these conditions are non-zero:
>>     user->prev & LOG_CONT
>>     msg->flags & LOG_PREFIX
>>     msg->flags & LOG_CONT
>> The bug is that despite the message's LOG_PREFIX flag, the
>> "cont" character is getting set to '+' rather than 'c'.
>>
>> The problem is that the message's LOG_PREFIX flag is getting
>> ignored if its LOG_CONT flag is also set.  Rearrange the logic
>> here to produce the correct result.
>>
>> The following table concisely defines the problem:
>>
>>      prev | msg  | msg  ||"cont"
>>      CONT |PREFIX| CONT || char
>>     ------+------+------++------
>>      clear| clear| clear||  '-'
>>      clear| clear|  set ||  'c'
>>      clear|  set | clear||  '-'
>>      clear|  set |  set ||  'c'
>>       set | clear| clear||  '+'
>>       set |  set |  set ||  '+'
> 	       ^^^ typo, it should be:

I will fix this, and it will show up when I re-post the series.

> 
>        set |  clear |  set ||  '+'
> 
>>       set |  set | clear||  '-'
>>       set |  set |  set ||  '+'      <-- should be 'c'
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  kernel/printk/printk.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 301ade3..9e9cf93 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -572,7 +572,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>>  	struct printk_log *msg;
>>  	u64 ts_usec;
>>  	size_t i;
>> -	char cont = '-';
>> +	char cont;
>>  	size_t len;
>>  	ssize_t ret;
>>  
>> @@ -619,11 +619,12 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>>  	 * better readable output. 'c' in the record flags mark the first
>>  	 * fragment of a line, '+' the following.
>>  	 */
>> -	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
>> -		cont = 'c';
>> -	else if ((msg->flags & LOG_CONT) ||
>> -		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
>> +	if (user->prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
>>  		cont = '+';
>> +	else if (msg->flags & LOG_CONT)
>> +		cont = 'c';
>> +	else
>> +		cont = '-';
> 
> Makes sense. Prefix should be always on a new line.
> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Yay!!!  Thanks.

					-Alex

> 
> Best Regards,
> Petr
> 
>>  	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
>>  		      (msg->facility << 3) | msg->level,
>> -- 
>> 1.9.1
>>

