Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbbAQATp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:19:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60587 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbAQATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:19:39 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 1/3] x86_64,entry: Fix RCX for traced syscalls
Date: Fri, 16 Jan 2015 16:19:27 -0800
Message-Id: <c9a418c3dc3993cb88bb7773800225fd318a4c67.1421453410.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
In-Reply-To: <cover.1421453410.git.luto@amacapital.net>
References: <cover.1421453410.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The int_ret_from_sys_call and syscall tracing code disagrees with
the sysret path as to the value of RCX.

The Intel SDM, the AMD APM, and my laptop all agree that sysret
returns with RCX == RIP.  The syscall tracing code does not respect
this property.

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

This changes FIXUP_TOP_OF_STACK to match sysret, causing the test to
show RCX == RIP even under strace.

It looks like this is a partial revert of:
88e4bc32686e [PATCH] x86-64 architecture specific sync for 2.5.8
from the historic git tree.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7d59df23e5bb..501212f14c87 100644
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
-- 
2.1.0

