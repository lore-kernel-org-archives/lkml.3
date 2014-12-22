Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaLVQKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:10:39 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43944 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbaLVQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:10:38 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start Technology
Date: Mon, 22 Dec 2014 17:10:34 +0100
Message-ID: <3142141.XpVRfRv0Jy@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <3318216.XHaCQKkcW4@xps13>
References: <9927036.n7iZq92iLW@xps13> <20141222145949.GB11844@srcf.ucam.org> <3318216.XHaCQKkcW4@xps13>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2014 16:50:37 Gabriele Mazzotta wrote:
> On Monday 22 December 2014 14:59:49 Matthew Garrett wrote:
> > Can you try this diff?
> 
> Unfortunately it doesn't work (I made a change, see here below).

I take a better look at the code and noticed a couple of mistakes in
your, but you nailed it.

Here below the working patch. There was an extra ! and another deadlock.

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5b2e761..4035927 100644
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
@@ -881,6 +884,8 @@ static int cmos_suspend(struct device *dev)
 	}
 	spin_unlock_irq(&rtc_lock);
 
+	cmos->valid_alarm = !cmos_read_alarm(dev, &cmos->alm);
+
 	if (tmp & RTC_AIE) {
 		cmos->enabled_wake = 1;
 		if (cmos->wake_on)
@@ -951,6 +956,9 @@ static int cmos_resume(struct device *dev)
 	}
 	spin_unlock_irq(&rtc_lock);
 
+	if (cmos->valid_alarm)
+		cmos_set_alarm(dev, &cmos->alm);
+
 	dev_dbg(dev, "resume, ctrl %02x\n", tmp);
 
 	return 0;

