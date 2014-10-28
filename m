Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbaJ1FYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:24:42 -0400
Received: from relay.parallels.com ([195.214.232.42]:47912 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbaJ1FYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:24:40 -0400
Message-ID: <1414473874.8574.2.camel@tkhai>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Tue, 28 Oct 2014 08:24:34 +0300
In-Reply-To: <20141027230427.GA18454@redhat.com>
References: <1414405105.19914.169.camel@tkhai>
	 <20141027230427.GA18454@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 28/10/2014 в 00:04 +0100, Oleg Nesterov пишет:
> On 10/27, Kirill Tkhai wrote:
> >
> > +static void cpu_cgroup_fork(struct task_struct *task)
> > +{
> > +	sched_move_task(task);
> > +}
> > +
> >  static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
> >  				 struct cgroup_taskset *tset)
> >  {
> > @@ -8205,6 +8210,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
> >  	.css_free	= cpu_cgroup_css_free,
> >  	.css_online	= cpu_cgroup_css_online,
> >  	.css_offline	= cpu_cgroup_css_offline,
> > +	.fork		= cpu_cgroup_fork,
> 
> Agreed, but it seems that sched_move_task() -> task_css_check() can
> complain if CONFIG_PROVE_RCU...

Thanks, Oleg.

> 
> cpu_cgroup_exit() too calls sched_move_task() without any lock, but
> there is the PF_EXITING check and init_css_set can't go away.
> 
> perhaps sched_move_task() should just take rcu_read_lock() and use
> task_css() ? This lockdep_is_held(siglock) looks ugly, and iiuc we
> need it to shut up the warning if autogroup_move_group() is the caller.

Shouldn't we do that in separate patch? How about this?

[PATCH]sched: Remove lockdep check in sched_move_task()

sched_move_task() is the only interface to change sched_task_group:
cpu_cgrp_subsys methods and autogroup_move_group() use it.

Everything is synchronized by task_rq_lock(), so cpu_cgroup_attach()
is ordered with other users of sched_move_task(). This means we do
no need RCU here: if we've dereferenced a tg here, the .attach method
hasn't been called for it yet.

Thus, we should pass "true" to task_css_check() to silence lockdep
warnings.
    
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dde8adb..d77e6ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7403,8 +7403,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		put_prev_task(rq, tsk);
 
-	tg = container_of(task_css_check(tsk, cpu_cgrp_id,
-				lockdep_is_held(&tsk->sighand->siglock)),
+	/*
+	 * All callers are synchronized by task_rq_lock(); we do not use RCU
+	 * which is pointless here. Thus, we pass "true" to task_css_check()
+	 * to prevent lockdep warnings.
+	 */
+	tg = container_of(task_css_check(tsk, cpu_cgrp_id, true),
 			  struct task_group, css);
 	tg = autogroup_task_group(tsk, tg);
 	tsk->sched_task_group = tg;


