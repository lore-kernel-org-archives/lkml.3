Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaGHTmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:42:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Lutomirski" <luto@amacapital.net>,
        "Toralf =?UTF-8?Q?F=C3=B6rster?=" <toralf.foerster@gmx.de>,
        "Roland McGrath" <roland@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.475792534@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 096/125] x86_32, entry: Do syscall exit work on badsys
 (CVE-2014-4508)
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/entry_32.S | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -427,9 +427,10 @@ sysenter_past_esp:
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
@@ -681,7 +682,12 @@ END(syscall_fault)
 
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

