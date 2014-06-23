Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaFWVWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:22:24 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56794 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaFWVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:22:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, security@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org,
        Roland McGrath <roland@redhat.com>
Subject: [PATCH] x86_32,entry: Do syscall exit work on badsys (CVE-2014-4508)
Date: Mon, 23 Jun 2014 14:22:15 -0700
Message-Id: <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
References: <CA+5PVA70nFS8JZkL0-Q-1HjFHT5NA04275_M4WstjQMrpT+hrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bad syscall nr paths are their own incomprehensible route
through the entry control flow.  Rearrange them to work just like
syscalls that return -ENOSYS.

This fixes an OOPS in the audit code when fast-path auditing is
enabled and sysenter gets a bad syscall nr (CVE-2014-4508).

This has probably been broken since Linux 2.6.27:
af0575bba0 i386 syscall audit fast-path

Cc: stable@vger.kernel.org
Cc: Roland McGrath <roland@redhat.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I realize that the syscall audit fast path and badsys code, on 32-bit
x86 no less, is possibly one of the least fun things in the kernel to
review, but this is still a real security bug and should get fixed :(

So I'm cc-ing a bunch of people and maybe someone will review it.

 arch/x86/kernel/entry_32.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index a2a4f46..f4258a5 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -431,9 +431,10 @@ sysenter_past_esp:
 	jnz sysenter_audit
 sysenter_do_call:
 	cmpl $(NR_syscalls), %eax
-	jae syscall_badsys
+	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
+sysenter_after_call:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -688,7 +689,12 @@ END(syscall_fault)
 
 syscall_badsys:
 	movl $-ENOSYS,PT_EAX(%esp)
-	jmp resume_userspace
+	jmp syscall_exit
+END(syscall_badsys)
+
+sysenter_badsys:
+	movl $-ENOSYS,PT_EAX(%esp)
+	jmp sysenter_after_call
 END(syscall_badsys)
 	CFI_ENDPROC
 /*
-- 
1.9.3

