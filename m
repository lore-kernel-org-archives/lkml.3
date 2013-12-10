Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924Ab3LJAc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:32:59 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64128 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3LJAcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:32:55 -0500
X-AuditID: 9c93017d-b7b46ae000000e86-22-52a661351f1b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/14] tools lib traceevent: Get rid of die in add_filter_type()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-3-git-send-email-namhyung@kernel.org>
	<20131209104437.GF1242@krava.brq.redhat.com>
Date: Tue, 10 Dec 2013 09:32:52 +0900
In-Reply-To: <20131209104437.GF1242@krava.brq.redhat.com> (Jiri Olsa's message
	of "Mon, 9 Dec 2013 11:44:37 +0100")
Message-ID: <87lhztlf4b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 11:44:37 +0100, Jiri Olsa wrote:
> On Mon, Dec 09, 2013 at 02:33:59PM +0900, Namhyung Kim wrote:
>> The realloc() should check return value and not to overwrite previous
>> pointer in case of error.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/parse-filter.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>> 
>> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
>> index 0fc905c230ad..d9c239933992 100644
>> --- a/tools/lib/traceevent/parse-filter.c
>> +++ b/tools/lib/traceevent/parse-filter.c
>> @@ -161,11 +161,13 @@ add_filter_type(struct event_filter *filter, int id)
>>  	if (filter_type)
>>  		return filter_type;
>>  
>> -	filter->event_filters =	realloc(filter->event_filters,
>> -					sizeof(*filter->event_filters) *
>> -					(filter->filters + 1));
>> -	if (!filter->event_filters)
>> -		die("Could not allocate filter");
>> +	filter_type = realloc(filter->event_filters,
>> +			      sizeof(*filter->event_filters) *
>> +			      (filter->filters + 1));
>> +	if (!filter_type)
>> +		return NULL;
>> +
>> +	filter->event_filters = filter_type;
>>  
>>  	for (i = 0; i < filter->filters; i++) {
>>  		if (filter->event_filters[i].event_id > id)
>> @@ -1164,6 +1166,12 @@ static int filter_event(struct event_filter *filter,
>>  	}
>>  
>>  	filter_type = add_filter_type(filter, event->id);
>> +	if (filter_type == NULL) {
>> +		show_error(error_str, "failed to add a new filter: %s",
>> +			   filter_str ? filter_str : "true");
>> +		return -1;
>
> so your key for using show_error in case of error is if it's
> used already in the error path in the function.. right?

Right.  In fact, it might look better if copy_filter_type() or
pevent_filter_copy() pass error_str too.  But the pevent_filter_
copy() looks like an user API so I was not sure I can change the
signature.  Also user can see its return value anyway and it's
relatively simple function so might not care about the detail..

Thanks,
Namhyung

>
>> +	}
>> +
>>  	if (filter_type->filter)
>>  		free_arg(filter_type->filter);
>>  	filter_type->filter = arg;
>> @@ -1395,6 +1403,9 @@ static int copy_filter_type(struct event_filter *filter,
>>  			arg->boolean.value = 0;
>>  
>>  		filter_type = add_filter_type(filter, event->id);
>> +		if (filter_type == NULL)
>> +			return -1;
>> +
>>  		filter_type->filter = arg;
>>  
>>  		free(str);
>> -- 
>> 1.7.11.7
>> 
