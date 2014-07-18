Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbaGRMEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:04:21 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:52998 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaGRMET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:04:19 -0400
Message-ID: <53C90D45.4000407@linaro.org>
Date: Fri, 18 Jul 2014 07:04:21 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] printk: update previous message for LOG_PREFIX
References: <1405619953-5475-1-git-send-email-elder@linaro.org> <1405619953-5475-3-git-send-email-elder@linaro.org> <20140718090251.GV6774@pathway.suse.cz>
In-Reply-To: <20140718090251.GV6774@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 04:02 AM, Petr Mládek wrote:
> On Thu 2014-07-17 12:59:10, Alex Elder wrote:
>> If log_store() gets flags containing LOG_PREFIX, it indicates the
>> record getting stored should implicitly complete the previous log
>> record and start a new one.
>>
>> We can also ensure the previous record is completed by keeping
>> track of the previously-logged record, and adding the LOG_NEWLINE
>> flag to it when log_store() sees a LOG_PREFIX flag.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  kernel/printk/printk.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
>> index e35d91a..6b72a77 100644
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -242,6 +242,9 @@ static size_t syslog_partial;
>>  static u64 log_first_seq;
>>  static u32 log_first_idx;
>>  
>> +/* Pointer to the last record written into the log */
>> +static struct printk_log *log_last_msg;
>> +
>>  /* index and sequence number of the next record to store in the buffer */
>>  static u64 log_next_seq;
>>  static u32 log_next_idx;
>> @@ -425,7 +428,13 @@ static int log_store(int facility, int level,
>>  		log_next_idx = 0;
>>  	}
>>  
>> -	/* fill message */
>> +	/*
>> +	 * If we're forcing a new log record, update the flags for
>> +	 * the previous one to mark it complete.
>> +	 */
>> +	if (flags & LOG_PREFIX && log_last_msg)
>> +		log_last_msg->flags |= LOG_NEWLINE;
> 
> You are not allowed to do this. The previous message might already be
> proceed by readers (console, syslog, kmsg).
> 
> IMHO, you will not be able to make this safe without adding extra
> complexity into the readers. So, I am afraid that there is no win
> in vanishing the LOG_PREFIX flag.

You're right.  I had not been thinking about this.
We can't change the flag state of a log entry that's
already been read, and we have no (good) way of knowing
when that has occurred.

I'll retract this and related patches, and will rework
it accordingly.  I'm still going to try to do what I
can with this (and the previous) series to be simplified.

I'm going to look at the rest of your reviews first.

Thank you.

					-Alex

> Best Regards,
> Petr
> 
>>  	msg = (struct printk_log *)(log_buf + log_next_idx);
>>  	memcpy(log_text(msg), text, text_len);
>>  	msg->text_len = text_len;
>> @@ -449,6 +458,9 @@ static int log_store(int facility, int level,
>>  	log_next_idx += msg->len;
>>  	log_next_seq++;
>>  
>> +	/* Save our previous record address for next time. */
>> +	log_last_msg = msg;
>> +
>>  	return msg->text_len;
>>  }
>>  
>> -- 
>> 1.9.1
>>

