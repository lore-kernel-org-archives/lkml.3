Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaKGX6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:58:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33394 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaKGX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:58:27 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/3] x86_64,entry: Fix RCX for traced syscalls
Date: Fri,  7 Nov 2014 15:58:17 -0800
Message-Id: <20059f41189ac95da62cc8b23709c0eaba168186.1415403984.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1415403984.git.luto@amacapital.net>
References: <cover.1415403984.git.luto@amacapital.net>
In-Reply-To: <cover.1415403984.git.luto@amacapital.net>
References: <cover.1415403984.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Warning: HELO: vger.kernel.org not a valid domain

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

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb03fb3..3710b8241945 100644
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
1.9.3

