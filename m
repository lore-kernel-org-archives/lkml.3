Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaJVOby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:31:54 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49820 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaJVObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:47 -0400
X-ASG-Debug-ID: 1413988304-0759e74a717a4fc0002-xx1T2L
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
Subject: [PATCH 11/13] power: reset: ltc2952: check trigger value before starting timer
Date: Wed, 22 Oct 2014 16:31:08 +0200
X-ASG-Orig-Subj: [PATCH 11/13] power: reset: ltc2952: check trigger value before starting timer
Message-ID: <1413988270-28092-12-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988304
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

In ltc2952_poweroff_handler it is theoretically possible that the timer
fails to start on first pass (button press), but succeeds in starting on
the second (button release). This will cause the button press to be
misinterpreted, and will incorrectly shut down the system. Because a
picture says more than a thousand words:

Expected behavior:
tmr:      ++++++++++
btn: -----__________-----

Faulty behavior:
tmr:                +++++
btn: -----__________-----

Legend:
+ timer runs
_ button pressed
- button depressed

To prevent this from happening, check the value of the gpio before
starting the timer. If the button is active, we should start the timer,
else we should stop it.

The situation described can now still occur if the polarity of the input
pin is set incorrectly, but that at least is predictable behavior and
can be detected during the first tests.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 2f3fd5b..fda2735 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -160,7 +160,7 @@ static irqreturn_t ltc2952_poweroff_handler(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	if (!hrtimer_active(&data->timer_trigger)) {
+	if (gpiod_get_value(data->gpio_trigger)) {
 		if (hrtimer_start(&data->timer_trigger, data->trigger_delay,
 				  HRTIMER_MODE_REL))
 			dev_err(data->dev, "unable to start the wait timer\n");
-- 
2.1.0

