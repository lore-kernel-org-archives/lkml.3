Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaLZJoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:44:05 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:58344 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaLZJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:44:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v7 1/3] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Fri, 26 Dec 2014 11:44:04 +0200
Message-ID: <1673229.XX60cPdPif@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1419340158-20567-2-git-send-email-p.zabel@pengutronix.de>
References: <1419340158-20567-1-git-send-email-p.zabel@pengutronix.de> <1419340158-20567-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Tuesday 23 December 2014 14:09:16 Philipp Zabel wrote:
> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (coresight, rcar-du, imx-drm, soc_camera, and omap2-dss) are changed to
> not decrement the passed prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
> Changes since v6:
>  - Added omap2-dss.
>  - Added Mathieu's ack.
> ---
>  drivers/coresight/of_coresight.c                  | 13 ++-----------
>  drivers/gpu/drm/imx/imx-drm-core.c                | 13 ++-----------
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 ++++-----------

For rcar-du,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  drivers/media/platform/soc_camera/soc_camera.c    |  3 ++-
>  drivers/of/base.c                                 |  9 +--------
>  drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +------
>  6 files changed, 12 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/coresight/of_coresight.c
> b/drivers/coresight/of_coresight.c index 5030c07..349c88b 100644
> --- a/drivers/coresight/of_coresight.c
> +++ b/drivers/coresight/of_coresight.c
> @@ -52,15 +52,6 @@ of_coresight_get_endpoint_device(struct device_node
> *endpoint) endpoint, of_dev_node_match);
>  }
> 
> -static struct device_node *of_get_coresight_endpoint(
> -		const struct device_node *parent, struct device_node *prev)
> -{
> -	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
> -
> -	of_node_put(prev);
> -	return node;
> -}
> -
>  static void of_coresight_get_ports(struct device_node *node,
>  				   int *nr_inport, int *nr_outport)
>  {
> @@ -68,7 +59,7 @@ static void of_coresight_get_ports(struct device_node
> *node, int in = 0, out = 0;
> 
>  	do {
> -		ep = of_get_coresight_endpoint(node, ep);
> +		ep = of_graph_get_next_endpoint(node, ep);
>  		if (!ep)
>  			break;
> 
> @@ -140,7 +131,7 @@ struct coresight_platform_data
> *of_get_coresight_platform_data( /* Iterate through each port to discover
> topology */
>  		do {
>  			/* Get a handle on a port */
> -			ep = of_get_coresight_endpoint(node, ep);
> +			ep = of_graph_get_next_endpoint(node, ep);
>  			if (!ep)
>  				break;
> 
> diff --git a/drivers/gpu/drm/imx/imx-drm-core.c
> b/drivers/gpu/drm/imx/imx-drm-core.c index b250130..fed627d 100644
> --- a/drivers/gpu/drm/imx/imx-drm-core.c
> +++ b/drivers/gpu/drm/imx/imx-drm-core.c
> @@ -436,15 +436,6 @@ static uint32_t imx_drm_find_crtc_mask(struct
> imx_drm_device *imxdrm, return 0;
>  }
> 
> -static struct device_node *imx_drm_of_get_next_endpoint(
> -		const struct device_node *parent, struct device_node *prev)
> -{
> -	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
> -
> -	of_node_put(prev);
> -	return node;
> -}
> -
>  int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	struct drm_encoder *encoder, struct device_node *np)
>  {
> @@ -456,7 +447,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	for (i = 0; ; i++) {
>  		u32 mask;
> 
> -		ep = imx_drm_of_get_next_endpoint(np, ep);
> +		ep = of_graph_get_next_endpoint(np, ep);
>  		if (!ep)
>  			break;
> 
> @@ -504,7 +495,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
> return -EINVAL;
> 
>  	do {
> -		ep = imx_drm_of_get_next_endpoint(node, ep);
> +		ep = of_graph_get_next_endpoint(node, ep);
>  		if (!ep)
>  			break;
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> b/drivers/gpu/drm/rcar-du/rcar_du_kms.c index 0c5ee61..480c4d9 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> @@ -206,7 +206,7 @@ static int rcar_du_encoders_init_one(struct
> rcar_du_device *rcdu, enum rcar_du_encoder_type enc_type =
> RCAR_DU_ENCODER_NONE;
>  	struct device_node *connector = NULL;
>  	struct device_node *encoder = NULL;
> -	struct device_node *prev = NULL;
> +	struct device_node *ep_node = NULL;
>  	struct device_node *entity_ep_node;
>  	struct device_node *entity;
>  	int ret;
> @@ -225,11 +225,7 @@ static int rcar_du_encoders_init_one(struct
> rcar_du_device *rcdu, entity_ep_node = of_parse_phandle(ep->local_node,
> "remote-endpoint", 0);
> 
>  	while (1) {
> -		struct device_node *ep_node;
> -
> -		ep_node = of_graph_get_next_endpoint(entity, prev);
> -		of_node_put(prev);
> -		prev = ep_node;
> +		ep_node = of_graph_get_next_endpoint(entity, ep_node);
> 
>  		if (!ep_node)
>  			break;
> @@ -300,7 +296,7 @@ static int rcar_du_encoders_init_one(struct
> rcar_du_device *rcdu, static int rcar_du_encoders_init(struct
> rcar_du_device *rcdu)
>  {
>  	struct device_node *np = rcdu->dev->of_node;
> -	struct device_node *prev = NULL;
> +	struct device_node *ep_node = NULL;
>  	unsigned int num_encoders = 0;
> 
>  	/*
> @@ -308,15 +304,12 @@ static int rcar_du_encoders_init(struct rcar_du_device
> *rcdu) * pipeline.
>  	 */
>  	while (1) {
> -		struct device_node *ep_node;
>  		enum rcar_du_output output;
>  		struct of_endpoint ep;
>  		unsigned int i;
>  		int ret;
> 
> -		ep_node = of_graph_get_next_endpoint(np, prev);
> -		of_node_put(prev);
> -		prev = ep_node;
> +		ep_node = of_graph_get_next_endpoint(np, ep_node);
> 
>  		if (ep_node == NULL)
>  			break;
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> b/drivers/media/platform/soc_camera/soc_camera.c index b3db51c..289b637
> 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1710,7 +1710,6 @@ static void scan_of_host(struct soc_camera_host *ici)
>  		if (!i)
>  			soc_of_bind(ici, epn, ren->parent);
> 
> -		of_node_put(epn);
>  		of_node_put(ren);
> 
>  		if (i) {
> @@ -1718,6 +1717,8 @@ static void scan_of_host(struct soc_camera_host *ici)
>  			break;
>  		}
>  	}
> +
> +	of_node_put(epn);
>  }
> 
>  #else
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 36536b6..aac66df 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2085,8 +2085,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
>   * @prev: previous endpoint node, or NULL to get first
>   *
>   * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> - * of the passed @prev node is not decremented, the caller have to use
> - * of_node_put() on it when done.
> + * of the passed @prev node is decremented.
>   */
>  struct device_node *of_graph_get_next_endpoint(const struct device_node
> *parent, struct device_node *prev)
> @@ -2122,12 +2121,6 @@ struct device_node *of_graph_get_next_endpoint(const
> struct device_node *parent, if (WARN_ONCE(!port, "%s(): endpoint %s has no
> parent node\n",
>  			      __func__, prev->full_name))
>  			return NULL;
> -
> -		/*
> -		 * Avoid dropping prev node refcount to 0 when getting the next
> -		 * child below.
> -		 */
> -		of_node_get(prev);
>  	}
> 
>  	while (1) {
> diff --git a/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
> b/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c index 2f0822e..76fb18b
> 100644
> --- a/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
> +++ b/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
> @@ -164,20 +164,15 @@ static void __init omapdss_walk_device(struct
> device_node *node, bool root)
> 
>  		pn = of_graph_get_remote_port_parent(n);
> 
> -		if (!pn) {
> -			of_node_put(n);
> +		if (!pn)
>  			continue;
> -		}
> 
>  		if (!of_device_is_available(pn) || omapdss_list_contains(pn)) {
>  			of_node_put(pn);
> -			of_node_put(n);
>  			continue;
>  		}
> 
>  		omapdss_walk_device(pn, false);
> -
> -		of_node_put(n);
>  	}
>  }

-- 
Regards,

Laurent Pinchart

