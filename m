Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaEHMsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:48:46 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23404 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaEHMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:48:16 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-fb-536b7d0e65d7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 2/3] drivercore: Bind/unbind power domain on probe/remove
Date: Thu, 08 May 2014 14:45:08 +0200
Message-id: <1399553109-6487-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1399553109-6487-1-git-send-email-t.figa@samsung.com>
References: <1399553109-6487-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRW0hTYQDH/c7OzjkOJ6ep9SkiMbCH8pIj4qNCtB76HrpIQwILcupwonOy
	4yyDaDIzL20KOR2mbrYWOi+HzUrTqWUzocyU2XxII1ZgpgUhalRkzb394H97+DMCybYgjikq
	LVdqSxUlUkpEvv477U+OvFEsP/xrJwK5LLwQWb2zQtS43iVEBjtPIaPtHYU2X3QD1NY8RiD3
	J78Q+UbaKbRh9AJkeTtOoPc+MVr//YVG/d5lGjkW5wm0/GqKQk2t/SR63DkLUGOXkUC3xrw0
	+jnTQKKvz2tIxFvWSOQc+QPQdP/FjFjc19kHcLXhDoV9JiOBn7Yt09juWSWw21lH4SW/h8IT
	HX00HnxwE5seOQEO2KsB7u7dpvGGOwG7OrKzInNEJwqUJUUVSm1qeq5I9dDkAGUrUddq2gcI
	PbCz9SCcgewRONTbS4V4L5z7wP9nESNhHQCutY8LgoKENRFwbkAcZIo9ADf0gd1ANBsPzQsT
	wmBAwPI0DMxYQD1gmCj2DPTZpUEPySbCWlfrbo+YzYTuxR5haCwB7qx2E0F7OHsSOseSQ1OZ
	0NrwjW4CYhsIc4IYpS6/jMsrVMtSOIWa05UWpuRr1G4QOmtzGDheHpsELAOkEWJbvEouESoq
	uEr1JICMQBotXqgslkvEBYrK60qt5opWV6LkJgHBhMfpAZVBW3taErM5Xtd8gRlPN+uP3q9N
	a3kS1jy1NTp46NR+meZSHh2z4jEM+6cHbZpnsg5fXWsNxMrzWVuxXQOq3NEq49Uft3VL5nXr
	WY8vUqb5nkavzZk/30018Kff3NtzHFfxl7PLY4cM8qhzSQZxYcCVlKOt2zfv130ksZTkVIq0
	gwItp/gHTgc0rooCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a number of platforms, devices are part of controllable power
domains, which need to be enabled before such devices can be accessed
and may be powered down when the device is idle to save some power.
This means that on systems that support power domain control using
generic power domains subsystem, it is necessary to add device to its
power domain before binding a driver to it and remove it from its power
domain after its driver is unbound to make sure that an unused device
does not affect power domain state.

Since this is not limited to particular busses and specific
archs/platforms, it is more convenient to do the above directly in
driver core, just as done with pinctrl default configuration. This patch
adds necessary code to really_probe() and __device_release_driver() to
achieve this and maintain consistent stack-like ordering of operations
happening when binding and unbinding a driver.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
[on i.MX6 GK802]
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
Reviewed-by: Mark Brown <broonie@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/base/dd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 62ec61e..9489b3a 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
+#include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 
@@ -287,6 +288,11 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	dev->driver = drv;
 
+	/* If using genpd, bind power domain now before probing */
+	ret = genpd_bind_domain(dev);
+	if (ret)
+		goto probe_failed;
+
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
 	if (ret)
@@ -317,6 +323,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 probe_failed:
 	devres_release_all(dev);
 	driver_sysfs_remove(dev);
+	genpd_unbind_domain(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
 
@@ -530,7 +537,7 @@ static void __device_release_driver(struct device *dev)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
-
+		genpd_unbind_domain(dev);
 	}
 }
 
-- 
1.9.2

