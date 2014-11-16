Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaKPWO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:14:29 -0500
Received: from 1wt.eu ([62.212.114.60]:47853 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaKPWA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:28 -0500
Message-Id: <20141116215328.693816276@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roland McGrath <roland@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 01/48] x86_32, entry: Do syscall exit work on badsys
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 (CVE-2014-4508)

From: Andy Lutomirski <luto@amacapital.net>

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
Link: http://lkml.kernel.org/r/e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
(cherry picked from commit 554086d85e71f30abe46fc014fea31929a7c6a8a)
[WT: this fix is incorrect and requires the two following patches]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/entry_32.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..40a0d02 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -445,9 +445,10 @@ sysenter_past_esp:
 	jnz sysenter_audit
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
-	jae syscall_badsys
+	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
+sysenter_after_call:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -702,7 +703,12 @@ END(syscall_fault)
 
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
 
-- 
1.7.12.2.21.g234cd45.dirty



