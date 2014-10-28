Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaJ1HAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:00:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbaJ1Dqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:46:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 104/127] sparc: Let memset return the address argument
Date: Tue, 28 Oct 2014 11:35:39 +0800
Message-Id: <20141028033425.388747154@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 74cad25c076a2f5253312c2fe82d1a4daecc1323 ]

This makes memset follow the standard (instead of returning 0 on success). This
is needed when certain versions of gcc optimizes around memset calls and assume
that the address argument is preserved in %o0.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/lib/memset.S |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

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


