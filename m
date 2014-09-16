Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaIPTyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:54:49 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:49088 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbaIPTyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:54:47 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] frv: Remove unused cpuinfo_frv and friends to fix future build error
Date: Tue, 16 Sep 2014 21:54:50 +0200
Message-Id: <1410897290-27815-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frv has a macro named cpu_data, interfering with variables and struct
members with the same name:

include/linux/pm_domain.h:75:24: error: expected identifier or '('
before '&' token
  struct gpd_cpu_data *cpu_data;

As struct cpuinfo_frv, boot_cpu_data, cpu_data, and current_cpu_data are
not used, removed them to fix this.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
There are a few more waiting for this to happen:

arch/m32r/include/asm/processor.h:#define cpu_data (&boot_cpu_data)
arch/mn10300/include/asm/processor.h:#define cpu_data &boot_cpu_data
arch/um/include/asm/processor-generic.h:#define cpu_data (&boot_cpu_data)

 arch/frv/include/asm/processor.h | 16 ----------------
 arch/frv/kernel/setup.c          |  2 --
 2 files changed, 18 deletions(-)

diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index 6554e78893f26bc8..ae8d423e79d9dbe5 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -35,22 +35,6 @@
 struct task_struct;
 
 /*
- *  CPU type and hardware bug flags. Kept separately for each CPU.
- */
-struct cpuinfo_frv {
-#ifdef CONFIG_MMU
-	unsigned long	*pgd_quick;
-	unsigned long	*pte_quick;
-	unsigned long	pgtable_cache_sz;
-#endif
-} __cacheline_aligned;
-
-extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
-
-#define cpu_data		(&boot_cpu_data)
-#define current_cpu_data	boot_cpu_data
-
-/*
  * Bus types
  */
 #define EISA_bus 0
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 9f3a7a62d7873dc2..9f4a9a607dbe68fd 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -104,8 +104,6 @@ unsigned long __nongprelbss dma_coherent_mem_end;
 unsigned long __initdata __sdram_old_base;
 unsigned long __initdata num_mappedpages;
 
-struct cpuinfo_frv __nongprelbss boot_cpu_data;
-
 char __initdata command_line[COMMAND_LINE_SIZE];
 char __initdata redboot_command_line[COMMAND_LINE_SIZE];
 
-- 
1.9.1

