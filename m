Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaICVXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:23:17 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51849 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbaICVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:23:09 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 14/24] ARM64:ILP32 use the standard start_thread for ILP32 so the processor state is not AARCH32
Date: Wed,  3 Sep 2014 14:19:08 -0700
Message-Id: <1409779158-30963-15-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have both ILP32 and AARCH32 compiled in, we need use the non compat start
thread for ILP32.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/processor.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 286b1be..7bd9f32 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -104,6 +104,17 @@ static inline void start_thread(struct pt_regs *regs, unsigned long pc,
 static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
 				       unsigned long sp)
 {
+#ifdef CONFIG_ARM64_ILP32
+	/*
+	 * ILP32 thread are started the same way as LP64 threads.
+	 * Note we cannot use is_ilp32_compat_task here as that
+	 * would introduce a header depency issue.
+	 */
+	if (!test_thread_flag(TIF_AARCH32)) {
+		start_thread(regs, pc, sp);
+		return;
+	}
+#endif
 	start_thread_common(regs, pc);
 	regs->pstate = COMPAT_PSR_MODE_USR;
 	if (pc & 1)
-- 
1.7.2.5

