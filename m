Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3JUJCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:02:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39801 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab3JUIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kirill Tkhai" <tkhai@yandex.ru>,
        "David Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.996319300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 118/149] sparc64: Fix not SRA'ed %o5 in 32-bit traced
 syscall
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

