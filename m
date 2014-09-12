Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaILITU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:19:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:40941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaILISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:18:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="572189650"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Part2 v1 1/2] intel_mid: Kill unused function apbt_quick_calibrate()
Date: Fri, 12 Sep 2014 16:20:38 +0800
Message-Id: <1410510039-12759-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
References: <y>
 <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no user of function apbt_quick_calibrate() anymore, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/apb_timer.h |    2 --
 arch/x86/kernel/apb_timer.c      |   53 --------------------------------------
 2 files changed, 55 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index 0acbac299e49..b61a3fe15d9b 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -32,7 +32,6 @@
 #define APBT_DEV_USED  1
 
 extern void apbt_time_init(void);
-extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
 
@@ -42,7 +41,6 @@ extern int sfi_mtimer_num;
 
 #else /* CONFIG_APB_TIMER */
 
-static inline unsigned long apbt_quick_calibrate(void) {return 0; }
 static inline void apbt_time_init(void) { }
 
 #endif
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index af5b08ab3b71..59180cd0f462 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -372,56 +372,3 @@ out_noapbt:
 	apb_timer_block_enabled = 0;
 	panic("failed to enable APB timer\n");
 }
-
-/* called before apb_timer_enable, use early map */
-unsigned long apbt_quick_calibrate(void)
-{
-	int i, scale;
-	u64 old, new;
-	cycle_t t1, t2;
-	unsigned long khz = 0;
-	u32 loop, shift;
-
-	apbt_set_mapping();
-	dw_apb_clocksource_start(clocksource_apbt);
-
-	/* check if the timer can count down, otherwise return */
-	old = dw_apb_clocksource_read(clocksource_apbt);
-	i = 10000;
-	while (--i) {
-		if (old != dw_apb_clocksource_read(clocksource_apbt))
-			break;
-	}
-	if (!i)
-		goto failed;
-
-	/* count 16 ms */
-	loop = (apbt_freq / 1000) << 4;
-
-	/* restart the timer to ensure it won't get to 0 in the calibration */
-	dw_apb_clocksource_start(clocksource_apbt);
-
-	old = dw_apb_clocksource_read(clocksource_apbt);
-	old += loop;
-
-	t1 = __native_read_tsc();
-
-	do {
-		new = dw_apb_clocksource_read(clocksource_apbt);
-	} while (new < old);
-
-	t2 = __native_read_tsc();
-
-	shift = 5;
-	if (unlikely(loop >> shift == 0)) {
-		printk(KERN_INFO
-		       "APBT TSC calibration failed, not enough resolution\n");
-		return 0;
-	}
-	scale = (int)div_u64((t2 - t1), loop >> shift);
-	khz = (scale * (apbt_freq / 1000)) >> shift;
-	printk(KERN_INFO "TSC freq calculated by APB timer is %lu khz\n", khz);
-	return khz;
-failed:
-	return 0;
-}
-- 
1.7.10.4

