Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaF3Muq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:50:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbaF3Mab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Roland McGrath <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 176/181] x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)
Date: Mon, 30 Jun 2014 13:53:17 +0200
Message-Id: <3ee8c4d6a43494d84ec3b0cae7e6e26bc312f8d6.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 554086d85e71f30abe46fc014fea31929a7c6a8a upstream.

The bad syscall nr paths are their own incomprehensible route
through the entry control flow.  Rearrange them to work just like
syscalls that return -ENOSYS.

This fixes an OOPS in the audit code when fast-path auditing is
enabled and sysenter gets a bad syscall nr (CVE-2014-4508).

This has probably been broken since Linux 2.6.27:
af0575bba0 i386 syscall audit fast-path

Cc: Roland McGrath <roland@redhat.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/entry_32.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cef8f5132b87..3308125c90aa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -434,9 +434,10 @@ sysenter_past_esp:
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
@@ -686,7 +687,12 @@ END(syscall_fault)
 
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
2.0.0

