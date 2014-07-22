Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaGVLW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:22:58 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60960 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGVLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:22:57 -0400
Message-ID: <53CE4997.5070405@linaro.org>
Date: Tue, 22 Jul 2014 06:23:03 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>
CC: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] printk: start simplifying some flags
References: <1405947761-26004-1-git-send-email-elder@linaro.org> <20140722100453.GO20751@pathway.suse.cz>
In-Reply-To: <20140722100453.GO20751@pathway.suse.cz>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 05:04 AM, Petr Mládek wrote:
> On Mon 2014-07-21 08:02:34, Alex Elder wrote:
>> Each log record has a "flags" field.  The flags keep track of, for
>> instance, whether the record was saved in its entirety (as opposed
>> to being one of multiple records that should be merged as a single
>> unit).  A log record's flags field alone is not currently sufficient
>> to know how the record should be formatted; you need to know the
>> previous record's flags field as well.  I found understanding the
>> real effect of various combinations of these flags to be very
>> difficult, and was moved to try to do something about that.
>>
>> This series includes three patches that begin the process of
>> simplifying how these flags are used and interpreted.  They include
>> very long, detailed explanations (as small patches often do) because
>> I want my reasoning to be very clear and examined very closely.  I
>> really don't want to break printk()...
>>
>> The first patch surrounds a "*** XXX printk messages dropped ***"
>> message with newlines, to improve readability.
>>
>> The second patch inserts a newline in /dev/kmsg output in the
>> event a LOG_PREFIX record follows a LOG_CONT record.
>>
>> The third patch changes how two global variables are initialized,
>> allowing the second patch to assume they always hold certain values.
>>
>> The fourth patch simplifies some code based on the observation that
>> the LOG_CONT and LOG_NEWLINE flags are mutually exclusive.
>>
>> The fifth and sixth patches fix a bug in two places.  The bug is
>> that a LOG_PREFIX in a record should implicitly terminate its
>> predecessor, even if the predecessor was marked LOG_CONT.
>>
>> One trivial final patch is included at the end of the series.
>>
>> 					-Alex
>>
>> History:
>> v5: - Initialized "prev" variables to LOG_NEWLINE in two more
>>       spots, as suggested.
>>     - Preserve previous flags when re-initializing "prev"
>>       variables when previous log messages have been reused.
>>     - Insert newline in msg_print_text() outside loop.
>>     - Moved "insert newline" patch earlier in series.
>>     - Rebased on v3.16-rc6.
>> v4: - Fixed two things I messed up in v3:
>>         - Fixed a sprintf() warning I mistakenly created.
>>         - Re-added a hunk inadvertently dropped from patch 3.
>> v3: - Inserted a patch to report dropped message on a new line.
>>     - Dropped a hunk from the (now) third patch, as requested.
>>     - Now insert a newline in msg_print_text() in addition to
>>       devkmsg_read().
>>     - Added Reviewed-by tags where appropriate.
>> v2: - Added a patch to initialize two globals with LOG_NEWLINE.
>>     - Changed the (now) second patch to argue that LOG_CONT and
>>       LOG_NEWLINES are mutally exclusive.
>>     - Added a patch to insert a newline in one case in devkmsg_read().
>>     - Added some extra parentheses in some conditions, as requested.
>>     - Fixed and updated some header commentary.
>>     - Deleted a hunk in the typo patch, as requested.
>>
>> This series, based on v3.16-rc6, is available here:
>>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>>     Branch review/printk-flags-v5
>>
>> Alex Elder (7):
>>   printk: report dropped messages on separate line
>>   printk: insert newline for truncated records
>>   printk: initialize syslog_prev and console_prev
>>   printk: LOG_CONT and LOG_NEWLINE are opposites
>>   printk: honor LOG_PREFIX in devkmsg_read()
>>   printk: honor LOG_PREFIX in msg_print_text()
>>   printk: correct some more typos
>>
>>  kernel/printk/printk.c | 104 +++++++++++++++++++++++++++++++------------------
>>  1 file changed, 66 insertions(+), 38 deletions(-)
> 
> Sadly the clean up could not be as big as we hoped. But there are some
> wins:
> 
> 1. It cleans up LOG_CONT/LOG_NEWLINE handling. Some conditions are
>    easier. Also we are ready to remove LOG_CONT entirely.
> 
> 2. IT fixes some bugs. It better handles unfinished continuous lines.
>    Prefix should not longer appear in the middle of line.
> 
> 
> It looks fine from my point of view.

Thank you very much Petr.

I found another problem or two in my own review after posting,
but didn't want to add more mail traffic to what I've already
produced, so I've waited to make any remarks.  I will send out
my comments, and then one (hopefully!) final version 6 of this
series.

					-Alex

> Best Regards,
> Petr
> 

