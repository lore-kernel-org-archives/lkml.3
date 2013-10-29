Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3J2SUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:20:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3J2SIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 62/81] sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
Date: Tue, 29 Oct 2013 11:04:23 -0700
Message-Id: <1383069882-11437-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit ab2abda6377723e0d5fbbfe5f5aa16a5523344d1 ]

(From v1 to v2: changed comment)

On the way linux_sparc_syscall32->linux_syscall_trace32->goto 2f,
register %o5 doesn't clear its second 32-bit.

Fix that.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/syscalls.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index e0fed77..dc7b524 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -158,7 +158,7 @@ linux_syscall_trace32:
 	srl	%i4, 0, %o4
 	srl	%i1, 0, %o1
 	srl	%i2, 0, %o2
-	ba,pt	%xcc, 2f
+	ba,pt	%xcc, 5f
 	 srl	%i3, 0, %o3
 
 linux_syscall_trace:
@@ -188,13 +188,13 @@ linux_sparc_syscall32:
 	srl	%i1, 0, %o1				! IEU0	Group
 	ldx	[%g6 + TI_FLAGS], %l0		! Load
 
-	srl	%i5, 0, %o5				! IEU1
+	srl	%i3, 0, %o3				! IEU0
 	srl	%i2, 0, %o2				! IEU0	Group
 	andcc	%l0, (_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT|_TIF_SYSCALL_TRACEPOINT), %g0
 	bne,pn	%icc, linux_syscall_trace32		! CTI
 	 mov	%i0, %l5				! IEU1
-	call	%l7					! CTI	Group brk forced
-	 srl	%i3, 0, %o3				! IEU0
+5:	call	%l7					! CTI	Group brk forced
+	 srl	%i5, 0, %o5				! IEU1
 	ba,a,pt	%xcc, 3f
 
 	/* Linux native system calls enter here... */
-- 
1.8.1.2

