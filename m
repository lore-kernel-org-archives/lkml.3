Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaJVObp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:31:45 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49740 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaJVObm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:42 -0400
X-ASG-Debug-ID: 1413988298-0759e74a717a4f40002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 08/13] power: reset: ltc2952: cleanup control flow in poweroff_handler
Date: Wed, 22 Oct 2014 16:31:05 +0200
X-ASG-Orig-Subj: [PATCH 08/13] power: reset: ltc2952: cleanup control flow in poweroff_handler
Message-ID: <1413988270-28092-9-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988299
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ltc2952_poweroff_handler uses gotos to return from the function. Since
we don't do cleanups exiting this function, just return IRQ_HANDLED on
the spot and be done with it.

While at it, remove the variable 'ret'. It was never used very much.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index af3cb6e..70d8e3a 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -153,29 +153,21 @@ ltc2952_poweroff_timer_trigger(struct hrtimer *timer)
  */
 static irqreturn_t ltc2952_poweroff_handler(int irq, void *dev_id)
 {
-	int ret;
 	struct ltc2952_poweroff *data = dev_id;
 
-	if (data->kernel_panic)
-		goto irq_ok;
-
-	if (hrtimer_active(&data->timer_wde)) {
+	if (data->kernel_panic || hrtimer_active(&data->timer_wde)) {
 		/* shutdown is already triggered, nothing to do any more */
-		goto irq_ok;
+		return IRQ_HANDLED;
 	}
 
 	if (!hrtimer_active(&data->timer_trigger)) {
-		ret = hrtimer_start(&data->timer_trigger, data->trigger_delay,
-			HRTIMER_MODE_REL);
-
-		if (ret)
+		if (hrtimer_start(&data->timer_trigger, data->trigger_delay,
+				  HRTIMER_MODE_REL))
 			dev_err(data->dev, "unable to start the wait timer\n");
 	} else {
-		ret = hrtimer_cancel(&data->timer_trigger);
+		hrtimer_cancel(&data->timer_trigger);
 		/* omitting return value check, timer should have been valid */
 	}
-
-irq_ok:
 	return IRQ_HANDLED;
 }
 
-- 
2.1.0

