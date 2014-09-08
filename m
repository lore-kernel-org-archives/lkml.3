Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaIHQPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:15:31 -0400
Received: from amersmtp1.software.dell.com ([12.106.87.226]:49627 "EHLO
	amersmtp1.software.dell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbaIHQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:15:29 -0400
From: Ted Percival <ted@tedp.id.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Christoph Lameter <cl@linux.com>, Ted Percival <ted@tedp.id.au>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
CC: "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, apic: Fix unmasked CPU initialization
Date: Mon, 8 Sep 2014 10:15:37 -0600
Message-ID: <1410192947-6830-1-git-send-email-ted@tedp.id.au>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Mlf-Version: 7.4.4.8437
X-Mlf-UniqueId: o201409081615290178841
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4ba2968420fa removed the application of the CPU mask resulting
in a hang when initializing the first CPU at boot:

  x86: Booting SMP configuration
  .... node  #0, CPUs:      #1_

Fixes: 4ba2968420fa ("percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t")
Signed-off-by: Ted Percival <ted@tedp.id.au>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 1f5d5f2..e658f21 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -43,6 +43,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	 * and be sure it's manipulated with irq off.
 	 */
 	ipi_mask_ptr = this_cpu_cpumask_var_ptr(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
 
 	/*
 	 * The idea is to send one IPI per cluster.
-- 
1.9.1

