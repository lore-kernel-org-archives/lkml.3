Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3LJBtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:49:01 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56504 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3LJBs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:48:59 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-85-52a67309d3a6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Refactor test_filter() to get rid of die()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-14-git-send-email-namhyung@kernel.org>
	<20131209111936.71a448c5@gandalf.local.home>
Date: Tue, 10 Dec 2013 10:48:57 +0900
In-Reply-To: <20131209111936.71a448c5@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 9 Dec 2013 11:19:36 -0500")
Message-ID: <87vbyxjx12.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 11:19:36 -0500, Steven Rostedt wrote:
> On Mon,  9 Dec 2013 14:34:10 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> @@ -1788,39 +1790,44 @@ get_exp_value(struct event_format *event, struct filter_arg *arg, struct pevent_
>>  
>>  	case FILTER_EXP_NOT:
>>  	default:
>> -		die("error in exp");
>> +		if (*error_str == NULL)
>> +			*error_str = "invalid expression type";
>
> Hmm, how do we tell the caller that there was an error? Do they just
> check to see if error_str was changed?
>
>>  	}
>>  	return 0;
>>  }
[SNIP]
>> @@ -2004,6 +2021,7 @@ int pevent_event_filtered(struct event_filter *filter,
>>   *  0 - filter found for event and @record does not match
>>   * -1 - no filter found for @record's event
>>   * -2 - if no filters exist
>> + * -3 - if error occurred during test
>>   */
>>  int pevent_filter_match(struct event_filter *filter,
>>  			struct pevent_record *record)
>> @@ -2011,6 +2029,8 @@ int pevent_filter_match(struct event_filter *filter,
>>  	struct pevent *pevent = filter->pevent;
>>  	struct filter_type *filter_type;
>>  	int event_id;
>> +	char *error_str = NULL;
>> +	int ret;
>>  
>>  	if (!filter->filters)
>>  		return FILTER_NONE;
>> @@ -2022,8 +2042,14 @@ int pevent_filter_match(struct event_filter *filter,
>>  	if (!filter_type)
>>  		return FILTER_NOEXIST;
>>  
>> -	return test_filter(filter_type->event, filter_type->filter, record) ?
>> -		FILTER_MATCH : FILTER_MISS;
>> +	ret = test_filter(filter_type->event, filter_type->filter, record,
>> +			  &error_str);
>> +	if (error_str) {
>> +		/* TODO: maybe we can print it or pass back to user */
>
> Ah, I guess this answers my question :-)

Right.  I was also considering what's the best way to handle error..

>
> Maybe we can save the error_str in the pevent. Then we can extract it
> later. The return of FILTER_ERROR will let the user see what happened.

Yes, but then we need the extraction and free-ing APIs too.

Or else, we can do similar to pevent_errno/strerror - returns a specific
error code and print it with user-supplied buffer.  If so we need to
think about whether consolidating it with existing pevent API or making
it a separate filter-specific API IMHO.

Thanks,
Namhyung

>
>> +		return FILTER_ERROR;
>> +	}
>> +
>> +	return ret ? FILTER_MATCH : FILTER_MISS;
>>  }
>>  
>>  static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
