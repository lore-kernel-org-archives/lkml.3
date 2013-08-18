Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3HRUg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:36:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3HRUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [ 41/45] m68k: Truncate base in do_div()
Date: Sun, 18 Aug 2013 13:36:30 -0700
Message-Id: <20130818203623.850246787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit ea077b1b96e073eac5c3c5590529e964767fc5f7 upstream.

Explicitly truncate the second operand of do_div() to 32 bits to guard
against bogus code calling it with a 64-bit divisor.

[Thorsten]

After upgrading from 3.2 to 3.10, mounting a btrfs volume fails with:

btrfs: setting nodatacow, compression disabled
btrfs: enabling auto recovery
btrfs: disk space caching is enabled
---
 arch/m68k/include/asm/div64.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/m68k/include/asm/div64.h
+++ b/arch/m68k/include/asm/div64.h
@@ -15,16 +15,17 @@
 		unsigned long long n64;				\
 	} __n;							\
 	unsigned long __rem, __upper;				\
+	unsigned long __base = (base);				\
 								\
 	__n.n64 = (n);						\
 	if ((__upper = __n.n32[0])) {				\
 		asm ("divul.l %2,%1:%0"				\
-			: "=d" (__n.n32[0]), "=d" (__upper)	\
-			: "d" (base), "0" (__n.n32[0]));	\
+		     : "=d" (__n.n32[0]), "=d" (__upper)	\
+		     : "d" (__base), "0" (__n.n32[0]));		\
 	}							\
 	asm ("divu.l %2,%1:%0"					\
-		: "=d" (__n.n32[1]), "=d" (__rem)		\
-		: "d" (base), "1" (__upper), "0" (__n.n32[1]));	\
+	     : "=d" (__n.n32[1]), "=d" (__rem)			\
+	     : "d" (__base), "1" (__upper), "0" (__n.n32[1]));	\
 	(n) = __n.n64;						\
 	__rem;							\
 })


