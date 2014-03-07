Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaCHFgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:36:45 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:36726 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaCHFaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:21 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 6/8] of: Implement simplified graph binding for single port devices
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1394011242-16783-7-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> < 1394011242-16783-7-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 07 Mar 2014 18:38:02 +0000
Message-Id: <20140307183802.B6E90C40C6F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 10:20:40 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> For simple devices with only one port, it can be made implicit.
> The endpoint node can be a direct child of the device node.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Ergh... I think this is too loosely defined. The caller really should be
explicit about which behaviour it needs. I'll listen to arguments
though if you can make a strong argument.

g.

> --- > Changes since v5:
>  - Unrolled for-loop in of_graph_get_remote_port_parent
> ---
>  drivers/of/base.c | 42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 715144af..ffd0217 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -2003,7 +2003,8 @@ int of_graph_parse_endpoint(const struct device_node *node,
>  	 * It doesn't matter whether the two calls below succeed.
>  	 * If they don't then the default value 0 is used.
>  	 */
> -	of_property_read_u32(port_node, "reg", &endpoint->port);
> +	if (port_node && !of_node_cmp(port_node->name, "port"))
> +		of_property_read_u32(port_node, "reg", &endpoint->port);
>  	of_property_read_u32(node, "reg", &endpoint->id);
>  
>  	of_node_put(port_node);
> @@ -2034,8 +2035,13 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  		struct device_node *node;
>  		/*
>  		 * It's the first call, we have to find a port subnode
> -		 * within this node or within an optional 'ports' node.
> +		 * within this node or within an optional 'ports' node,
> +		 * or at least a single endpoint.
>  		 */
> +		endpoint = of_get_child_by_name(parent, "endpoint");
> +		if (endpoint)
> +			return endpoint;
> +
>  		node = of_get_child_by_name(parent, "ports");
>  		if (node)
>  			parent = node;
> @@ -2046,8 +2052,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  			/* Found a port, get an endpoint. */
>  			endpoint = of_get_next_child(port, NULL);
>  			of_node_put(port);
> -		} else {
> -			endpoint = NULL;
>  		}
>  
>  		if (!endpoint)
> @@ -2062,6 +2066,10 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
>  	if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
>  		      __func__, prev->full_name))
>  		return NULL;
> +	if (port == parent) {
> +		of_node_put(port);
> +		return NULL;
> +	}
>  
>  	/* Avoid dropping prev node refcount to 0. */
>  	of_node_get(prev);
> @@ -2097,18 +2105,21 @@ struct device_node *of_graph_get_remote_port_parent(
>  			       const struct device_node *node)
>  {
>  	struct device_node *np;
> -	unsigned int depth;
>  
>  	/* Get remote endpoint node. */
>  	np = of_parse_phandle(node, "remote-endpoint", 0);
> +	if (!np)
> +		return NULL;
>  
> -	/* Walk 3 levels up only if there is 'ports' node. */
> -	for (depth = 3; depth && np; depth--) {
> -		np = of_get_next_parent(np);
> -		if (depth == 2 && of_node_cmp(np->name, "ports"))
> -			break;
> -	}
> -	return np;
> +	np = of_get_next_parent(np);
> +	if (!np || of_node_cmp(np->name, "port") != 0)
> +		return np;
> +
> +	np = of_get_next_parent(np);
> +	if (!np || of_node_cmp(np->name, "ports") != 0)
> +		return np;
> +
> +	return of_get_next_parent(np);
>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port_parent);
>  
> @@ -2127,6 +2138,11 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
>  	np = of_parse_phandle(node, "remote-endpoint", 0);
>  	if (!np)
>  		return NULL;
> -	return of_get_next_parent(np);
> +	np = of_get_next_parent(np);
> +	if (of_node_cmp(np->name, "port")) {
> +		of_node_put(np);
> +		return NULL;
> +	}
> +	return np;
>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port);
> -- 
> 1.9.0.rc3
> 

