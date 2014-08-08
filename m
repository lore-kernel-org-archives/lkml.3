Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaHHRqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:46:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaHHRqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:46:03 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 16/17] x86: entry_64.S: trivial optimization for ENOSYS
Date: Fri,  8 Aug 2014 19:44:39 +0200
Message-Id: <1407519880-6719-17-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code uses a slightly shorter insn.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/entry_64.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7bc8c24..5d639a6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -272,6 +272,7 @@ system_call_fastpath:
 	ja badsys
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
+from_badsys:
 	movq %rax,RAX(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
@@ -334,8 +335,8 @@ sysret_signal:
 	jmp int_check_syscall_exit_work
 
 badsys:
-	movq $-ENOSYS,RAX(%rsp)
-	jmp ret_from_sys_call
+	movq	$-ENOSYS,%rax
+	jmp	from_badsys
 
 #ifdef CONFIG_AUDITSYSCALL
 	/*
-- 
1.8.1.4

