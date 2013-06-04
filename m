Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3FDAUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 20:20:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55982 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606Ab3FDAUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 20:20:19 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] msm: platsmp: Consolidate write to pen_release
Date: Mon,  3 Jun 2013 17:19:43 -0700
Message-Id: <1370305185-6450-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org>
References: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the pen variable in one place.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 00cdb0a..2028f3f 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -32,6 +32,14 @@ extern void msm_secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
 
+static void __cpuinit write_pen_release(int val)
+{
+	pen_release = val;
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
+}
+
 static inline int get_core_count(void)
 {
 	/* 1 + the PART[1:0] field of MIDR */
@@ -44,8 +52,7 @@ static void __cpuinit msm_secondary_init(unsigned int cpu)
 	 * let the primary processor know we're out of the
 	 * pen, then head off into the C entry point
 	 */
-	pen_release = -1;
-	smp_wmb();
+	write_pen_release(-1);
 
 	/*
 	 * Synchronise with the boot thread.
@@ -98,9 +105,7 @@ static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *id
 	 * Note that "pen_release" is the hardware CPU ID, whereas
 	 * "cpu" is Linux's internal ID.
 	 */
-	pen_release = cpu_logical_map(cpu);
-	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
-	outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
+	write_pen_release(cpu_logical_map(cpu));
 
 	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

