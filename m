Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3A3GuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:50:12 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61419 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3A3GuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:50:10 -0500
Message-ID: <5108C298.1000500@gmail.com>
Date: Wed, 30 Jan 2013 14:50:00 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, gnurou@gmail.com
Subject: Re: [RFC 3/4] drm: tegra: use the Common Display Framework
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com> <1359514939-15653-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1359514939-15653-4-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 11:02 AM, Alexandre Courbot wrote:
> Make the tegra-drm driver use the Common Display Framework, letting it
> control the panel state according to the DPMS status.
> 
> A "nvidia,panel" property is added to the output node of the Tegra DC
> that references the panel connected to a given output.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
[...]
> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> index 741b5dc..5e63c56 100644
> --- a/drivers/gpu/drm/tegra/drm.h
> +++ b/drivers/gpu/drm/tegra/drm.h
> @@ -17,6 +17,7 @@
>  #include <drm/drm_gem_cma_helper.h>
>  #include <drm/drm_fb_cma_helper.h>
>  #include <drm/drm_fixed.h>
> +#include <video/display.h>
>  
>  struct tegra_framebuffer {
>  	struct drm_framebuffer base;
> @@ -147,6 +148,9 @@ struct tegra_output {
>  
>  	struct drm_encoder encoder;
>  	struct drm_connector connector;
> +	struct display_entity this;
> +	struct display_entity *output;

Could you pick up a somewhat meaningful name? You know, there are too
many variables with name "drm/connector/output/encoder"... :)

> +	struct display_entity_notifier display_notifier;
>  };
>  
[...]
> +static int display_notify_callback(struct display_entity_notifier *notifier,
> +				   struct display_entity *entity, int event)
> +{
> +	struct tegra_output *output = display_notifier_to_output(notifier);
> +	struct device_node *pnode;
> +
> +	switch (event) {
> +	case DISPLAY_ENTITY_NOTIFIER_CONNECT:
> +		if (output->output)
> +			break;
> +
> +		pnode = of_parse_phandle(output->of_node, "nvidia,panel", 0);
> +		if (!pnode)
> +			break;
> +
> +		if (entity->dev && entity->dev->of_node == pnode) {
> +			dev_dbg(output->dev, "connecting panel\n");
> +			output->output = display_entity_get(entity);
> +			display_entity_connect(&output->this, output->output);
> +		}
> +		of_node_put(pnode);
> +
> +		break;
> +
> +	case DISPLAY_ENTITY_NOTIFIER_DISCONNECT:
> +		if (!output->output || output->output != entity)
> +			break;
> +
> +		dev_dbg(output->dev, "disconnecting panel\n");
> +		display_entity_disconnect(&output->this, output->output);
> +		output->output = NULL;
> +		display_entity_put(&output->this);

No "display_entity_get" for "output->this", so I don't think we need
"display_entity_put" here. If you register this entity with "release"
callback and you wanna release "output->this", call the "release"
function manually.

Only when you have "display_entity_get", use "display_entity_put" to
release.

> +
> +		break;
> +
> +	default:
> +		dev_dbg(output->dev, "unhandled display event\n");
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
[...]
>  int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
>  {
>  	int connector, encoder, err;
> @@ -250,6 +341,23 @@ int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
>  
>  	output->encoder.possible_crtcs = 0x3;
>  
> +	/* register display entity */
> +	memset(&output->this, 0, sizeof(output->this));
> +	output->this.dev = drm->dev;

Use "output->dev" here. Actually the device you wanna register it to
display entity is the "encoder"(in drm terms), not "drm->dev". If we use
"drm->dev" here, we will have all same device for all encoders(HDMI,
DSI...).

> +	output->this.ops.video = &tegra_output_video_ops;
> +	err = display_entity_register(&output->this);
> +	if (err) {
> +		dev_err(output->dev, "cannot register display entity\n");
> +		return err;
> +	}
> +
> +	/* register display notifier */
> +	output->display_notifier.dev = NULL;

Set "display_notifier.dev" to NULL makes we have to compare with every
display entity, just like what you do in "display_notify_callback":

entity->dev && entity->dev->of_node == pnode

So can we get the "struct device *" of panel here? Seems currently the
"of" framework doesn't allow "device_node -> device".

> +	output->display_notifier.notify = display_notify_callback;
> +	err = display_entity_register_notifier(&output->display_notifier);
> +	if (err)
> +		return err;
> +
>  	return 0;
>  
>  free_hpd:
> @@ -260,6 +368,12 @@ free_hpd:
>  
>  int tegra_output_exit(struct tegra_output *output)
>  {
> +	if (output->output)
> +		display_entity_put(output->output);
> +
> +	display_entity_unregister_notifier(&output->display_notifier);
> +	display_entity_unregister(&output->this);
> +
>  	if (gpio_is_valid(output->hpd_gpio)) {
>  		free_irq(output->hpd_irq, output);
>  		gpio_free(output->hpd_gpio);
> 
