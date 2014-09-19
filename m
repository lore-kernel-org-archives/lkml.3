Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbaISDiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:38:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53779 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaISDiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:38:14 -0400
Date: Thu, 18 Sep 2014 22:32:02 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: qcom: register a restart notifier
Message-ID: <20140919033202.GF3749@joshc.qualcomm.com>
References: <cover.1411078425.git.joshc@codeaurora.org>
 <d0f4cd93ad3f6690d637413b1171ac3c71aba861.1411078426.git.joshc@codeaurora.org>
 <541B995A.6000609@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541B995A.6000609@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 07:47:54PM -0700, Guenter Roeck wrote:
> On 09/18/2014 03:27 PM, Josh Cartwright wrote:
> >The WDT's BITE_TIME warm-reset behavior can be leveraged as a last
> >resort mechanism for triggering chip reset.  Usually, other restart
> >methods (such as PS_HOLD) are preferrable for issuing a more complete
> >reset of the chip.  As such, keep the priority of the watchdog notifier
> >low.
> >
> >Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
[..]
> >+static int qcom_wdt_restart(struct notifier_block *nb, unsigned long action,
> >+			    void *data)
> >+{
> >+	struct qcom_wdt *wdt = container_of(nb, struct qcom_wdt, restart_nb);
> >+
> >+	/*
> >+	 * Trigger watchdog bite:
> >+	 *    Setup BITE_TIME to be very low, and enable WDT.
> >+	 */
> >+	mutex_lock(&wdt->wdd.lock);
> 
> At this time you don't need to worry about locks.
> 
> Actually, this might be dangerous if the lock happens to be taken,
> as it won't be released (there is no other code running anymore
> when this function is called).

Ah, great.  I'll drop the locking.

> >+	writel_relaxed(0, wdt->base + WDT_EN);
> >+	writel_relaxed(1, wdt->base + WDT_RST);
> >+	writel_relaxed(0x31F3, wdt->base + WDT_BITE_TIME);
> 
> What is the magic here, ie what does 0x31F3 stand for ?

Nothing magic, it's just a reasonably low value to set the bite time
counter at.  It also happens to be the value at reset.

> >+	writel_relaxed(1, wdt->base + WDT_EN);
> >+	mutex_unlock(&wdt->wdd.lock);
> >+	return NOTIFY_DONE;
> >+}
> >+
> >  static int qcom_watchdog_probe(struct platform_device *pdev)
> >  {
> >  	struct qcom_wdt *wdt;
> >@@ -121,6 +141,17 @@ static int qcom_watchdog_probe(struct platform_device *pdev)
> >  		return ret;
> >  	}
> >
> >+	/*
> >+	 * WDT restart notifier has priority 0 (use as a last resort)
> >+	 */
> >+	wdt->restart_nb.notifier_call = qcom_wdt_restart;
> >+	ret = register_restart_handler(&wdt->restart_nb);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "failed to setup restart handler\n");
> >+		watchdog_unregister_device(&wdt->wdd);
> >+		return ret;
> 
> Sure you want to return an error here ? The watchdog itself is still working,
> and this is supposed to be a restart method of last resort. Causing the driver
> to fail loading because it can not register its restart handler seems to be
> a bit aggressive.

It is a bit aggressive.  I'll at least drop it to a dev_warn(); even
though it is a "last resort", on some boards it's the only available
mechanism for reliable restart.

Thanks!
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
