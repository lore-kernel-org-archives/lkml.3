Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaD1Bar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbaD1B3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Allen Pais" <allen.pais@oracle.com>,
        "Bob Picco" <bob.picco@oracle.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.803107968@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/94] sparc64: don't treat 64-bit syscall return
 codes as  32-bit
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/syscalls.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 817187d..557212c 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -184,7 +184,8 @@ linux_sparc_syscall32:
 	 mov	%i0, %l5				! IEU1
 5:	call	%l7					! CTI	Group brk forced
 	 srl	%i5, 0, %o5				! IEU1
-	ba,a,pt	%xcc, 3f
+	ba,pt	%xcc, 3f
+	 sra	%o0, 0, %o0
 
 	/* Linux native system calls enter here... */
 	.align	32
@@ -212,7 +213,6 @@ linux_sparc_syscall:
 3:	stx	%o0, [%sp + PTREGS_OFF + PT_V9_I0]
 ret_sys_call:
 	ldx	[%sp + PTREGS_OFF + PT_V9_TSTATE], %g3
-	sra	%o0, 0, %o0
 	mov	%ulo(TSTATE_XCARRY | TSTATE_ICARRY), %g2
 	sllx	%g2, 32, %g2
 

