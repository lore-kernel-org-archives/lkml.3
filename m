Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3EMHUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:20:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39619 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3EMHUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:20:48 -0400
From: Joe Damato <ice799@gmail.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        Joe Damato <ice799@gmail.com>
Subject: [PATCH v2] x86: Reduce duplicated code in the x86_64 context switch path.
Date: Mon, 13 May 2013 00:20:12 -0700
Message-Id: <1368429613-1237-1-git-send-email-ice799@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368422091-959-1-git-send-email-ice799@gmail.com>
References: <1368422091-959-1-git-send-email-ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/include/asm/switch_to.h |   25 +++++++++++++++++++++++++
 arch/x86/kernel/process_64.c     |   29 ++---------------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 4ec45b3..5fd0267 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -124,6 +124,31 @@ do {									\
 	       __switch_canary_iparam					  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
 
+#define load_fs_index(index)						       \
+	loadsegment(fs, index)
+
+#define switch_segment(prev, next, index, seg, msr)			       \
+	do {								       \
+		/*							       \
+		 * Segment register != 0 always requires a reload.  Also       \
+		 * reload when it has changed.  When prev process used 64bit   \
+		 * base always reload to avoid an information leak.	       \
+		 */							       \
+		if (unlikely(index | next->index | prev->seg)) {	       \
+			load_##seg##_index(next->index);		       \
+			/*						       \
+			 * Check if the user used a selector != 0; if yes      \
+			 *  clear 64bit base, since overloaded base is always  \
+			 *  mapped to the Null selector			       \
+			 */						       \
+			if (index)					       \
+			  prev->seg = 0;				       \
+		}							       \
+		/* when next process has a 64bit base use it */		       \
+		if (next->seg)						       \
+		  wrmsrl(msr, next->seg);				       \
+		prev->index = index;					       \
+	} while (0)
 #endif /* CONFIG_X86_32 */
 
 #endif /* _ASM_X86_SWITCH_TO_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 355ae06..f41d026 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -318,34 +318,9 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	/*
 	 * Switch FS and GS.
-	 *
-	 * Segment register != 0 always requires a reload.  Also
-	 * reload when it has changed.  When prev process used 64bit
-	 * base always reload to avoid an information leak.
 	 */
-	if (unlikely(fsindex | next->fsindex | prev->fs)) {
-		loadsegment(fs, next->fsindex);
-		/*
-		 * Check if the user used a selector != 0; if yes
-		 *  clear 64bit base, since overloaded base is always
-		 *  mapped to the Null selector
-		 */
-		if (fsindex)
-			prev->fs = 0;
-	}
-	/* when next process has a 64bit base use it */
-	if (next->fs)
-		wrmsrl(MSR_FS_BASE, next->fs);
-	prev->fsindex = fsindex;
-
-	if (unlikely(gsindex | next->gsindex | prev->gs)) {
-		load_gs_index(next->gsindex);
-		if (gsindex)
-			prev->gs = 0;
-	}
-	if (next->gs)
-		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
-	prev->gsindex = gsindex;
+	switch_segment(prev, next, fsindex, fs, MSR_FS_BASE);
+	switch_segment(prev, next, gsindex, gs, MSR_KERNEL_GS_BASE);
 
 	switch_fpu_finish(next_p, fpu);
 
-- 
1.7.9.5

