Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3CRVLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:11:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46572 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab3CRVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130318210512.334023372@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
	<20130318210512.334023372@linuxfoundation.org>
Date: Mon, 18 Mar 2013 22:11:28 +0100
Message-ID: <CABPqkBQquwGc6S3Jfz1tgm2SZhA3pFuSC8xvAojLFk-6G3gqAA@mail.gmail.com>
Subject: Re: [ 29/75] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Stephane Eranian <eranian@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:06 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.
>
Greg, you also need to pick David Rientjes patch to fix compilation on
non X86 architectures.
Thanks.
> ------------------
>
> From: Stephane Eranian <eranian@google.com>
>
> commit 1d9d8639c063caf6efc2447f5f26aa637f844ff6 upstream.
>
> This patch fixes a kernel crash when using precise sampling (PEBS)
> after a suspend/resume. Turns out the CPU notifier code is not invoked
> on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
> by the kernel and keeps it power-on/resume value of 0 causing any PEBS
> measurement to crash when running on CPU0.
>
> The workaround is to add a hook in the actual resume code to restore
> the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
> the DS_AREA will be restored twice but this is harmless.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++++++
>  arch/x86/power/cpu.c                      |    2 ++
>  include/linux/perf_event.h                |    2 ++
>  3 files changed, 12 insertions(+)
>
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -729,3 +729,11 @@ void intel_ds_init(void)
>                 }
>         }
>  }
> +
> +void perf_restore_debug_store(void)
> +{
> +       if (!x86_pmu.bts && !x86_pmu.pebs)
> +               return;
> +
> +       init_debug_store_on_cpu(smp_processor_id());
> +}
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -11,6 +11,7 @@
>  #include <linux/suspend.h>
>  #include <linux/export.h>
>  #include <linux/smp.h>
> +#include <linux/perf_event.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/proto.h>
> @@ -228,6 +229,7 @@ static void __restore_processor_state(st
>         do_fpu_end();
>         x86_platform.restore_sched_clock_state();
>         mtrr_bp_restore();
> +       perf_restore_debug_store();
>  }
>
>  /* Needed by apm.c */
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -753,6 +753,7 @@ extern void perf_event_enable(struct per
>  extern void perf_event_disable(struct perf_event *event);
>  extern int __perf_event_disable(void *info);
>  extern void perf_event_task_tick(void);
> +extern void perf_restore_debug_store(void);
>  #else
>  static inline void
>  perf_event_task_sched_in(struct task_struct *prev,
> @@ -792,6 +793,7 @@ static inline void perf_event_enable(str
>  static inline void perf_event_disable(struct perf_event *event)                { }
>  static inline int __perf_event_disable(void *info)                     { return -1; }
>  static inline void perf_event_task_tick(void)                          { }
> +static inline void perf_restore_debug_store(void)                      { }
>  #endif
>
>  #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
>
>
