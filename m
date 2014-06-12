Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaFLTsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:48:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56756 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaFLTsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:48:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 2/2] x86, kaslr: boot-time selectable with hibernation
Date: Thu, 12 Jun 2014 12:46:59 -0700
Message-Id: <1402602419-27934-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402602419-27934-1-git-send-email-keescook@chromium.org>
References: <1402602419-27934-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes kASLR from being compile-time selectable (blocked by
CONFIG_HIBERNATION), to being boot-time selectable (with hibernation
available by default) via the "kaslr" kernel command line.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/kernel-parameters.txt |   11 +++++++----
 arch/x86/Kconfig                    |    1 -
 arch/x86/boot/compressed/aslr.c     |    9 ++++++++-
 kernel/power/hibernate.c            |    7 +++++++
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b9f67781c577..ea0430de1e52 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1464,6 +1464,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
+	kaslr/nokaslr	[X86]
+			Enable/disable kernel and module base offset ASLR
+			(Address Space Layout Randomization) if built into
+			the kernel. When CONFIG_HIBERNATION is selected,
+			kASLR is disabled by default. When kASLR is enabled,
+			hibernation will be disabled.
+
 	keepinitrd	[HW,ARM]
 
 	kernelcore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
@@ -2100,10 +2107,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
-	nokaslr		[X86]
-			Disable kernel and module base offset ASLR (Address
-			Space Layout Randomization) if built into the kernel.
-
 	noautogroup	Disable scheduler automatic task group creation.
 
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b660088c220d..7fdb639f1b63 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1671,7 +1671,6 @@ config RELOCATABLE
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image"
 	depends on RELOCATABLE
-	depends on !HIBERNATION
 	default n
 	---help---
 	   Randomizes the physical and virtual address at which the
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 4dbf967da50d..fc6091abedb7 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -289,10 +289,17 @@ unsigned char *choose_kernel_location(unsigned char *input,
 	unsigned long choice = (unsigned long)output;
 	unsigned long random;
 
+#ifdef CONFIG_HIBERNATION
+	if (!cmdline_find_option_bool("kaslr")) {
+		debug_putstr("KASLR disabled by default...\n");
+		goto out;
+	}
+#else
 	if (cmdline_find_option_bool("nokaslr")) {
-		debug_putstr("KASLR disabled...\n");
+		debug_putstr("KASLR disabled by cmdline...\n");
 		goto out;
 	}
+#endif
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 32672da81114..4aba1621b59c 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -67,6 +67,13 @@ bool hibernation_available(void)
 	return (hibernation_mode > HIBERNATION_DISABLED);
 }
 
+static int __init parse_kaslr(char *p)
+{
+	hibernation_mode = HIBERNATION_DISABLED;
+	return 0;
+}
+early_param("kaslr", parse_kaslr);
+
 /**
  * hibernation_set_ops - Set the global hibernate operations.
  * @ops: Hibernation operations to use in subsequent hibernation transitions.
-- 
1.7.9.5

