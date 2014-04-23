Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaDWQri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:47:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9002 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbaDWQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:47:28 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-00-5357ee9ea94a
From: Tomasz Figa <t.figa@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 2/3] drivercore: Bind/unbind power domain on probe/remove
Date: Wed, 23 Apr 2014 18:46:57 +0200
Message-id: <1398271618-28932-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1398271618-28932-1-git-send-email-t.figa@samsung.com>
References: <1398271618-28932-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Nd1578KDDd4uMrTYOGM9q8XUh0/Y
	LOYfOcdq0f9mIatF8+L1bBbnXq1ktOhdcJXN4uvhFYwWs6bsZbLY9Pgaq8XlXXPYLD73HmG0
	mHF+H5PF7cu8Fm9+v2C3WHvkLrvF0usXmSzunjrKZjFh+loWi63zzjFanDl9idWide8Rdosf
	Z7pZLF4dbGOxWD/jNYvFql1/GC2Orw13kPZYM28No0dLcw+bx+W+XiaPnbPusnusXP6FzWPx
	npdMHptWdbJ53Lm2h81j/9w17B6bl9R7bLnazuLRt2UVo8eK1d/ZPT5vkvPYODc0gD+KyyYl
	NSezLLVI3y6BK+P8iR6WgufCFf23prI1MC4W6GLk5JAQMJFY+3AaG4QtJnHh3nogm4tDSGAp
	o8TCBe2sEE4fk8T9nztZQKrYBNQkPjc8AusQEZCRmHplP1gRs8AvdokHf98wgSSEBXwk1n9Y
	xQ5iswioSry8eBXM5hVwkjh/9BQzxDo5if8vV4DVcwo4S9zoPw9WIwRUM3/ycqYJjLwLGBlW
	MYqmliYXFCel5xrqFSfmFpfmpesl5+duYoRE35cdjIuPWR1iFOBgVOLhVbgVHizEmlhWXJl7
	iFGCg1lJhHfJIqAQb0piZVVqUX58UWlOavEhRiYOTqkGRmu5u/u9Lxs528g93fHKI+/P5DIh
	3s16s+1XhemfWHzk2u1AE+2uC+cn5jSX1URdFaipb/Lb/Xv6vvNvz3GWpRzLV76caLXxRi3H
	Tb3jnvs+1xak3b11LSd9xvzw9QKd6f+c/3bPTZ7wrOOaYKTeigJx51/nfz5JTovU+r7jgWTL
	6R23Qw6uYVFiKc5INNRiLipOBACVlfSlnAIAAA==
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
index 8986b9f..7501c42 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -23,6 +23,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
+#include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
 
@@ -273,6 +274,11 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	dev->driver = drv;
 
+	/* If using genpd, bind power domain now before probing */
+	ret = genpd_bind_domain(dev);
+	if (ret)
+		goto probe_failed;
+
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
 	if (ret)
@@ -303,6 +309,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 probe_failed:
 	devres_release_all(dev);
 	driver_sysfs_remove(dev);
+	genpd_unbind_domain(dev);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
 
@@ -513,7 +520,7 @@ static void __device_release_driver(struct device *dev)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 						     BUS_NOTIFY_UNBOUND_DRIVER,
 						     dev);
-
+		genpd_unbind_domain(dev);
 	}
 }
 
-- 
1.9.2

