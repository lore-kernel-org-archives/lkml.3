Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3HMRaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45656 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab3HMR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:57 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 4/6] ARM64: arch_timer: configure and enable event stream
Date: Tue, 13 Aug 2013 18:29:42 +0100
Message-Id: <1376414984-14182-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:53.0127 (UTC) FILETIME=[B8885F70:01CE984A]
X-MC-Unique: 113081318295502801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHUCR6000798

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch configures the event stream frequency and enables it.
It also adds the hwcaps as well as compat-specific definitions to
the user to detect this event stream feature.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[sudeep: moving ARM/ARM64 changes into separate patches]
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm64/include/asm/arch_timer.h | 12 ++++++++++--
 arch/arm64/include/asm/hwcap.h      |  4 +++-
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/setup.c           |  1 +
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 69f5c8e..43f322a 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -106,14 +106,22 @@ static inline void arch_counter_set_user_access(int divider)
 	/* Disable user access to the timers and the physical counter. */
 	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
 			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_EVT_TRIGGER_MASK
 			| ARCH_TIMER_USR_PCT_ACCESS_EN);
 
-	/* Enable user access to the virtual counter. */
-	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+	/* Enable event stream and user access to the virtual counter */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_VCT_ACCESS_EN;
 
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
+static inline void arch_timer_set_hwcap_evtstrm(void)
+{
+	elf_hwcap |= HWCAP_EVTSTRM;
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 6d4482f..effd8f9 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -30,6 +30,7 @@
 #define COMPAT_HWCAP_IDIVA	(1 << 17)
 #define COMPAT_HWCAP_IDIVT	(1 << 18)
 #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
+#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
 
 #ifndef __ASSEMBLY__
 /*
@@ -41,7 +42,8 @@
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
 				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
 				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
-				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
+				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
+				 COMPAT_HWCAP_EVTSTRM)
 
 extern unsigned int elf_hwcap;
 #endif
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index eea4975..9b12476 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -21,6 +21,7 @@
  */
 #define HWCAP_FP		(1 << 0)
 #define HWCAP_ASIMD		(1 << 1)
+#define HWCAP_EVTSTRM		(1 << 2)
 
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index add6ea6..1111833 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -309,6 +309,7 @@ subsys_initcall(topology_init);
 static const char *hwcap_str[] = {
 	"fp",
 	"asimd",
+	"evtstrm",
 	NULL
 };
 
-- 
1.8.1.2


