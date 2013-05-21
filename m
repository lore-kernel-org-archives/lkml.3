Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3EUVkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:40:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50441 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751689Ab3EUVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:40:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18kBubdO+jdRcGylEsDiRKK
Date: Tue, 21 May 2013 14:40:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH] rtc: rtc-twl: Fix missing device_init_wakeup() when booted
 with device tree
Message-ID: <20130521214026.GV10378@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booted in legacy mode device_init_wakeup() gets called
by drivers/mfd/twl-core.c when the children are initialized.
However, when booted using device tree, the children are
created with of_platform_populate() instead add_children().

This means that the RTC driver will not have device_init_wakeup()
set, and we need to call it from the driver probe like RTC drivers
typically do.

Without this we cannot test PM wake-up events on omaps for
cases where there may not be any physical wake-up event.

Reported-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

---

This fix is for the -rc cycle please.

--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -524,6 +524,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 	return 0;
 
 out2:
