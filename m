Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab3CRAMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 20:12:41 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:37701 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3CRAMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303171544030.368@chino.kir.corp.google.com>
References: <20130315132607.GA4565@quad>
	<alpine.DEB.2.02.1303171544030.368@chino.kir.corp.google.com>
Date: Mon, 18 Mar 2013 01:12:37 +0100
Message-ID: <CABPqkBQZTUaRjA6NiVFw0hoOw_6Wu8kNjiCCNYXLZKOTt+ZbSw@mail.gmail.com>
Subject: Re: [patch for-] perf,x86: fix link failure for non-Intel configs
From: Stephane Eranian <eranian@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 11:49 PM, David Rientjes <rientjes@google.com> wrote:
> Commit 1d9d8639c063 ("perf,x86: fix kernel crash with PEBS/BTS after
> suspend/resume") introduces a link failure since
> perf_restore_debug_store() is only defined for CONFIG_CPU_SUP_INTEL:
>
>         arch/x86/power/built-in.o: In function `restore_processor_state':
>         (.text+0x45c): undefined reference to `perf_restore_debug_store'
>
> Fix it by defining the dummy function appropriately.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Yeah, missed that. Too bad we have to pull SUP_INTEL into
a generic header file. But the alternative would be to use a weak()
function in core.c which is not nicer, in my opinion.

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  include/linux/perf_event.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -758,7 +758,6 @@ extern void perf_event_enable(struct perf_event *event);
>  extern void perf_event_disable(struct perf_event *event);
>  extern int __perf_event_disable(void *info);
>  extern void perf_event_task_tick(void);
> -extern void perf_restore_debug_store(void);
>  #else
>  static inline void
>  perf_event_task_sched_in(struct task_struct *prev,
> @@ -798,6 +797,11 @@ static inline void perf_event_enable(struct perf_event *event)             { }
>  static inline void perf_event_disable(struct perf_event *event)                { }
>  static inline int __perf_event_disable(void *info)                     { return -1; }
>  static inline void perf_event_task_tick(void)                          { }
> +#endif
> +
> +#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
> +extern void perf_restore_debug_store(void);
> +#else
>  static inline void perf_restore_debug_store(void)                      { }
>  #endif
>
