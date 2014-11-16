Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaKPATt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:19:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62238 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbaKPATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:45 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 16/22] MIPS: BMIPS: Add special cache handling in c-r4k.c
Date: Sat, 15 Nov 2014 16:17:40 -0800
Message-Id: <1416097066-20452-17-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BMIPS435x and BMIPS438x have a single shared L1 D$ and load/store unit,
so it isn't necessary to raise IPIs to keep both CPUs coherent.

BMIPS5000 has VIPT L1 caches that handle aliases in hardware, and its I$
fills from D$.  But a special sequence with 2 SYNCs and 32 NOPs is needed
to ensure coherency.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/mm/c-r4k.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index fbcd867..dd261df 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -917,6 +917,18 @@ static inline void alias_74k_erratum(struct cpuinfo_mips *c)
 	}
 }
 
+static void b5k_instruction_hazard(void)
+{
+	__sync();
+	__sync();
+	__asm__ __volatile__(
+	"       nop; nop; nop; nop; nop; nop; nop; nop\n"
+	"       nop; nop; nop; nop; nop; nop; nop; nop\n"
+	"       nop; nop; nop; nop; nop; nop; nop; nop\n"
+	"       nop; nop; nop; nop; nop; nop; nop; nop\n"
+	: : : "memory");
+}
+
 static char *way_string[] = { NULL, "direct mapped", "2-way",
 	"3-way", "4-way", "5-way", "6-way", "7-way", "8-way"
 };
@@ -1683,6 +1695,37 @@ void r4k_cache_init(void)
 
 	coherency_setup();
 	board_cache_error_setup = r4k_cache_error_setup;
+
+	/*
+	 * Per-CPU overrides
+	 */
+	switch (current_cpu_type()) {
+	case CPU_BMIPS4350:
+	case CPU_BMIPS4380:
+		/* No IPI is needed because all CPUs share the same D$ */
+		flush_data_cache_page = r4k_blast_dcache_page;
+		break;
+	case CPU_BMIPS5000:
+		/* We lose our superpowers if L2 is disabled */
+		if (c->scache.flags & MIPS_CACHE_NOT_PRESENT)
+			break;
+
+		/* I$ fills from D$ just by emptying the write buffers */
+		flush_cache_page = (void *)b5k_instruction_hazard;
+		flush_cache_range = (void *)b5k_instruction_hazard;
+		flush_cache_sigtramp = (void *)b5k_instruction_hazard;
+		local_flush_data_cache_page = (void *)b5k_instruction_hazard;
+		flush_data_cache_page = (void *)b5k_instruction_hazard;
+		flush_icache_range = (void *)b5k_instruction_hazard;
+		local_flush_icache_range = (void *)b5k_instruction_hazard;
+
+		/* Cache aliases are handled in hardware; allow HIGHMEM */
+		current_cpu_data.dcache.flags &= ~MIPS_CACHE_ALIASES;
+
+		/* Optimization: an L2 flush implicitly flushes the L1 */
+		current_cpu_data.options |= MIPS_CPU_INCLUSIVE_CACHES;
+		break;
+	}
 }
 
 static int r4k_cache_pm_notifier(struct notifier_block *self, unsigned long cmd,
-- 
2.1.1

