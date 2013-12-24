Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3LXCZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:25:59 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37548 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LXCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:25:56 -0500
Date: Mon, 23 Dec 2013 18:20:36 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 1/3] power_supply: add power_supply_get_by_phandle
Message-ID: <20131224022035.GA25939@lizard>
References: <1385311771-447-1-git-send-email-sre@debian.org>
 <1385311771-447-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385311771-447-2-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 05:49:29PM +0100, Sebastian Reichel wrote:
> Add method to get power supply by device tree phandle.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/power/power_supply_core.c | 24 ++++++++++++++++++++++++
>  include/linux/power_supply.h      |  2 ++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 08bce22..99e4b41 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -340,6 +340,30 @@ struct power_supply *power_supply_get_by_name(const char *name)
...
> +
> +	dev = class_find_device(power_supply_class, NULL, power_supply_np,
> +						power_supply_match_device_node);
> +
> +	of_node_put(power_supply_np);
> +
> +	return dev ? dev_get_drvdata(dev) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);

The code had no !CONFIG_OF protection so I had to make the following
changes to this patch:

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 23cd055..2660664 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -341,6 +341,7 @@ struct power_supply *power_supply_get_by_name(const char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+#ifdef CONFIG_OF
 static int power_supply_match_device_node(struct device *dev, const void *data)
 {
 	return dev->parent && dev->parent->of_node == data;
@@ -364,6 +365,7 @@ struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 	return dev ? dev_get_drvdata(dev) : NULL;
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_phandle);
+#endif /* CONFIG_OF */
 
 int power_supply_powers(struct power_supply *psy, struct device *dev)
 {
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 8d06537..c9dc4e0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -244,8 +244,14 @@ extern struct atomic_notifier_head power_supply_notifier;
 extern int power_supply_reg_notifier(struct notifier_block *nb);
 extern void power_supply_unreg_notifier(struct notifier_block *nb);
 extern struct power_supply *power_supply_get_by_name(const char *name);
+#ifdef CONFIG_OF
 extern struct power_supply *power_supply_get_by_phandle(struct device_node *np,
 							const char *property);
+#else /* !CONFIG_OF */
+static inline struct power_supply *
+power_supply_get_by_phandle(struct device_node *np, const char *property)
+{ return NULL; }
+#endif /* CONFIG_OF */
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
 extern int power_supply_set_battery_charged(struct power_supply *psy);
