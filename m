Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbbAKWFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:36 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38181 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbbAKWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:19 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 05/11] x86,fpu: ensure FPU state is reloaded from memory if task is traced
Date: Sun, 11 Jan 2015 16:46:27 -0500
Message-Id: <1421012793-30106-6-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

If the old task is in a state where its FPU state could be changed by
a debugger, ensure the FPU state is always restored from memory on the
next context switch.

Currently the system only skips FPU reloads when !eager_fpu_mode()
and the task's FPU state is still loaded on the CPU.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 539b050..4db8781 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -412,8 +412,14 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 	bool preload = tsk_used_math(new) && (use_eager_fpu() ||
 					     new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
-		if (!__save_init_fpu(old))
+		/*
+		 * Make sure the FPU state is restored from memory next time,
+		 * if the task has an FPU exception pending, or the task's in
+		 * memory FPU state could be changed by a debugger.
+		 */
+		if (!__save_init_fpu(old) || task_is_stopped_or_traced(old))
 			cpu = ~0;
+
 		old->thread.fpu.last_cpu = cpu;
 		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
 
-- 
1.9.3

