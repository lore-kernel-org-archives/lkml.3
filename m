Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaAQCFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:05:39 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48415 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaAQCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:05:36 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 1/3] ACPI / idle: Move idle_boot_override out of the arch directory
Date: Fri, 17 Jan 2014 10:03:25 +0800
Message-Id: <1389924207-7360-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org>
References: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move idle_boot_override out of the arch directory to be a single enum
including both platforms values, this will make it rather easier to
avoid ifdefs around which definitions are for which processor in
generally used ACPI code.

IDLE_FORCE_MWAIT for IA64 is not used anywhere, so romove it.

No functional change in this patch.

Suggested-by: Alan <gnomes@lxorguk.ukuu.org.uk>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/ia64/include/asm/processor.h    | 3 ---
 arch/powerpc/include/asm/processor.h | 1 -
 arch/x86/include/asm/processor.h     | 3 ---
 arch/x86/kernel/process.c            | 1 +
 include/linux/cpu.h                  | 8 ++++++++
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 5a84b3a..ccd63a0 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -698,9 +698,6 @@ prefetchw (const void *x)
 
 extern unsigned long boot_option_idle_override;
 
-enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
-			 IDLE_NOMWAIT, IDLE_POLL};
-
 void default_idle(void);
 
 #define ia64_platform_is(x) (strcmp(x, ia64_platform_name) == 0)
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index fc14a38..06689c0 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -440,7 +440,6 @@ static inline unsigned long get_clean_sp(unsigned long sp, int is_32)
 #endif
 
 extern unsigned long cpuidle_disable;
-enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 extern void power7_nap(void);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..4bee51a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -729,9 +729,6 @@ extern void init_amd_e400_c1e_mask(void);
 extern unsigned long		boot_option_idle_override;
 extern bool			amd_e400_c1e_detected;
 
-enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_NOMWAIT,
-			 IDLE_POLL};
-
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95..62764ff 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -17,6 +17,7 @@
 #include <linux/stackprotector.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
+#include <linux/cpu.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad..e324561 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -220,6 +220,14 @@ void cpu_idle(void);
 
 void cpu_idle_poll_ctrl(bool enable);
 
+enum idle_boot_override {
+	IDLE_NO_OVERRIDE = 0,
+	IDLE_HALT,
+	IDLE_NOMWAIT,
+	IDLE_POLL,
+	IDLE_POWERSAVE_OFF
+};
+
 void arch_cpu_idle(void);
 void arch_cpu_idle_prepare(void);
 void arch_cpu_idle_enter(void);
-- 
1.8.2.2

