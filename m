Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933Ab3CTAyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:54:05 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43561 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3CTAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:54:03 -0400
X-AuditID: 9c93016f-b7b08ae000000bbd-bd-514908a81dec
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/9] perf util: Let get_tracing_file() can return NULL
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	<1363683224-28804-2-git-send-email-namhyung@kernel.org>
	<1363701261.5938.18.camel@gandalf.local.home>
Date: Wed, 20 Mar 2013 09:53:59 +0900
In-Reply-To: <1363701261.5938.18.camel@gandalf.local.home> (Steven Rostedt's
	message of "Tue, 19 Mar 2013 09:54:21 -0400")
Message-ID: <87r4jaj3h4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Tue, 19 Mar 2013 09:54:21 -0400, Steven Rostedt wrote:
> On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> So that it can be used by other places.
>> 
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/util/trace-event-info.c | 25 ++++++++++++++++++++++---
>>  1 file changed, 22 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
>> index 5729f434c5b1..f241343b7d48 100644
>> --- a/tools/perf/util/trace-event-info.c
>> +++ b/tools/perf/util/trace-event-info.c
>> @@ -62,7 +62,7 @@ static const char *find_debugfs(void)
>>  	const char *path = perf_debugfs_mount(NULL);
>>  
>>  	if (!path)
>> -		die("Your kernel not support debugfs filesystem");
>> +		pr_err("Your kernel not support debugfs filesystem");
>
> "Your kernel does not support the debugfs filesystem"
>
> I know you just did a s/die/pr_err/ but might as well fix the grammar
> too ;-)

Right, will do.

>
>>  
>>  	return path;
>>  }
>> @@ -81,8 +81,12 @@ static const char *find_tracing_dir(void)
>>  		return tracing;
>>  
>>  	debugfs = find_debugfs();
>> +	if (!debugfs)
>> +		return NULL;
>>  
>> -	tracing = malloc_or_die(strlen(debugfs) + 9);
>> +	tracing = malloc(strlen(debugfs) + 9);
>> +	if (!tracing)
>> +		return NULL;
>>  
>>  	sprintf(tracing, "%s/tracing", debugfs);
>>  
>> @@ -99,7 +103,9 @@ static char *get_tracing_file(const char *name)
>>  	if (!tracing)
>>  		return NULL;
>>  
>> -	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
>> +	file = malloc(strlen(tracing) + strlen(name) + 2);
>> +	if (!file)
>> +		return NULL;
>
> Should have clean up as well. That is, if file fails, we need to free
> tracing. Otherwise there's a memory leak.

Well, I'm not sure - there's a static pointer in the
find_tracing_dir().  If we free tracing here, we'll need to reset
tracing_found in the function also.  So I just kept it. :(

>
>>  
>>  	sprintf(file, "%s/%s", tracing, name);
>>  	return file;
>> @@ -170,6 +176,9 @@ static void read_header_files(void)
>>  	struct stat st;
>>  
>>  	path = get_tracing_file("events/header_page");
>> +	if (!path)
>> +		die("can't get tracing/events/header_page");
>> +
>>  	if (stat(path, &st) < 0)
>>  		die("can't read '%s'", path);
>>  
>> @@ -178,6 +187,9 @@ static void read_header_files(void)
>>  	put_tracing_file(path);
>>  
>>  	path = get_tracing_file("events/header_event");
>> +	if (!path)
>> +		die("can't get tracing/events/header_event");
>> +
>>  	if (stat(path, &st) < 0)
>>  		die("can't read '%s'", path);
>>  
>> @@ -251,6 +263,8 @@ static void read_ftrace_files(struct tracepoint_path *tps)
>>  	char *path;
>>  
>>  	path = get_tracing_file("events/ftrace");
>> +	if (!path)
>> +		die("can't get tracing/events/ftrace");
>>  
>>  	copy_event_system(path, tps);
>>  
>> @@ -279,6 +293,8 @@ static void read_event_files(struct tracepoint_path *tps)
>>  	int ret;
>>  
>>  	path = get_tracing_file("events");
>> +	if (!path)
>> +		die("can't get tracing/events");
>>  
>>  	dir = opendir(path);
>>  	if (!dir)
>> @@ -343,6 +359,9 @@ static void read_ftrace_printk(void)
>>  	int ret;
>>  
>>  	path = get_tracing_file("printk_formats");
>> +	if (!path)
>> +		die("can't get tracing/printk_formats");
>> +
>
> OK, so we are just moving die to the caller? I'm fine with that. If we
> can get the utilities to remove die, that's a big step.

They'll be removed on later patches, I moved them to callers since I
don't have proper error handling code at this time.

Thanks for review,
Namhyung
