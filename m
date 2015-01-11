Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbAKWHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:07:37 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38183 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbbAKWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:22 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 08/11] x86,fpu: restore user FPU state lazily after __kernel_fpu_end
Date: Sun, 11 Jan 2015 16:46:30 -0500
Message-Id: <1421012793-30106-9-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Tasks may have multiple invocations of kernel_fpu_start and kernel_fpu_end
in sequence without ever hitting userspace in-between.

Delaying the restore of the user FPU state until the task returns to
userspace means the kernel only has to save the user FPU state on the
first invocation of kernel_fpu_start, making the other invocations
cheaper.

This is especially true for KVM vcpu threads, which can handle lots
of guest events and exceptions entirely in kernel mode.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/kernel/i387.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index c98f88d..cfbf325 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -89,13 +89,11 @@ void __kernel_fpu_end(void)
 	if (use_eager_fpu()) {
 		/*
 		 * For eager fpu, most the time, tsk_used_math() is true.
-		 * Restore the user math as we are done with the kernel usage.
-		 * At few instances during thread exit, signal handling etc,
-		 * tsk_used_math() is false. Those few places will take proper
-		 * actions, so we don't need to restore the math here.
+		 * Make sure the user math state is restored on return to
+		 * userspace.
 		 */
 		if (likely(tsk_used_math(current)))
-			math_state_restore();
+			set_thread_flag(TIF_LOAD_FPU);
 	} else {
 		stts();
 	}
-- 
1.9.3

