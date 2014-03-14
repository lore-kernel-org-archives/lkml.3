Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaCNOPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:15:33 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:44697 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaCNOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:15:15 -0400
Date: Fri, 14 Mar 2014 11:15:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] perf tools: Factor machine__find_thread to take tid
 argument
Message-ID: <20140314141509.GD2396@ghostprotocols.net>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394805606-25883-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 14, 2014 at 03:00:03PM +0100, Jiri Olsa escreveu:
> Forcing the code to always search thread by pid/tid pair.
> 
> The PID value will be needed in future to determine
> the process thread leader for map groups sharing.

This one looks OK, Adrian?

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  tools/perf/tests/dwarf-unwind.c |  2 +-
>  tools/perf/util/machine.c       | 13 +++++++++----
>  tools/perf/util/machine.h       |  3 ++-
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
> index f16ea28..c059ee8 100644
> --- a/tools/perf/tests/dwarf-unwind.c
> +++ b/tools/perf/tests/dwarf-unwind.c
> @@ -128,7 +128,7 @@ int test__dwarf_unwind(void)
>  	if (verbose > 1)
>  		machine__fprintf(machine, stderr);
>  
> -	thread = machine__find_thread(machine, getpid());
> +	thread = machine__find_thread(machine, getpid(), getpid());
>  	if (!thread) {
>  		pr_err("Could not get thread\n");
>  		goto out;
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index eb26544..a189faf 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -327,9 +327,10 @@ struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
>  	return __machine__findnew_thread(machine, pid, tid, true);
>  }
>  
> -struct thread *machine__find_thread(struct machine *machine, pid_t tid)
> +struct thread *machine__find_thread(struct machine *machine, pid_t pid,
> +				    pid_t tid)
>  {
> -	return __machine__findnew_thread(machine, 0, tid, false);
> +	return __machine__findnew_thread(machine, pid, tid, false);
>  }
>  
>  int machine__process_comm_event(struct machine *machine, union perf_event *event,
> @@ -1114,7 +1115,9 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
>  int machine__process_fork_event(struct machine *machine, union perf_event *event,
>  				struct perf_sample *sample)
>  {
> -	struct thread *thread = machine__find_thread(machine, event->fork.tid);
> +	struct thread *thread = machine__find_thread(machine,
> +						     event->fork.pid,
> +						     event->fork.tid);
>  	struct thread *parent = machine__findnew_thread(machine,
>  							event->fork.ppid,
>  							event->fork.ptid);
> @@ -1140,7 +1143,9 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
>  int machine__process_exit_event(struct machine *machine, union perf_event *event,
>  				struct perf_sample *sample __maybe_unused)
>  {
> -	struct thread *thread = machine__find_thread(machine, event->fork.tid);
> +	struct thread *thread = machine__find_thread(machine,
> +						     event->fork.pid,
> +						     event->fork.tid);
>  
>  	if (dump_trace)
>  		perf_event__fprintf_task(event, stdout);
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index 2e6c248..c8c74a1 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -41,7 +41,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
>  	return machine->vmlinux_maps[type];
>  }
>  
> -struct thread *machine__find_thread(struct machine *machine, pid_t tid);
> +struct thread *machine__find_thread(struct machine *machine, pid_t pid,
> +				    pid_t tid);
>  
>  int machine__process_comm_event(struct machine *machine, union perf_event *event,
>  				struct perf_sample *sample);
> -- 
> 1.8.3.1
