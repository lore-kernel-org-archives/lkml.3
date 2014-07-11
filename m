Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaGKQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:29:39 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33816 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaGKQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:29:37 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/2] x86_64,signal: Save and restore SS in signal frames
Date: Fri, 11 Jul 2014 09:29:22 -0700
Message-Id: <d8865f151f1b0abed2df6a3ba545f4cd8b1e873f.1405095200.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405095200.git.luto@amacapital.net>
References: <cover.1405095200.git.luto@amacapital.net>
In-Reply-To: <cover.1405095200.git.luto@amacapital.net>
References: <cover.1405095200.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment in the signal code says that apps can save/restore other
segments on their own.  It's true that apps can *save* SS on their
own, but there's no way for apps to restore it: SYSCALL effectively
resets SS to __USER_DS, so any value that user code tries to load
into SS gets lost on entry to sigreturn.

This recycles two padding bytes in the segment selector area for SS.

I suspect that 64-bit programs that try to run 16-bit code and uses
signals will have a lot of trouble without this.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/sigcontext.h      | 2 +-
 arch/x86/include/uapi/asm/sigcontext.h | 2 +-
 arch/x86/kernel/signal.c               | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index 9dfce4e..f910cdc 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -59,7 +59,7 @@ struct sigcontext {
 	unsigned short cs;
 	unsigned short gs;
 	unsigned short fs;
-	unsigned short __pad0;
+	unsigned short ss;
 	unsigned long err;
 	unsigned long trapno;
 	unsigned long oldmask;
diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
index d8b9f90..076b11f 100644
--- a/arch/x86/include/uapi/asm/sigcontext.h
+++ b/arch/x86/include/uapi/asm/sigcontext.h
@@ -179,7 +179,7 @@ struct sigcontext {
 	__u16 cs;
 	__u16 gs;
 	__u16 fs;
-	__u16 __pad0;
+	__u16 ss;
 	__u64 err;
 	__u64 trapno;
 	__u64 oldmask;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 2851d63..08d7a9e 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -94,15 +94,8 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		COPY(r15);
 #endif /* CONFIG_X86_64 */
 
-#ifdef CONFIG_X86_32
 		COPY_SEG_CPL3(cs);
 		COPY_SEG_CPL3(ss);
-#else /* !CONFIG_X86_32 */
-		/* Kernel saves and restores only the CS segment register on signals,
-		 * which is the bare minimum needed to allow mixed 32/64-bit code.
-		 * App's signal handler can save/restore other segments if needed. */
-		COPY_SEG_CPL3(cs);
-#endif /* CONFIG_X86_32 */
 
 		get_user_ex(tmpflags, &sc->flags);
 		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
@@ -164,6 +157,7 @@ int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		put_user_ex(regs->cs, &sc->cs);
 		put_user_ex(0, &sc->gs);
 		put_user_ex(0, &sc->fs);
+		put_user_ex(regs->ss, &sc->ss);
 #endif /* CONFIG_X86_32 */
 
 		put_user_ex(fpstate, &sc->fpstate);
-- 
1.9.3

