Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3HIRZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:25:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59635 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab3HIRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:25:32 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Fri,  9 Aug 2013 18:25:02 +0100
Message-Id: <1376069102-15658-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: tps65010: Use power efficient workqueue for power polling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

There is no need to use a per CPU workqueue to poll, especially with the
5s delay used, so allow the scheduler to use any CPU.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/tps65010.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index 4d67692..8114567 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -242,8 +242,8 @@ static int dbg_show(struct seq_file *s, void *_)
 	seq_printf(s, "mask2     %s\n", buf);
 	/* ignore ackint2 */
 
-	schedule_delayed_work(&tps->work, POWER_POLL_DELAY);
-
+	queue_delayed_work(system_power_efficient_wq, &tps->work,
+			   POWER_POLL_DELAY);
 
 	/* VMAIN voltage, enable lowpower, etc */
 	value = i2c_smbus_read_byte_data(tps->client, TPS_VDCDC1);
@@ -400,7 +400,8 @@ static void tps65010_interrupt(struct tps65010 *tps)
 			&& (tps->chgstatus & (TPS_CHG_USB|TPS_CHG_AC)))
 		poll = 1;
 	if (poll)
-		schedule_delayed_work(&tps->work, POWER_POLL_DELAY);
+		queue_delayed_work(system_power_efficient_wq, &tps->work,
+				   POWER_POLL_DELAY);
 
 	/* also potentially gpio-in rise or fall */
 }
@@ -448,7 +449,7 @@ static irqreturn_t tps65010_irq(int irq, void *_tps)
 
 	disable_irq_nosync(irq);
 	set_bit(FLAG_IRQ_ENABLE, &tps->flags);
-	schedule_delayed_work(&tps->work, 0);
+	queue_delayed_work(system_power_efficient_wq, &tps->work, 0);
 	return IRQ_HANDLED;
 }
 
@@ -718,7 +719,8 @@ int tps65010_set_vbus_draw(unsigned mA)
 			&& test_and_set_bit(
 				FLAG_VBUS_CHANGED, &the_tps->flags)) {
 		/* gadget drivers call this in_irq() */
-		schedule_delayed_work(&the_tps->work, 0);
+		queue_delayed_work(system_power_efficient_wq, &the_tps->work,
+				   0);
 	}
 	local_irq_restore(flags);
 
-- 
1.8.4.rc1

