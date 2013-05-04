Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3EDFDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 01:03:13 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:47961 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3EDFDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 01:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1305032015060.2990@ionos>
References: <20130430212007.GB18598@redhat.com>
	<20130430213719.GA14988@redhat.com>
	<alpine.LFD.2.02.1305021234510.3972@ionos>
	<20130502154621.GA23990@redhat.com>
	<alpine.LFD.2.02.1305022152280.2891@ionos>
	<CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
	<alpine.LFD.2.02.1305022304370.2891@ionos>
	<CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
	<alpine.LFD.2.02.1305022337470.2891@ionos>
	<20130503144912.GB1283@redhat.com>
	<alpine.LFD.2.02.1305032015060.2990@ionos>
Date: Fri, 3 May 2013 22:03:11 -0700
X-Google-Sender-Auth: FcX5Numq991sQUyLJP2FK_EhFSs
Message-ID: <CAE9FiQUHETMqN2jxaSGV8Rq6_pdnCiFXhJydh3xPmCV3S5Bb7w@mail.gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 11:32 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Subject: tick: Use zalloc_cpumask_var for allocating offstack cpumasks
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 03 May 2013 20:22:36 +0200
>
> commit b352bc1cbc (tick: Convert broadcast cpu bitmaps to
> cpumask_var_t) broke CONFIG_CPUMASK_OFFSTACK in a very subtle way.
>
> Instead of allocating the cpumasks with zalloc_cpumask_var it uses
> alloc_cpumask_var, so we can get random data there, which of course
> confuses the logic completely and causes random failures.
>
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/tick-broadcast.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/kernel/time/tick-broadcast.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/tick-broadcast.c
> +++ linux-2.6/kernel/time/tick-broadcast.c
> @@ -785,11 +785,11 @@ bool tick_broadcast_oneshot_available(vo
>
>  void __init tick_broadcast_init(void)
>  {
> -       alloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
> -       alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
> +       zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
> +       zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
>  #ifdef CONFIG_TICK_ONESHOT
> -       alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
> -       alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
> -       alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
> +       zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
> +       zalloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
> +       zalloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
>  #endif
>  }

Yes, it works on Nehalem-EX 8 socket system now.

Tested-by: Yinghai Lu <yinghai@kernel.org>
