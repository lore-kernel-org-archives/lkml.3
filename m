Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaCPNbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 09:31:10 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46607 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbaCPNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 09:30:08 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH net-next v2 6/9] dp83640: correct the periodic output frequency
Date: Sun, 16 Mar 2014 14:29:27 +0100
Message-Id: <39aa0aefeed43f2e1ad7b041ed9e5162e7374259.1394975663.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1394975663.git.richardcochran@gmail.com>
References: <cover.1394975663.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phyter driver incorrectly feeds the value of the period into what
is in fact a pulse width register, resulting in the actual period
being twice the dialed value. This patch fixes the issue and renames a
variable to make the code at bit more clear.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index d6c1061..9e26555 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -271,7 +271,7 @@ static void periodic_output(struct dp83640_clock *clock,
 {
 	struct dp83640_private *dp83640 = clock->chosen;
 	struct phy_device *phydev = dp83640->phydev;
-	u32 sec, nsec, period;
+	u32 sec, nsec, pwidth;
 	u16 gpio, ptp_trig, trigger, val;
 
 	gpio = on ? gpio_tab[PEROUT_GPIO] : 0;
@@ -296,8 +296,9 @@ static void periodic_output(struct dp83640_clock *clock,
 
 	sec = clkreq->perout.start.sec;
 	nsec = clkreq->perout.start.nsec;
-	period = clkreq->perout.period.sec * 1000000000UL;
-	period += clkreq->perout.period.nsec;
+	pwidth = clkreq->perout.period.sec * 1000000000UL;
+	pwidth += clkreq->perout.period.nsec;
+	pwidth /= 2;
 
 	mutex_lock(&clock->extreg_lock);
 
@@ -310,8 +311,8 @@ static void periodic_output(struct dp83640_clock *clock,
 	ext_write(0, phydev, PAGE4, PTP_TDR, nsec >> 16);      /* ns[31:16] */
 	ext_write(0, phydev, PAGE4, PTP_TDR, sec & 0xffff);    /* sec[15:0] */
 	ext_write(0, phydev, PAGE4, PTP_TDR, sec >> 16);       /* sec[31:16] */
-	ext_write(0, phydev, PAGE4, PTP_TDR, period & 0xffff); /* ns[15:0] */
-	ext_write(0, phydev, PAGE4, PTP_TDR, period >> 16);    /* ns[31:16] */
+	ext_write(0, phydev, PAGE4, PTP_TDR, pwidth & 0xffff); /* ns[15:0] */
+	ext_write(0, phydev, PAGE4, PTP_TDR, pwidth >> 16);    /* ns[31:16] */
 
 	/*enable trigger*/
 	val &= ~TRIG_LOAD;
-- 
1.7.10.4

