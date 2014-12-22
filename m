Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaLVO7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:59:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59548 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaLVO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:59:51 -0500
Date: Mon, 22 Dec 2014 14:59:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start
 Technology
Message-ID: <20141222145949.GB11844@srcf.ucam.org>
References: <9927036.n7iZq92iLW@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9927036.n7iZq92iLW@xps13>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this diff?

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5b2e761..637f980 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -48,6 +48,7 @@ struct cmos_rtc {
 	struct device		*dev;
 	int			irq;
 	struct resource		*iomem;
+	struct rtc_wkalrm	alm;
 
 	void			(*wake_on)(struct device *);
 	void			(*wake_off)(struct device *);
@@ -59,6 +60,8 @@ struct cmos_rtc {
 	u8			day_alrm;
 	u8			mon_alrm;
 	u8			century;
+
+	bool			valid_alarm;
 };
 
 /* both platform and pnp busses use negative numbers for invalid irqs */
@@ -879,6 +882,7 @@ static int cmos_suspend(struct device *dev)
 
 		cmos_checkintr(cmos, tmp);
 	}
+	cmos->valid_alarm = !!cmos_read_alarm(dev, &cmos->alm);
 	spin_unlock_irq(&rtc_lock);
 
 	if (tmp & RTC_AIE) {
@@ -949,6 +953,10 @@ static int cmos_resume(struct device *dev)
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		} while (mask & RTC_AIE);
 	}
+
+	if (cmos->valid_alarm)
+		cmos_set_alarm(dev, &cmos->alm);
+
 	spin_unlock_irq(&rtc_lock);
 
 	dev_dbg(dev, "resume, ctrl %02x\n", tmp);


-- 
Matthew Garrett | mjg59@srcf.ucam.org
