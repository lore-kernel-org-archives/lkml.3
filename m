Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaCDQnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:43:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbaCDQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:43:12 -0500
Date: Tue, 4 Mar 2014 08:42:36 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-929320e4b4c10708d3477d7e395f0ce7b0cc8744@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, kys@microsoft.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        peterz@infradead.org, kys@microsoft.com, tglx@linutronix.de
In-Reply-To: <20140223212738.681855582@linutronix.de>
References: <20140223212738.681855582@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86:
  Add proper vector accounting for HYPERVISOR_CALLBACK_VECTOR
Git-Commit-ID: 929320e4b4c10708d3477d7e395f0ce7b0cc8744
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

Commit-ID:  929320e4b4c10708d3477d7e395f0ce7b0cc8744
Gitweb:     http://git.kernel.org/tip/929320e4b4c10708d3477d7e395f0ce7b0cc8744
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:20 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:54 +0100

x86: Add proper vector accounting for HYPERVISOR_CALLBACK_VECTOR

HyperV abuses a device interrupt to account for the
HYPERVISOR_CALLBACK_VECTOR.

Provide proper accounting as we have for the other vectors as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: x86 <x86@kernel.org>
Link: http://lkml.kernel.org/r/20140223212738.681855582@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hardirq.h | 3 +++
 arch/x86/kernel/irq.c          | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index ab0ae1a..afb6536 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -33,6 +33,9 @@ typedef struct {
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
 #endif
+#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	unsigned int irq_hv_callback_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d99f31d..42805fa 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -125,6 +125,12 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
+#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	seq_printf(p, "%*s: ", prec, "THR");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
+	seq_printf(p, "  Hypervisor callback interrupts\n");
+#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
