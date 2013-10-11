Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab3JKKyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:54:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab3JKKnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/100] sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
Date: Fri, 11 Oct 2013 11:41:39 +0100
Message-Id: <1381488130-30235-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

commit ab2abda6377723e0d5fbbfe5f5aa16a5523344d1 upstream.

(From v1 to v2: changed comment)

On the way linux_sparc_syscall32->linux_syscall_trace32->goto 2f,
register %o5 doesn't clear its second 32-bit.

Fix that.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/kernel/syscalls.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 7f5f65d..817187d 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -147,7 +147,7 @@ linux_syscall_trace32:
 	srl	%i4, 0, %o4
 	srl	%i1, 0, %o1
 	srl	%i2, 0, %o2
-	ba,pt	%xcc, 2f
+	ba,pt	%xcc, 5f
 	 srl	%i3, 0, %o3
 
 linux_syscall_trace:
@@ -177,13 +177,13 @@ linux_sparc_syscall32:
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
1.8.3.2

