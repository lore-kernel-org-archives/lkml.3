Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaJ2JQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:16:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41089 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbaJ2JQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:16:46 -0400
Date: Wed, 29 Oct 2014 10:16:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20141029091640.GW3337@twins.programming.kicks-ass.net>
References: <1414405105.19914.169.camel@tkhai>
 <20141027230427.GA18454@redhat.com>
 <1414473874.8574.2.camel@tkhai>
 <20141028225250.GA8519@redhat.com>
 <54505D10.7050809@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54505D10.7050809@yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 06:20:48AM +0300, Kirill Tkhai wrote:
> > And cgroup_task_migrate() can free ->cgroups via call_rcu(). Of course,
> > in practice raw_spin_lock_irq() should also act as rcu_read_lock(), but
> > we should not rely on implementation details.
> 
> Do you mean cgroup_task_migrate()->put_css_set_locked()? It's not
> possible there, because old_cset->refcount is lager than 1. We increment
> it in cgroup_migrate_add_src() and real freeing happens in
> cgroup_migrate_finish(). These functions are around task_migrate(), they
> are pair brackets.
> 
> > task_group = tsk->cgroups[cpu_cgrp_id] can't go away because yes, if we
> > race with migrate then ->attach() was not called. But it seems that in
> > theory it is not safe to dereference tsk->cgroups.
> 
> old_cset can't be freed in cgroup_task_migrate(), so we can safely
> dereference it. If we've got old_cset in
> cgroup_post_fork()->sched_move_task(), the right sched_task_group will
> be installed by attach->sched_move_task().


Would it be fair to summarise your argument thusly:

 "Because sched_move_task() is only called from cgroup_subsys methods
  the cgroup infrastructure itself holds reference on the relevant
  css sets, and therefore their existence is guaranteed."

?

The question then would be how do we guarantee/assert the assumption
that sched_move_task() is indeed only ever called from such a method.
