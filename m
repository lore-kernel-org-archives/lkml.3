Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaIKJ05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:26:57 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:34772 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaIKJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:26:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de
Subject: Re: [PATCH v2 5/8] of: Add of_graph_get_port_by_id function
Date: Thu, 11 Sep 2014 12:26:58 +0300
Message-ID: <1821937.Xurs6vFZSc@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1410346708-5125-6-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de> <1410346708-5125-6-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Thank you for the patch.

On Wednesday 10 September 2014 12:58:25 Philipp Zabel wrote:
> This patch adds a function to get a port device tree node by port id,
> or reg property value.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Fixed whitespace in comment
>  - Changed id parameter to of_graph_get_port_by_id to u32
>  - Simplified of_graph_get_port_by_id as suggested by Laurent,
>    making use of port id defaulting to 0 if no "reg" property is given.
> ---
>  drivers/of/base.c        | 26 ++++++++++++++++++++++++++
>  include/linux/of_graph.h |  7 +++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index a49b5628..b282474 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2053,6 +2053,32 @@ int of_graph_parse_endpoint(const struct device_node
> *node, EXPORT_SYMBOL(of_graph_parse_endpoint);
> 
>  /**
> + * of_graph_get_port_by_id() - get the port matching a given id
> + * @parent: pointer to the parent device node
> + * @id: id of the port
> + *
> + * Return: A 'port' node pointer with refcount incremented. The caller
> + * has to use of_node_put() on it when done.
> + */
> +struct device_node *of_graph_get_port_by_id(struct device_node *node, u32
> id) +{
> +	struct device_node *port = NULL;

No need to initialize port to NULL.

> +	u32 port_id = 0;
> +
> +	while (true) {
> +		port = of_get_next_child(node, port);
> +		if (!port)
> +			return NULL;

How about using for_each_child_of_node() ?

> +		if (of_node_cmp(port->name, "port") != 0)
> +			continue;
> +		of_property_read_u32(port, "reg", &port_id);

A port with no reg property will be treated as having the id of the previous 
port. You can fix this by moving the port_id variable declaration inside the 
loop.

> +		if (id == port_id)
> +			return port;
> +	}
> +}
> +EXPORT_SYMBOL(of_graph_get_port_by_id);
> +
> +/**
>   * of_graph_get_next_endpoint() - get next endpoint node
>   * @parent: pointer to the parent device node
>   * @prev: previous endpoint node, or NULL to get first
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index e43442e..e028e49 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -40,6 +40,7 @@ struct of_endpoint {
>  #ifdef CONFIG_OF
>  int of_graph_parse_endpoint(const struct device_node *node,
>  				struct of_endpoint *endpoint);
> +struct device_node *of_graph_get_port_by_id(struct device_node *node, u32
> id); struct device_node *of_graph_get_next_endpoint(const struct
> device_node *parent, struct device_node *previous);
>  struct device_node *of_graph_get_remote_port_parent(
> @@ -53,6 +54,12 @@ static inline int of_graph_parse_endpoint(const struct
> device_node *node, return -ENOSYS;
>  }
> 
> +static inline struct device_node *of_graph_get_port_by_id(
> +					struct device_node *node, int id)

id should be u32 here.

> +{
> +	return NULL;
> +}
> +
>  static inline struct device_node *of_graph_get_next_endpoint(
>  					const struct device_node *parent,
>  					struct device_node *previous)

-- 
Regards,

Laurent Pinchart

