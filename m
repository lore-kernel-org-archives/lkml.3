Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3HWQVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:21:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55979 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3HWQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:20:24 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v4 2/5] ARM: arch_timer: add support to configure and enable event stream
Date: Fri, 23 Aug 2013 17:19:06 +0100
Message-Id: <1377274749-6196-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1377274749-6196-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 23 Aug 2013 16:20:22.0391 (UTC) FILETIME=[AAB61070:01CEA01C]
X-MC-Unique: 113082317202301401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7NGLiZT008001

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch adds support for configure the event stream frequency
and enabling it.

It also adds the hwcaps definitions to the user to detect this event
stream feature.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h | 36 +++++++++++++++++++++++++++++++-----
 arch/arm/include/uapi/asm/hwcap.h |  1 +
 arch/arm/kernel/setup.c           |  1 +
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 9ef74da..9617327 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -89,21 +89,47 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline u32 arch_timer_get_cntkctl(void)
 {
 	u32 cntkctl;
-
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
+	return cntkctl;
+}
+
+static inline void arch_timer_set_cntkctl(u32 cntkctl)
+{
+	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
+}
+
+static inline void arch_counter_set_user_access(void)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
 
 	/* Disable user access to both physical/virtual counters/timers. */
-	/* Also disable virtual event stream */
 	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
 			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
 			| ARCH_TIMER_USR_VCT_ACCESS_EN
 			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+	arch_timer_set_cntkctl(cntkctl);
+}
 
-	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
+static inline void arch_timer_evtstrm_config(bool enable, int divider)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+	if (enable) {
+		cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+		/* Set the divider and enable virtual event stream */
+		cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+				| ARCH_TIMER_VIRT_EVT_EN;
+	} else {
+		cntkctl &= ~ARCH_TIMER_VIRT_EVT_EN; /* disable event stream */
+	}
+	arch_timer_set_cntkctl(cntkctl);
+}
+
+static inline void arch_timer_set_hwcap_evtstrm(void)
+{
+	elf_hwcap |= HWCAP_EVTSTRM;
 }
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


