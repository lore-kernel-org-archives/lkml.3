Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909AbaDIRcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933352AbaDIRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:32:48 -0400
Date: Wed, 9 Apr 2014 19:32:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
	for_each_thread()
Message-ID: <20140409173233.GA28615@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-2-git-send-email-fweisbec@gmail.com> <20140409171607.GA13498@dyad.arnhem.chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409171607.GA13498@dyad.arnhem.chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Peter Zijlstra wrote:
>
> On Wed, Apr 09, 2014 at 06:11:18PM +0200, Frederic Weisbecker wrote:
> > do_each_thread/while_each_thread iterators are deprecated by
> > for_each_thread/for_each_process_thread() APIs.
> >
> > Lets convert the callers in the cputime code accounting. The ultimate
> > goal is to remove the struct task_struct::thread_group field and
> > the corresponding do_each_thread/while_each_thread iterators that are
> > RCU unsafe.
> >
> > It also makes thread_group_cputime() eventually RCU-safe.
>
> this fails to explain how the current code is broken.

while_each_thread(g, t) will loop forever if g exits and removes itself
from ->thread_group. This can happen even if it is the group leader,
de_thread() can do this.

Another problem is that it is used wrongly very often, even if
while_each_thread() was fine people forget to check pid_alive() to ensure
it didn't exit even before we take rcu_read_lock().

for_each_thread(p, t) is always safe. Unless p's task_struct can't go away,
of course.

But there is a difference. Ignoring the bug above

	p = g;
	do {
		printk("pid=%d\n", p->pid);
	} while_each_thread(g, p);

always prints at least one pid.

	for_each_thread(g, p)
		printk("pid=%d\n", p->pid);

can print nothing if g has already exited.

Oleg.

