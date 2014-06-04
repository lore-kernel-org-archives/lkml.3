Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaFDXW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaFDXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [PATCH 3.14 168/228] parisc: Improve LWS-CAS performance
Date: Wed,  4 Jun 2014 16:23:17 -0700
Message-Id: <20140604232353.428134008@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit c776cd89fc705fc8b5c2e5ad906bf5d791620fed upstream.

The attached change significantly improves the performance of the LWS-CAS code
in syscall.S.
This allows a number of packages to build (e.g., zeromq3, gtest and libxs)
that previously failed because slow LWS-CAS performance under contention. In
particular, interrupts taken while the lock was taken degraded performance
significantly.

The change does the following:

1) Disables interrupts around the CAS operation, and
2) Changes the loads and stores to use the ordered completer, "o", on
PA 2.0. "o" and "ma" with a zero offset are equivalent. The latter is
accepted on both PA 1.X and 2.0.

The use of ordered loads and stores probably makes no difference on all
existing hardware, but it seemed pedantically correct. In particular, the CAS
operation must complete before LDCW lock is released. As written before, a
processor could reorder the operations.

I don't believe the period interrupts are disabled is long enough to
significantly increase interrupt latency. For example, the TLB insert code is
longer. Worst case is a memory fault in the CAS operation.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/syscall.S |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -589,10 +589,13 @@ cas_nocontend:
 # endif
 /* ENABLE_LWS_DEBUG */
 
+	rsm	PSW_SM_I, %r0				/* Disable interrupts */
+	/* COW breaks can cause contention on UP systems */
 	LDCW	0(%sr2,%r20), %r28			/* Try to acquire the lock */
 	cmpb,<>,n	%r0, %r28, cas_action		/* Did we get it? */
 cas_wouldblock:
 	ldo	2(%r0), %r28				/* 2nd case */
+	ssm	PSW_SM_I, %r0
 	b	lws_exit				/* Contended... */
 	ldo	-EAGAIN(%r0), %r21			/* Spin in userspace */
 
@@ -619,15 +622,17 @@ cas_action:
 	stw	%r1, 4(%sr2,%r20)
 #endif
 	/* The load and store could fail */
-1:	ldw	0(%sr3,%r26), %r28
+1:	ldw,ma	0(%sr3,%r26), %r28
 	sub,<>	%r28, %r25, %r0
-2:	stw	%r24, 0(%sr3,%r26)
+2:	stw,ma	%r24, 0(%sr3,%r26)
 	/* Free lock */
-	stw	%r20, 0(%sr2,%r20)
+	stw,ma	%r20, 0(%sr2,%r20)
 #if ENABLE_LWS_DEBUG
 	/* Clear thread register indicator */
 	stw	%r0, 4(%sr2,%r20)
 #endif
+	/* Enable interrupts */
+	ssm	PSW_SM_I, %r0
 	/* Return to userspace, set no error */
 	b	lws_exit
 	copy	%r0, %r21
@@ -639,6 +644,7 @@ cas_action:
 #if ENABLE_LWS_DEBUG
 	stw	%r0, 4(%sr2,%r20)
 #endif
+	ssm	PSW_SM_I, %r0
 	b	lws_exit
 	ldo	-EFAULT(%r0),%r21	/* set errno */
 	nop


