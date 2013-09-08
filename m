Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab3IHEcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 00:32:45 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57749 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3IHEcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 00:32:43 -0400
X-Nat-Received: from [202.181.97.72]:59671 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378614744.16208
To: maarten.lankhorst@canonical.com
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, robdclark@gmail.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootable kernel.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
In-Reply-To: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp>
Message-Id: <201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 8 Sep 2013 13:32:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 08092013 #11006252, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I found what is wrong.

---------- bad patch start ----------
>From 3c56dfbd32a9b67ba824ce96128bb513eb65de4b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 8 Sep 2013 12:44:20 +0900
Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.

Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
"!__builtin_constant_p(p == NULL)" which I guess the author meant that
"__builtin_constant_p(p) && p", but gcc 3.x cannot handle such expression
correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@kernel.org> [3.11+]
---
 kernel/mutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a52ee7bb..0a6f14f 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
-			if (!__builtin_constant_p(ww_ctx == NULL)) {
+			if (__builtin_constant_p(ww_ctx) && ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -548,7 +548,7 @@ slowpath:
 			goto err;
 		}
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -568,7 +568,7 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
-	if (!__builtin_constant_p(ww_ctx == NULL)) {
+	if (__builtin_constant_p(ww_ctx) && ww_ctx) {
 		struct ww_mutex *ww = container_of(lock,
 						      struct ww_mutex,
 						      base);
-- 
1.7.8
---------- bad patch end ----------

However, after applying the patch above, I get problems (both gcc 3.x and 4.x)
with locking selftests.

---------- gcc version 3.3.5 start ----------
[    0.000000] Linux version 3.11.0-dirty (root@aqua) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #124 SMP Sun Sep 8 12:05:18 JST 2013
(...snipped...)
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at lib/locking-selftest.c:1143 ww_test_fail_acquire+0x112/0x2c0()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000477 00000000 c1577f18 c11e6736 c1577f24 c11e677d c11ffeb2 c1577f50
[    0.000000]  c1041af9 c14f5ea0 00000000 00000000 c15114fa 00000477 c11ffeb2 c1cd9360
[    0.000000]  00000000 00000001 c1577f60 c1041bbd 00000009 00000000 c1577f84 c11ffeb2
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c11ffeb2>] ? ww_test_fail_acquire+0x112/0x2c0
[    0.000000]  [<c1041af9>] warn_slowpath_common+0x79/0xa0
[    0.000000]  [<c11ffeb2>] ? ww_test_fail_acquire+0x112/0x2c0
[    0.000000]  [<c1041bbd>] warn_slowpath_null+0x1d/0x30
[    0.000000]  [<c11ffeb2>] ww_test_fail_acquire+0x112/0x2c0
[    0.000000]  [<c11ffce2>] ? dotest+0x42/0x100
[    0.000000]  [<c11ffda0>] ? dotest+0x100/0x100
[    0.000000]  [<c11ffce2>] dotest+0x42/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c12030b3>] ww_tests+0x53/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000] ---[ end trace 74d4202eb2b56266 ]---
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1577f78 c11e6736 c1577f84 c11e677d c1200480 c1577fac
[    0.000000]  c11ffd01 c151157d c1084f95 00000000 ffffffff 00000010 00000000 00020800
[    0.000000]  c1788800 c1577fbc c120311b c15115f7 c151160d c1577fd0 c1204e14 c1504b06
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c1200480>] ? ww_test_two_contexts+0x160/0x160
[    0.000000]  [<c11ffd01>] dotest+0x61/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c120311b>] ww_tests+0xbb/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000]
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1577f78 c11e6736 c1577f84 c11e677d c1200ba0 c1577fac
[    0.000000]  c11ffd01 c151157d c1084f95 00000000 ffffffff 00000010 00000000 00020800
[    0.000000]  c1788800 c1577fbc c1203180 c15115f7 c1511620 c1577fd0 c1204e14 c1504b06
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c1200ba0>] ? ww_test_context_fini_early+0x1e0/0x1e0
[    0.000000]  [<c11ffd01>] dotest+0x61/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c1203180>] ww_tests+0x120/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000]
[    0.000000]                locking mismatches:  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1577f78 c11e6736 c1577f84 c11e677d c1200d40 c1577fac
[    0.000000]  c11ffd01 c151157d c1084f95 00000000 ffffffff 00000010 00000000 00020800
[    0.000000]  c1788800 c1577fbc c12031c3 c15115f7 c1511635 c1577fd0 c1204e14 c1504b06
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c1200d40>] ? ww_test_object_unlock_twice+0x30/0x30
[    0.000000]  [<c11ffd01>] dotest+0x61/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c12031c3>] ww_tests+0x163/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000] FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1577f78 c11e6736 c1577f84 c11e677d c1200ea0 c1577fac
[    0.000000]  c11ffd01 c151157d c1084f95 00000000 ffffffff 00000010 00000000 00020800
[    0.000000]  c1788800 c1577fbc c12031d4 c15115f7 c1511635 c1577fd0 c1204e14 c1504b06
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c1200ea0>] ? ww_test_object_lock_unbalanced+0x160/0x160
[    0.000000]  [<c11ffd01>] dotest+0x61/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c12031d4>] ww_tests+0x174/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000]
[    0.000000]                  EDEADLK handling:
[    0.000000] BUG: scheduling while atomic: swapper/0/0/0x00000002
[    0.000000] 2 locks held by swapper/0/0:
[    0.000000]  #0:  (ww_lockdep_acquire){+.+...}, at: [<c11ffce2>] dotest+0x42/0x100
[    0.000000]  #1:  (ww_lockdep_mutex){+.+...}, at: [<c1201093>] ww_test_edeadlk_normal+0x103/0x210
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00200246 00000000 c1577e04 c11e6736 c1577e10 c11e677d c1581160 c1577e2c
[    0.000000]  c106cd05 c14f7440 c1581430 00000000 00000002 00000000 c1577efc c13c0a57
[    0.000000]  c17b56a8 00000001 c1581608 c1577e80 c109363e 00000000 c1577e78 c100470e
[    0.000000] Call Trace:
[    0.000000]  [<c11e6736>] __dump_stack+0x16/0x20
[    0.000000]  [<c11e677d>] dump_stack+0x3d/0x60
[    0.000000]  [<c106cd05>] __schedule_bug+0x75/0xa0
[    0.000000]  [<c13c0a57>] __schedule+0x67/0x790
[    0.000000]  [<c109363e>] ? validate_chain+0x49e/0x540
[    0.000000]  [<c100470e>] ? dump_trace+0x9e/0xd0
[    0.000000]  [<c1090ab9>] ? save_trace+0x39/0xa0
[    0.000000]  [<c109438a>] ? mark_held_locks+0xca/0x100
[    0.000000]  [<c13bfb2c>] ? __ww_mutex_lock+0x1cc/0x380
[    0.000000]  [<c10945ce>] ? trace_hardirqs_on_caller+0x14e/0x160
[    0.000000]  [<c13c11e5>] schedule+0x65/0x70
[    0.000000]  [<c13c1202>] schedule_preempt_disabled+0x12/0x20
[    0.000000]  [<c13bfb33>] __ww_mutex_lock+0x1d3/0x380
[    0.000000]  [<c12010e3>] ? ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c12010e3>] ? ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c12010e3>] ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c11ffce2>] ? dotest+0x42/0x100
[    0.000000]  [<c1200f90>] ? ww_test_object_lock_stale_context+0xf0/0xf0
[    0.000000]  [<c11ffce2>] dotest+0x42/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c1203209>] ww_tests+0x1a9/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 00000008
[    0.000000] IP: [<c11ebce3>] rb_next+0x3/0x60
[    0.000000] *pde = 00000000
[    0.000000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #124
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] task: c1581160 ti: c1576000 task.ti: c1576000
[    0.000000] EIP: 0060:[<c11ebce3>] EFLAGS: 00210002 CPU: 0
[    0.000000] EIP is at rb_next+0x3/0x60
[    0.000000] EAX: 00000008 EBX: dffed47c ECX: fffffff8 EDX: 00000008
[    0.000000] ESI: 00000000 EDI: c15813e0 EBP: c1577e04 ESP: c1577dfc
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] CR0: 8005003b CR2: 00000008 CR3: 01787000 CR4: 00000690
[    0.000000] Stack:
[    0.000000]  c1577e04 c1073ceb c1577e1c c10759a5 00000000 dffed420 dffed47c c15813e0
[    0.000000]  c1577e2c c1077937 dffed420 ffffffff c1577efc c13c0bf5 c17b56a8 00000001
[    0.000000]  c1581608 c1577e80 c109363e 00000000 c1577e78 c100470e c13c6f68 c1905be0
[    0.000000] Call Trace:
[    0.000000]  [<c1073ceb>] ? __pick_next_entity+0xb/0x20
[    0.000000]  [<c10759a5>] pick_next_entity+0x25/0xa0
[    0.000000]  [<c1077937>] pick_next_task_fair+0x27/0x40
[    0.000000]  [<c13c0bf5>] __schedule+0x205/0x790
[    0.000000]  [<c109363e>] ? validate_chain+0x49e/0x540
[    0.000000]  [<c100470e>] ? dump_trace+0x9e/0xd0
[    0.000000]  [<c1090ab9>] ? save_trace+0x39/0xa0
[    0.000000]  [<c109438a>] ? mark_held_locks+0xca/0x100
[    0.000000]  [<c13bfb2c>] ? __ww_mutex_lock+0x1cc/0x380
[    0.000000]  [<c10945ce>] ? trace_hardirqs_on_caller+0x14e/0x160
[    0.000000]  [<c13c11e5>] schedule+0x65/0x70
[    0.000000]  [<c13c1202>] schedule_preempt_disabled+0x12/0x20
[    0.000000]  [<c13bfb33>] __ww_mutex_lock+0x1d3/0x380
[    0.000000]  [<c12010e3>] ? ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c12010e3>] ? ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c12010e3>] ww_test_edeadlk_normal+0x153/0x210
[    0.000000]  [<c11ffce2>] ? dotest+0x42/0x100
[    0.000000]  [<c1200f90>] ? ww_test_object_lock_stale_context+0xf0/0xf0
[    0.000000]  [<c11ffce2>] dotest+0x42/0x100
[    0.000000]  [<c1084f95>] ? printk+0x35/0x40
[    0.000000]  [<c1203209>] ww_tests+0x1a9/0x410
[    0.000000]  [<c1204e14>] locking_selftest+0x19a4/0x1ab0
[    0.000000]  [<c15c2a0c>] start_kernel+0x1ec/0x2c0
[    0.000000]  [<c15c2480>] ? repair_env_string+0x70/0x70
[    0.000000]  [<c15c2275>] i386_start_kernel+0x25/0x30
[    0.000000] Code: d2 74 20 8b 42 04 85 c0 74 17 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 89 c2 8b 40 04 85 c0 75 f7 89 d0 5d c3 8d 76 00 55 89 c2 <8b> 08 31 c0 89 e5 39 d1 74 43 8b 42 04 85 c0 74 1c 89 c2 8b 40
[    0.000000] EIP: [<c11ebce3>] rb_next+0x3/0x60 SS:ESP 0068:c1577dfc
[    0.000000] CR2: 0000000000000008
[    0.000000] ---[ end trace 74d4202eb2b56267 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
---------- gcc version 3.3.5 end ----------

---------- gcc version 4.6.3 start ----------
[    0.000000] Linux version 3.11.0-dirty (root@aqua) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #125 SMP Sun Sep 8 12:13:43 JST 2013
(...snipped...)
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at lib/locking-selftest.c:1143 ww_test_fail_acquire+0xee/0x280()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505f2c c13938a3 c14a89d9 c1505f5c c103a47a c1492b9c
[    0.000000]  00000000 00000000 c14a89d9 00000477 c11e16de c11e16de c11e15f0 00000001
[    0.000000]  00000001 c1505f6c c103a4bd 00000009 00000000 c1505f84 c11e16de 00000000
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c103a47a>] warn_slowpath_common+0x7a/0xa0
[    0.000000]  [<c11e16de>] ? ww_test_fail_acquire+0xee/0x280
[    0.000000]  [<c11e16de>] ? ww_test_fail_acquire+0xee/0x280
[    0.000000]  [<c11e15f0>] ? ww_test_edeadlk_no_unlock_slow+0x270/0x270
[    0.000000]  [<c103a4bd>] warn_slowpath_null+0x1d/0x20
[    0.000000]  [<c11e16de>] ww_test_fail_acquire+0xee/0x280
[    0.000000]  [<c1393e84>] ? dotest+0x32/0xcf
[    0.000000]  [<c1393e84>] dotest+0x32/0xcf
[    0.000000]  [<c1393f67>] ww_tests+0x46/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000] ---[ end trace 614b89df0eea1b4a ]---
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505f84 c13938a3 c11e29a0 c1505fac c1393ea3 c14a89f0
[    0.000000]  00000000 c14a893c c1505fa8 00000010 c157e100 00020800 c1707800 c1505fb8
[    0.000000]  c1393fc4 c14a4e60 c1505fcc c11e464c c14a4e60 c1495b4c 00000780 c1505fec
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c11e29a0>] ? ww_test_try_context+0x110/0x110
[    0.000000]  [<c1393ea3>] dotest+0x51/0xcf
[    0.000000]  [<c1393fc4>] ww_tests+0xa3/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000]
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505f84 c13938a3 c11e0b70 c1505fac c1393ea3 c14a89f0
[    0.000000]  00000000 c14a893c c1505fa8 00000010 c157e100 00020800 c1707800 c1505fb8
[    0.000000]  c139401e c14a4e60 c1505fcc c11e464c c14a4e60 c1495b4c 00000780 c1505fec
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c11e0b70>] ? ww_test_context_fini_early+0x1c0/0x1c0
[    0.000000]  [<c1393ea3>] dotest+0x51/0xcf
[    0.000000]  [<c139401e>] ww_tests+0xfd/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000]
[    0.000000]                locking mismatches:  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505f84 c13938a3 c11e1870 c1505fac c1393ea3 c14a89f0
[    0.000000]  00000000 c14a893c c1505fa8 00000010 c157e100 00020800 c1707800 c1505fb8
[    0.000000]  c1394056 c14a4e60 c1505fcc c11e464c c14a4e60 c1495b4c 00000780 c1505fec
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c11e1870>] ? ww_test_fail_acquire+0x280/0x280
[    0.000000]  [<c1393ea3>] dotest+0x51/0xcf
[    0.000000]  [<c1394056>] ww_tests+0x135/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000] FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505f84 c13938a3 c11e2a80 c1505fac c1393ea3 c14a89f0
[    0.000000]  00000000 c14a893c c1505fa8 00000010 c157e100 00020800 c1707800 c1505fb8
[    0.000000]  c1394067 c14a4e60 c1505fcc c11e464c c14a4e60 c1495b4c 00000780 c1505fec
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c11e2a80>] ? ww_test_diff_class+0xe0/0xe0
[    0.000000]  [<c1393ea3>] dotest+0x51/0xcf
[    0.000000]  [<c1394067>] ww_tests+0x146/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000]
[    0.000000]                  EDEADLK handling:
[    0.000000] BUG: scheduling while atomic: swapper/0/0/0x00000002
[    0.000000] 2 locks held by swapper/0/0:
[    0.000000]  #0:  (ww_lockdep_acquire){+.+...}, at: [<c1393e84>] dotest+0x32/0xcf
[    0.000000]  #1:  (ww_lockdep_mutex){+.+...}, at: [<c11e0e51>] ww_test_edeadlk_normal+0x181/0x220
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505e6c c13938a3 c150e920 c1505e88 c138e482 c1493b04
[    0.000000]  c150ebf0 00000000 00000002 dffed440 c1505f10 c139a565 00000000 003c41e1
[    0.000000]  00000000 c150edc8 c1505eec c150e920 00000006 00000001 c16fe440 c16fe440
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c138e482>] __schedule_bug+0x5f/0x71
[    0.000000]  [<c139a565>] __schedule+0x65/0x5d0
[    0.000000]  [<c10896bf>] ? mark_held_locks+0xcf/0x100
[    0.000000]  [<c13994f5>] ? __ww_mutex_lock+0x1b5/0x370
[    0.000000]  [<c1089976>] ? trace_hardirqs_on_caller+0x146/0x170
[    0.000000]  [<c139ab9d>] schedule+0x4d/0x50
[    0.000000]  [<c139add3>] schedule_preempt_disabled+0x13/0x20
[    0.000000]  [<c1399505>] __ww_mutex_lock+0x1c5/0x370
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0cd0>] ? ww_test_context_lock_after_done+0x160/0x160
[    0.000000]  [<c11e0e77>] ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c1393e84>] ? dotest+0x32/0xcf
[    0.000000]  [<c1393e84>] dotest+0x32/0xcf
[    0.000000]  [<c1394091>] ww_tests+0x170/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1371 warn_pre_alternatives+0x22/0x30()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000]  00000000 00000000 c1505d38 c13938a3 c1484b96 c1505d68 c103a47a c1488bf8
[    0.000000]  c1505d94 00000000 c1484b96 0000055b c100f502 c100f502 c1505e20 00000008
[    0.000000]  c1032a90 c1505d80 c103a51e 00000009 c1505d78 c1488bf8 c1505d94 c1505d94
[    0.000000] Call Trace:
[    0.000000]  [<c13938a3>] dump_stack+0x4b/0x66
[    0.000000]  [<c103a47a>] warn_slowpath_common+0x7a/0xa0
[    0.000000]  [<c100f502>] ? warn_pre_alternatives+0x22/0x30
[    0.000000]  [<c100f502>] ? warn_pre_alternatives+0x22/0x30
[    0.000000]  [<c1032a90>] ? vmalloc_sync_all+0x120/0x120
[    0.000000]  [<c103a51e>] warn_slowpath_fmt+0x2e/0x30
[    0.000000]  [<c100f502>] warn_pre_alternatives+0x22/0x30
[    0.000000]  [<c1032655>] __do_page_fault+0xe5/0x400
[    0.000000]  [<c1088ee0>] ? validate_chain.isra.23+0x5d0/0x6c0
[    0.000000]  [<c106c5e0>] ? dequeue_entity+0x420/0x4f0
[    0.000000]  [<c1032a90>] ? vmalloc_sync_all+0x120/0x120
[    0.000000]  [<c1032a98>] do_page_fault+0x8/0x10
[    0.000000]  [<c139cb97>] error_code+0x5f/0x64
[    0.000000]  [<c1032a90>] ? vmalloc_sync_all+0x120/0x120
[    0.000000]  [<c11cc966>] ? rb_next+0x6/0x50
[    0.000000]  [<c106a0cd>] pick_next_entity+0x2d/0xb0
[    0.000000]  [<c106a16f>] pick_next_task_fair+0x1f/0x40
[    0.000000]  [<c139a725>] __schedule+0x225/0x5d0
[    0.000000]  [<c10896bf>] ? mark_held_locks+0xcf/0x100
[    0.000000]  [<c13994f5>] ? __ww_mutex_lock+0x1b5/0x370
[    0.000000]  [<c1089976>] ? trace_hardirqs_on_caller+0x146/0x170
[    0.000000]  [<c139ab9d>] schedule+0x4d/0x50
[    0.000000]  [<c139add3>] schedule_preempt_disabled+0x13/0x20
[    0.000000]  [<c1399505>] __ww_mutex_lock+0x1c5/0x370
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0cd0>] ? ww_test_context_lock_after_done+0x160/0x160
[    0.000000]  [<c11e0e77>] ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c1393e84>] ? dotest+0x32/0xcf
[    0.000000]  [<c1393e84>] dotest+0x32/0xcf
[    0.000000]  [<c1394091>] ww_tests+0x170/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000] ---[ end trace 614b89df0eea1b4b ]---
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at 00000008
[    0.000000] IP: [<c11cc966>] rb_next+0x6/0x50
[    0.000000] *pde = 00000000
[    0.000000] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.11.0-dirty #125
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] task: c150e920 ti: c1504000 task.ti: c1504000
[    0.000000] EIP: 0060:[<c11cc966>] EFLAGS: 00210046 CPU: 0
[    0.000000] EIP is at rb_next+0x6/0x50
[    0.000000] EAX: 00000008 EBX: dffed4a0 ECX: 00000000 EDX: fffffff8
[    0.000000] ESI: 00000000 EDI: 00000000 EBP: c1505e60 ESP: c1505e5c
[    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.000000] CR0: 8005003b CR2: 00000008 CR3: 01706000 CR4: 00000690
[    0.000000] Stack:
[    0.000000]  dffed4a0 c1505e78 c106a0cd 0112a880 00000000 dffed4a0 00000000 c1505e88
[    0.000000]  c106a16f dffed440 c150eba0 c1505f10 c139a725 00000000 003c41e1 00000000
[    0.000000]  c150edc8 c1505eec c150e920 00000006 00000001 c16fe440 c16fe440 c150e920
[    0.000000] Call Trace:
[    0.000000]  [<c106a0cd>] pick_next_entity+0x2d/0xb0
[    0.000000]  [<c106a16f>] pick_next_task_fair+0x1f/0x40
[    0.000000]  [<c139a725>] __schedule+0x225/0x5d0
[    0.000000]  [<c10896bf>] ? mark_held_locks+0xcf/0x100
[    0.000000]  [<c13994f5>] ? __ww_mutex_lock+0x1b5/0x370
[    0.000000]  [<c1089976>] ? trace_hardirqs_on_caller+0x146/0x170
[    0.000000]  [<c139ab9d>] schedule+0x4d/0x50
[    0.000000]  [<c139add3>] schedule_preempt_disabled+0x13/0x20
[    0.000000]  [<c1399505>] __ww_mutex_lock+0x1c5/0x370
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0e77>] ? ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c11e0cd0>] ? ww_test_context_lock_after_done+0x160/0x160
[    0.000000]  [<c11e0e77>] ww_test_edeadlk_normal+0x1a7/0x220
[    0.000000]  [<c1393e84>] ? dotest+0x32/0xcf
[    0.000000]  [<c1393e84>] dotest+0x32/0xcf
[    0.000000]  [<c1394091>] ww_tests+0x170/0x398
[    0.000000]  [<c11e464c>] locking_selftest+0x168c/0x1720
[    0.000000]  [<c154a939>] start_kernel+0x249/0x325
[    0.000000]  [<c154a52e>] ? obsolete_checksetup+0x95/0x95
[    0.000000]  [<c154a358>] i386_start_kernel+0x12e/0x131
[    0.000000] Code: 90 8d 74 26 00 55 8b 00 89 e5 85 c0 75 09 eb 0e 90 8d 74 26 00 89 d0 8b 50 04 85 d2 75 f7 5d c3 90 8d 74 26 00 55 31 c9 89 e5 53 <8b> 10 39 d0 74 3c 8b 48 04 85 c9 75 07 eb 13 8d 76 00 89 d1 8b
[    0.000000] EIP: [<c11cc966>] rb_next+0x6/0x50 SS:ESP 0068:c1505e5c
[    0.000000] CR2: 0000000000000008
[    0.000000] ---[ end trace 614b89df0eea1b4c ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
---------- gcc version 4.6.3 end ----------

The patch below can fix "boot failure on gcc 3.x" and avoid "locking selftests
failure on gcc 3.x / 4.x".

---------- good patch start ----------
>From 04a2739f00822a4ca59128501b1f3f5bf4981af7 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 8 Sep 2013 13:06:42 +0900
Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.

Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
"!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.

But changing from "!__builtin_constant_p(p == NULL)" to
"__builtin_constant_p(p) && p" causes locking selftest failures when built with
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y. Therefore, change from
"!__builtin_constant_p(p == NULL)" to "p".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@kernel.org> [3.11+]
---
 kernel/mutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index a52ee7bb..3b04d6a 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (ww_ctx && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
 
 			ww = container_of(lock, struct ww_mutex, base);
@@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
-			if (!__builtin_constant_p(ww_ctx == NULL)) {
+			if (ww_ctx) {
 				struct ww_mutex *ww;
 				ww = container_of(lock, struct ww_mutex, base);
 
@@ -548,7 +548,7 @@ slowpath:
 			goto err;
 		}
 
-		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+		if (ww_ctx && ww_ctx->acquired > 0) {
 			ret = __mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
@@ -568,7 +568,7 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
-	if (!__builtin_constant_p(ww_ctx == NULL)) {
+	if (ww_ctx) {
 		struct ww_mutex *ww = container_of(lock,
 						      struct ww_mutex,
 						      base);
-- 
1.7.8
---------- good patch end ----------

We need to give up __builtin_constant_p() optimization after all?
