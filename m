Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaIHNVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:21:19 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62230 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaIHNVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140908124945.GD17728@krava.brq.redhat.com>
References: <CABPqkBRREcix0TtLLUgiq8uabUqG=m2un79WKLqPXF=LccSQbw@mail.gmail.com>
	<20140908124945.GD17728@krava.brq.redhat.com>
Date: Mon, 8 Sep 2014 15:21:12 +0200
Message-ID: <CABPqkBRPWh+=CfXBYaYW=P6FJke3KB-7y-U1ky8JAKjDY3JaEg@mail.gmail.com>
Subject: Re: [BUG] perf: cannot read counts in per-process mode in 3.17-rcX
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 2:49 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Sep 08, 2014 at 02:35:06PM +0200, Stephane Eranian wrote:
> > Hi,
> >
> > It seems something is seriously broken with perf_events in
> > 3.17-rcX. I have tried rc3, rc4. No way to get any counts
> > out using perf stat in per-process mode. I am trying on Intel
> > and the PMU is correctly detected:
> >
> > $ perf stat -e cycles ls
> >       <not counted> cycles
> >
> > It is not a permission problem. It is a read problem!
> > $ strace perf stat -e cycles ls
> >
> > perf_event_open(0x27d7e20, 2261, -1, -1, 0x8 /* PERF_FLAG_??? */) = 3
> > write(6, "\0", 1)                       = 1
> > close(6)                                = 0
> > wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 2261
> > --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=2261,
> > si_status=0, si_utime=0, si_stime=0} ---
> > rt_sigreturn()                          = 2261
> > read(3, "", 24)                         = 0
> >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> ouch thats me.. sry :-\
>
> the PERF_EVENT_STATE_EXIT check should not go to the
> read path.. could you please test attached patch?
>
> jirka
>
Works for me again now. Thanks for the quick fix. Please push it upstream.

Acked-by: Stephane Eranian <eranian@google.com>
>
>
> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d8cb4d2..6d1c9ce 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3600,8 +3600,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
>          * error state (i.e. because it was pinned but it couldn't be
>          * scheduled on to the CPU at some point).
>          */
> -       if ((event->state == PERF_EVENT_STATE_ERROR) ||
> -           (event->state == PERF_EVENT_STATE_EXIT))
> +       if (event->state == PERF_EVENT_STATE_ERROR)
>                 return 0;
>
>         if (count < event->read_size)
