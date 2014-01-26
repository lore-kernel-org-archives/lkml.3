Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaAZUeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:34:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38086 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaAZUeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:34:19 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, irq: get correct available vectors for cpu disable
Date: Sun, 26 Jan 2014 12:34:54 -0800
Message-Id: <1390768494-17251-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

assign_irq_vector will stop before first_system_vector.
also it will not vector that is set in used_vectors.

used_vectors is used to track non per_cpu irq_vector in vector_irq.
It include first 32 exception [0,1f) and system vector near 0xfe.
and IA32_SYSCALL_VECTOR (0x80), IRQ_MOVE_CLEANUP_VECTOR (0x20).

So add checking for them for counting avaiable vectors.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/irq.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -321,8 +321,19 @@ int check_irq_vectors_for_cpu_disable(vo
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
 			continue;
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-		     vector++) {
+
+		/*
+		 * assign_irq_vector() only use vector under
+		 * first_system_vector and not set in used_vectors bitmask.
+		 * used_vectors could have bits set for
+		 *	IA32_SYSCALL_VECTOR (0x80)
+		 *	IRQ_MOVE_CLEANUP_VECTOR (0x20)
+		 */
+		for (vector = FIRST_EXTERNAL_VECTOR;
+		     vector < first_system_vector; vector++) {
+			if (test_bit(vector, used_vectors)
+				continue;
+
 			if (per_cpu(vector_irq, cpu)[vector] < 0)
 				count++;
 		}
