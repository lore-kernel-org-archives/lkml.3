Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaKBRcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 12:32:25 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50013 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKBRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:21 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 2 Nov 2014 09:32:14 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH v4 03/10] x86: processor.h: Introduce macros to initialize IO
 fields of thread and TSS
Message-ID: <a7a86806f71398b4b0bbb78eecee0d72a05acc23.1414870871.git.josh@joshtriplett.org>
References: <cover.1414870871.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414870871.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just splitting out parts of the existing
INIT_THREAD and INIT_TSS macros.  This will simplify making those fields
optional later.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/include/asm/processor.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 76751cd..0a12534 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -842,12 +842,7 @@ static inline void spin_lock_prefetch(const void *x)
 #define STACK_TOP		TASK_SIZE
 #define STACK_TOP_MAX		STACK_TOP
 
-#define INIT_THREAD  {							  \
-	.sp0			= sizeof(init_stack) + (long)&init_stack, \
-	.vm86_info		= NULL,					  \
-	.sysenter_cs		= __KERNEL_CS,				  \
-	.io_bitmap_ptr		= NULL,					  \
-}
+#define INIT_THREAD_IO .io_bitmap_ptr = NULL,
 
 /*
  * Note that the .io_bitmap member must be extra-big. This is because
@@ -855,6 +850,15 @@ static inline void spin_lock_prefetch(const void *x)
  * permission bitmap. The extra byte must be all 1 bits, and must
  * be within the limit.
  */
+#define INIT_TSS_IO .io_bitmap = { [0 ... IO_BITMAP_LONGS] = ~0 },
+
+#define INIT_THREAD  {							  \
+	.sp0			= sizeof(init_stack) + (long)&init_stack, \
+	.vm86_info		= NULL,					  \
+	.sysenter_cs		= __KERNEL_CS,				  \
+	INIT_THREAD_IO							  \
+}
+
 #define INIT_TSS  {							  \
 	.x86_tss = {							  \
 		.sp0		= sizeof(init_stack) + (long)&init_stack, \
@@ -862,7 +866,7 @@ static inline void spin_lock_prefetch(const void *x)
 		.ss1		= __KERNEL_CS,				  \
 		.io_bitmap_base	= INVALID_IO_BITMAP_OFFSET,		  \
 	 },								  \
-	.io_bitmap		= { [0 ... IO_BITMAP_LONGS] = ~0 },	  \
+	INIT_TSS_IO							  \
 }
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
-- 
2.1.1

