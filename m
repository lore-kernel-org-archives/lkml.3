Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaCPNbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:31:20 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46488 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaCPNaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:30:17 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH net-next v2 9/9] dp83640: let the periodic pin from the module parameter be a default.
Date: Sun, 16 Mar 2014 14:29:30 +0100
Message-Id: <9b2e10f3b6d4fdbb1ff535c59603c6a302d89af6.1394975663.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394975663.git.richardcochran@gmail.com>
References: <cover.1394975663.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver use the new pin configuration method when
programming the periodic output signal.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 93db564..352c5e4 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -298,15 +298,22 @@ static u64 phy2txts(struct phy_txts *p)
 	return ns;
 }
 
-static void periodic_output(struct dp83640_clock *clock,
-			    struct ptp_clock_request *clkreq, bool on)
+static int periodic_output(struct dp83640_clock *clock,
+			   struct ptp_clock_request *clkreq, bool on)
 {
 	struct dp83640_private *dp83640 = clock->chosen;
 	struct phy_device *phydev = dp83640->phydev;
 	u32 sec, nsec, pwidth;
 	u16 gpio, ptp_trig, trigger, val;
 
-	gpio = on ? gpio_tab[PEROUT_GPIO] : 0;
+	if (on) {
+		gpio = 1 + ptp_find_pin(clock->ptp_clock, PTP_PF_PEROUT, 0);
+		if (gpio < 1)
+			return -EINVAL;
+	} else {
+		gpio = 0;
+	}
+
 	trigger = PER_TRIGGER;
 
 	ptp_trig = TRIG_WR |
@@ -323,7 +330,7 @@ static void periodic_output(struct dp83640_clock *clock,
 		ext_write(0, phydev, PAGE5, PTP_TRIG, ptp_trig);
 		ext_write(0, phydev, PAGE4, PTP_CTL, val);
 		mutex_unlock(&clock->extreg_lock);
-		return;
+		return 0;
 	}
 
 	sec = clkreq->perout.start.sec;
@@ -352,6 +359,7 @@ static void periodic_output(struct dp83640_clock *clock,
 	ext_write(0, phydev, PAGE4, PTP_CTL, val);
 
 	mutex_unlock(&clock->extreg_lock);
+	return 0;
 }
 
 /* ptp clock methods */
@@ -484,8 +492,7 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 	case PTP_CLK_REQ_PEROUT:
 		if (rq->perout.index != 0)
 			return -EINVAL;
-		periodic_output(clock, rq, on);
-		return 0;
+		return periodic_output(clock, rq, on);
 
 	default:
 		break;
-- 
1.7.10.4

