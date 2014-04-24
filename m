Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaDXVx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:53:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaDXVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Bob Picco <bob.picco@oracle.com>, Allen Pais <allen.pais@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 3.4 20/27] sparc64: dont treat 64-bit syscall return codes as 32-bit
Date: Thu, 24 Apr 2014 14:55:54 -0700
Message-Id: <20140424215552.582457774@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/syscalls.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 


