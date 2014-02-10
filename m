Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBJPiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:38:04 -0500
Received: from hofr.at ([212.69.189.236]:43839 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbaBJPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:38:00 -0500
Date: Mon, 10 Feb 2014 16:37:59 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: [PATCH RT 2/5] allow preemption in alloc and free _buffer_head
Message-ID: <20140210153759.GC20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


allow preemption in alloc and free _buffer_head

fs/buffer.c:3339
void free_buffer_head(struct buffer_head *bh)
{
        BUG_ON(!list_empty(&bh->b_assoc_buffers));
        kmem_cache_free(bh_cachep, bh);
        preempt_disable();
        __this_cpu_dec(bh_accounting.nr);
        recalc_bh_state();
        preempt_enable();
}
migrate_disable here should do

Interleavings that could occure if preemption is allowed:

1) Simple interleaving: 
  T1 dec
           T2 dec
           T2 recalc
  T1 recalc

that would not be a problem the second recalc would not change anything it
would only set buffer_heads_over_limit again which is idempotent. If the
first recalc hit the ratelimit so will the second and equally if the first
did not hit the ratelimit.

2a) premption induced race in __this_cpu_dec
  T1 dec:start
               T2 dec
  T1 dec:end

__this_cpu_dec 
  -> __this_cpu_sub 
    -> __this_cpu_add
      -> __this_cpu_add_#
        -> __this_cpu_generic_to_op
         -> __this_cpu_ptr += val


so we end up with the possibilities of
  T1 load
          T2 load
          T2 store
  T1 store
and the increment provided by T2 would be lost. The result of which
is that reaching the buffer_heads_over_limit threshold in recalc_bh_state 
static void recalc_bh_state(void)
{
        int i;
        int tot = 0;

        if (__this_cpu_inc_return(bh_accounting.ratelimit) - 1 < 4096)
                return;
        __this_cpu_write(bh_accounting.ratelimit, 0);
        for_each_online_cpu(i)
                tot += per_cpu(bh_accounting, i).nr;
        buffer_heads_over_limit = (tot > max_buffer_heads);
}
would be reached a bit later - but given that this is a one-line race, and 
thus low probability - if it does happen it would not significantly impact 
reaching the buffer_heads_over_limit - as this is not a precise process
anyway (ratelimited) it should not have any functional impact.

2b) preemption induced race in recalc_bh_state
  T1 recalc:start
               T2 recalc
  T1 recalc:end
This case is not really a race as the only write operations are
to a local variable and ultimately to the buffer_heads_over_limit. The only
thing that could happen is that the buffer_heads_over_limit would remain
set if T1s recalc used and older, thus higher, bh_accounting.nr and sets the
buffer_heads_over_limit to 1 even though the second recalc had intermediately 
set it to 0. This would be fixed at the next recalc_bh_state execution.

The argument for alloc_buffer_head is along the same line - the potential
side-effects due to low-probability races seem negligable.

patch against 3.12.10-rt15

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 fs/buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 01eaa17..e2e4dd7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3327,10 +3327,10 @@ struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 	if (ret) {
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		buffer_head_init_locks(ret);
-		preempt_disable();
+		migrate_disable();
 		__this_cpu_inc(bh_accounting.nr);
 		recalc_bh_state();
-		preempt_enable();
+		migrate_enable();
 	}
 	return ret;
 }
@@ -3340,10 +3340,10 @@ void free_buffer_head(struct buffer_head *bh)
 {
 	BUG_ON(!list_empty(&bh->b_assoc_buffers));
 	kmem_cache_free(bh_cachep, bh);
-	preempt_disable();
+	migrate_disable();
 	__this_cpu_dec(bh_accounting.nr);
 	recalc_bh_state();
-	preempt_enable();
+	migrate_enable();
 }
 EXPORT_SYMBOL(free_buffer_head);
 
-- 
1.7.2.5

