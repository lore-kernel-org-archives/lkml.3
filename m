Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaEEMuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41026 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 47/50] sparc64: don't treat 64-bit syscall return codes as 32-bit
Date: Mon,  5 May 2014 14:43:29 +0200
Message-Id: <094c49e05b7684cf4c81d1da2620c1a65fa8ced9.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Kleikamp <dave.kleikamp@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1535bd8adbdedd60a0ee62e28fd5225d66434371 ]

When checking a system call return code for an error,
linux_sparc_syscall was sign-extending the lower 32-bit value and
comparing it to -ERESTART_RESTARTBLOCK. lseek can return valid return
codes whose lower 32-bits alone would indicate a failure (such as 4G-1).
Use the whole 64-bit value to check for errors. Only the 32-bit path
should sign extend the lower 32-bit value.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Allen Pais <allen.pais@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/syscalls.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index d950197a17e1..6dee79575791 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -189,7 +189,8 @@ linux_sparc_syscall32:
 	 mov	%i0, %l5				! IEU1
 5:	call	%l7					! CTI	Group brk forced
 	 srl	%i5, 0, %o5				! IEU1
-	ba,a,pt	%xcc, 3f
+	ba,pt	%xcc, 3f
+	 sra	%o0, 0, %o0
 
 	/* Linux native system calls enter here... */
 	.align	32
@@ -217,7 +218,6 @@ linux_sparc_syscall:
 3:	stx	%o0, [%sp + PTREGS_OFF + PT_V9_I0]
 ret_sys_call:
 	ldx	[%sp + PTREGS_OFF + PT_V9_TSTATE], %g3
-	sra	%o0, 0, %o0
 	mov	%ulo(TSTATE_XCARRY | TSTATE_ICARRY), %g2
 	sllx	%g2, 32, %g2
 
-- 
1.9.2

