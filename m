Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaEMPkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbaEMPkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:40:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        Andi Kleen <ak@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] x86, irq: get correct available vectors for cpu disable
Date: Tue, 13 May 2014 11:39:34 -0400
Message-Id: <1399995575-3129-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1399995575-3129-1-git-send-email-prarit@redhat.com>
References: <1399995575-3129-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

check_irq_vectors_for_cpu_disable() may overestimate the number of
available vectors assigned to a cpu.  This can cause cpu remove to
erroneously fail.

commit da6139e49c7cb0f4251265cb5243b8d220adb48d,  x86: Add check for
number of available vectors before CPU down, introduces a check to see if
there are enough empty vectors in the system to replace a downed cpu's
vectors.  Code inspection shows that the range used in the check
(currently from FIRST_EXTERNAL_VECTOR to NR_VECTORS) is incorrect and
should be FIRST_EXTERNAL_VECTOR to first_system_vector.  The value of
first_system_vector is decremented when system vectors are assigned in
alloc_system_vector().

The check_irq_vectors_for_cpu_disable() check also does not take into
account the first 32 system vectors which are not managed in the per_cpu
vector_irq arrays, including IA32_SYSCALL_VECTOR (0x80) and the
IRQ_MOVE_CLEANUP_VECTOR (0x20).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/irq.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 283a76a..d03ff8f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/desc.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -334,10 +335,24 @@ int check_irq_vectors_for_cpu_disable(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
 			continue;
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-		     vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] < 0)
+
+		/*
+		 * assign_irq_vector() only scan per_cpu vectors from
+		 * FIRST_EXTERNAL_VECTOR to first_system_vector.
+		 * It aslo skip vectors that are set in used_vectors bitmask.
+		 * used_vectors could have bits set for
+		 *	IA32_SYSCALL_VECTOR (0x80)
+		 *	IRQ_MOVE_CLEANUP_VECTOR (0x20)
+		 * Don't count those as available vectors.
+		 */
+		for (vector = FIRST_EXTERNAL_VECTOR;
+		     vector < first_system_vector; vector++) {
+			if (test_bit(vector, used_vectors))
+				continue;
+
+			if (per_cpu(vector_irq, cpu)[vector] < 0) {
 				count++;
+			}
 		}
 	}
 
-- 
1.7.9.3

