Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaE2RAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:00:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52102 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaE2RAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:00:31 -0400
Date: Thu, 29 May 2014 19:00:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140529170024.GA2315@laptop.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
 <20140514162943.GR30445@twins.programming.kicks-ass.net>
 <53739A9A.5010703@oracle.com>
 <20140514163535.GS30445@twins.programming.kicks-ass.net>
 <538676A7.6090306@oracle.com>
 <20140529075723.GA30445@twins.programming.kicks-ass.net>
 <5387486D.20108@oracle.com>
 <20140529150705.GJ19143@laptop.programming.kicks-ass.net>
 <538763E7.6030902@oracle.com>
 <20140529165057.GK19143@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529165057.GK19143@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:50:57PM +0200, Peter Zijlstra wrote:
> On Thu, May 29, 2014 at 12:44:23PM -0400, Sasha Levin wrote:
> > On 05/29/2014 11:07 AM, Peter Zijlstra wrote:
> > > On Thu, May 29, 2014 at 10:47:09AM -0400, Sasha Levin wrote:
> > >> It doesn't work out well because we later lock a mutex in sync_child_event().
> > >>
> > > 
> > > Urgh, right you are. I'll go stare at it more. It shouldn't have
> > > mattered, because the mutex we take just before should ensure existence,
> > > but.. you know.. :-)
> > > 
> > 
> > So the only caller to sync_child_event() is that loop. According to what you said
> > it should be safe to remove that mutex lock, but doing that triggers a list
> > corruption:
> > 
> > [ 1204.341887] WARNING: CPU: 20 PID: 12839 at lib/list_debug.c:62 __list_del_entry+0xa1/0xe0()
> > [ 1204.347597] list_del corruption. next->prev should be ffff8806ca68b108, but was ffff88051a67c398
> > [...]
> > 
> > I don't see how that would happen :/
> 
> No, what I said is that the mutex in perf_event_exit_task() should be
> sufficient to guard the list iteration calling __perf_event_exit_task().
> 
> Ading the RCU was a bit of paranoia.. 

Hmm, so can you try this..

While that mutex should guard the elements, it doesn't guard against the
use-after-free that's from list_for_each_entry_rcu().
__perf_event_exit_task() can actually free the event.

And because list addition/deletion is guarded by both ctx->mutex and
ctx->lock, holding ctx->mutex is sufficient for reading the list, so we
don't actually need the rcu list iteration.

---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 689237a0c5e8..2bb45d483325 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7432,7 +7432,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event;
+	struct perf_event *child_event, *next;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
@@ -7486,7 +7486,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
 
-	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
+	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
 	mutex_unlock(&child_ctx->mutex);
