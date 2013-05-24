Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3EXOLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:11:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55063 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3EXOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:11:42 -0400
Message-ID: <519F7519.8050100@gmail.com>
Date: Fri, 24 May 2013 08:11:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: handle death by SIGTERM
References: <1367864663-1309-1-git-send-email-dsahern@gmail.com> <20130524090817.GA1020@krava.brq.redhat.com>
In-Reply-To: <20130524090817.GA1020@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/13 3:08 AM, Jiri Olsa wrote:
> On Mon, May 06, 2013 at 12:24:23PM -0600, David Ahern wrote:
>> perf data files cannot be processed until the header file is update
>> which is done via an on_exit handler. If perf is killed due to a SIGTERM
>> it does not run the on_exit hooks leaving the perf.data file in a
>> random state which perf-report will happily spin on trying to read. As
>> noted by Mike an easy reproducer is:
>>    perf record -a -g & sleep 1; killall perf
>>
>> Fix by catching SIGTERM like it does SIGINT.  Also need to remove the
>> kill which was added via commit f7b7c26e.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Stephane Eranian <eranian@google.com>
>> ---
>>   tools/perf/builtin-record.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index cdf58ec..fff985c 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -198,7 +198,6 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
>>   		return;
>>
>>   	signal(signr, SIG_DFL);
>> -	kill(getpid(), signr);
>>   }
>>
>>   static bool perf_evlist__equal(struct perf_evlist *evlist,
>> @@ -404,6 +403,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>>   	signal(SIGCHLD, sig_handler);
>>   	signal(SIGINT, sig_handler);
>>   	signal(SIGUSR1, sig_handler);
>> +	signal(SIGTERM, sig_handler);
>>
>>   	if (!output_name) {
>>   		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
>> --
>> 1.7.10.1
>>
>
> hi,
> got a perf test hanging on me on latest acme's perf/core and bisected
> it to this one. I separated reproducer so far but probably wont get to
> it this week:

Ok, I should have some time to look into it this weekend.

David

>
> [jolsa@krava2 perf]$ cat /proc/sys/kernel/perf_event_paranoid
> 1
> [jolsa@krava2 perf]$ ./perf record -C 0 kill
> Error:
> You may not have permission to collect %sstats.
> Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>   -1 - Not paranoid at all
>    0 - Disallow raw tracepoint access for unpriv
>    1 - Disallow cpu events for unpriv
>    2 - Disallow kernel profiling for unpriv
>
> jirka
>

