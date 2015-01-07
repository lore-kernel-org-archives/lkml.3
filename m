Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbbAGRKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:10:35 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35423 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbbAGRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:10:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] documentation: Record limitations of bitfields and small variables
Date: Wed,  7 Jan 2015 09:10:21 -0800
Message-Id: <1420650622-31241-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420650622-31241-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107170950.GA30629@linux.vnet.ibm.com>
 <1420650622-31241-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0017-0000-0000-000007BD3C01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit documents the fact that it is not safe to use bitfields
as shared variables in synchronization algorithms.  It also documents
that CPUs must be able to concurrently load from and store to adjacent
one-byte and two-byte variables, which is in fact required by the
C11 standard (Section 3.14).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 44 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 70a09f8a0383..a10f7cd2619e 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -269,6 +269,50 @@ And there are a number of things that _must_ or _must_not_ be assumed:
 	STORE *(A + 4) = Y; STORE *A = X;
 	STORE {*A, *(A + 4) } = {X, Y};
 
+And there are anti-guarantees:
+
+ (*) These guarantees do not apply to bitfields, because compilers often
+     generate code to modify these using non-atomic read-modify-write
+     sequences.  Do not attempt to use bitfields to synchronize parallel
+     algorithms.
+
+ (*) Even in cases where bitfields are protected by locks, all fields
+     in a given bitfield must be protected by one lock.  If two fields
+     in a given bitfield are protected by different locks, the compiler's
+     non-atomic read-modify-write sequences can cause an update to one
+     field to corrupt the value of an adjacent field.
+
+ (*) These guarantees apply only to properly aligned and sized scalar
+     variables.  "Properly sized" currently means variables that are
+     the same size as "char", "short", "int" and "long".  "Properly
+     aligned" means the natural alignment, thus no constraints for
+     "char", two-byte alignment for "short", four-byte alignment for
+     "int", and either four-byte or eight-byte alignment for "long",
+     on 32-bit and 64-bit systems, respectively.  Note that these
+     guarantees were introduced into the C11 standard, so beware when
+     using older pre-C11 compilers (for example, gcc 4.6).  The portion
+     of the standard containing this guarantee is Section 3.14, which
+     defines "memory location" as follows:
+
+     	memory location
+		either an object of scalar type, or a maximal sequence
+		of adjacent bit-fields all having nonzero width
+
+		NOTE 1: Two threads of execution can update and access
+		separate memory locations without interfering with
+		each other.
+
+		NOTE 2: A bit-field and an adjacent non-bit-field member
+		are in separate memory locations. The same applies
+		to two bit-fields, if one is declared inside a nested
+		structure declaration and the other is not, or if the two
+		are separated by a zero-length bit-field declaration,
+		or if they are separated by a non-bit-field member
+		declaration. It is not safe to concurrently update two
+		bit-fields in the same structure if all members declared
+		between them are also bit-fields, no matter what the
+		sizes of those intervening bit-fields happen to be.
+
 
 =========================
 WHAT ARE MEMORY BARRIERS?
-- 
1.8.1.5

