Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaFDMXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:23:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaFDMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:23:09 -0400
Date: Wed, 4 Jun 2014 05:22:21 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-ac2a55395eddccd6e3e39532df9869d61e97b2ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, kys@microsoft.com,
        seiji.aguchi@hds.com, Elliott@hp.com, rostedt@goodmis.org,
        ak@linux.intel.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, kys@microsoft.com,
        seiji.aguchi@hds.com, Elliott@hp.com, rostedt@goodmis.org,
        ak@linux.intel.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1400160305-17774-2-git-send-email-prarit@redhat.com>
References: <1400160305-17774-2-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: irq:
  Get correct available vectors for cpu disable
Git-Commit-ID: ac2a55395eddccd6e3e39532df9869d61e97b2ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac2a55395eddccd6e3e39532df9869d61e97b2ee
Gitweb:     http://git.kernel.org/tip/ac2a55395eddccd6e3e39532df9869d61e97b2ee
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 13 May 2014 11:39:34 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 4 Jun 2014 14:18:34 +0200

x86: irq: Get correct available vectors for cpu disable

check_irq_vectors_for_cpu_disable() can overestimate the number of
available interrupt vectors, so the check for cpu down succeeds, but
the actual cpu removal fails.

It iterates from FIRST_EXTERNAL_VECTOR to NR_VECTORS, which is wrong
because the systems vectors are not taken into account.

Limit the search to first_system_vector instead of NR_VECTORS.

The second indicator for vector availability the used_vectors bitmap
is not taken into account at all. So system vectors,
e.g. IA32_SYSCALL_VECTOR (0x80) and IRQ_MOVE_CLEANUP_VECTOR (0x20),
are accounted as available.

Add a check for the used_vectors bitmap and do not account vectors
which are marked there.

[ tglx: Simplified code. Rewrote changelog and code comments. ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/1400160305-17774-2-git-send-email-prarit@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/irq.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 283a76a..11ccfb0 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/desc.h>
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
@@ -334,10 +335,17 @@ int check_irq_vectors_for_cpu_disable(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == this_cpu)
 			continue;
-		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
-		     vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] < 0)
-				count++;
+		/*
+		 * We scan from FIRST_EXTERNAL_VECTOR to first system
+		 * vector. If the vector is marked in the used vectors
+		 * bitmap or an irq is assigned to it, we don't count
+		 * it as available.
+		 */
+		for (vector = FIRST_EXTERNAL_VECTOR;
+		     vector < first_system_vector; vector++) {
+			if (!test_bit(vector, used_vectors) &&
+			    per_cpu(vector_irq, cpu)[vector] < 0)
+					count++;
 		}
 	}
 
