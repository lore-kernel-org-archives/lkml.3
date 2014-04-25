Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaDYJb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:31:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24907 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbaDYJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:31:21 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 4/7] rtc-cmos: allow strictly MMIO based configurations
Date: Fri, 25 Apr 2014 10:31:12 +0100
Message-Id: <1398418275-9671-5-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
References: <1398418275-9671-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those new fancy architectures lacking any kind of I/O ports,
and unwilling to emulate them, introduce the new config symbol
RTC_DRV_CMOS_MMIO_STRICT, which provides default (and explosive)
legacy I/O port accessors.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/rtc/Kconfig    | 4 ++++
 drivers/rtc/rtc-cmos.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 7e88866..10974f7 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -680,6 +680,10 @@ config RTC_DRV_CMOS
 config RTC_DRV_CMOS_MMIO
 	bool
 
+config RTC_DRV_CMOS_MMIO_STRICT
+	select RTC_DRV_CMOS_MMIO
+	bool
+
 config RTC_DRV_ALPHA
 	bool "Alpha PC-style CMOS"
 	depends on ALPHA
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d535e72..e2d1338 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -70,6 +70,11 @@ static const char driver_name[] = "rtc_cmos";
 #ifdef CONFIG_RTC_DRV_CMOS_MMIO
 static void __iomem *rtc_cmos_base;
 
+#ifdef CONFIG_RTC_DRV_CMOS_MMIO_STRICT
+#define CMOS_READ(reg)		({BUG(); 0;})
+#define CMOS_WRITE(val,reg)	BUG();
+#endif
+
 static u8 do_cmos_read(u8 reg)
 {
 	u8 val;
-- 
1.8.3.4

