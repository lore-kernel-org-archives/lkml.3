Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaEXHEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:04:07 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35919 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaEXHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 12/24] ARM64: Add is_ilp32_compat_task and is_ilp32_compat_thread and TIF_32BIT_AARCH64.
Date: Sat, 24 May 2014 00:02:07 -0700
Message-Id: <1400914939-9708-13-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the thread bit for ILP32 and has is_compat_task return true in that case.  We don't set it yet though.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h      |   32 ++++++++++++++++++++++++++++++--
 arch/arm64/include/asm/thread_info.h |    1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fad7612..85f945c 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -313,6 +313,26 @@ static inline int is_a32_compat_thread(struct thread_info *thread)
 }
 #endif
 
+#ifdef CONFIG_ARM64_ILP32
+static inline int is_ilp32_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT_AARCH64);
+}
+static inline int is_ilp32_compat_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_32BIT_AARCH64);
+}
+#else
+static inline int is_ilp32_compat_task(void)
+{
+	return 0;
+}
+static inline int is_ilp32_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
+#endif
+
 #else /* !CONFIG_COMPAT */
 
 static inline int is_a32_compat_task(void)
@@ -323,17 +343,25 @@ static inline int is_a32_compat_thread(struct thread_info *thread)
 {
 	return 0;
 }
+static inline int is_ilp32_compat_task(void)
+{
+	return 0;
+}
+static inline int is_ilp32_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
 
 #endif /* CONFIG_COMPAT */
 
 static inline int is_compat_task(void)
 {
-	return is_a32_compat_task();
+	return is_a32_compat_task() || is_ilp32_compat_task();
 }
 
 static inline int is_compat_thread(struct thread_info *thread)
 {
-	return is_a32_compat_thread(thread);
+	return is_a32_compat_thread(thread) || is_ilp32_compat_thread(thread);
 }
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index b2bf728..98baf65 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* AARCH32 process */
 #define TIF_SWITCH_MM		23	/* deferred switch_mm */
+#define TIF_32BIT_AARCH64	24	/* 32 bit process on AArch64(ILP32) */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-- 
1.7.2.5

