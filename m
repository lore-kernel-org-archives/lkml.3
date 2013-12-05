Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3LESTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:19:36 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47209 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab3LESTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131205085912.GB13377@gmail.com>
References: <20131205015557.GA13397@quad>
	<20131205085912.GB13377@gmail.com>
Date: Thu, 5 Dec 2013 19:19:33 +0100
Message-ID: <CABPqkBR8Q=iV_-0O=BNkxCyuu7C3GUjB+ZjQc-Kysux3pE16vA@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix bug in usage of the basename() function
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 9:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>>
>> The basename() implementation varies a lot between systems.
>> The Linux man page says: "basename may modify the content of the path,
>> so it may be desirable to pass a copy when calling the function".
>> On some other systems, the returned address may come from an internal
>> buffer which can be reused in subsequent calls, thus the results should
>> also be copied.
>>
>> The dso__set_basename() function was not doing this causing problems
>> on some systems with wrong library names being shown by perf report,
>> such as on Android systems.
>>
>> This patch fixes the problem.
>> Thanks to Ben Cheng for tracking down the problem.
>>
>> Patch relative to tip.git at commit 631d5ea.
>>
>> Reported-by: Ben Cheng <bccheng@google.com>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>
> Just three nits:
>
>>  tools/perf/util/dso.c |   29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index af4c687c..d186ace 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -404,7 +404,34 @@ void dso__set_short_name(struct dso *dso, const char *name)
>>
>>  static void dso__set_basename(struct dso *dso)
>>  {
>> -     dso__set_short_name(dso, basename(dso->long_name));
>> +     char *lname, *base;
>> +
>> +     /*
>> +      * basename may modify path buffer, so we must pass
>> +      * a copy.
>
> s/basename may modify path buffer
>  /basename() may modify the path buffer
>
>> +      */
>> +     lname = strdup(dso->long_name);
>> +     if (!lname)
>> +             return;
>> +
>> +     /*
>> +      * basename may return pointer to internal
>> +      * storage which is reused in subsequent calls
>> +      * so copy the result
>> +      */
>
> s/basename may return pointer
>  /basename() may return a pointer
>
> Makes for easier reading.
>
> (Also please use consistent periods - the first comment has a period,
> the second one doesn't. ':' works well too:)
>
Fixed that.

>
>> +     base = strdup(basename(lname));
>> +
>> +     free(lname);
>> +
>> +     if (!base)
>> +             return;
>> +
>> +     if (dso->sname_alloc)
>> +             free((char *)dso->short_name);
>
> That cast is probably not needed.
>
It is with my compiler. It prints out a warning otherwise.

>> +     else
>> +             dso->sname_alloc = 1;
>> +
>> +     dso__set_short_name(dso, base);
>>  }
>>
>>  int dso__name_len(const struct dso *dso)
>
> Otherwise:
>
> Acked-by: Ingo Molnar <mingo@kernel.org>
>
> Thanks,
>
>         Ingo

Reposting ASAP.
Thanks.
