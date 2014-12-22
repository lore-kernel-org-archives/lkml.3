Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaLVVJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:09:48 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61378 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaLVVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <1419261091-29888-2-git-send-email-p.zabel@pengutronix.de>
References: <1419261091-29888-1-git-send-email-p.zabel@pengutronix.de>
	<1419261091-29888-2-git-send-email-p.zabel@pengutronix.de>
Date: Mon, 22 Dec 2014 14:09:46 -0700
Message-ID: <CANLsYkydZGBQa2KXyVsjp3PaAvfBtOSf+qa0yVdzidJbxcQybw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 December 2014 at 08:11, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (that is, soc_camera and imx-drm) are changed to not decrement the passed
> prev argument's refcount themselves.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> Changes since v5:
>  - Rebased onto v3.19-rc1
>  - Added coresight and rcar-du
> ---
>  drivers/coresight/of_coresight.c               | 13 ++-----------
>  drivers/gpu/drm/imx/imx-drm-core.c             | 13 ++-----------
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c          | 15 ++++-----------
>  drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
>  drivers/of/base.c                              |  9 +--------
>  5 files changed, 11 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
> index 5030c07..349c88b 100644
> --- a/drivers/coresight/of_coresight.c
> +++ b/drivers/coresight/of_coresight.c
> @@ -52,15 +52,6 @@ of_coresight_get_endpoint_device(struct device_node *endpoint)
>                                endpoint, of_dev_node_match);
>  }
>
> -static struct device_node *of_get_coresight_endpoint(
> -               const struct device_node *parent, struct device_node *prev)
> -{
> -       struct device_node *node = of_graph_get_next_endpoint(parent, prev);
> -
> -       of_node_put(prev);
> -       return node;
> -}
> -
>  static void of_coresight_get_ports(struct device_node *node,
>                                    int *nr_inport, int *nr_outport)
>  {
> @@ -68,7 +59,7 @@ static void of_coresight_get_ports(struct device_node *node,
>         int in = 0, out = 0;
>
>         do {
> -               ep = of_get_coresight_endpoint(node, ep);
> +               ep = of_graph_get_next_endpoint(node, ep);
>                 if (!ep)
>                         break;
>
> @@ -140,7 +131,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
>                 /* Iterate through each port to discover topology */
>                 do {
>                         /* Get a handle on a port */
> -                       ep = of_get_coresight_endpoint(node, ep);
> +                       ep = of_graph_get_next_endpoint(node, ep);
>                         if (!ep)
>                                 break;
>

I tested this in my tree - ack.
