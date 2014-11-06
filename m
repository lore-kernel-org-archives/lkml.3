Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaKFXIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:08:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaKFWls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/162] sparc: Let memset return the address argument
Date: Thu,  6 Nov 2014 14:34:59 -0800
Message-Id: <1415313426-9622-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 74cad25c076a2f5253312c2fe82d1a4daecc1323 ]

This makes memset follow the standard (instead of returning 0 on success). This
is needed when certain versions of gcc optimizes around memset calls and assume
that the address argument is preserved in %o0.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/lib/memset.S | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/lib/memset.S b/arch/sparc/lib/memset.S
index 99c017b..f75e690 100644
--- a/arch/sparc/lib/memset.S
+++ b/arch/sparc/lib/memset.S
@@ -3,8 +3,9 @@
  * Copyright (C) 1996,1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
  * Copyright (C) 1996 David S. Miller (davem@caip.rutgers.edu)
  *
- * Returns 0, if ok, and number of bytes not yet set if exception
- * occurs and we were called as clear_user.
+ * Calls to memset returns initial %o0. Calls to bzero returns 0, if ok, and
+ * number of bytes not yet set if exception occurs and we were called as
+ * clear_user.
  */
 
 #include <asm/ptrace.h>
@@ -65,6 +66,8 @@ __bzero_begin:
 	.globl	__memset_start, __memset_end
 __memset_start:
 memset:
+	mov	%o0, %g1
+	mov	1, %g4
 	and	%o1, 0xff, %g3
 	sll	%g3, 8, %g2
 	or	%g3, %g2, %g3
@@ -89,6 +92,7 @@ memset:
 	 sub	%o0, %o2, %o0
 
 __bzero:
+	clr	%g4
 	mov	%g0, %g3
 1:
 	cmp	%o1, 7
@@ -151,8 +155,8 @@ __bzero:
 	bne,a	8f
 	 EX(stb	%g3, [%o0], and %o1, 1)
 8:
-	retl
-	 clr	%o0
+	b	0f
+	 nop
 7:
 	be	13b
 	 orcc	%o1, 0, %g0
@@ -164,6 +168,12 @@ __bzero:
 	bne	8b
 	 EX(stb	%g3, [%o0 - 1], add %o1, 1)
 0:
+	andcc	%g4, 1, %g0
+	be	5f
+	 nop
+	retl
+	 mov	%g1, %o0
+5:
 	retl
 	 clr	%o0
 __memset_end:
-- 
1.9.1

