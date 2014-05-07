Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaEGRTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:19:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57039 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaEGRTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140507150404.GO30445@twins.programming.kicks-ass.net>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
	<1398346054-3322-2-git-send-email-namhyung@kernel.org>
	<20140429105654.GB1148@krava.brq.redhat.com>
	<20140429111939.GP11096@twins.programming.kicks-ass.net>
	<20140429113747.GD1148@krava.brq.redhat.com>
	<87tx9boeaf.fsf@sejong.aot.lge.com>
	<20140507150404.GO30445@twins.programming.kicks-ass.net>
Date: Wed, 7 May 2014 19:19:14 +0200
Message-ID: <CABPqkBTC-MjMB0U0+NjqrdKFFuoQt-N7MZJikcbcWJpLLgVRRg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 5:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 30, 2014 at 09:24:08AM +0900, Namhyung Kim wrote:
>> Hi Jiri and Peter,
>>
>> On Tue, 29 Apr 2014 13:37:47 +0200, Jiri Olsa wrote:
>> > On Tue, Apr 29, 2014 at 01:19:39PM +0200, Peter Zijlstra wrote:
>> >> On Tue, Apr 29, 2014 at 12:56:54PM +0200, Jiri Olsa wrote:
>> >> >
>> >> >   perf_counter tools: Propagate signals properly
>> >> >   commit f7b7c26e01e51fe46097e11f179dc71ce7950084
>> >> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> >   Date:   Wed Jun 10 15:55:59 2009 +0200
>> >> >
>> >> > but I dont think we need to do that
>> >>
>> >> But but but, then you're re-introducing that fail again? That no good.
>>
>> FYI, it's already gone with 804f7ac78803 ("perf record: handle death by
>> SIGTERM").
>>
>> >
>> > well, I was trying the testcase you mentioned in the changelog
>> > and it seemed to work for me.. ;-) I guess I was lucky to hit
>> > the bash time window..
>> >
>> >   while :; do perf stat ./foo ; done
>> >
>> > so how does this work? bash will kill the loop if perf's wait
>> > status is WIFSIGNALED?
>>
>> I'm not sure but isn't it *bash* to catch signal and terminate the
>> loop?  It seems the wait status of child has no business with the loop
>> termination.  Am I missing something?
>>
>>   $ cat suicide.c
>>   #include <signal.h>
>>
>>   int main(void)
>>   {
>>     raise(SIGTERM);
>>     return 0;
>>   }
>>
>
> SIGTERM isn't the problem. SIGINT is. Typically when you run:
>
> while :; do perf stat ./foo ; done
>
> Its foo that is running, so when you press ^C, you'll SIGINT foo. foo
> will then exit, perf stat will notice the exit, exit itself and because
> the loop doesn't look at the return value of perf stat, simply
> continues.
>
> What I want, and fixed back then, is that if you press ^C foo
> terminates, perf stat/record/etc. will finish, but then terminate with
> the same signal. In that case bash finally sees the SIGINT and will in
> fact terminate the loop.
>
> try:
>
> $ while :; do ./foo /bin/sleep 5 ; done
>
> and try and break out using ^C
>
What I usually do here is hit ^Z, then kill the job.
But I agree it would be nicer to handle this case automatically.

> ---
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <signal.h>
> #include <sys/types.h>
> #include <sys/wait.h>
>
> int main(int argc, char *argv[], char *envp[])
> {
>         pid_t pid = fork();
>         if (!pid) /* child */ {
>                 execve(argv[1], argv+1, envp);
>                 perror("execve");
>                 return;
>         }
>
>         signal(SIGINT, SIG_IGN);
>         waitpid(pid, NULL, 0);
>         return 0;
> }
