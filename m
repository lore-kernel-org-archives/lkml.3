Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaHNHWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:22:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:34886 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbaHNHW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,861,1400050800"; 
   d="scan'208";a="558398270"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH v2 2/5] x86, MCE: Don't use percpu for MCE workqueue/irq_work
Date: Thu, 14 Aug 2014 02:49:43 -0400
Message-Id: <1407998986-1834-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An MCE is considered a rare event. Therefore, there's no need to have
per-CPU instances of both normal and IRQ workqueues. Make them both
global.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1406797523-28710-3-git-send-email-gong.chen@linux.intel.com
[Boris: massage commit message]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b2c8bb83672a..7534cfce43e9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -107,7 +107,8 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
  */
 mce_banks_t mce_banks_ce_disabled;
 
-static DEFINE_PER_CPU(struct work_struct, mce_work);
+static struct work_struct mce_work;
+static struct irq_work mce_irq_work;
 
 static void (*quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs);
 
@@ -526,11 +527,9 @@ int mce_available(struct cpuinfo_x86 *c)
 static void mce_schedule_work(void)
 {
 	if (!mce_ring_empty())
-		schedule_work(&__get_cpu_var(mce_work));
+		schedule_work(&mce_work);
 }
 
-DEFINE_PER_CPU(struct irq_work, mce_irq_work);
-
 static void mce_irq_work_cb(struct irq_work *entry)
 {
 	mce_notify_irq();
@@ -551,7 +550,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-	irq_work_queue(&__get_cpu_var(mce_irq_work));
+	irq_work_queue(&mce_irq_work);
 }
 
 /*
@@ -1708,8 +1707,8 @@ void mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
-	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
+	INIT_WORK(&mce_work, mce_process_work);
+	init_irq_work(&mce_irq_work, mce_irq_work_cb);
 }
 
 /*
-- 
2.0.0.rc2

