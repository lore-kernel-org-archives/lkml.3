Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3KVU5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:57:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:29605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab3KVU5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:57:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,753,1378882800"; 
   d="scan'208,223";a="440115231"
Date: Fri, 22 Nov 2013 22:56:40 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
Message-ID: <20131122205640.GA21895@xps8300>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
 <528FA520.7080501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <528FA520.7080501@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2013 at 11:40:32AM -0700, Stephen Warren wrote:
> On 11/22/2013 05:14 AM, Mika Westerberg wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > 
> > All platforms using this driver are now converted to the new
> > descriptor-based GPIO interface.
> 
> Don't you want to remove the fields from the pdata structure too, since
> it's pointless to set them anymore IIUC?

Agreed. We should have removed them in this patch.

I have prepared a separate patch where I remove those and some other
unused fields from the pdata structure (attachment). Would it be OK to
add that to this patch set? Or should this patch simply be updated?

-- 
heikki

--AhhlLboLdkugWU4S
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-net-rfkill-gpio-remove-obsolete-fields-from-platform.patch"

>From 1c561787e04361b2a6a8114df99b6a2854834684 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 22 Nov 2013 15:35:10 +0200
Subject: [PATCH] net: rfkill: gpio: remove obsolete fields from platform data

The driver does not support the legacy GPIO API any more and
there are no users for the clock.

The platform setup hooks were apparently designed to be
used if platform specific configurations like pin
multiplexing needed handling. Now there is the pin control
subsystem that is designed to cover such things. In any
case, there are no users for those either.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 include/linux/rfkill-gpio.h | 15 ++-------------
 net/rfkill/rfkill-gpio.c    | 25 -------------------------
 2 files changed, 2 insertions(+), 38 deletions(-)

diff --git a/include/linux/rfkill-gpio.h b/include/linux/rfkill-gpio.h
index 4d09f6e..2c65e5d 100644
--- a/include/linux/rfkill-gpio.h
+++ b/include/linux/rfkill-gpio.h
@@ -20,28 +20,17 @@
 #ifndef __RFKILL_GPIO_H
 #define __RFKILL_GPIO_H
 
-#include <linux/types.h>
 #include <linux/rfkill.h>
 
 /**
  * struct rfkill_gpio_platform_data - platform data for rfkill gpio device.
- * for unused gpio's, the expected value is -1.
- * @name:		name for the gpio rf kill instance
- * @reset_gpio:		GPIO which is used for reseting rfkill switch
- * @shutdown_gpio:	GPIO which is used for shutdown of rfkill switch
- * @power_clk_name:	[optional] name of clk to turn off while blocked
- * @gpio_runtime_close:	clean up platform specific gpio configuration
- * @gpio_runtime_setup:	set up platform specific gpio configuration
+ * @name: name for the gpio rfkill instance
+ * @type: rfkill type for the instance
  */
 
 struct rfkill_gpio_platform_data {
 	char			*name;
-	int			reset_gpio;
-	int			shutdown_gpio;
-	const char		*power_clk_name;
 	enum rfkill_type	type;
-	void	(*gpio_runtime_close)(struct platform_device *);
-	int	(*gpio_runtime_setup)(struct platform_device *);
 };
 
 #endif /* __RFKILL_GPIO_H */
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index bd2a5b9..829da11 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/rfkill.h>
 #include <linux/platform_device.h>
-#include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
@@ -38,9 +37,6 @@ struct rfkill_gpio_data {
 	struct rfkill		*rfkill_dev;
 	char			*reset_name;
 	char			*shutdown_name;
-	struct clk		*clk;
-
-	bool			clk_enabled;
 };
 
 static int rfkill_gpio_set_power(void *data, bool blocked)
@@ -50,17 +46,11 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 	if (blocked) {
 		gpiod_set_value(rfkill->shutdown_gpio, 0);
 		gpiod_set_value(rfkill->reset_gpio, 0);
-		if (!IS_ERR(rfkill->clk) && rfkill->clk_enabled)
-			clk_disable(rfkill->clk);
 	} else {
-		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-			clk_enable(rfkill->clk);
 		gpiod_set_value(rfkill->reset_gpio, 1);
 		gpiod_set_value(rfkill->shutdown_gpio, 1);
 	}
 
-	rfkill->clk_enabled = blocked;
-
 	return 0;
 }
 
@@ -87,7 +77,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct rfkill_gpio_data *rfkill;
-	const char *clk_name = NULL;
 	struct gpio_desc *gpio;
 	int ret;
 	int len;
@@ -101,7 +90,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		if (ret)
 			return ret;
 	} else if (pdata) {
-		clk_name = pdata->power_clk_name;
 		rfkill->name = pdata->name;
 		rfkill->type = pdata->type;
 	} else {
@@ -120,8 +108,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	snprintf(rfkill->reset_name, len + 6 , "%s_reset", rfkill->name);
 	snprintf(rfkill->shutdown_name, len + 9, "%s_shutdown", rfkill->name);
 
-	rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
-
 	gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
@@ -146,14 +132,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (pdata && pdata->gpio_runtime_setup) {
-		ret = pdata->gpio_runtime_setup(pdev);
-		if (ret) {
-			dev_err(&pdev->dev, "can't set up gpio\n");
-			return ret;
-		}
-	}
-
 	rfkill->rfkill_dev = rfkill_alloc(rfkill->name, &pdev->dev,
 					  rfkill->type, &rfkill_gpio_ops,
 					  rfkill);
@@ -174,10 +152,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 static int rfkill_gpio_remove(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill = platform_get_drvdata(pdev);
-	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
 
-	if (pdata && pdata->gpio_runtime_close)
-		pdata->gpio_runtime_close(pdev);
 	rfkill_unregister(rfkill->rfkill_dev);
 	rfkill_destroy(rfkill->rfkill_dev);
 
-- 
1.8.4.3


--AhhlLboLdkugWU4S--
