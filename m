Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaJ1WFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:05:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51697 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaJ1WEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:04:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/5] documentation: Record limitations of bitfields and small variables
Date: Tue, 28 Oct 2014 15:00:13 -0700
Message-Id: <1414533617-25933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141028215937.GA25095@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-00000280415D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit documents the fact that it is not safe to use bitfields
as shared variables in synchronization algorithms.  It also documents
that CPUs must provide one-byte and two-byte normal load and store
instructions in order to be supported by the Linux kernel.  (Michael
Cree has agreed to the resulting non-support of pre-EV56 Alpha CPUs:
https://lkml.org/lkml/2014/9/5/143.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 22a969cdd476..d6bc77eb179a 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -269,6 +269,37 @@ And there are a number of things that _must_ or _must_not_ be assumed:
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
+     on 32-bit and 64-bit systems, respectively.  Note that this means
+     that the Linux kernel does not support pre-EV56 Alpha CPUs,
+     because these older CPUs do not provide one-byte and two-byte
+     load and store instructions.  (In theory, the pre-EV56 Alpha CPUs
+     can emulate these instructions using load-linked/store-conditional
+     instructions, but in practice this approach has excessive overhead.
+     Keep in mind that this emulation would be required on -all- single-
+     and double-byte loads and stores in order to handle adjacent bytes
+     protected by different locks.)
+
+     Alpha EV56 and later Alpha CPUs are still supported.
+
 
 =========================
 WHAT ARE MEMORY BARRIERS?
-- 
1.8.1.5

