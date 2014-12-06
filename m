Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaLFPSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:18:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47753 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752212AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 47/66] ARM: 8226/1: cacheflush: get rid of restarting block
Date: Sat,  6 Dec 2014 16:07:39 +0100
Message-Id: <932307a475b5c56786987a98472c8e6c5bb5cd78.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Murzin <vladimir.murzin@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3f4aa45ceea5789a4aade536acc27f2e0d3da5e1 upstream.

We cannot restart cacheflush safely if a process provides user-defined
signal handler and signal is pending. In this case -EINTR is returned
and it is expected that process re-invokes syscall. However, there are
a few problems with that:
 * looks like nobody bothers checking return value from cacheflush
 * but if it did, we don't provide the restart address for that, so the
   process has to use the same range again
 * ...and again, what might lead to looping forever

So, remove cacheflush restarting code and terminate cache flushing
as early as fatal signal is pending.

Reported-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/include/asm/thread_info.h | 11 -----------
 arch/arm/kernel/traps.c            | 31 ++-----------------------------
 2 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d64f2c..2b8114fcba09 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -43,16 +43,6 @@ struct cpu_context_save {
 	__u32	extra[2];		/* Xscale 'acc' register, etc */
 };
 
-struct arm_restart_block {
-	union {
-		/* For user cache flushing */
-		struct {
-			unsigned long start;
-			unsigned long end;
-		} cache;
-	};
-};
-
 /*
  * low level task data that entry.S needs immediate access to.
  * __switch_to() assumes cpu_context follows immediately after cpu_domain.
@@ -78,7 +68,6 @@ struct thread_info {
 	unsigned long		thumbee_state;	/* ThumbEE Handler Base register */
 #endif
 	struct restart_block	restart_block;
-	struct arm_restart_block	arm_restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)						\
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index a8dd111ff99a..8e6cd760cc68 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -503,8 +503,6 @@ static int bad_syscall(int n, struct pt_regs *regs)
 	return regs->ARM_r0;
 }
 
-static long do_cache_op_restart(struct restart_block *);
-
 static inline int
 __do_cache_op(unsigned long start, unsigned long end)
 {
@@ -513,24 +511,8 @@ __do_cache_op(unsigned long start, unsigned long end)
 	do {
 		unsigned long chunk = min(PAGE_SIZE, end - start);
 
-		if (signal_pending(current)) {
-			struct thread_info *ti = current_thread_info();
-
-			ti->restart_block = (struct restart_block) {
-				.fn	= do_cache_op_restart,
-			};
-
-			ti->arm_restart_block = (struct arm_restart_block) {
-				{
-					.cache = {
-						.start	= start,
-						.end	= end,
-					},
-				},
-			};
-
-			return -ERESTART_RESTARTBLOCK;
-		}
+		if (fatal_signal_pending(current))
+			return 0;
 
 		ret = flush_cache_user_range(start, start + chunk);
 		if (ret)
@@ -543,15 +525,6 @@ __do_cache_op(unsigned long start, unsigned long end)
 	return 0;
 }
 
-static long do_cache_op_restart(struct restart_block *unused)
-{
-	struct arm_restart_block *restart_block;
-
-	restart_block = &current_thread_info()->arm_restart_block;
-	return __do_cache_op(restart_block->cache.start,
-			     restart_block->cache.end);
-}
-
 static inline int
 do_cache_op(unsigned long start, unsigned long end, int flags)
 {
-- 
2.1.3

