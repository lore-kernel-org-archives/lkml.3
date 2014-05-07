Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaEGMBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:01:24 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35363 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
References: <1399429566-15587-1-git-send-email-namhyung@kernel.org>
Date: Wed, 7 May 2014 14:01:22 +0200
Message-ID: <CABPqkBSZCK0MBO9HB+V2giTrn7s47zntDsp0EgZD0h-W39aAbQ@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Use tid for finding thread
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 4:26 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>
> I believe that passing pid (instead of tid) as the 3rd arg of the
> machine__find*_thread() was to find a main thread so that it can
> search proper map group for symbols.  However with the map sharing
> patch applied, it now can do it in any thread.
>
Your patch makes the code more meaningful for sure.
The pid, pid looked like a bug to me at first, but then I realized,
that yes, it is
look for the main thread.

Acked-by: Stephane Eranian <eranian@google.com>

>
> It fixes a bug when each thread has different name, it only reports a
> main thread for samples in other threads.
>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-inject.c     | 2 +-
>  tools/perf/builtin-kmem.c       | 2 +-
>  tools/perf/tests/code-reading.c | 2 +-
>  tools/perf/util/build-id.c      | 2 +-
>  tools/perf/util/event.c         | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 3a7387551369..6a3af0013d68 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -209,7 +209,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
>
>         cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>
> -       thread = machine__findnew_thread(machine, sample->pid, sample->pid);
> +       thread = machine__findnew_thread(machine, sample->pid, sample->tid);
>         if (thread == NULL) {
>                 pr_err("problem processing %d event, skipping it.\n",
>                        event->header.type);
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index f91fa4376f4b..bef3376bfaf3 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -235,7 +235,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>                                 struct machine *machine)
>  {
>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
> -                                                       sample->pid);
> +                                                       sample->tid);
>
>         if (thread == NULL) {
>                 pr_debug("problem processing %d event, skipping it.\n",
> diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
> index adf3de3e38d6..67f2d6323558 100644
> --- a/tools/perf/tests/code-reading.c
> +++ b/tools/perf/tests/code-reading.c
> @@ -256,7 +256,7 @@ static int process_sample_event(struct machine *machine,
>                 return -1;
>         }
>
> -       thread = machine__findnew_thread(machine, sample.pid, sample.pid);
> +       thread = machine__findnew_thread(machine, sample.pid, sample.tid);
>         if (!thread) {
>                 pr_debug("machine__findnew_thread failed\n");
>                 return -1;
> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
> index 6baabe63182b..a904a4cfe7d3 100644
> --- a/tools/perf/util/build-id.c
> +++ b/tools/perf/util/build-id.c
> @@ -25,7 +25,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
>         struct addr_location al;
>         u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
> -                                                       sample->pid);
> +                                                       sample->tid);
>
>         if (thread == NULL) {
>                 pr_err("problem processing %d event, skipping it.\n",
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index dbcaea1a8180..65795b835b39 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -788,7 +788,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  {
>         u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
> -                                                       sample->pid);
> +                                                       sample->tid);
>
>         if (thread == NULL)
>                 return -1;
> --
> 1.9.2
>
