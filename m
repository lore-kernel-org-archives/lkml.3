Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3EJNYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:24:42 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:59078 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3EJNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:24:41 -0400
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
Date: Fri, 10 May 2013 09:24:40 -0400
Message-ID: <CA+5PVA47O+chNZ6fFHMMK+kkqzzYZaXKOXZoZmdX9TSg19dc+w@mail.gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
From: Josh Boyer <jwboyer@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 2:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 3 May 2013, Dave Jones wrote:
>> On Fri, May 03, 2013 at 12:49:20AM +0200, Thomas Gleixner wrote:
>>
>>  > I'm fundamentally confused and Daves observation about slub debug does
>>  > not make it less confusing.
>>  >
>>  > It'd be nice if you could add some more instrumentation or bisect the
>>  > issue.
>>
>> Here's what I ended up with..
>> b352bc1cbc29134a356b5c16ee2281807a7b984e is the first bad commit
>> commit b352bc1cbc29134a356b5c16ee2281807a7b984e
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Tue Mar 5 14:25:32 2013 +0100
>>
>>     tick: Convert broadcast cpu bitmaps to cpumask_var_t
>>
>>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>     Link: http://lkml.kernel.org/r/20130306111537.366394000@linutronix.de
>>     Cc: Rusty Russell <rusty@rustcorp.com.au>
>>
>
> I bet you have CONFIG_CPUMASK_OFFSTACK enabled.
>
> /me is a moron and rumages for a brown paperbag.
>
> Patch below.
>
> Thanks,
>
>         tglx
>
> ------------>
>
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

This still isn't in Linus' tree and it fixes boot issues on a number
of different machine types.  Is it queued up anywhere?  Hoping it gets
into 3.10-rc1.

josh

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
