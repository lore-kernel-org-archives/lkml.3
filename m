Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbbAKWIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:08:02 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38175 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:07 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 10/11] x86,fpu: fix fpu_copy to deal with not-loaded fpu
Date: Sun, 11 Jan 2015 16:46:32 -0500
Message-Id: <1421012793-30106-11-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

It is possible to hit fpu_copy in eager fpu mode, but without
the current task's FPU context actually loaded into the CPU.

In that case, we should copy the FPU context from memory, not
save it from registers.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 8546c0a..095dacc 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -594,7 +594,8 @@ static inline void fpu_free(struct fpu *fpu)
 
 static inline void fpu_copy(struct task_struct *dst, struct task_struct *src)
 {
-	if (use_eager_fpu()) {
+	preempt_disable();
+	if (use_eager_fpu() && __thread_has_fpu(src)) {
 		memset(&dst->thread.fpu.state->xsave, 0, xstate_size);
 		__save_fpu(dst);
 	} else {
@@ -604,6 +605,7 @@ static inline void fpu_copy(struct task_struct *dst, struct task_struct *src)
 		unlazy_fpu(src);
 		memcpy(dfpu->state, sfpu->state, xstate_size);
 	}
+	preempt_enable();
 }
 
 static inline unsigned long
-- 
1.9.3

