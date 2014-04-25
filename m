Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaDYJhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:37:11 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24920 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752078AbaDYJbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:23 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 6/7] ARM: rtc: update CMOS RTC to support MMIO and private lock
Date: Fri, 25 Apr 2014 10:31:14 +0100
Message-Id: <1398418275-9671-7-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, the CMOS RTC (PC-style mc146818) has always been used
through an ISA I/O port of some sort, with each platform configuring
the address in a static way.

Some platforms (KVM with kvmtools, for example) offer a MMIO version
of the CMOS RTC, which requires a different access method.

This patch select the RTC_DRV_CMOS_MMIO configuration in order to
support MMIO accesses as well as the older IO port method.

While we're at it, switch to RTC_DRV_CMOS_PRIV_LOCK and remove the
ancient rtc_lock.

Tested on Cortex-A7 with KVM and kvmtools.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/time.c | 7 -------
 drivers/rtc/Kconfig    | 2 ++
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 829a96d..38c8718 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -32,13 +32,6 @@
 #include <asm/stacktrace.h>
 #include <asm/thread_info.h>
 
-#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || \
-    defined(CONFIG_NVRAM) || defined(CONFIG_NVRAM_MODULE)
-/* this needs a better home */
-DEFINE_SPINLOCK(rtc_lock);
-EXPORT_SYMBOL(rtc_lock);
-#endif	/* pc-style 'CMOS' RTC support */
-
 /* change this if you have some constant time drift */
 #define USECS_PER_JIFFY	(1000000/HZ)
 
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 12bc27d..b2a512e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -662,6 +662,8 @@ config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ARM || M32R || PPC || MIPS || SPARC64
 	default y if X86
+	select RTC_DRV_CMOS_MMIO if ARM
+	select RTC_DRV_CMOS_PRIV_LOCK if ARM
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
-- 
1.8.3.4

