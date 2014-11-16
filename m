Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaKPAXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:23:36 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33196 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaKPATc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:32 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 08/22] MIPS: BMIPS: Align secondary boot sequence with latest firmware releases
Date: Sat, 15 Nov 2014 16:17:32 -0800
Message-Id: <1416097066-20452-9-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some older BMIPS5200 (dual core / quad thread) platforms, the
PROM code set up CPU2/CPU3 so they would be started through an NMI
instead of through the ACTION register.  But this was incompatible with
some power management features that were later added, so the scheme was
changed so that Linux is fully responsible for booting CPU2/CPU3.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/smp-bmips.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index 06bb5ed..4e56911 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -213,17 +213,7 @@ static void bmips_boot_secondary(int cpu, struct task_struct *idle)
 				set_c0_brcm_cmt_ctrl(0x01);
 			break;
 		case CPU_BMIPS5000:
-			if (cpu & 0x01)
-				write_c0_brcm_action(ACTION_BOOT_THREAD(cpu));
-			else {
-				/*
-				 * core N thread 0 was already booted; just
-				 * pulse the NMI line
-				 */
-				bmips_write_zscm_reg(0x210, 0xc0000000);
-				udelay(10);
-				bmips_write_zscm_reg(0x210, 0x00);
-			}
+			write_c0_brcm_action(ACTION_BOOT_THREAD(cpu));
 			break;
 		}
 		cpumask_set_cpu(cpu, &bmips_booted_mask);
-- 
2.1.1

