Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaFZTIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:08:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49618 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaFZTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:08:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86_64,entry: Fix RCX for traced syscalls
Date: Thu, 26 Jun 2014 12:08:43 -0700
Message-Id: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
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

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b25ca96..6624e18 100644
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

