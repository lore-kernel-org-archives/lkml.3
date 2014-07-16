Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaGPVOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:14:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:59752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaGPVEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:40 -0400
Message-Id: <20140716205055.055526806@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch V2 34/64] powerpc: cell: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=powerpc-cell-remove-silly-timespec-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ever recurring:
	ts = ktime_get_ts();
	ns = timespec_to_ns(&ts);
with
	ns = ktime_get_ns();

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/platforms/cell/spu_base.c      |   11 +++--------
 arch/powerpc/platforms/cell/spufs/context.c |    4 +---
 arch/powerpc/platforms/cell/spufs/file.c    |    4 +---
 arch/powerpc/platforms/cell/spufs/sched.c   |    4 +---
 4 files changed, 6 insertions(+), 17 deletions(-)

Index: tip/arch/powerpc/platforms/cell/spu_base.c
===================================================================
--- tip.orig/arch/powerpc/platforms/cell/spu_base.c
+++ tip/arch/powerpc/platforms/cell/spu_base.c
@@ -611,7 +611,6 @@ static int __init create_spu(void *data)
 	int ret;
 	static int number;
 	unsigned long flags;
-	struct timespec ts;
 
 	ret = -ENOMEM;
 	spu = kzalloc(sizeof (*spu), GFP_KERNEL);
@@ -652,8 +651,7 @@ static int __init create_spu(void *data)
 	mutex_unlock(&spu_full_list_mutex);
 
 	spu->stats.util_state = SPU_UTIL_IDLE_LOADED;
-	ktime_get_ts(&ts);
-	spu->stats.tstamp = timespec_to_ns(&ts);
+	spu->stats.tstamp = ktime_get_ns();
 
 	INIT_LIST_HEAD(&spu->aff_list);
 
@@ -676,7 +674,6 @@ static const char *spu_state_names[] = {
 static unsigned long long spu_acct_time(struct spu *spu,
 		enum spu_utilization_state state)
 {
-	struct timespec ts;
 	unsigned long long time = spu->stats.times[state];
 
 	/*
@@ -684,10 +681,8 @@ static unsigned long long spu_acct_time(
 	 * statistics are not updated.  Apply the time delta from the
 	 * last recorded state of the spu.
 	 */
-	if (spu->stats.util_state == state) {
-		ktime_get_ts(&ts);
-		time += timespec_to_ns(&ts) - spu->stats.tstamp;
-	}
+	if (spu->stats.util_state == state)
+		time += ktime_get_ns() - spu->stats.tstamp;
 
 	return time / NSEC_PER_MSEC;
 }
Index: tip/arch/powerpc/platforms/cell/spufs/context.c
===================================================================
--- tip.orig/arch/powerpc/platforms/cell/spufs/context.c
+++ tip/arch/powerpc/platforms/cell/spufs/context.c
@@ -36,7 +36,6 @@ atomic_t nr_spu_contexts = ATOMIC_INIT(0
 struct spu_context *alloc_spu_context(struct spu_gang *gang)
 {
 	struct spu_context *ctx;
-	struct timespec ts;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -67,8 +66,7 @@ struct spu_context *alloc_spu_context(st
 	__spu_update_sched_info(ctx);
 	spu_set_timeslice(ctx);
 	ctx->stats.util_state = SPU_UTIL_IDLE_LOADED;
-	ktime_get_ts(&ts);
-	ctx->stats.tstamp = timespec_to_ns(&ts);
+	ctx->stats.tstamp = ktime_get_ns();
 
 	atomic_inc(&nr_spu_contexts);
 	goto out;
Index: tip/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- tip.orig/arch/powerpc/platforms/cell/spufs/file.c
+++ tip/arch/powerpc/platforms/cell/spufs/file.c
@@ -2338,7 +2338,6 @@ static const char *ctx_state_names[] = {
 static unsigned long long spufs_acct_time(struct spu_context *ctx,
 		enum spu_utilization_state state)
 {
-	struct timespec ts;
 	unsigned long long time = ctx->stats.times[state];
 
 	/*
@@ -2351,8 +2350,7 @@ static unsigned long long spufs_acct_tim
 	 * of the spu context.
 	 */
 	if (ctx->spu && ctx->stats.util_state == state) {
-		ktime_get_ts(&ts);
-		time += timespec_to_ns(&ts) - ctx->stats.tstamp;
+		time += ktime_get_ns() - ctx->stats.tstamp;
 	}
 
 	return time / NSEC_PER_MSEC;
Index: tip/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- tip.orig/arch/powerpc/platforms/cell/spufs/sched.c
+++ tip/arch/powerpc/platforms/cell/spufs/sched.c
@@ -1039,13 +1039,11 @@ void spuctx_switch_state(struct spu_cont
 {
 	unsigned long long curtime;
 	signed long long delta;
-	struct timespec ts;
 	struct spu *spu;
 	enum spu_utilization_state old_state;
 	int node;
 
-	ktime_get_ts(&ts);
-	curtime = timespec_to_ns(&ts);
+	curtime = ktime_get_ns();
 	delta = curtime - ctx->stats.tstamp;
 
 	WARN_ON(!mutex_is_locked(&ctx->state_mutex));


