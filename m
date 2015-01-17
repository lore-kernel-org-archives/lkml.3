Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbbAQKOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:14:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44364 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbbAQKOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:14:03 -0500
Date: Sat, 17 Jan 2015 02:13:45 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-0fcedc8631ec28ca25d3c0b116e8fa0c19dd5f6d@git.kernel.org>
Cc: fweisbec@gmail.com, luto@amacapital.net, mingo@kernel.org, hpa@zytor.com,
        bp@suse.de, oleg@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        riel@redhat.com
Reply-To: oleg@redhat.com, bp@suse.de, mingo@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, luto@amacapital.net, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <c9a418c3dc3993cb88bb7773800225fd318a4c67.1421453410.git.luto@amacapital.net>
References: <c9a418c3dc3993cb88bb7773800225fd318a4c67.1421453410.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86_64 entry: Fix RCX for ptraced syscalls
Git-Commit-ID: 0fcedc8631ec28ca25d3c0b116e8fa0c19dd5f6d
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

Commit-ID:  0fcedc8631ec28ca25d3c0b116e8fa0c19dd5f6d
Gitweb:     http://git.kernel.org/tip/0fcedc8631ec28ca25d3c0b116e8fa0c19dd5f6d
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 16 Jan 2015 16:19:27 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 17 Jan 2015 11:02:53 +0100

x86_64 entry: Fix RCX for ptraced syscalls

The int_ret_from_sys_call and syscall tracing code disagrees
with the sysret path as to the value of RCX.

The Intel SDM, the AMD APM, and my laptop all agree that sysret
returns with RCX == RIP.  The syscall tracing code does not
respect this property.

For example, this program:

int main()
{
	extern const char syscall_rip[];
	unsigned long rcx = 1;
	unsigned long orig_rcx = rcx;
	asm ("mov $-1, %%eax\n\t"
	     "syscall\n\t"
	     "syscall_rip:"
	     : "+c" (rcx) : : "r11");
	printf("syscall: RCX = %lX  RIP = %lX  orig RCX = %lx\n",
	       rcx, (unsigned long)syscall_rip, orig_rcx);
	return 0;
}

prints:

  syscall: RCX = 400556  RIP = 400556  orig RCX = 1

Running it under strace gives this instead:

  syscall: RCX = FFFFFFFFFFFFFFFF  RIP = 400556  orig RCX = 1

This changes FIXUP_TOP_OF_STACK to match sysret, causing the
test to show RCX == RIP even under strace.

It looks like this is a partial revert of:
88e4bc32686e ("[PATCH] x86-64 architecture specific sync for 2.5.8")
from the historic git tree.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/c9a418c3dc3993cb88bb7773800225fd318a4c67.1421453410.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/entry_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 9ebaf63..c653dc4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -143,7 +143,8 @@ ENDPROC(native_usergs_sysret64)
 	movq \tmp,RSP+\offset(%rsp)
 	movq $__USER_DS,SS+\offset(%rsp)
 	movq $__USER_CS,CS+\offset(%rsp)
-	movq $-1,RCX+\offset(%rsp)
+	movq RIP+\offset(%rsp),\tmp  /* get rip */
+	movq \tmp,RCX+\offset(%rsp)  /* copy it to rcx as sysret would do */
 	movq R11+\offset(%rsp),\tmp  /* get eflags */
 	movq \tmp,EFLAGS+\offset(%rsp)
 	.endm
