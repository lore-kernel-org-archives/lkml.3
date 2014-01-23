Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaAWPnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:43:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAWPnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:43:35 -0500
Date: Thu, 23 Jan 2014 16:43:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123154312.GX30183@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
 <20140123135539.GF889@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123135539.GF889@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:55:39AM -0800, Kent Overstreet wrote:
> On Thu, Jan 23, 2014 at 02:50:03PM +0100, Peter Zijlstra wrote:
> > On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> > > pool->lock is also going to be fairly badly contended in the worst case,
> > > and that can get real bad real fast... now that I think about it we
> > > probably want to avoid the __alloc_global_tag() double call just because
> > > of that, pool->lock is going to be quite a bit more contended than the
> > > waitlist lock just because fo the amount of work done under it.
> > 
> > OK, how about this then.. Not quite at pretty though
> 
> Heh, I suppose that is a solution. Let me screw around to see what I can
> come up with tomorrow, but if I can't come up with anything I like I'm
> not opposed to this.

Please also consider the below patch.

---
Subject: percpu-ida: Reduce IRQ held duration

Its bad manners to hold IRQs disabled over a full cpumask iteration.
Change it so that it disables the IRQs only where strictly required to
avoid lock inversion issues.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -342,33 +342,31 @@ EXPORT_SYMBOL_GPL(__percpu_ida_init);
 int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
 	void *data)
 {
-	unsigned long flags;
 	struct percpu_ida_cpu *remote;
-	unsigned cpu, i, err = 0;
+	unsigned long flags;
+	int cpu, i, err = 0;
 
-	local_irq_save(flags);
 	for_each_possible_cpu(cpu) {
 		remote = per_cpu_ptr(pool->tag_cpu, cpu);
-		spin_lock(&remote->lock);
+		spin_lock_irqsave(&remote->lock, flags);
 		for (i = 0; i < remote->nr_free; i++) {
 			err = fn(remote->freelist[i], data);
 			if (err)
 				break;
 		}
-		spin_unlock(&remote->lock);
+		spin_unlock_irqrestore(&remote->lock, flags);
 		if (err)
-			goto out;
+			return err;
 	}
 
-	spin_lock(&pool->lock);
+	spin_lock_irqsave(&pool->lock, flags);
 	for (i = 0; i < pool->nr_free; i++) {
 		err = fn(pool->freelist[i], data);
 		if (err)
 			break;
 	}
-	spin_unlock(&pool->lock);
-out:
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(percpu_ida_for_each_free);
