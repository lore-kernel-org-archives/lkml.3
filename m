Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbaITUJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 16:09:16 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:39499 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaITUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 16:09:14 -0400
X-Yandex-Uniq: 963c6c6c-6eb8-4535-a3a7-238cc5ea81bb
Authentication-Results: smtp4o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1411243745.3396.7.camel@localhost.localdomain>
Subject: Re: [PATCH 2/7] sched: Fix picking a task switching on other cpu
 (__ARCH_WANT_UNLOCKED_CTXSW)
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>, ralf@linux-mips.org
Date: Sun, 21 Sep 2014 00:09:05 +0400
In-Reply-To: <20140920185434.GE3037@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
	 <20140920165122.16299.31150.stgit@localhost>
	 <20140920183326.GT2832@worktop.localdomain>
	 <20140920185434.GE3037@worktop.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Сб, 20/09/2014 в 20:54 +0200, Peter Zijlstra пишет:
> On Sat, Sep 20, 2014 at 08:33:26PM +0200, Peter Zijlstra wrote:
> > On Sat, Sep 20, 2014 at 08:51:22PM +0400, Kirill Tkhai wrote:
> > > From: Kirill Tkhai <ktkhai@parallels.com>
> > > 
> > > We may pick a task which is in context_switch() on other cpu at the moment.
> > > Parallel using of a single stack by two processes is not a good idea.
> > 
> > Please elaborate on who exactly that might happen. Its best to have
> > comprehensive changelogs for issues that fix races.
> 
> FWIW IIRC we can remove UNLOCKED_CTXSW from IA64 and I forgot if I
> audited MIPS, but I suspect we can (and should) remove it there too.
> 
> That would make this exception go away and clean up some of this ugly.

Yeah, you've said me about IA64:

http://www.spinics.net/lists/linux-ia64/msg10229.html

It's about 10 years since the logic, which was documented in ia64
header, has been removed. It looks like, ia64 maintainers are not
interested much...

***

To do not to start a new message. I've found the above when I was
analysing if the optimisation below is OK (assume, we have accessor
cpu_relax__while_on_cpu()):

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7d0d023..8d765ba 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1699,8 +1699,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		goto stat;
 
 #ifdef CONFIG_SMP
-	cpu_relax__while_on_cpu(p);
-
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
@@ -1708,6 +1706,9 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, p->wake_cpu, SD_BALANCE_WAKE, wake_flags);
+
+	cpu_relax__while_on_cpu(p);
+
 	if (task_cpu(p) != cpu) {
 		wake_flags |= WF_MIGRATED;
 		set_task_cpu(p, cpu);

Looks like, now problem here. Task p is dequeued, we can set sched_contributes_to_load and state
here, also task_waking does not produce problems, only arithmetics is there. select_task_rq()
is R/O function.

Now I'm testing this.

