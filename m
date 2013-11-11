Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3KKOpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:45:06 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:32924 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3KKOpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:45:00 -0500
Message-ID: <5280ECFF.10103@gmail.com>
Date: Mon, 11 Nov 2013 07:43:11 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing
 the perf data file
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com> <20131111093747.GA14810@gmail.com>
In-Reply-To: <20131111093747.GA14810@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 2:37 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> If perf fails to write data to the data file (e.g., ENOSPC error) it fails
>> with the message:
>>    failed to write perf data, error: No space left on device
>>
>> and stops — killing the workload too. The file is an unknown state.
>> Trying to read it (e.g., perf report) fails with a SIGBUS error.
>
> Ouch - guys please first investiage that SIGBUS, we should not behave
> unexpectedly on _any_ (read: random) perf.data file contents. The SIGBUS
> likely suggests that the parsing isn't robust enough.

I think we know why the SIGBUS is happening. From 'man mmap':


 From man mmap:
        SIGBUS Attempted access to a portion of the buffer that
        does not correspond  to  the  file (for  example, beyond
        the end of the file, ...


With regards to perf-record, on a write() failure the header is not 
updated. From a recent change we try to proceed even though the data 
size is 0 - parsing the events we can. We finally hit upon an event that 
is only partially in the file (eg., header, but no data for event). 
Trying to read the event data leads to the SIGBUS:

Running perf-report in gdb:

WARNING: The /tmp/mnt/perf.data file's data size field is 0 which is 
unexpected.
Was the 'perf record' command properly terminated?


Program received signal SIGBUS, Bus error.
perf_evsel__parse_sample (evsel=0x94eec0, event=0x7ffff7ed9d80, 
data=0x7fffffffd260)
     at util/evsel.c:1242
1242		u16 max_size = event->header.size;
(gdb) bt
#0  perf_evsel__parse_sample (evsel=0x94eec0, event=0x7ffff7ed9d80, 
data=0x7fffffffd260)
     at util/evsel.c:1242
#1  0x000000000047c9ce in flush_sample_queue (s=0x94e2b0, 
tool=0x7fffffffde80)
     at util/session.c:542
#2  0x000000000047e2d4 in __perf_session__process_events (session=0x94e2b0,
     data_offset=<optimized out>, data_size=<optimized out>, 
file_size=1048576, tool=0x7fffffffde80)
     at util/session.c:1388
#3  0x000000000042993c in __cmd_report (rep=0x7fffffffde80) at 
builtin-report.c:509
#4  cmd_report (argc=0, argv=0x7fffffffe370, prefix=<optimized out>) at 
builtin-report.c:967
#5  0x000000000041b063 in run_builtin (p=0x7cdf28, argc=4, 
argv=0x7fffffffe370) at perf.c:319
#6  0x000000000041a8e3 in handle_internal_command (argv=0x7fffffffe370, 
argc=4) at perf.c:376
#7  run_argv (argv=0x7fffffffe180, argcp=0x7fffffffe18c) at perf.c:420
#8  main (argc=4, argv=0x7fffffffe370) at perf.c:521

>
>> Fix by deleting the file on a failure.
>
> That only works around the issue - if the same data file is produced by
> some other method (or maliciously) then perf report will still SIGBUS ...

We could handle SIGBUS in the analysis commands too. See the suggestion 
I had for handling the output failure using the mmap output option which 
uses lngjmp.

David
