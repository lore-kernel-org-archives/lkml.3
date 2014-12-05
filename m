Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaLEW6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:58:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaLEW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 48/73] ARM: 8226/1: cacheflush: get rid of restarting block
Date: Fri,  5 Dec 2014 14:44:54 -0800
Message-Id: <20141205224435.377906459@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/thread_info.h |   11 -----------
 arch/arm/kernel/traps.c            |   31 ++-----------------------------
 2 files changed, 2 insertions(+), 40 deletions(-)

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
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -510,8 +510,6 @@ static int bad_syscall(int n, struct pt_
 	return regs->ARM_r0;
 }
 
-static long do_cache_op_restart(struct restart_block *);
-
 static inline int
 __do_cache_op(unsigned long start, unsigned long end)
 {
@@ -520,24 +518,8 @@ __do_cache_op(unsigned long start, unsig
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
@@ -550,15 +532,6 @@ __do_cache_op(unsigned long start, unsig
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


