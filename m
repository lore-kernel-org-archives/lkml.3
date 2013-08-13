Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab3HMRaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45638 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3HMR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:56 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3 3/6] ARM: arch_timer: configure and enable event stream
Date: Tue, 13 Aug 2013 18:29:41 +0100
Message-Id: <1376414984-14182-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:52.0361 (UTC) FILETIME=[B8137D90:01CE984A]
X-MC-Unique: 113081318295406301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHVtpx000831

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch configures the event stream frequency and enables it.
It also adds the hwcaps definitions to the user to detect this event
stream feature.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[sudeep: moving ARM/ARM64 changes into separate patches]
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h | 11 +++++++++--
 arch/arm/include/uapi/asm/hwcap.h |  1 +
 arch/arm/kernel/setup.c           |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 12f3fac..25abeb5 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -96,15 +96,22 @@ static inline void arch_counter_set_user_access(int divider)
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
 
 	/* Disable user access to both physical/virtual counters/timers. */
-	/* Also disable virtual event stream */
 	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
 			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_EVT_TRIGGER_MASK
 			| ARCH_TIMER_USR_VCT_ACCESS_EN
 			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+	/* Set the divider and enable virtual event stream */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
+
+static inline void arch_timer_set_hwcap_evtstrm(void)
+{
+	elf_hwcap |= HWCAP_EVTSTRM;
+}
 #endif
 
 #endif
diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
index 6d34d08..7dcc10d 100644
--- a/arch/arm/include/uapi/asm/hwcap.h
+++ b/arch/arm/include/uapi/asm/hwcap.h
@@ -26,5 +26,6 @@
 #define HWCAP_VFPD32	(1 << 19)	/* set if VFP has 32 regs (not 16) */
 #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
 #define HWCAP_LPAE	(1 << 20)
+#define HWCAP_EVTSTRM	(1 << 21)
 
 #endif /* _UAPI__ASMARM_HWCAP_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index afc2489..305ffc9 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -975,6 +975,7 @@ static const char *hwcap_str[] = {
 	"idivt",
 	"vfpd32",
 	"lpae",
+	"evtstrm",
 	NULL
 };
 
-- 
1.8.1.2


