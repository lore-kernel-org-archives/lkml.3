Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaKGWGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:06:40 -0500
Received: from mout.gmx.net ([212.227.15.18]:64619 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaKGWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:06:39 -0500
Date: Fri, 7 Nov 2014 23:06:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Philipp Zabel <p.zabel@pengutronix.de>
cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
In-Reply-To: <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1411072255130.4252@axis700.grange>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:05Qtlnx9xJeckAm7VETYPEtHplYilEZNG5wggosA2erUBYtx+um
 0Swsy+8SwjA8CI3gjAk3/tZJwd4reBzbUSNRupRfdk8mLXBdOM+VuIgVi4/noib5kEVLYFl
 HRg/cAl997b3vssXJAo0HsB8JpvIZ5pQYxF76eu/j7aUr+h3WYhHwI1T8+L45KwhiZGhYkg
 EqpxWjveVTHU//vDgUTXA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thanks for the patch and sorry for a late reply. I did look at your 
patches earlier too, but maybe not attentively enough, or maybe I'm 
misunderstanding something now. In the scan_of_host() function in 
soc_camera.c as of current -next I see:

		epn = of_graph_get_next_endpoint(np, epn);

which already looks like a refcount leak to me. If epn != NULL, its 
refcount is incremented, but then immediately the variable gets 
overwritten, and there's no extra copy of that variable to fix this. If 
I'm right, then that bug in itself should be fixed, ideally before your 
patch is applied. But in fact, your patch fixes this, since it modifies 
of_graph_get_next_endpoint() to return with prev's refcount not 
incremented, right? Whereas the of_node_put(epn) later down in 
scan_of_host() decrements refcount of the _next_ endpoint, not the 
previous one, so, it should be left alone? I.e. AFAICT your modification 
to of_graph_get_next_endpoint() fixes soc_camera.c with no further 
modifications to it required?

Thanks
Guennadi

On Mon, 29 Sep 2014, Philipp Zabel wrote:

> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (that is, soc_camera and imx-drm) are changed to not decrement the passed
> prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v4:
>  - Folded patches 1-3 into this one
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
>  drivers/of/base.c                              |  9 +--------
>  drivers/staging/imx-drm/imx-drm-core.c         | 12 ++----------
>  3 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index f4308fe..619b2d4 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1696,7 +1696,6 @@ static void scan_of_host(struct soc_camera_host *ici)
>  		if (!i)
>  			soc_of_bind(ici, epn, ren->parent);
>  
> -		of_node_put(epn);
>  		of_node_put(ren);
>  
>  		if (i) {
> @@ -1704,6 +1703,8 @@ static void scan_of_host(struct soc_camera_host *ici)
>  			break;
>  		}
>  	}
> +
> +	of_node_put(epn);
>  }
>  
>  #else
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 293ed4b..f7a9aa8 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2070,8 +2070,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
>   * @prev: previous endpoint node, or NULL to get first
>   *
>   * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> - * of the passed @prev node is not decremented, the caller have to use
> - * of_node_put() on it when done.
> + * of the passed @prev node is decremented.
>   */
>  struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  					struct device_node *prev)
> @@ -2107,12 +2106,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
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
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 6b22106..12303b3 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -434,14 +434,6 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
>  	return 0;
>  }
>  
> -static struct device_node *imx_drm_of_get_next_endpoint(
> -		const struct device_node *parent, struct device_node *prev)
> -{
> -	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
> -	of_node_put(prev);
> -	return node;
> -}
> -
>  int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	struct drm_encoder *encoder, struct device_node *np)
>  {
> @@ -453,7 +445,7 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
>  	for (i = 0; ; i++) {
>  		u32 mask;
>  
> -		ep = imx_drm_of_get_next_endpoint(np, ep);
> +		ep = of_graph_get_next_endpoint(np, ep);
>  		if (!ep)
>  			break;
>  
> @@ -502,7 +494,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
>  		return -EINVAL;
>  
>  	do {
> -		ep = imx_drm_of_get_next_endpoint(node, ep);
> +		ep = of_graph_get_next_endpoint(node, ep);
>  		if (!ep)
>  			break;
>  
> -- 
> 2.1.0
> 
