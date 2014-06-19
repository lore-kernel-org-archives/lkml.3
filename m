Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaFSAva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:51:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbaFSAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="355784429"
Message-ID: <53A2340D.9030503@linux.intel.com>
Date: Thu, 19 Jun 2014 08:51:25 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] GPIO button wth wakeup attribute is supposed to wake the
 system up
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the wakeup attribute is set, the GPIO button is capable of
waking up the system from sleep states, including the "freeze"
sleep state.  For that to work, its driver needs to pass the
IRQF_NO_SUSPEND flag to devm_request_any_context_irq(), or the
interrupt will be disabled by suspend_device_irqs() and the
system won't be woken up by it from the "freeze" sleep state.

The suspend_device_irqs() routine is a workaround for drivers
that mishandle interrupts triggered when the devices handled
by them are suspended, so it is safe to use IRQF_NO_SUSPEND in
all drivers that don't have that problem.

The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/input/keyboard/gpio_keys.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 8c98e97..b046dc6 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -527,6 +527,14 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 	if (!button->can_disable)
 		irqflags |= IRQF_SHARED;
 
+	/*
+	 * If platform has specified the wakeup attribute of the button,
+	 * we add IRQF_NO_SUSPEND to desc->action->flag. So the wake up
+	 * interrupt will not be disabled in suspend_device_irqs
+	 */
+	if (button->wakeup)
+		irqflags |= IRQF_NO_SUSPEND;
+
 	error = devm_request_any_context_irq(&pdev->dev, bdata->irq,
 					     isr, irqflags, desc, bdata);
 	if (error < 0) {
-- 
1.7.10.4
