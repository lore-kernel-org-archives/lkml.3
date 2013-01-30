Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3A3HUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:20:46 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33232 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3A3HUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:20:43 -0500
Message-ID: <5108C9C1.1090707@gmail.com>
Date: Wed, 30 Jan 2013 15:20:33 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, gnurou@gmail.com
Subject: Re: [RFC 1/4] video: panel: add CLAA101WA01A panel support
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1359514939-15653-2-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 11:02 AM, Alexandre Courbot wrote:
> Add support for the Chunghwa CLAA101WA01A display panel.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
[...]
> +
> +#include <video/display.h>
> +
> +#define CLAA101WA01A_WIDTH	223
> +#define CLAA101WA01A_HEIGHT	125

If I remember correct, the physical size of the panel can be fetched in
EDID. If this is correct, we don't have to hard-code here.

> +
> +struct panel_claa101 {
> +	struct display_entity entity;
> +	struct regulator *vdd_pnl;
> +	struct regulator *vdd_bl;
> +	/* Enable GPIOs */
> +	int pnl_enable;
> +	int bl_enable;
> +};
> +
> +#define to_panel_claa101(p)	container_of(p, struct panel_claa101, entity)
> +
> +static int panel_claa101_set_state(struct display_entity *entity,
> +				   enum display_entity_state state)
> +{
> +	struct panel_claa101 *panel = to_panel_claa101(entity);
> +
> +	/* OFF and STANDBY are equivalent to us */
> +	if (state == DISPLAY_ENTITY_STATE_STANDBY)
> +		state = DISPLAY_ENTITY_STATE_OFF;

Do we need this? The "switch" below handles the same thing already.

> +
> +	switch (state) {
> +	case DISPLAY_ENTITY_STATE_OFF:
> +	case DISPLAY_ENTITY_STATE_STANDBY:
> +		if (entity->source)
> +			display_entity_set_stream(entity->source,
> +						 DISPLAY_ENTITY_STREAM_STOPPED);
> +
> +		/* TODO error checking? */
> +		gpio_set_value_cansleep(panel->bl_enable, 0);
> +		usleep_range(10000, 10000);
> +		regulator_disable(panel->vdd_bl);
> +		usleep_range(200000, 200000);
> +		gpio_set_value_cansleep(panel->pnl_enable, 0);
> +		regulator_disable(panel->vdd_pnl);
> +		break;
> +
> +	case DISPLAY_ENTITY_STATE_ON:
> +		regulator_enable(panel->vdd_pnl);
> +		gpio_set_value_cansleep(panel->pnl_enable, 1);
> +		usleep_range(200000, 200000);
> +		regulator_enable(panel->vdd_bl);
> +		usleep_range(10000, 10000);
> +		gpio_set_value_cansleep(panel->bl_enable, 1);
> +
> +		if (entity->source)
> +			display_entity_set_stream(entity->source,
> +					      DISPLAY_ENTITY_STREAM_CONTINUOUS);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int panel_claa101_get_modes(struct display_entity *entity,
> +				   const struct videomode **modes)
> +{
> +	/* TODO get modes from EDID? */

Why not move the "nvidia,ddc" from encoder's DT to panel's DT? In that
case, you can get EDID here. I know drm has some helpers to fetch EDID
but I recall there are some other functions which has no drm
dependencies which may be suitable for you.

> +	return 0;
> +}
[...]
> +
> +static int __exit panel_claa101_remove(struct platform_device *pdev)
> +{
> +	struct panel_claa101 *panel = platform_get_drvdata(pdev);
> +
> +	display_entity_unregister(&panel->entity);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF

We don't need this kind of "ifdef" in upstream kernel.

> +static struct of_device_id panel_claa101_of_match[] = {
> +	{ .compatible = "chunghwa,claa101wa01a", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, pwm_backlight_of_match);

What does this mean? Why we need this?

> +#else
> +#endif
> +
> +static const struct dev_pm_ops panel_claa101_dev_pm_ops = {
> +};
> +
> +static struct platform_driver panel_claa101_driver = {
> +	.probe = panel_claa101_probe,
> +	.remove = panel_claa101_remove,
> +	.driver = {
> +		.name = "panel_claa101wa01a",
> +		.owner = THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm = &panel_claa101_dev_pm_ops,

If you haven't implemented this in this patch set, I suggest removing this.

> +#endif
> +#ifdef CONFIG_OF
> +		.of_match_table	= of_match_ptr(panel_claa101_of_match),
> +#endif
> +	},
> +};
> +
> +module_platform_driver(panel_claa101_driver);
> +
> +MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
> +MODULE_DESCRIPTION("Chunghwa CLAA101WA01A Display Panel");
> +MODULE_LICENSE("GPL");
> 
