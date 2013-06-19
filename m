Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab3FSGrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:47:01 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54224 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab3FSGrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130604154426.GA2928@quad>
References: <20130604154426.GA2928@quad>
Date: Wed, 19 Jun 2013 08:46:59 +0200
Message-ID: <CABPqkBRQ1UM=zHR0oHzAQRo_wzFf3WoGa4-5k1XkDC3be8KBQA@mail.gmail.com>
Subject: Re: [PATCH] perf stat: avoid sending SIGTERM to random processes
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comment on this patch Arnaldo?


On Tue, Jun 4, 2013 at 5:44 PM, Stephane Eranian <eranian@google.com> wrote:
>
> This patch fixes a problem with perf stat whereby on termination
> it may send a SIGTERM signal to random processes on systems
> with high PID recycling. I got some actual bug reports on this.
>
> There is race between the SIGCHLD and sig_atexit() handlers.
> This patch addresses this problem by clearing child_pid in the
> SIGCHLD handler.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 7e910ba..95768af 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -87,7 +87,7 @@ static int                    run_count                       =  1;
>  static bool                    no_inherit                      = false;
>  static bool                    scale                           =  true;
>  static enum aggr_mode          aggr_mode                       = AGGR_GLOBAL;
> -static pid_t                   child_pid                       = -1;
> +static volatile pid_t          child_pid                       = -1;
>  static bool                    null_run                        =  false;
>  static int                     detailed_run                    =  0;
>  static bool                    big_num                         =  true;
> @@ -1148,13 +1148,34 @@ static void skip_signal(int signo)
>                 done = 1;
>
>         signr = signo;
> +       /*
> +        * render child_pid harmless
> +        * won't send SIGTERM to a random
> +        * process in case of race condition
> +        * and fast PID recycling
> +        */
> +       child_pid = -1;
>  }
>
>  static void sig_atexit(void)
>  {
> +       sigset_t set, oset;
> +
> +       /*
> +        * avoid race condition with SIGCHLD handler
> +        * in skip_signal() which is modifying child_pid
> +        * goal is to avoid send SIGTERM to a random
> +        * process
> +        */
> +       sigemptyset(&set);
> +       sigaddset(&set, SIGCHLD);
> +       sigprocmask(SIG_BLOCK, &set, &oset);
> +
>         if (child_pid != -1)
>                 kill(child_pid, SIGTERM);
>
> +       sigprocmask(SIG_SETMASK, &oset, NULL);
> +
>         if (signr == -1)
>                 return;
>
