Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaJ0WIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaJ0WIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:08:13 -0400
Date: Tue, 28 Oct 2014 00:04:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20141027230427.GA18454@redhat.com>
References: <1414405105.19914.169.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414405105.19914.169.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27, Kirill Tkhai wrote:
>
> +static void cpu_cgroup_fork(struct task_struct *task)
> +{
> +	sched_move_task(task);
> +}
> +
>  static int cpu_cgroup_can_attach(struct cgroup_subsys_state *css,
>  				 struct cgroup_taskset *tset)
>  {
> @@ -8205,6 +8210,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
>  	.css_free	= cpu_cgroup_css_free,
>  	.css_online	= cpu_cgroup_css_online,
>  	.css_offline	= cpu_cgroup_css_offline,
> +	.fork		= cpu_cgroup_fork,

Agreed, but it seems that sched_move_task() -> task_css_check() can
complain if CONFIG_PROVE_RCU...

cpu_cgroup_exit() too calls sched_move_task() without any lock, but
there is the PF_EXITING check and init_css_set can't go away.

perhaps sched_move_task() should just take rcu_read_lock() and use
task_css() ? This lockdep_is_held(siglock) looks ugly, and iiuc we
need it to shut up the warning if autogroup_move_group() is the caller.

Oleg.

