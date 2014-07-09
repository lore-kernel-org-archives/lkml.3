Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaGIQpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:45:53 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62999 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaGIQpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:45:52 -0400
Message-ID: <53BD71BD.9010308@linaro.org>
Date: Wed, 09 Jul 2014 11:45:49 -0500
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>,
        Alex Elder <elder@linaro.org>
CC: akpm@linux-foundation.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz,
        john.stultz@linaro.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] printk: miscellaneous cleanups
References: <1404911056-29064-1-git-send-email-elder@linaro.org> <1404911056-29064-5-git-send-email-elder@linaro.org> <20140709162935.GB26508@pathway.suse.cz>
In-Reply-To: <20140709162935.GB26508@pathway.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 11:29 AM, Petr Mládek wrote:
> Sending once again as a correct reply. I am sorry for the
> confusion. I think that it is high time for me to go home and sleep :-)
>
> On Wed 2014-07-09 08:04:16, Alex Elder wrote:
>> This patch contains some small cleanups to kernel/printk/printk.c.
>> None of them should cause any change in behavior.
>>    - When CONFIG_PRINTK is defined, parenthesize the value of LOG_LINE_MAX.
>>    - When CONFIG_PRINTK is *not* defined, there is an extra LOG_LINE_MAX
>>      definition; delete it.
>>    - Pull an assignment out of a conditional expression in console_setup().
>>    - Use isdigit() in console_setup() rather than open coding it.
>>    - In update_console_cmdline(), drop a NUL-termination assignment;
>>      the strlcpy() call that precedes it guarantees it's not needed.
>>    - Simplify some logic in printk_timed_ratelimit().
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   kernel/printk/printk.c | 26 +++++++++++++-------------
>>   1 file changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index 6f75e8a..909029e 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c

. . .

>> @@ -2611,14 +2612,13 @@ EXPORT_SYMBOL(__printk_ratelimit);
>>   bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>>   			unsigned int interval_msecs)
>>   {
>> -	if (*caller_jiffies == 0
>> -			|| !time_in_range(jiffies, *caller_jiffies,
>> -					*caller_jiffies
>> -					+ msecs_to_jiffies(interval_msecs))) {
>> -		*caller_jiffies = jiffies;
>> -		return true;
>> -	}
>> -	return false;
>> +	unsigned long elapsed = jiffies - *caller_jiffies;
>

Currently, all callers pass a 0 value in *caller_jiffies
initially (using a static/BSS variable), and a value updated
by a previous call to __printk_ratelimit() thereafter.

If a caller passed something different, yes, it's possible the
result would wrap to a high unsigned value (i.e., go negative).
However the logic used here involves the same subtraction
operation as was used before--though previously that was
buried inside the time_after() macro called by time_in_range().

					-Alex

> I wondered if the deduction might be negative. Well, it should not be
> if none manipulates *caller_jiffies in a strange way. If it happens,
> the following condition will most likely fail and *caller_jiffies will
> get reset to jiffies. It looks reasonable to me.
>
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
>
>> +	if (*caller_jiffies && elapsed <= msecs_to_jiffies(interval_msecs))
>> +		return false;
>> +
>> +	*caller_jiffies = jiffies;
>> +	return true;
>>   }
>>   EXPORT_SYMBOL(printk_timed_ratelimit);
>
> Best Regards,
> Petr
>

