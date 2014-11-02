Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaKBRc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:32:56 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33843 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaKBRct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:49 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 07/10] x86: process: Introduce helper to switch iopl mask
Message-ID: <38733fd32dae1cbf8a3891773ff7ae0336f063de.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies __switch_to a bit, and will make it easier to make iopl
optional later.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/process-io.h | 13 +++++++++++++
 arch/x86/kernel/process_32.c |  9 +--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
index ffa65e8..6d4f147 100644
--- a/arch/x86/kernel/process-io.h
+++ b/arch/x86/kernel/process-io.h
@@ -24,4 +24,17 @@ static inline int copy_io_bitmap(struct task_struct *me,
 	return 0;
 }
 
+static inline void switch_iopl_mask(struct thread_struct *prev,
+				    struct thread_struct *next)
+{
+        /*
+         * Restore IOPL if needed.  In normal use, the flags restore
+         * in the switch assembly will handle this.  But if the kernel
+         * is running virtualized at a non-zero CPL, the popf will
+         * not restore flags, so it must be done in a separate step.
+         */
+        if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
+                set_iopl_mask(next->iopl);
+}
+
 #endif /* _X86_KERNEL_PROCESS_IO_H */
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b55f78e..3b82293 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -265,14 +265,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	load_TLS(next, cpu);
 
-	/*
-	 * Restore IOPL if needed.  In normal use, the flags restore
-	 * in the switch assembly will handle this.  But if the kernel
-	 * is running virtualized at a non-zero CPL, the popf will
-	 * not restore flags, so it must be done in a separate step.
-	 */
-	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
-		set_iopl_mask(next->iopl);
+	switch_iopl_mask(prev, next);
 
 	/*
 	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
-- 
2.1.1

