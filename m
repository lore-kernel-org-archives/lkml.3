Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaKTGFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:05:48 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58589 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaKTGFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:05:46 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: byungchul.park@lge.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v5 2/2] tracing: add additional marks to signal very large time
References: <1416442535-31188-1-git-send-email-byungchul.park@lge.com>
	<1416442535-31188-3-git-send-email-byungchul.park@lge.com>
	<20141119200604.6b57266d@gandalf.local.home>
Date: Thu, 20 Nov 2014 15:05:43 +0900
In-Reply-To: <20141119200604.6b57266d@gandalf.local.home> (Steven Rostedt's
	message of "Wed, 19 Nov 2014 20:06:04 -0500")
Message-ID: <87ioiapft4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve and Byungchul,

On Wed, 19 Nov 2014 20:06:04 -0500, Steven Rostedt wrote:
> On Thu, 20 Nov 2014 09:15:35 +0900
> byungchul.park@lge.com wrote:
>> -static unsigned long preempt_mark_thresh_us = 100;
>> +#undef MARK
>> +#define MARK(v, s) {.val = v, .sym = s}
>> +/* trace overhead mark */
>> +static const struct trace_mark {
>> +	unsigned long long	val; /* unit: nsec */
>> +	char			sym;
>> +} mark[] = {
>> +	MARK(1000000000ULL	, '$'), /* 1 sec */
>> +	MARK(1000000ULL		, '#'), /* 1000 usecs */
>> +	MARK(100000ULL		, '!'), /* 100 usecs */
>> +	MARK(10000ULL		, '+'), /* 10 usecs */
>> +	MARK(0ULL		, ' '), /* 0 usecs */
>> +};
>> +#undef MARK
>> +
>> +char trace_find_mark(unsigned long long d)
>> +{
>> +	int i;
>> +	int size = ARRAY_SIZE(mark);
>> +
>> +	for (i = 0; i < size; i++) {
>> +		if (d >= mark[i].val)
>> +			break;
>> +	}
>> +
>> +	return (i == size)? ' ' : mark[i].sym;
>
> Change this to:
>
> 	/* The break from loop must have been hit */
> 	if (WARN_ON_ONCE(i == size))
> 		return ' ';

I think it's impossible since it's always true that 'd >= 0'.

Thanks,
Namhyung

>
> 	return mark[i].sym;
>
> -- Steve
>
>
>> +}
>>  
>>  static int
>>  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>> @@ -506,8 +532,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>>  		return trace_seq_printf(
>>  				s, " %4lldus%c: ",
>>  				abs_ts,
>> -				rel_ts > preempt_mark_thresh_us ? '!' :
>> -				  rel_ts > 1 ? '+' : ' ');
>> +				trace_find_mark(rel_ts * NSEC_PER_USEC));
>>  	} else { /* !verbose && !in_ns */
>>  		return trace_seq_printf(s, " %4lld: ", abs_ts);
>>  	}
>> @@ -692,7 +717,7 @@ int register_ftrace_event(struct trace_event *event)
>>  				goto out;
>>  
>>  		} else {
>> -			
>> +
>>  			event->type = next_event_type++;
>>  			list = &ftrace_event_list;
>>  		}
