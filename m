Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3A2Pyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:54:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37274 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3A2Pyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:54:35 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
Subject: [RFC PATCH 1/2] ARM: kernel: update cpuinfo to print CPU model name
Date: Tue, 29 Jan 2013 17:54:24 +0200
Message-ID: <1359474865-15408-2-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, reading /proc/cpuinfo provides userspace with CPU ID of
the CPU carrying out the read from the file.
Userspace using this information may decide what module
to load or how to configure some specific (and processor-depended)
settings or so.
However, since really different SoCs can share same ARM core,
this information currently is not so useful.
For example, TI OMAP4460 and OMAP4470 SoCs show the same
information in the /proc/cpuinfo whereas they are different.
The "cpuinfo" file looks like exactly that place, where
This information have to be displayed.

So added new line "CPU name" in the "cpuinfo" output for CPU model name

Example:

/ # cat proc/cpuinfo
processor       : 0
model name      : ARMv7 Processor rev 10 (v7l)
BogoMIPS        : 1590.23
Features        : swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
CPU implementer : 0x41
CPU name        : OMAP4470 ES1.0 HS
CPU architecture: 7
CPU variant     : 0x2
CPU part        : 0xc09
CPU revision    : 10
[...]

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/include/asm/setup.h |    1 +
 arch/arm/kernel/setup.c      |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index c50f056..f49de38 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -52,5 +52,6 @@ extern struct meminfo meminfo;
 extern int arm_add_memory(phys_addr_t start, phys_addr_t size);
 extern void early_print(const char *str, ...);
 extern void dump_machine_table(void);
+extern void set_cpu_model_name(char *name);
 
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..6fab2e2 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -134,6 +134,7 @@ char elf_platform[ELF_PLATFORM_SIZE];
 EXPORT_SYMBOL(elf_platform);
 
 static const char *cpu_name;
+static const char *cpu_model_name;
 static const char *machine_name;
 static char __initdata cmd_line[COMMAND_LINE_SIZE];
 struct machine_desc *machine_desc __initdata;
@@ -493,6 +494,11 @@ static void __init setup_processor(void)
 	cpu_init();
 }
 
+void set_cpu_model_name(char *name)
+{
+	cpu_model_name = name;
+}
+
 void __init dump_machine_table(void)
 {
 	struct machine_desc *p;
@@ -880,6 +886,10 @@ static int c_show(struct seq_file *m, void *v)
 				seq_printf(m, "%s ", hwcap_str[j]);
 
 		seq_printf(m, "\nCPU implementer\t: 0x%02x\n", cpuid >> 24);
+
+		if (cpu_model_name)
+			seq_printf(m, "CPU name\t: %s\n", cpu_model_name);
+
 		seq_printf(m, "CPU architecture: %s\n",
 			   proc_arch[cpu_architecture()]);
 
-- 
1.7.9.5

