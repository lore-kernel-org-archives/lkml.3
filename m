Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JMOUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 10:20:50 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59978 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3JMOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 10:20:48 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v2 1/4] arm64: fix possible invalid FPSIMD initialization state
Date: Sun, 13 Oct 2013 22:20:17 +0800
Message-Id: <1381674029-430-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

If context switching happens during executing fpsimd_flush_thread(),
stale value in FPSIMD registers will be saved into current thread's
fpsimd_state by fpsimd_thread_switch(). That may cause invalid
initialization state for the new process, so disable preemption
when executing fpsimd_flush_thread().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/arm64/kernel/fpsimd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1f2e4d5..bb785d2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -80,8 +80,10 @@ void fpsimd_thread_switch(struct task_struct *next)
 
 void fpsimd_flush_thread(void)
 {
+	preempt_disable();
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
 	fpsimd_load_state(&current->thread.fpsimd_state);
+	preempt_enable();
 }
 
 #ifdef CONFIG_KERNEL_MODE_NEON
-- 
1.8.1.2

