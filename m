Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab3LIQYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:24:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50591 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934051Ab3LIQWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:22:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: <lee.jones@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 10/15] mfd: menelaus: Pass menelaus_chip argument to menelaus <-> time helpers
Date: Mon, 9 Dec 2013 10:21:20 -0600
Message-ID: <1386606085-26838-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1386606085-26838-1-git-send-email-balbi@ti.com>
References: <20131209161422.GC24047@saruman.home>
 <1386606085-26838-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

time_to_menelaus() and menelaus_to_time() are static and can easily
receive a struct menelaus_chip pointer argument.

After this patch, the_menelaus is only used on exported functions which
are currently being used by board-n8x0.c.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 13d1cb0..aa3c579 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -857,10 +857,9 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
 
 #define RTC_HR_PM		(1 << 7)
 
-static void menelaus_to_time(char *regs, struct rtc_time *t)
+static void menelaus_to_time(struct menelaus_chip *m,
+		char *regs, struct rtc_time *t)
 {
-	struct menelaus_chip *m = the_menelaus;
-
 	t->tm_sec = bcd2bin(regs[0]);
 	t->tm_min = bcd2bin(regs[1]);
 	if (m->rtc_control & RTC_CTRL_MODE12) {
@@ -874,9 +873,9 @@ static void menelaus_to_time(char *regs, struct rtc_time *t)
 	t->tm_year = bcd2bin(regs[5]) + 100;
 }
 
-static int time_to_menelaus(struct rtc_time *t, int regnum)
+static int time_to_menelaus(struct menelaus_chip *m,
+		struct rtc_time *t, int regnum)
 {
-	struct menelaus_chip *m = the_menelaus;
 	int	hour, status;
 
 	status = menelaus_write_reg(m, regnum++, bin2bcd(t->tm_sec));
@@ -944,7 +943,7 @@ static int menelaus_read_time(struct device *dev, struct rtc_time *t)
 		return -EIO;
 	}
 
-	menelaus_to_time(regs, t);
+	menelaus_to_time(m, regs, t);
 	t->tm_wday = bcd2bin(regs[6]);
 
 	return 0;
@@ -956,7 +955,7 @@ static int menelaus_set_time(struct device *dev, struct rtc_time *t)
 	int		status;
 
 	/* write date and time registers */
-	status = time_to_menelaus(t, MENELAUS_RTC_SEC);
+	status = time_to_menelaus(m, t, MENELAUS_RTC_SEC);
 	if (status < 0)
 		return status;
 	status = menelaus_write_reg(m, MENELAUS_RTC_WKDAY, bin2bcd(t->tm_wday));
@@ -1001,7 +1000,7 @@ static int menelaus_read_alarm(struct device *dev, struct rtc_wkalrm *w)
 		return -EIO;
 	}
 
-	menelaus_to_time(regs, &w->time);
+	menelaus_to_time(m, regs, &w->time);
 
 	w->enabled = !!(m->rtc_control & RTC_CTRL_AL_EN);
 
@@ -1029,7 +1028,7 @@ static int menelaus_set_alarm(struct device *dev, struct rtc_wkalrm *w)
 	}
 
 	/* write alarm registers */
-	status = time_to_menelaus(&w->time, MENELAUS_RTC_AL_SEC);
+	status = time_to_menelaus(m, &w->time, MENELAUS_RTC_AL_SEC);
 	if (status < 0)
 		return status;
 
-- 
1.8.4.GIT

