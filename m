Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaBZLhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:37:43 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52000 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaBZLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:37:39 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
In-Reply-To: <1393340304-19005-2-git-send-email-p.zabel@pengutronix.de>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de>
Date: Wed, 26 Feb 2014 11:37:29 +0000
Message-Id: <20140226113729.A9D5AC40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014 15:58:22 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> From: Philipp Zabel <philipp.zabel@gmail.com>
> 
> This patch moves the parsing helpers used to parse connected graphs
> in the device tree, like the video interface bindings documented in
> Documentation/devicetree/bindings/media/video-interfaces.txt, from
> drivers/media/v4l2-core to drivers/of.
> 
> This allows to reuse the same parser code from outside the V4L2
> framework, most importantly from display drivers.
> The functions v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
> and v4l2_of_get_remote_port_parent are moved. They are renamed to
> of_graph_get_next_endpoint, of_graph_get_remote_port, and
> of_graph_get_remote_port_parent, respectively.
> Since there are not that many current users yet, switch all of
> them to the new functions right away.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v3:
>  - Moved back to drivers/of
> ---
>  drivers/media/i2c/adv7343.c                   |   4 +-
>  drivers/media/i2c/mt9p031.c                   |   4 +-
>  drivers/media/i2c/s5k5baf.c                   |   3 +-
>  drivers/media/i2c/tvp514x.c                   |   3 +-
>  drivers/media/i2c/tvp7002.c                   |   3 +-
>  drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
>  drivers/media/platform/exynos4-is/media-dev.c |   3 +-
>  drivers/media/platform/exynos4-is/mipi-csis.c |   3 +-
>  drivers/media/v4l2-core/v4l2-of.c             | 117 ----------------------
>  drivers/of/Makefile                           |   1 +
>  drivers/of/of_graph.c                         | 134 ++++++++++++++++++++++++++

Nah. Just put it into drivers/of/base.c. This isn't a separate subsystem
and the functions are pretty basic.

