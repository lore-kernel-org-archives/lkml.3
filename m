Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaEWN03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:26:29 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33884 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaEWN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140523081357.GC1074@krava>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<20140523081357.GC1074@krava>
Date: Fri, 23 May 2014 15:26:27 +0200
Message-ID: <CAFrcx1k+dk2sjB4boHQtDSzTdutJ1pxMDnGTsFwh_2_gTgYa2g@mail.gmail.com>
Subject: Re: [PATCHv2 00/14] perf tools: Speedup DWARF unwind
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,


On 23 May 2014 10:13, Jiri Olsa <jolsa@redhat.com> wrote:
> ping ;-)
This looks a ping to yourself ;-)

Here are the results on ARMv7:
- libunwind: between -29% in execution time for light load (i.e. using
not-so-deep backtraces from the stress app.) and -49% for deep
backtrace (the 'stress_bt' app.),
- libdw: no significant improvement (0-2% improvement).

Cf. https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-callstack-unwinding#Speed_improvement
for more details.

FWIW:
Acked-by: Jean Pihet <jean.pihet@linaro.org>

Regards,
Jean


>
> thanks,
> jirka
>
> On Thu, May 15, 2014 at 07:23:21PM +0200, Jiri Olsa wrote:
>> hi,
>> trying to speedup DWARF unwind report code by factoring
>> related code:
>>   - caching sample's registers access
>>   - keep dso data file descriptor open for the
>>     life of the dso object
>>   - replace dso cache code by mapping dso data file
>>     directly for the life of the dso object
>>
>> The speedup is mainly for libunwind unwind. The libdw will benefit
>> mainly from cached registers access, because it handles dso data
>> accesses by itself.. and anyway it's still faster ;-).
>>
>> v2 changes:
>>   - adding limit for open dso objects with sort of LRU
>>     mechanism to pick up and close dso objects if we
>>     are over the limit
>>   - file mmaping changes are omitted, because I couldn't prove
>>     the improvement exactly, will resubmit later
>>   - added dso close logic in case of no memory
>>   - added tests
>>
>> On 10GB perf data file with dwarf unwind data I've got
>> around 30% speed up.
>>
>> Also reachable in here:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>>   perf/core_unwind_speedup
>>
>> thanks,
>> jirka
>>
>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jean Pihet <jean.pihet@linaro.org>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> ---
>> Jiri Olsa (14):
>>       perf tools: Cache register accesses for unwind processing
>>       perf tools: Separate dso data related variables
>>       perf tools: Add data_fd into dso object
>>       perf tools: Add global list of opened dso objects
>>       perf tools: Add global count of opened dso objects
>>       perf tools: Cache dso data file descriptor
>>       perf tools: Add file size check and factor dso__data_read_offset
>>       perf tools: Allow to close dso fd in case of open failure
>>       perf tools: Add dso__data_* interface descriptons
>>       perf tests: Spawn child for each test
>>       perf tests: Allow reuse of test_file function
>>       perf tests: Add test interface for dso data fd limit
>>       perf tests: Add test for caching dso file descriptors
>>       perf tests: Add test for closing dso objects on EMFILE error
>>
>>  tools/perf/tests/builtin-test.c    |  42 ++++++++++++++-
>>  tools/perf/tests/dso-data.c        | 256 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  tools/perf/tests/tests.h           |   2 +
>>  tools/perf/util/dso.c              | 274 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
>>  tools/perf/util/dso.h              |  56 +++++++++++++++++++-
>>  tools/perf/util/event.h            |   5 ++
>>  tools/perf/util/perf_regs.c        |  10 +++-
>>  tools/perf/util/perf_regs.h        |   4 +-
>>  tools/perf/util/unwind-libunwind.c |   4 +-
>>  9 files changed, 617 insertions(+), 36 deletions(-)
