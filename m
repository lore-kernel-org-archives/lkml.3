Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3EEWI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 18:08:28 -0400
Received: from mout.gmx.net ([212.227.15.18]:58587 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3EEWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 18:08:26 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18z/VcGF74z9YMQVQGHkzo8svClO7s2VGUTJdKzRH
	JCBmgjxzNiy46C
Date: Mon, 6 May 2013 00:08:22 +0200
From: Helge Deller <deller@gmx.de>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH] MPILIB: disable usage of floating point registers on parisc
Message-ID: <20130505220822.GA7819@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The umul_ppmm() macro for parisc uses the xmpyu assembler statement
which does calculation via a floating point register.

But usage of floating point registers inside the Linux kernel are not
allowed and gcc will stop compilation due to the -mdisable-fpregs
compiler option.

Fix this by disabling the umul_ppmm() and udiv_qrnnd() macros. The
mpilib will then use the generic built-in implementations instead.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 095ab15..d411355 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -318,7 +318,8 @@ extern UDItype __udiv_qrnnd();
 	     "rM" ((USItype)(bh)), \
 	     "rM" ((USItype)(al)), \
 	     "rM" ((USItype)(bl)))
-#if defined(_PA_RISC1_1)
+#if 0 && defined(_PA_RISC1_1)
+/* xmpyu uses floating point register which is not allowed in Linux kernel. */
 #define umul_ppmm(wh, wl, u, v) \
 do { \
 	union {UDItype __ll; \
@@ -337,7 +338,7 @@ do { \
 #define UMUL_TIME 40
 #define UDIV_TIME 80
 #endif
-#ifndef LONGLONG_STANDALONE
+#if 0 /* #ifndef LONGLONG_STANDALONE */
 #define udiv_qrnnd(q, r, n1, n0, d) \
 do { USItype __r; \
 	(q) = __udiv_qrnnd(&__r, (n1), (n0), (d)); \
