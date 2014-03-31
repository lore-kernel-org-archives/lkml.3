Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaCaJqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 05:46:31 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42290 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbaCaJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 05:46:30 -0400
Date: Mon, 31 Mar 2014 11:46:27 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140331114627.5e1a4609@linux.lan.towertech.it>
In-Reply-To: <53384080.9020502@oracle.com>
References: <5308E3AE.3040405@oracle.com>
	<20140222205217.GC16272@mtj.dyndns.org>
	<20140224120427.6394d5dd@linux.lan.towertech.it>
	<5331FA9E.20506@oracle.com>
	<20140325233936.655a798e@linux.lan.towertech.it>
	<53321D04.2040102@oracle.com>
	<5337653D.6020002@oracle.com>
	<53384080.9020502@oracle.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2014 12:04:16 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> > Look good, thanks!  
> 
> Or not...
> 
> Hit it again during overnight fuzzing:
> 

 I think this is a different bug, please try this.

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index cae212f..2c77d8e 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -712,6 +712,20 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		}
 	}
 
+	spin_lock_irq(&rtc_lock);
+	rtc_control = CMOS_READ(RTC_CONTROL);
+	spin_unlock_irq(&rtc_lock);
+
+	/* FIXME:
+	 * <asm-generic/rtc.h> doesn't know 12-hour mode either.
+	 */
+	if (is_valid_irq(rtc_irq) && !(rtc_control & RTC_24H)) {
+		dev_warn(dev, "only 24-hr supported\n");
+		retval = -ENXIO;
+		goto cleanup0;
+	}
+
+
 	cmos_rtc.dev = dev;
 	dev_set_drvdata(dev, &cmos_rtc);
 
@@ -739,49 +753,49 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	/* disable irqs */
 	cmos_irq_disable(&cmos_rtc, RTC_PIE | RTC_AIE | RTC_UIE);
 
-	rtc_control = CMOS_READ(RTC_CONTROL);
-
 	spin_unlock_irq(&rtc_lock);
 
-	/* FIXME:
-	 * <asm-generic/rtc.h> doesn't know 12-hour mode either.
-	 */
-	if (is_valid_irq(rtc_irq) && !(rtc_control & RTC_24H)) {
-		dev_warn(dev, "only 24-hr supported\n");
-		retval = -ENXIO;
-		goto cleanup1;
-	}
-
 	if (is_valid_irq(rtc_irq)) {
-		irq_handler_t rtc_cmos_int_handler;
+
+		irq_handler_t rtc_cmos_int_handler = NULL;
 
 		if (is_hpet_enabled()) {
-			rtc_cmos_int_handler = hpet_rtc_interrupt;
+
 			retval = hpet_register_irq_handler(cmos_interrupt);
 			if (retval) {
 				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
-				goto cleanup1;
+			} else {
+				rtc_cmos_int_handler = hpet_rtc_interrupt;
 			}
-		} else
+		} else {
 			rtc_cmos_int_handler = cmos_interrupt;
+		}
 
-		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				0, dev_name(&cmos_rtc.rtc->dev),
-				cmos_rtc.rtc);
-		if (retval < 0) {
-			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
-			goto cleanup1;
+		if (rtc_cmos_int_handler) {
+			retval = request_irq(rtc_irq, rtc_cmos_int_handler,
+					0, dev_name(&cmos_rtc.rtc->dev),
+					cmos_rtc.rtc);
+			if (retval < 0) {
+
+				dev_err(dev, "IRQ %d is already in use\n", rtc_irq);
+
+				cmos_rtc.irq = -1;
+
+				if (is_hpet_enabled()) {
+					hpet_unregister_irq_handler(cmos_interrupt);
+				}
+			}
 		}
 	}
+
 	hpet_rtc_timer_init();
 
 	/* export at least the first block of NVRAM */
 	nvram.size = address_space - NVRAM_OFFSET;
 	retval = sysfs_create_bin_file(&dev->kobj, &nvram);
 	if (retval < 0) {
-		dev_dbg(dev, "can't create nvram file? %d\n", retval);
-		goto cleanup2;
+		dev_err(dev, "can't create nvram file? %d\n", retval);
 	}
 
 	dev_info(dev, "%s%s, %zd bytes nvram%s\n",
@@ -795,12 +809,6 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	return 0;
 
-cleanup2:
-	if (is_valid_irq(rtc_irq))
-		free_irq(rtc_irq, cmos_rtc.rtc);
-cleanup1:
-	cmos_rtc.dev = NULL;
-	rtc_device_unregister(cmos_rtc.rtc);
 cleanup0:
 	release_region(ports->start, resource_size(ports));
 	return retval;
@@ -823,8 +831,12 @@ static void __exit cmos_do_remove(struct device *dev)
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
 
 	if (is_valid_irq(cmos->irq)) {
+
 		free_irq(cmos->irq, cmos->rtc);
-		hpet_unregister_irq_handler(cmos_interrupt);
+
+		if (is_hpet_enabled()) {
+			hpet_unregister_irq_handler(cmos_interrupt);
+		}
 	}
 
 	rtc_device_unregister(cmos->rtc);



-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

