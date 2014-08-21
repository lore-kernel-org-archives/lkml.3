Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaHUMXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:23:49 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61748 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaHUMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:43 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 6/9] x86, mm: Make x86_init.memory_setup() return a const char *
Date: Thu, 21 Aug 2014 14:23:09 +0200
Message-Id: <1408623792-7973-7-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All implementations of x86_init.memory_setup() actually return a const
char *.  Adjust the prototypes to reflect reality.

Also add the missing __init annotation to xen_auto_xlated_memory_setup().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/e820.h     |    4 ++--
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/kernel/e820.c          |    8 ++++----
 arch/x86/lguest/boot.c          |    2 +-
 arch/x86/xen/setup.c            |    4 ++--
 arch/x86/xen/xen-ops.h          |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 779c2efe2e..7d17fb2b16 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -17,7 +17,7 @@ extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
-extern void e820_print_map(char *who);
+extern void e820_print_map(const char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
@@ -59,7 +59,7 @@ extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
-extern char *default_machine_specific_memory_setup(void);
+extern const char *default_machine_specific_memory_setup(void);
 
 /*
  * Returns true iff the specified range [s,e) is completely contained inside
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da96b..64e80c9815 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -42,7 +42,7 @@ struct x86_init_mpparse {
 struct x86_init_resources {
 	void (*probe_roms)(void);
 	void (*reserve_resources)(void);
-	char *(*memory_setup)(void);
+	const char *(*memory_setup)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 988c00a1f6..14323a7c66 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -155,7 +155,7 @@ static void __init e820_print_type(u32 type)
 	}
 }
 
-void __init e820_print_map(char *who)
+void __init e820_print_map(const char *who)
 {
 	int i;
 
@@ -1021,9 +1021,9 @@ void __init e820_reserve_resources_late(void)
 	}
 }
 
-char *__init default_machine_specific_memory_setup(void)
+const char *__init default_machine_specific_memory_setup(void)
 {
-	char *who = "BIOS-e820";
+	const char *who = "BIOS-e820";
 	u32 new_nr;
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
@@ -1061,7 +1061,7 @@ char *__init default_machine_specific_memory_setup(void)
 
 void __init setup_memory_map(void)
 {
-	char *who;
+	const char *who;
 
 	who = x86_init.resources.memory_setup();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aae94132bc..28457edc2f 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1167,7 +1167,7 @@ static struct notifier_block paniced = {
 };
 
 /* Setting up memory is fairly easy. */
-static __init char *lguest_memory_setup(void)
+static __init const char *lguest_memory_setup(void)
 {
 	/*
 	 * The Linux bootloader header contains an "e820" memory map: the
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2e555163c2..fabe61f6f3 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -336,7 +336,7 @@ void xen_ignore_unusable(struct e820entry *list, size_t map_size)
 /**
  * machine_specific_memory_setup - Hook for machine specific memory setup.
  **/
-char * __init xen_memory_setup(void)
+const char * __init xen_memory_setup(void)
 {
 	static struct e820entry map[E820MAX] __initdata;
 
@@ -502,7 +502,7 @@ char * __init xen_memory_setup(void)
 /*
  * Machine specific memory setup for auto-translated guests.
  */
-char * __init xen_auto_xlated_memory_setup(void)
+const char * __init xen_auto_xlated_memory_setup(void)
 {
 	static struct e820entry map[E820MAX] __initdata;
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 28c7e0be56..da12e3413c 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -35,8 +35,8 @@ void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 void xen_set_pat(u64);
 
-char * __init xen_memory_setup(void);
-char * xen_auto_xlated_memory_setup(void);
+const char * __init xen_memory_setup(void);
+const char * __init xen_auto_xlated_memory_setup(void);
 void __init xen_arch_setup(void);
 void xen_enable_sysenter(void);
 void xen_enable_syscall(void);
-- 
1.7.10.4

