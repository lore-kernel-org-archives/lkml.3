Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3IHDtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:49:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56215 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756728Ab3IHDTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andreas Schwab" <schwab@linux-m68k.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.255511353@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [074/121] m68k: Truncate base in do_div()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
--- a/arch/m68k/include/asm/div64.h
+++ b/arch/m68k/include/asm/div64.h
@@ -13,16 +13,17 @@
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

