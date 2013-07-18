Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3GRGiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:38:22 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57078 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3GRGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:38:21 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-c4-51e78d5b31bb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/19] perf ftrace: Add support for --pid option
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
	<1372230862-15861-7-git-send-email-namhyung@kernel.org>
	<20130710141820.GA5931@krava.brq.redhat.com>
	<87fvvly1fd.fsf@sejong.aot.lge.com>
Date: Thu, 18 Jul 2013 15:38:19 +0900
In-Reply-To: <87fvvly1fd.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 11 Jul 2013 16:56:54 +0900")
Message-ID: <87ppugwexw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 11 Jul 2013 16:56:54 +0900, Namhyung Kim wrote:
> On Wed, 10 Jul 2013 16:18:20 +0200, Jiri Olsa wrote:
>> On Wed, Jun 26, 2013 at 04:14:09PM +0900, Namhyung Kim wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>> 
>>> The -p (--pid) option enables to trace existing process by its pid.
>>
>> hi,
>> I can't get any output from -p for live subcommand:
>>
>> [jolsa@krava perf]$ pgrep yes
>> 6443
>> [jolsa@krava perf]$ sudo ./perf ftrace live -p `pgrep yes`
>
> Hmm... looks like it's stuck on polling the trace_pipe:
>
>   $ sudo strace ./perf ftrace -p `pgrep yes'
>   ...
>   poll([{fd=3, events=POLLIN}], 1, 4294967295
>
>
> Need to investigate it more.

What's your kernel version?  My kernel was 3.6.9.  I guess there's a
problem with trace_pipe's poll implementation on pre-3.10 kernels which
was fixed by:

commit cc60cdc952be09bca5b0bff9fefc7aa6185c3049
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 28 09:17:16 2013 -0500

    tracing: Fix polling on trace_pipe_raw
    
    The trace_pipe_raw never implemented polling and this was casing
    issues for several utilities. This is now implemented.
    
    Blocked reads still are on the TODO list.
    
    Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
    Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


It seems recent kernel doesn't have this issue.  Could you confirm that?

Anyway, I decided not to use poll() here since all recorders only read
one file and it'll provide better compatibility.  I will use
non-blocking read() + nanosleep() as trace-cmd does.

Thanks,
Namhyung
