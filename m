Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaK1CMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:12:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:15207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaK1CMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:12:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422490425"
From: Maurice Petallo <mauricex.r.petallo@intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maurice Petallo <mauricex.r.petallo@intel.com>
Subject: [PATCH v2] thermal: Intel SoC DTS: Don't do thermal zone update inside spin_lock
Date: Fri, 28 Nov 2014 10:11:41 +0800
Message-Id: <1417140701-884-1-git-send-email-mauricex.r.petallo@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver calls spin_lock_irqsave during DTS interrupt. The interrupt
handle then calls thermal_zone_device_update which implicitly calls
a sleep function and produce the following bug:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:97
in_atomic(): 1, irqs_disabled(): 1, pid: 920, name: irq/86-soc_dts
CPU: 0 PID: 920 Comm: irq/86-soc_dts Tainted: G            E  3.17.0-rc2+ #1
Hardware name: Intel Corp. VALLEYVIEW B3 PLATFORM/NOTEBOOK, BIOS BYTICRB1.86C.0092.R31.1408290850 08/29/2014
 00000000 00000000 c25dbe74 c1818cfd f3cc488c c25dbe9c c1059305 c1b4063b
 00000001 00000001 00000398 f3cc488c f6817644 f6817644 f3ecc6c0 c25dbea8
 c18208f2 f6817400 c25dbebc c159b0bb c25dbedc f6817400 f32a2300 c25dbee8
Call Trace:
 [<c1818cfd>] dump_stack+0x48/0x60
 [<c1059305>] __might_sleep+0xec/0xf4
 [<c18208f2>] mutex_lock+0x1c/0x34
 [<c159b0bb>] thermal_zone_get_temp+0x34/0x59
 [<c159bde5>] thermal_zone_device_update+0x2d/0xcb
 [<f85da16a>] ? iosf_mbi_write+0x6c/0x74 [iosf_mbi]
 [<f7c7445d>] soc_irq_thread_fn+0x10c/0x163 [intel_soc_dts_thermal]
 [<c107b72b>] irq_thread_fn+0x18/0x2a
 [<c107bedb>] irq_thread+0x81/0x11f
 [<c107b713>] ? irq_finalize_oneshot+0x7c/0x7c
 [<c107bf79>] ? irq_thread+0x11f/0x11f
 [<c107be5a>] ? wake_threads_waitq+0x31/0x31
 [<c1054217>] kthread+0x87/0x8c
 [<c1821e41>] ret_from_kernel_thread+0x21/0x30
 [<c1054190>] ? __kthread_parkme+0x55/0x55

Signed-off-by: Maurice Petallo <mauricex.r.petallo@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
CC: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
Changelog v2:
* Change subject to emphasize that this patch affects only Intel SoC DTS
  (intel_soc_dts_thermal.c)

 drivers/thermal/intel_soc_dts_thermal.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/intel_soc_dts_thermal.c b/drivers/thermal/intel_soc_dts_thermal.c
index a6a0a18..5580f5b 100644
--- a/drivers/thermal/intel_soc_dts_thermal.c
+++ b/drivers/thermal/intel_soc_dts_thermal.c
@@ -360,6 +360,9 @@ static void proc_thermal_interrupt(void)
 	u32 sticky_out;
 	int status;
 	u32 ptmc_out;
+	unsigned long flags;
+
+	spin_lock_irqsave(&intr_notify_lock, flags);
 
 	/* Clear APIC interrupt */
 	status = iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
@@ -378,21 +381,20 @@ static void proc_thermal_interrupt(void)
 		/* reset sticky bit */
 		status = iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
 					SOC_DTS_OFFSET_PTTSS, sticky_out);
+		spin_unlock_irqrestore(&intr_notify_lock, flags);
+
 		for (i = 0; i < SOC_MAX_DTS_SENSORS; ++i) {
 			pr_debug("TZD update for zone %d\n", i);
 			thermal_zone_device_update(soc_dts[i]->tzone);
 		}
-	}
+	} else
+		spin_unlock_irqrestore(&intr_notify_lock, flags);
 
 }
 
 static irqreturn_t soc_irq_thread_fn(int irq, void *dev_data)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&intr_notify_lock, flags);
 	proc_thermal_interrupt();
-	spin_unlock_irqrestore(&intr_notify_lock, flags);
 	pr_debug("proc_thermal_interrupt\n");
 
 	return IRQ_HANDLED;
-- 
1.7.9.5

