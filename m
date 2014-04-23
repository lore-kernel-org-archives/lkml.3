Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaDWI06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:26:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:49945 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaDWI04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="517801816"
Date: Wed, 23 Apr 2014 11:34:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Adam Williamson <awilliam@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
Message-ID: <20140423083430.GV30677@intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
 <5353A1F6.60602@linux.intel.com>
 <5353B8A4.1080900@linux.intel.com>
 <1398007690.2674.0.camel@adam.happyassassin.net>
 <5354BA59.2000008@linux.intel.com>
 <53551D0F.40906@linux.intel.com>
 <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
 <1398230210.2704.8.camel@adam.happyassassin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398230210.2704.8.camel@adam.happyassassin.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:16:50PM -0700, Adam Williamson wrote:
> Well, I can't actually concur. See my results in
> https://bugzilla.kernel.org/show_bug.cgi?id=68291#c44 .
> 
> 1. A kernel with neither patch applied (and no hid-rmi driver) results
> in a working touchscreen.
> 2. A kernel with only v3 of Doug's patch from
> https://bugzilla.kernel.org/show_bug.cgi?id=67921 results in a working
> touchscreen.
> 3. A kernel with both v3 of Doug's patch and this IRQ descriptor
> conflict "fix" results in a broken touchscreen.
> 
> Seems to me there really is some kind of problem with this patch...

Can you try so that you have both patches applied and then this one? I'm
suspecting that the ACPI GPIO operation region support might do something
unexpected in this case.

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 555af733d5eb..1a9e0ab27141 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -557,6 +557,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = false;
 	gc->dev = dev;
 
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
+		return ret;
+	}
+
 	/* set up interrupts  */
 	irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_rc && irq_rc->start) {
@@ -575,12 +581,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
 	}
 
-	ret = gpiochip_add(gc);
-	if (ret) {
-		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
-		return ret;
-	}
-
 	pm_runtime_enable(dev);
 
 	return 0;
