Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3HWQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:41:30 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17379 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab3HWQl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:41:29 -0400
Message-ID: <5217908E.2040702@siemens.com>
Date: Fri, 23 Aug 2013 18:40:46 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        H Peter Anvin <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: x86-32: Early microcode loading stumbles over disabled DYNAMIC_FTRACE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

32-bit kernels currently crash/reboot in early microcode loading when
non-dynamic function tracing is enabled. Several functions in that path
get instrumented with mcount, but its non-dynamic implementation does
not work before paging is enabled (it accesses global variables at wrong
addresses).

Below some hunks to get it working again - at least in the absence of
any microcode in the initrd. Marking all involved functions as __init is
another option (as __init implies notrace). But I bet there is more
hidden. I see e.g. a pr_warn() in find_cpio_init that should trigger the
issue as well if we hit the error it reports (btw. printing at this
point of the boot should not work anyway, should it?).

Better ideas?

Jan


diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 88d99ea..c093a9c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,9 @@ CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_microcode_core_early.o = -pg
+CFLAGS_REMOVE_microcode_intel_early.o = -pg
+CFLAGS_REMOVE_microcode_amd_early.o = -pg
 endif

 CFLAGS_irq.o := -I$(src)/../include/asm/trace
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 96b2c66..0917142 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,6 +2,10 @@
 # Makefile for x86 specific library files.
 #

+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_string_32.o = -pg
+endif
+
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