>  include/linux/of_graph.h                      |  46 +++++++++
>  include/media/v4l2-of.h                       |  25 +----
>  13 files changed, 199 insertions(+), 153 deletions(-)
>  create mode 100644 drivers/of/of_graph.c
>  create mode 100644 include/linux/of_graph.h
> 
[...]
> diff --git a/drivers/of/of_graph.c b/drivers/of/of_graph.c
> new file mode 100644
> index 0000000..267d8f7
> --- /dev/null
> +++ b/drivers/of/of_graph.c
> @@ -0,0 +1,134 @@
> +/*
> + * OF graph binding parsing library
> + *
> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/types.h>
> +
> +/**
> + * of_graph_get_next_endpoint() - get next endpoint node
> + * @parent: pointer to the parent device node
> + * @prev: previous endpoint node, or NULL to get first
> + *
> + * Return: An 'endpoint' node pointer with refcount incremented. Refcount
> + * of the passed @prev node is not decremented, the caller have to use
> + * of_node_put() on it when done.
> + */
> +struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
> +					struct device_node *prev)
> +{
> +	struct device_node *endpoint;
> +	struct device_node *port = NULL;
> +
> +	if (!parent)
> +		return NULL;
> +
> +	if (!prev) {
> +		struct device_node *node;
> +		/*
> +		 * It's the first call, we have to find a port subnode
> +		 * within this node or within an optional 'ports' node.
> +		 */
> +		node = of_get_child_by_name(parent, "ports");
> +		if (node)
> +			parent = node;
> +
> +		port = of_get_child_by_name(parent, "port");

If you've got a "ports" node, then I would expect every single child to
be a port. Should not need the _by_name variant.

It seems that this function is merely a helper to get all grandchildren
of a node (with some very minor constraints). That could be generalized
and simplified. If the function takes the "ports" node as an argument
instead of the parent, then there is a greater likelyhood that other
code can make use of it...

Thinking further. I think the semantics of this whole feature basically
boil down to this:

#define for_each_grandchild_of_node(parent, child, grandchild) \
	for_each_child_of_node(parent, child) \
		for_each_child_of_node(child, grandchild)

Correct? Or in this specific case:

	parent = of_get_child_by_name(np, "ports")
	for_each_grandchild_of_node(parent, child, grandchild) {
		...
	}

Finally, looking at the actual patch, is any of this actually needed.
All of the users updated by this patch only ever handle a single
endpoint. Have I read it correctly? Are there any users supporting
multiple endpoints?

> +
> +		if (port) {
> +			/* Found a port, get an endpoint. */
> +			endpoint = of_get_next_child(port, NULL);
> +			of_node_put(port);
> +		} else {
> +			endpoint = NULL;
> +		}
> +
> +		if (!endpoint)
> +			pr_err("%s(): no endpoint nodes specified for %s\n",
> +			       __func__, parent->full_name);
> +		of_node_put(node);

If you 'return endpoint' here, then the else block can go down a level.

> +	} else {
> +		port = of_get_parent(prev);
> +		if (!port)
> +			/* Hm, has someone given us the root node ?... */
> +			return NULL;

WARN_ONCE(). That's a very definite coding failure if that happens.

> +
> +		/* Avoid dropping prev node refcount to 0. */
> +		of_node_get(prev);
> +		endpoint = of_get_next_child(port, prev);
> +		if (endpoint) {
> +			of_node_put(port);
> +			return endpoint;
> +		}
> +
> +		/* No more endpoints under this port, try the next one. */
> +		do {
> +			port = of_get_next_child(parent, port);
> +			if (!port)
> +				return NULL;
> +		} while (of_node_cmp(port->name, "port"));
> +
> +		/* Pick up the first endpoint in this port. */
> +		endpoint = of_get_next_child(port, NULL);
> +		of_node_put(port);
> +	}
> +
> +	return endpoint;
> +}
> +EXPORT_SYMBOL(of_graph_get_next_endpoint);
> +
> +/**
> + * of_graph_get_remote_port_parent() - get remote port's parent node
> + * @node: pointer to a local endpoint device_node
> + *
> + * Return: Remote device node associated with remote endpoint node linked
> + *	   to @node. Use of_node_put() on it when done.
> + */
> +struct device_node *of_graph_get_remote_port_parent(
> +			       const struct device_node *node)
> +{
> +	struct device_node *np;
> +	unsigned int depth;
> +
> +	/* Get remote endpoint node. */
> +	np = of_parse_phandle(node, "remote-endpoint", 0);
> +
> +	/* Walk 3 levels up only if there is 'ports' node. */

This needs a some explaining. My reading of the binding pattern is that
it will always be a fixed number of levels. Why is this test fuzzy?

> +	for (depth = 3; depth && np; depth--) {
> +		np = of_get_next_parent(np);
> +		if (depth == 2 && of_node_cmp(np->name, "ports"))
> +			break;
> +	}
> +	return np;
> +}
> +EXPORT_SYMBOL(of_graph_get_remote_port_parent);
> +
> +/**
> + * of_graph_get_remote_port() - get remote port node
> + * @node: pointer to a local endpoint device_node
> + *
> + * Return: Remote port node associated with remote endpoint node linked
> + *	   to @node. Use of_node_put() on it when done.
> + */
> +struct device_node *of_graph_get_remote_port(const struct device_node *node)
> +{
> +	struct device_node *np;
> +
> +	/* Get remote endpoint node. */
> +	np = of_parse_phandle(node, "remote-endpoint", 0);
> +	if (!np)
> +		return NULL;
> +	return of_get_next_parent(np);
> +}
> +EXPORT_SYMBOL(of_graph_get_remote_port);
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> new file mode 100644
> index 0000000..3bbeb60
> --- /dev/null
> +++ b/include/linux/of_graph.h
> @@ -0,0 +1,46 @@
> +/*
> + * OF graph binding parsing helpers
> + *
> + * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
> + * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * Copyright (C) 2012 Renesas Electronics Corp.
> + * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __LINUX_OF_GRAPH_H
> +#define __LINUX_OF_GRAPH_H
> +
> +#ifdef CONFIG_OF
> +struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
> +					struct device_node *previous);
> +struct device_node *of_graph_get_remote_port_parent(
> +					const struct device_node *node);
> +struct device_node *of_graph_get_remote_port(const struct device_node *node);
> +#else
> +
> +static inline struct device_node *of_graph_get_next_endpoint(
> +					const struct device_node *parent,
> +					struct device_node *previous)
> +{
> +	return NULL;
> +}
> +
> +static inline struct device_node *of_graph_get_remote_port_parent(
> +					const struct device_node *node)
> +{
> +	return NULL;
> +}
> +
> +static inline struct device_node *of_graph_get_remote_port(
> +					const struct device_node *node)
> +{
> +	return NULL;
> +}
> +
> +#endif /* CONFIG_OF */
> +
> +#endif /* __LINUX_OF_GRAPH_H */
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 541cea4..3a49735 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -17,6 +17,7 @@
>  #include <linux/list.h>
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/of_graph.h>
>  
>  #include <media/v4l2-mediabus.h>
>  
> @@ -72,11 +73,6 @@ struct v4l2_of_endpoint {
>  #ifdef CONFIG_OF
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>  			   struct v4l2_of_endpoint *endpoint);
> -struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
> -					struct device_node *previous);
> -struct device_node *v4l2_of_get_remote_port_parent(
> -					const struct device_node *node);
> -struct device_node *v4l2_of_get_remote_port(const struct device_node *node);
>  #else /* CONFIG_OF */
>  
>  static inline int v4l2_of_parse_endpoint(const struct device_node *node,
> @@ -85,25 +81,6 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
>  	return -ENOSYS;
>  }
>  
> -static inline struct device_node *v4l2_of_get_next_endpoint(
> -					const struct device_node *parent,
> -					struct device_node *previous)
> -{
> -	return NULL;
> -}
> -
> -static inline struct device_node *v4l2_of_get_remote_port_parent(
> -					const struct device_node *node)
> -{
> -	return NULL;
> -}
> -
> -static inline struct device_node *v4l2_of_get_remote_port(
> -					const struct device_node *node)
> -{
> -	return NULL;
> -}
> -
>  #endif /* CONFIG_OF */
>  
>  #endif /* _V4L2_OF_H */
> -- 
> 1.8.5.3
> 

