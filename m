Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaLaPcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:32:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39240 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaLaPci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <20141231141744.GE1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-17-git-send-email-namhyung@kernel.org> <20141231141744.GE1256@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Thu, 1 Jan 2015 00:32:17 +0900
X-Google-Sender-Auth: -HB5RATkOTZVz9EyecieezmqYs8
Message-ID: <CAM9d7ci9CnMPGgcAbs=ZQcm_LAWeMSdfZcszji_C=1yzU9Yp1g@mail.gmail.com>
Subject: Re: [PATCH 16/37] perf tools: Add a test case for timed thread handling
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 11:17 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:12PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>               .func = NULL,
>>       },
>>  };
>> diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
>> index 43ac17780629..1090337f63e5 100644
>> --- a/tools/perf/tests/tests.h
>> +++ b/tools/perf/tests/tests.h
>> @@ -52,6 +52,7 @@ int test__switch_tracking(void);
>>  int test__fdarray__filter(void);
>>  int test__fdarray__add(void);
>>  int test__thread_comm(void);
>> +int test__thread_lookup_time(void);
>>
>>  #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
>>  #ifdef HAVE_DWARF_UNWIND_SUPPORT
>> diff --git a/tools/perf/tests/thread-lookup-time.c b/tools/perf/tests/thread-lookup-time.c
>> new file mode 100644
>> index 000000000000..6237ecf8caae
>> --- /dev/null
>> +++ b/tools/perf/tests/thread-lookup-time.c
>> @@ -0,0 +1,174 @@
>> +#include "tests.h"
>> +#include "machine.h"
>> +#include "thread.h"
>> +#include "map.h"
>> +#include "debug.h"
>> +
>> +static int thread__print_cb(struct thread *th, void *arg __maybe_unused)
>> +{
>> +     printf("thread: %d, start time: %"PRIu64" %s\n",
>> +            th->tid, th->start_time, th->dead ? "(dead)" : "");
>> +     return 0;
>> +}
>> +
>> +static int lookup_with_timestamp(struct machine *machine)
>> +{
>> +     struct thread *t1, *t2, *t3;
>> +     union perf_event fork = {
>> +             .fork = {
>> +                     .pid = 0,
>> +                     .tid = 0,
>> +                     .ppid = 1,
>> +                     .ptid = 1,
>> +             },
>
> I've got following output from the test:
>
> test child forked, pid 18483
> ========= after t1 created ==========
> thread: 0, start time: 0
> ========= after t1 set comm ==========
> thread: 0, start time: 20000
> ========= after t2 forked ==========
> thread: 0, start time: 50000
> thread: 1, start time: 0
> thread: 0, start time: 10000
> thread: 0, start time: 20000 (dead)
> ========= after t3 forked ==========
> thread: 0, start time: 60000
> thread: 1, start time: 0
> thread: 0, start time: 10000
> thread: 0, start time: 50000 (dead)
> thread: 0, start time: 20000 (dead)
> test child finished with 0
>
> 'after t2 forked' data shows 'thread 0 with time 50000' and
> newly added parent 'thread: 1, start time: 0'
>
> this makes me wonder if you wanted switch 0 and 1 for pid and ppid
> in above sample init and follow with forked pid 1 ... but not sure
> because you're using the same sample for fork 3 ;-)
>
> my question is if that was intentional, because I've got
> confused in here

Yeah, it's intentional.  I'm testing machine__findnew_thread_time()
and machine__process_fork_event() can generate threads properly.  The
former creates a dead thread if the timestamp is before any of
existing threads which have a same pid.  The latter can create two
threads - one for tid and another for ptid (only if it doesn't exist).


>
>> +     };
>> +     struct perf_sample sample = {
>> +             .time = 50000,
>> +     };
>> +
>> +     /* start_time is set to 0 */
>> +     t1 = machine__findnew_thread(machine, 0, 0);
>> +
>> +     if (verbose > 1) {
>> +             printf("========= after t1 created ==========\n");
>> +             machine__for_each_thread(machine, thread__print_cb, NULL);
>> +     }
>> +
>> +     TEST_ASSERT_VAL("wrong start time of old thread", t1->start_time == 0);
>> +
>> +     TEST_ASSERT_VAL("cannot find current thread",
>> +                     machine__find_thread(machine, 0, 0) == t1);
>> +
>> +     TEST_ASSERT_VAL("cannot find current thread with time",
>> +                     machine__findnew_thread_time(machine, 0, 0, 10000) == t1);
>> +
>> +     /* start_time is overwritten to new value */
>> +     thread__set_comm(t1, "/usr/bin/perf", 20000);
>> +
>> +     if (verbose > 1) {
>> +             printf("========= after t1 set comm ==========\n");
>> +             machine__for_each_thread(machine, thread__print_cb, NULL);
>> +     }
>> +
>> +     TEST_ASSERT_VAL("failed to update start time", t1->start_time == 20000);
>> +
>> +     TEST_ASSERT_VAL("should not find passed thread",
>> +                     /* this will create yet another dead thread */
>> +                     machine__findnew_thread_time(machine, 0, 0, 10000) != t1);
>
> also this comment say that calling machine__findnew_thread_time will
> create another dead thread, which actually did not happened based on
> above test output

Oh, it's actually a dead thread - it's in the dead threads tree - but
I just missed to set the dead flag. :)

Thanks,
Namhyung
