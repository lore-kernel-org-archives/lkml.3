Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaGKQ3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:29:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33368 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaGKQ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:29:47 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
Date: Fri, 11 Jul 2014 09:29:23 -0700
Message-Id: <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405095200.git.luto@amacapital.net>
References: <cover.1405095200.git.luto@amacapital.net>
In-Reply-To: <cover.1405095200.git.luto@amacapital.net>
References: <cover.1405095200.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, these fields have been set to zero on save and
ignored on restore since Linux was imported into git.  Rename them
'__pad1' and '__pad2' to avoid confusion and to allow them to be
recycled some day.

I'm intentionally avoiding calling either of them __pad0: the field
formerly known as __pad0 is now ss.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/sigcontext.h      | 4 ++--
 arch/x86/include/uapi/asm/sigcontext.h | 4 ++--
 arch/x86/kernel/signal.c               | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sigcontext.h b/arch/x86/include/asm/sigcontext.h
index f910cdc..5f0ef11 100644
--- a/arch/x86/include/asm/sigcontext.h
+++ b/arch/x86/include/asm/sigcontext.h
@@ -57,8 +57,8 @@ struct sigcontext {
 	unsigned long ip;
 	unsigned long flags;
 	unsigned short cs;
-	unsigned short gs;
-	unsigned short fs;
+	unsigned short __pad2;	/* Was called gs, but was always zero. */
+	unsigned short __pad1;	/* Was called gs, but was always zero. */
 	unsigned short ss;
 	unsigned long err;
 	unsigned long trapno;
diff --git a/arch/x86/include/uapi/asm/sigcontext.h b/arch/x86/include/uapi/asm/sigcontext.h
index 076b11f..df9908b 100644
--- a/arch/x86/include/uapi/asm/sigcontext.h
+++ b/arch/x86/include/uapi/asm/sigcontext.h
@@ -177,8 +177,8 @@ struct sigcontext {
 	__u64 rip;
 	__u64 eflags;		/* RFLAGS */
 	__u16 cs;
-	__u16 gs;
-	__u16 fs;
+	__u16 __pad2;		/* Was called gs, but was always zero. */
+	__u16 __pad1;		/* Was called fs, but was always zero. */
 	__u16 ss;
 	__u64 err;
 	__u64 trapno;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 08d7a9e..a1867ce 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -155,8 +155,8 @@ int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 #else /* !CONFIG_X86_32 */
 		put_user_ex(regs->flags, &sc->flags);
 		put_user_ex(regs->cs, &sc->cs);
-		put_user_ex(0, &sc->gs);
-		put_user_ex(0, &sc->fs);
+		put_user_ex(0, &sc->__pad2);
+		put_user_ex(0, &sc->__pad1);
 		put_user_ex(regs->ss, &sc->ss);
 #endif /* CONFIG_X86_32 */
 
-- 
1.9.3

