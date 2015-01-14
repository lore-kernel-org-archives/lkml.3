Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbbANVsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:48:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbbANVsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:48:53 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] x86: code shrink in paranoid_exit
Date: Wed, 14 Jan 2015 22:48:12 +0100
Message-Id: <1421272101-16847-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
References: <1421272101-16847-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RESTORE_EXTRA_REGS + RESTORE_C_REGS looks small, but it's
a lot of instructions (fourteen). Let's reuse them.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/entry_64.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index a21b5b3..f5e815e 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1270,12 +1270,10 @@ ENTRY(paranoid_exit)
 	jnz paranoid_restore
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
-	RESTORE_EXTRA_REGS
-	RESTORE_C_REGS
-	REMOVE_PT_GPREGS_FROM_STACK 8
-	INTERRUPT_RETURN
+	jmp paranoid_restore1
 paranoid_restore:
 	TRACE_IRQS_IRETQ_DEBUG 0
+paranoid_restore1:
 	RESTORE_EXTRA_REGS
 	RESTORE_C_REGS
 	REMOVE_PT_GPREGS_FROM_STACK 8
-- 
1.8.1.4

