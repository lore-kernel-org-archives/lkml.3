Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaFDMDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:03:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaFDMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:03:41 -0400
Date: Wed, 4 Jun 2014 14:03:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "riel@redhat.com" <riel@redhat.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: Fix migration_cpu_stop() return value
Message-ID: <20140604120338.GH13930@laptop.programming.kicks-ass.net>
References: <20140604104122.GL30445@twins.programming.kicks-ass.net>
 <5962011401880725@web26h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5962011401880725@web26h.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 03:18:45PM +0400, Kirill Tkhai wrote:
> Hi, Peter,
> 
> 04.06.2014, 14:41, "Peter Zijlstra" <peterz@infradead.org>:
> >  A while ago I did a similar patch for some debugging, but looking at it
> >  again today I realized we should probably fix this anyway.
> >
> >  ---
> >  Subject: sched: Fix migration_cpu_stop() return value
> >
> >  There are a number of migration_cpu_stop() users; and some actually care
> >  about the success of the migration. So report this.
> >
> >  In particular migrate_task_to() as used from task_numa_migrate()
> >  actually tests this return value.
> >
> >  Also change set_cpus_allowed_ptr() to propagate this return value, since
> >  it already returns other errors.
> >
> >  Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> >  Cc: Ingo Molnar <mingo@redhat.com>
> >  Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >  ---
> >   kernel/sched/core.c |   15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> (snipped everything because of bad email editor)
> 
> In set_cpus_allowed_ptr() p->on_rq branch can not fail.
> 
> We've changed affinity and released rq's lock, so task can migrate
> on allowed cpu only (even if migration_cpu_stop fails).
> 
> And it's a little ambiguously how user should react on this EAGAIN.

Try again? So one reason it might fail is because the task got migrated
in between the stop_cpu_call(migration_cpu_stop) call getting to
__migrate_task().

Esp. if you look at migrate_task_to() its fairly easy to fail this.
Currently it reports success, even though we completely failed to
migrate.

On -EAGAIN, re-evaluate the target and try again (later). Like for the
numa case, we'll try again on the next task_numa_migrate() call if its
still relevant.

