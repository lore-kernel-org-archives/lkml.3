Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3CEIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:34:00 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57923 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3CEId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:33:58 -0500
MIME-Version: 1.0
In-Reply-To: <513568A0.6020804@huawei.com>
References: <513568A0.6020804@huawei.com>
Date: Tue, 5 Mar 2013 09:33:57 +0100
Message-ID: <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 4:38 AM, Li Zefan <lizefan@huawei.com> wrote:
> Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
> and then we can remove include of cgroup.h.
>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  include/linux/perf_event.h | 18 +-----------------
>  kernel/events/core.c       | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index e47ee46..8737e1c 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -21,7 +21,6 @@
>   */
>
>  #ifdef CONFIG_PERF_EVENTS
> -# include <linux/cgroup.h>
>  # include <asm/perf_event.h>
>  # include <asm/local64.h>
>  #endif
> @@ -299,22 +298,7 @@ struct swevent_hlist {
>  #define PERF_ATTACH_GROUP      0x02
>  #define PERF_ATTACH_TASK       0x04
>
> -#ifdef CONFIG_CGROUP_PERF
> -/*
> - * perf_cgroup_info keeps track of time_enabled for a cgroup.
> - * This is a per-cpu dynamically allocated data structure.
> - */
> -struct perf_cgroup_info {
> -       u64                             time;
> -       u64                             timestamp;
> -};
> -
> -struct perf_cgroup {
> -       struct                          cgroup_subsys_state css;
> -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
> -};
> -#endif
> -
> +struct perf_cgroup;

The problem is that you have struct perf_cgroup in the struct perf_event
structure. Today, this field is not referenced outside of kernel/events/core.c
But it is available outside this file. If someday the field is reference, your
changes will have to do reverted. So I am wondering what is the point
of the change right now?


>  struct ring_buffer;
>
>  /**
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b0cd865..5976a2a 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -37,6 +37,7 @@
>  #include <linux/ftrace_event.h>
>  #include <linux/hw_breakpoint.h>
>  #include <linux/mm_types.h>
> +#include <linux/cgroup.h>
>
>  #include "internal.h"
>
> @@ -234,6 +235,20 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
>  #ifdef CONFIG_CGROUP_PERF
>
>  /*
> + * perf_cgroup_info keeps track of time_enabled for a cgroup.
> + * This is a per-cpu dynamically allocated data structure.
> + */
> +struct perf_cgroup_info {
> +       u64                             time;
> +       u64                             timestamp;
> +};
> +
> +struct perf_cgroup {
> +       struct cgroup_subsys_state      css;
> +       struct perf_cgroup_info         *info;
> +};
> +
> +/*
>   * Must ensure cgroup is pinned (css_get) before calling
>   * this function. In other words, we cannot call this function
>   * if there is no cgroup event for the current CPU context.
> --
> 1.8.0.2
>
