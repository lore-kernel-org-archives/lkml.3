Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3CTBMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:12:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53618 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3CTBMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:12:43 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-9a-51490d099b65
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/9] perf util: Handle failure case in trace_report()
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-6-git-send-email-namhyung@kernel.org>
	<1363704473.5938.25.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 10:12:41 +0900
In-Reply-To: <1363704473.5938.25.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 19 Mar 2013 10:47:53 -0400")
Message-ID: <87ip4mj2ly.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013 10:47:53 -0400, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>
>> @@ -3100,7 +3105,7 @@ int perf_event__process_tracing_data(union perf_event *event,
>>  		}
>>  	}
>>  
>> -	if (size_read + padding != size) {
>> +	if (size_read + padding != size || session->pevent == NULL) {
>>  		pr_err("%s: tracing data size mismatch", __func__);
>
> This is a strange error to give when pevent is NULL. Could have been a
> malloc failure.

Hmm.. right.  I was just too lazy. ;)

Will break NULL check and print "failed to process tracing data" as we
set it to NULL if something broken.

>
>
>>  		return -1;
>>  	}
>> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
>> index 7cb24635adf2..129362b97ca5 100644
>> --- a/tools/perf/util/trace-event-read.c
>> +++ b/tools/perf/util/trace-event-read.c
>> @@ -293,7 +293,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>>  	int show_version = 0;
>>  	int show_funcs = 0;
>>  	int show_printk = 0;
>> -	ssize_t size;
>> +	ssize_t size = -1;
>> +	struct pevent *pevent;
>> +
>> +	*ppevent = NULL;
>>  
>>  	calc_data_size = 1;
>>  	repipe = __repipe;
>> @@ -317,34 +320,38 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>>  	file_bigendian = buf[0];
>>  	host_bigendian = bigendian();
>>  
>> -	*ppevent = read_trace_init(file_bigendian, host_bigendian);
>> -	if (*ppevent == NULL)
>> -		die("read_trace_init failed");
>> +	pevent = read_trace_init(file_bigendian, host_bigendian);
>> +	if (pevent == NULL) {
>
> Shouldn't we still set *ppevent to NULL? Or will the user now need to
> make sure that its pevent is NULL and always check for error?

I thought it's impossible to check return value for error since we don't
know how large a tracing data is, so I decided to init *ppevent to NULL
at the beginning and set it to a valid pevent right before return.  Thus
user need to check NULL before using it.

In the above case of perf_event__process_tracing_data(), it's a pipe
mode and we can know its size since it's saved in a temp file.

Thanks,
Namhyung
