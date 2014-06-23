Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaFWWTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:19:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFWWTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:19:13 -0400
Date: Mon, 23 Jun 2014 15:18:43 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-554086d85e71f30abe46fc014fea31929a7c6a8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        luto@amacapital.net, roland@redhat.com, toralf.foerster@gmx.de,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, roland@redhat.com, toralf.foerster@gmx.de,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
References: <e09c499eade6fc321266dd6b54da7beb28d6991c.1403558229.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_32, entry: Do syscall exit work on badsys (
 CVE-2014-4508)
Git-Commit-ID: 554086d85e71f30abe46fc014fea31929a7c6a8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  554086d85e71f30abe46fc014fea31929a7c6a8a
Gitweb:     http://git.kernel.org/tip/554086d85e71f30abe46fc014fea31929a7c6a8a
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 23 Jun 2014 14:22:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Jun 2014 14:59:26 -0700

x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

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
---
 arch/x86/kernel/entry_32.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0da82b..dbaa23e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -423,9 +423,10 @@ sysenter_past_esp:
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
@@ -675,7 +676,12 @@ END(syscall_fault)
 
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
 
