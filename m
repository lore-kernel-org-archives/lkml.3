Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161245AbaKNPzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:55:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63799 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965708AbaKNPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:43 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] arm64: protect alternatives workarounds with Kconfig options
Date: Fri, 14 Nov 2014 15:54:12 +0000
Message-Id: <1415980452-20366-7-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all of the errata we have workarounds for apply necessarily to all
SoCs, so people compiling a kernel for one very specific SoC may not
need to patch the kernel.
Introduce a new submenu in the "Platform selection" menu to allow
people to turn off certain bugs if they are not affected. By default
all of them are enabled.
Normal users or distribution kernels shouldn't bother to deselect any
bugs here, since the alternatives framework will take care of
patching them in only if needed.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/Kconfig             |  107 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c |   14 ++++++
 2 files changed, 121 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..e484aaa 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -162,6 +162,113 @@ config ARCH_XGENE
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
 
+menu "ARM errata workarounds via the alternatives framework"
+
+config ARM64_ERRATUM_826319
+	bool "Cortex-A53: 826319: System might deadlock if a write cannot complete until read data is accepted"
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 826319 on Cortex-A53 parts up to r0p2 with an AMBA 4 ACE or
+	  AXI master interface and an L2 cache.
+
+	  If a Cortex-A53 uses an AMBA AXI4 ACE interface to other processors
+	  and is unable to accept a certain write via this interface, it will
+	  not progress on read data presented on the read data channel and the
+	  system can deadlock.
+
+	  The workaround promotes data cache clean instructions to
+	  data cache clean-and-invalidate.
+	  Please note that this does not necessarily enable the workaround,
+	  as it depends on the alternative framework, which will only patch
+	  the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
+config ARM64_ERRATUM_827319
+	bool "Cortex-A53: 827319: Data cache clean instructions might cause overlapping transactions to the interconnect"
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 827319 on Cortex-A53 parts up to r0p2 with an AMBA 5 CHI
+	  master interface and an L2 cache.
+
+	  Under certain conditions this erratum can cause a clean line eviction
+	  to occur at the same time as another transaction to the same address
+	  on the AMBA 5 CHI interface, which can cause data corruption if the
+	  interconnect reorders the two transactions.
+
+	  The workaround promotes data cache clean instructions to
+	  data cache clean-and-invalidate.
+	  Please note that this does not necessarily enable the workaround,
+	  as it depends on the alternative framework, which will only patch
+	  the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
+config ARM64_ERRATUM_824069
+	bool "Cortex-A53: 824069: Cache line might not be marked as clean after a CleanShared snoop"
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 824069 on Cortex-A53 parts up to r0p2 when it is connected
+	  to a coherent interconnect.
+
+	  If a Cortex-A53 processor is executing a store or prefetch for
+	  write instruction at the same time as a processor in another
+	  cluster is executing a cache maintenance operation to the same
+	  address, then this erratum might cause a clean cache line to be
+	  incorrectly marked as dirty.
+
+	  The workaround promotes data cache clean instructions to
+	  data cache clean-and-invalidate.
+	  Please note that this option does not necessarily enable the
+	  workaround, as it depends on the alternative framework, which will
+	  only patch the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
+config ARM64_ERRATUM_819472
+	bool "Cortex-A53: 819472: Store exclusive instructions might cause data corruption"
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 819472 on Cortex-A53 parts up to r0p1 with an L2 cache
+	  present when it is connected to a coherent interconnect.
+
+	  If the processor is executing a load and store exclusive sequence at
+	  the same time as a processor in another cluster is executing a cache
+	  maintenance operation to the same address, then this erratum might
+	  cause data corruption.
+
+	  The workaround promotes data cache clean instructions to
+	  data cache clean-and-invalidate.
+	  Please note that this does not necessarily enable the workaround,
+	  as it depends on the alternative framework, which will only patch
+	  the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
+config ARM64_ERRATUM_832075
+	bool "Cortex-A57: possible deadlock on mixing exclusive memory accesses with device loads"
+	default y
+	help
+	  This option adds an alternative code sequence to work around ARM
+	  erratum 832075 on Cortex-A57 parts up to r1p2.
+
+	  Affected Cortex-A57 parts might deadlock when exclusive load/store
+	  instructions to Write-Back memory are mixed with Device loads.
+
+	  The workaround is to promote device loads to use Load-Acquire
+	  semantics.
+	  Please note that this does not necessarily enable the workaround,
+	  as it depends on the alternative framework, which will only patch
+	  the kernel if an affected CPU is detected.
+
+	  If unsure, say Y.
+
+endmenu
+
 endmenu
 
 menu "Bus support"
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index f232849..2a66456 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -64,18 +64,32 @@ static bool is_affected_midr_range(struct arm64_cpu_capabilities *entry)
 	.midr_range_max = max
 
 struct arm64_cpu_capabilities arm64_errata[] = {
+#if	defined(CONFIG_ARM64_ERRATUM_826319) || \
+	defined(CONFIG_ARM64_ERRATUM_827319) || \
+	defined(CONFIG_ARM64_ERRATUM_824069)
 	{
 	/* Cortex-A53 r0p[012] */
 		.desc = "ARM errata 826319, 827319, 824069",
 		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
 		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x02),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_819472
+	{
+	/* Cortex-A53 r0p[01] */
+		.desc = "ARM errata 819472",
+		.capability = ARM64_WORKAROUND_CLEAN_CACHE,
+		MIDR_RANGE(MIDR_CORTEX_A53, 0x00, 0x01),
+	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_832075
 	{
 	/* Cortex-A57 r0p0 - r1p2 */
 		.desc = "ARM erratum 832075",
 		.capability = ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE,
 		MIDR_RANGE(MIDR_CORTEX_A57, 0x00, 0x12),
 	},
+#endif
 	{
 	}
 };
-- 
1.7.9.5

