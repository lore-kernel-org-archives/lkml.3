Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaGGNpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:45:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43061 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaGGNpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:45:38 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, steve.capper@linaro.org,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] ARM: perf: disable the pagefault handler when reading from user space
Date: Mon,  7 Jul 2014 15:45:09 +0200
Message-Id: <1404740710-14691-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404740710-14691-1-git-send-email-jean.pihet@linaro.org>
References: <1404740710-14691-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under perf, the fp unwinding scheme requires access to user space memory
and can provoke a pagefault via call to __copy_from_user_inatomic from
user_backtrace. This unwinding can take place in response to an interrupt
(__perf_event_overflow). This is undesirable as we may already have
mmap_sem held for write. One example being a process that calls mprotect
just as a the PMU counters overflow.

An example that can provoke this behaviour:
perf record -e event:tocapture --call-graph fp ./application_to_test

This patch addresses this issue by disabling pagefaults briefly in
user_backtrace (as is done in the other architectures: ARM64, x86, Sparc etc.).

Without the patch a deadlock occurs when __perf_event_overflow is called
while reading the data from the user space:

 [ INFO: possible recursive locking detected ]
 3.16.0-rc2-00038-g0ed7ff6 #46 Not tainted
 ---------------------------------------------
 stress/1634 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c001dc04>] do_page_fault+0xa8/0x428

 but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c00f4098>] SyS_mprotect+0xa8/0x1c8

 other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&mm->mmap_sem);
  lock(&mm->mmap_sem);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

 2 locks held by stress/1634:
 #0:  (&mm->mmap_sem){++++++}, at: [<c00f4098>] SyS_mprotect+0xa8/0x1c8
 #1:  (rcu_read_lock){......}, at: [<c00c29dc>] __perf_event_overflow+0x120/0x294

 stack backtrace:
 CPU: 1 PID: 1634 Comm: stress Not tainted 3.16.0-rc2-00038-g0ed7ff6 #46
 [<c0017c8c>] (unwind_backtrace) from [<c0012eec>] (show_stack+0x20/0x24)
 [<c0012eec>] (show_stack) from [<c04de914>] (dump_stack+0x7c/0x98)
 [<c04de914>] (dump_stack) from [<c006a360>] (__lock_acquire+0x1484/0x1cf0)
 [<c006a360>] (__lock_acquire) from [<c006b14c>] (lock_acquire+0xa4/0x11c)
 [<c006b14c>] (lock_acquire) from [<c04e3880>] (down_read+0x40/0x7c)
 [<c04e3880>] (down_read) from [<c001dc04>] (do_page_fault+0xa8/0x428)
 [<c001dc04>] (do_page_fault) from [<c00084ec>] (do_DataAbort+0x44/0xa8)
 [<c00084ec>] (do_DataAbort) from [<c0013a1c>] (__dabt_svc+0x3c/0x60)
 Exception stack(0xed7c5ae0 to 0xed7c5b28)
 5ae0: ed7c5b5c b6dadff4 ffffffec 00000000 b6dadff4 ebc08000 00000000 ebc08000
 5b00: 0000007e 00000000 ed7c4000 ed7c5b94 00000014 ed7c5b2c c001a438 c0236c60
 5b20: 00000013 ffffffff
 [<c0013a1c>] (__dabt_svc) from [<c0236c60>] (__copy_from_user+0xa4/0x3a4)

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Steve Capper <steve.capper@linaro.org>
---
 arch/arm/kernel/perf_event.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 6493c4c..f5aeca2 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -560,11 +560,16 @@ user_backtrace(struct frame_tail __user *tail,
 	       struct perf_callchain_entry *entry)
 {
 	struct frame_tail buftail;
+	unsigned long err;
 
-	/* Also check accessibility of one struct frame_tail beyond */
 	if (!access_ok(VERIFY_READ, tail, sizeof(buftail)))
 		return NULL;
-	if (__copy_from_user_inatomic(&buftail, tail, sizeof(buftail)))
+
+	pagefault_disable();
+	err = __copy_from_user_inatomic(&buftail, tail, sizeof(buftail));
+	pagefault_enable();
+
+	if (err)
 		return NULL;
 
 	perf_callchain_store(entry, buftail.lr);
-- 
1.8.1.2

