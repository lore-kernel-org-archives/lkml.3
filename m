Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaA1Vxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:53:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaA1Vx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:53:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3] x86, irq: get correct available vectors for cpu disable
Date: Tue, 28 Jan 2014 13:54:05 -0800
Message-Id: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

used_vectors is a bitmap for vectors that are not tracked in per_cpu
vector_irq.
used_vectors contains information on the first 32 exceptions, the system vectors.
the IA32_SYSCALL_VECTOR (0x80), and the IRQ_MOVE_CLEANUP_VECTOR (0x20).

assign_irq_vectors() assigns vectors up to first_system_vector and
it will not use vectors that are set used_vectors.

This patch modifies the code to scan up to first_system_vector
and do a test on the used_vectors bitmap.

So count avaiable vectors correctly.

-v2: fix compiling problem.
-v3: update changelog and commets

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/irq.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/desc.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -321,8 +322,21 @@ int check_irq_vectors_for_cpu_disable(vo
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
 			continue;
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-		     vector++) {
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
 			if (per_cpu(vector_irq, cpu)[vector] < 0)
 				count++;
 		}
