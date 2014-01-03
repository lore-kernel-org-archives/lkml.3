Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaACIXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 03:23:10 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44460 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaACIXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 03:23:09 -0500
X-AuditID: 9c93017d-b7c2eae000004ec2-ae-52c6736957eb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 4/8] perf tools: Introduce struct perf_log
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
	<1388036284-32342-5-git-send-email-namhyung@kernel.org>
	<20131226145051.GG30980@ghostprotocols.net>
Date: Fri, 03 Jan 2014 17:23:05 +0900
In-Reply-To: <20131226145051.GG30980@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 26 Dec 2013 11:50:51 -0300")
Message-ID: <87a9fdfp92.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 26 Dec 2013 11:50:51 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 26, 2013 at 02:38:00PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Add new functions to save error messages in a temp file.  It'll be
>> used by some UI front-ends to see the messages.

[SNIP]
>> +struct perf_log {
>> +	FILE *fp;
>> +	off_t *linemap;
>> +	u32 lines;
>> +	u32 nr_alloc;
>> +	bool seen_newline;
>> +};
>> +
>> +extern struct perf_log perf_log;
>> +
>> +int perf_log_init(void);
>> +int perf_log_exit(void);
>> +void perf_log_add(const char *msg);
>> +void perf_log_addv(const char *fmt, va_list ap);
>
> The convention in tools/perf/ has been to use class__method, i.e. in the
> above case we would have:
>
> int perf_log__init(void);
> int perf_log__exit(void);
> void perf_log__add(const char *msg);
> void perf_log__addv(const char *fmt, va_list ap);

Okay.  (I wasn't follow the convention since the functions do not pass
the perf_log as an argument, but I agree it's better to follow it.)
Will change.

>
>
> But I have some questions about the implementation, will we go on
> allocating memory for each and every line?

Yes, it needs an offset for each line in order to find starting point.

>
> Can't we just come out with a simple ui_file_browser class that would
> then be usable for any file, including this one?

Yes we can do it if need be.  Do you think of another use case?

>
> The ui_file_browser__seek() method would have to go on reading lines and
> seeking newlines, with the ui_file_browser__seek(browser, 0, SEEK_SET)
> would map directly to fseek(log_fp, 0, SEEK_SET), etc.

It supposed to.  But in this case, the ->seek() method is called in
ui_browser__run() which is not protected by ui__lock.  So it's possible
that new log message alters file position if it's called after ->seek()
method was executed.

If it's guaranteed that there's no concurrent access to the file, we can
move fseek() to the ->seek() method IMHO.

>
> It should handle "live" files, like the one we're feeding log lines,
> etc.
>
> The way you implemented it will grow memory consumption without
> limits, no?

Right, it'll consume 8 bytes for each line of the file.  What's the
reasonable limitation?

Thanks,
Namhyung
