Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaDEO0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 10:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaDEO0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 10:26:40 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: fix !CONFIG_COMPAT build failures
Date: Sat,  5 Apr 2014 10:25:49 -0400
Message-Id: <1396707949-397-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent arm64 builds using CONFIG_ARM64_64K_PAGES are failing with:

  arch/arm64/kernel/perf_regs.c: In function ‘perf_reg_abi’:
  arch/arm64/kernel/perf_regs.c:41:2: error: implicit declaration of function ‘is_compat_thread’

  arch/arm64/kernel/perf_event.c:1398:2: error: unknown type name ‘compat_uptr_t’

This is due to some recent arm64 perf commits with compat support:

  commit 23c7d70d55c6d9:
    ARM64: perf: add support for frame pointer unwinding in compat mode

  commit 2ee0d7fd36a3f8:
    ARM64: perf: add support for perf registers API

Those patches make the arm64 kernel unbuildable if CONFIG_COMPAT is not
defined and CONFIG_ARM64_64K_PAGES depends on !CONFIG_COMPAT. This patch
allows the arm64 kernel to build with and without CONFIG_COMPAT.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/perf_event.c | 4 ++++
 arch/arm64/kernel/perf_regs.c  | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index e868c72..baf5afb 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1386,6 +1386,7 @@ user_backtrace(struct frame_tail __user *tail,
 	return buftail.fp;
 }
 
+#ifdef CONFIG_COMPAT
 /*
  * The registers we're interested in are at the end of the variable
  * length saved register structure. The fp points at the end of this
@@ -1430,6 +1431,7 @@ compat_user_backtrace(struct compat_frame_tail __user *tail,
 
 	return (struct compat_frame_tail __user *)compat_ptr(buftail.fp) - 1;
 }
+#endif /* CONFIG_COMPAT */
 
 void perf_callchain_user(struct perf_callchain_entry *entry,
 			 struct pt_regs *regs)
@@ -1451,6 +1453,7 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 		       tail && !((unsigned long)tail & 0xf))
 			tail = user_backtrace(tail, entry);
 	} else {
+#ifdef CONFIG_COMPAT
 		/* AARCH32 compat mode */
 		struct compat_frame_tail __user *tail;
 
@@ -1459,6 +1462,7 @@ void perf_callchain_user(struct perf_callchain_entry *entry,
 		while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
 			tail && !((unsigned long)tail & 0x3))
 			tail = compat_user_backtrace(tail, entry);
+#endif
 	}
 }
 
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index f2d6f0a..422ebd6 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -2,6 +2,8 @@
 #include <linux/kernel.h>
 #include <linux/perf_event.h>
 #include <linux/bug.h>
+
+#include <asm/compat.h>
 #include <asm/perf_regs.h>
 #include <asm/ptrace.h>
 
-- 
1.8.5.3

