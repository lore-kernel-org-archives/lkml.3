Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaFLVB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:01:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56874 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaFLVBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:01:23 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 2/2] x86, kaslr: boot-time selectable with hibernation
Date: Thu, 12 Jun 2014 14:00:33 -0700
Message-Id: <1402606833-9825-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402606833-9825-1-git-send-email-keescook@chromium.org>
References: <1402606833-9825-1-git-send-email-keescook@chromium.org>
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
 kernel/power/hibernate.c            |    6 ++++++
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index f8f0466b8b1d..884904975d0b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1474,6 +1474,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
@@ -2110,10 +2117,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index fd3e785dbc37..c1e0daa032b3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1150,6 +1150,11 @@ static int __init nohibernate_setup(char *str)
 	return 1;
 }
 
+static int __init kaslr_nohibernate_setup(char *str)
+{
+	return nohibernate_setup(str);
+}
+
 __setup("noresume", noresume_setup);
 __setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
@@ -1157,3 +1162,4 @@ __setup("hibernate=", hibernate_setup);
 __setup("resumewait", resumewait_setup);
 __setup("resumedelay=", resumedelay_setup);
 __setup("nohibernate", nohibernate_setup);
+__setup("kaslr", kaslr_nohibernate_setup);
-- 
1.7.9.5

