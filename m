Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKBRdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:33:05 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36093 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaKBRdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:33:01 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:55 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 09/10] x86: process: Introduce helper to switch IO bitmap
Message-ID: <7da73a194a9856de21cf9cf035be29239ce88ef3.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies __switch_to_xtra, and will make it easier to make IO
optional later.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/process-io.h | 23 +++++++++++++++++++++++
 arch/x86/kernel/process.c    | 14 +-------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/process-io.h b/arch/x86/kernel/process-io.h
index 012c1d5..e48d5c9 100644
--- a/arch/x86/kernel/process-io.h
+++ b/arch/x86/kernel/process-io.h
@@ -57,4 +57,27 @@ static inline void switch_iopl_mask(struct thread_struct *prev,
                 set_iopl_mask(next->iopl);
 }
 
+static inline void switch_io_bitmap(struct tss_struct *tss,
+				    struct task_struct *prev_p,
+				    struct task_struct *next_p)
+{
+        struct thread_struct *prev, *next;
+        prev = &prev_p->thread;
+        next = &next_p->thread;
+
+        if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
+                /*
+                 * Copy the relevant range of the IO bitmap.
+                 * Normally this is 128 bytes or less:
+                 */
+                memcpy(tss->io_bitmap, next->io_bitmap_ptr,
+                       max(prev->io_bitmap_max, next->io_bitmap_max));
+        } else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
+                /*
+                 * Clear any possible leftover bits:
+                 */
+                memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
+        }
+}
+
 #endif /* _X86_KERNEL_PROCESS_IO_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 37b45ca..7ac01bf 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -211,19 +211,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 			hard_enable_TSC();
 	}
 
-	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Copy the relevant range of the IO bitmap.
-		 * Normally this is 128 bytes or less:
-		 */
-		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
-		       max(prev->io_bitmap_max, next->io_bitmap_max));
-	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
-		/*
-		 * Clear any possible leftover bits:
-		 */
-		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
-	}
+	switch_io_bitmap(tss, prev_p, next_p);
 	propagate_user_return_notify(prev_p, next_p);
 }
 
-- 
2.1.1

