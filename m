Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaJ0JvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:51:02 -0400
Received: from forward17.mail.yandex.net ([95.108.253.142]:44070 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaJ0Jte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:34 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>,
        Burke Libbey <burke.libbey@shopify.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
In-Reply-To: <164441414171122@web11g.yandex.ru>
References: <20141024150746.GB25260@burke.local> <20141024155805.GF21513@worktop.programming.kicks-ass.net> <164441414171122@web11g.yandex.ru>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
MIME-Version: 1.0
Message-Id: <1501441414403369@web28g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 27 Oct 2014 12:49:29 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've dived into this and found, we are really need this.
I'll send a patch with description soon.

24.10.2014, 22:19, "Kirill Tkhai" <tkhai@yandex.ru>:
> 24.10.2014, 19:58, "Peter Zijlstra" <peterz@infradead.org>:
>> šOn Fri, Oct 24, 2014 at 11:07:46AM -0400, Burke Libbey wrote:
>>> ššFrom 2014-02-15: https://lkml.org/lkml/2014/2/15/217
>>>
>>> ššThis issue was reported and patched, but it still occurs in some situations on
>>> ššnewer kernel versions.
>>>
>>> šš[2249353.328452] BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
>>> šš[2249353.336528] IP: [<ffffffff810b1cf7>] check_preempt_wakeup+0xe7/0x210
>>>
>>> ššse.parent gets out of sync with se.depth, causing a panic when the algorithm in
>>> ššfind_matching_se assumes they are correct. This patch forces se.depth to be
>>> ššupdated every time se.parent is, so they can no longer become desync'd.
>>>
>>> ššCC: Ingo Molnar <mingo@kernel.org>
>>> ššCC: Peter Zijlstra <peterz@infradead.org>
>>> ššSigned-off-by: Burke Libbey <burke.libbey@shopify.com>
>>> šš---
>>>
>>> ššI haven't been able to isolate the problem. Though I'm pretty confident this
>>> ššfixes the issue I've been having, I have not been able to prove it.
>> šSo this isn't correct, switching rq should not change depth. I suspect
>> šyou're just papering over the issue by frequently resetting the value,
>> šwhich simply narrows the race window.
>
> Just a hypothesis.
>
> I was seeking a places where task_group of a task may change. I can't understand
> how changing of parent's cgroup during fork() applies to a child.
>
> Child's cgroup is the same as parent's after dup_task_struct(). The only function
> changing task_group is sched_move_task(), but we do not call it between
> dup_task_struct() and wake_up_new_task(). Shouldn't we do something like this?
>
> (compile tested only)
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index cc18694..0ccbbdb 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7833,6 +7833,11 @@ static void cpu_cgroup_css_offline(struct cgroup_subsys_state *css)
> šššššššššsched_offline_group(tg);
> š}
>
> +static void cpu_cgroup_fork(struct task_struct *task)
> +{
> + sched_move_task(task);
> +}
> +
> šstatic int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
> ššššššššššššššššššššššššššššššššššstruct cgroup_taskset *tset)
> š{
> @@ -8205,6 +8210,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
> ššššššššš.css_free = cpu_cgroup_css_free,
> ššššššššš.css_online = cpu_cgroup_css_online,
> ššššššššš.css_offline = cpu_cgroup_css_offline,
> + .fork = cpu_cgroup_fork,
> ššššššššš.can_attach = cpu_cgroup_can_attach,
> ššššššššš.attach = cpu_cgroup_attach,
> ššššššššš.exit = cpu_cgroup_exit,
>
> Or we just should set tsk->sched_task_group?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
