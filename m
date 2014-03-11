Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaCKPUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:20:18 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53691 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaCKPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:20:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Tue, 11 Mar 2014 16:21:49 +0100
Message-ID: <2089551.u6VYBAmlhv@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394550420.3772.29.camel@paszta.hi.pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140310145815.17595C405FA@trevor.secretlab.ca> <1394550420.3772.29.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Tuesday 11 March 2014 16:07:00 Philipp Zabel wrote:
> Am Montag, den 10.03.2014, 14:58 +0000 schrieb Grant Likely:
> > On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart wrote:

[snip]

> > > In theory unidirectional links in DT are indeed enough. However, let's
> > > not forget the following.
> > > 
> > > - There's no such thing as single start points for graphs. Sure, in some
> > > simple cases the graph will have a single start point, but that's not a
> > > generic rule. For instance the camera graphs
> > > http://ideasonboard.org/media/omap3isp.ps and
> > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and
> > > thus two starting points from a data flow point of view. And if you
> > > want a better understanding of how complex media graphs can become,
> > > have a look at http://ideasonboard.org/media/vsp1.0.pdf (that's a real
> > > world example, albeit all connections are internal to the SoC in that
> > > particular case, and don't need to be described in DT).
> > > 
> > > - There's also no such thing as a master device that can just point to
> > > slave devices. Once again simple cases exist where that model could
> > > work, but real world examples exist of complex pipelines with dozens of
> > > elements all implemented by a separate IP core and handled by separate
> > > drivers, forming a graph with long chains and branches. We thus need
> > > real graph bindings.
> > > 
> > > - Finally, having no backlinks in DT would make the software
> > > implementation very complex. We need to be able to walk the graph in a
> > > generic way without having any of the IP core drivers loaded, and
> > > without any specific starting point. We would thus need to parse the
> > > complete DT tree, looking at all nodes and trying to find out whether
> > > they're part of the graph we're trying to walk. The complexity of the
> > > operation would be at best quadratic to the number of nodes in the whole
> > > DT and to the number of nodes in the graph.
> > 
> > Not really. To being with, you cannot determine any meaning of a node
> > across the tree (aside from it being an endpoint) without also
> > understanding the binding that the node is a part of. That means you
> > need to have something matching against the compatible string on both
> > ends of the linkage. For instance:
> > 
> > panel {
> > 	compatible = "acme,lvds-panel";
> > 	lvds-port: port {
> > 	};
> > };
> > 
> > display-controller {
> > 	compatible = "encom,video";
> > 	port {
> > 		remote-endpoint = <&lvds-port>;
> > 	};
> > };
> > 
> > In the above example, the encom,video driver has absolutely zero
> > information about what the acme,lvds-panel binding actually implements.
> > There needs to be both a driver for the "acme,lvds-panel" binding and
> > one for the "encom,video" binding (even if the acme,lvds-panel binding
> > is very thin and defers the functionality to the video controller).
> > 
> > What you want here is the drivers to register each side of the
> > connection. That could be modeled with something like the following
> > (pseudocode):
> > 
> > struct of_endpoint {
> > 
> > 	struct list_head list;
> > 	struct device_node *ep_node;
> > 	void *context;
> > 	void (*cb)(struct of_endpoint *ep, void *data);
> > 
> > }
> > 
> > int of_register_port(struct device *node, void (*cb)(struct of_endpoint
> > *ep, void *data), void *data) {
> > 
> > 	struct of_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
> > 	
> > 	ep->ep_node = node;
> > 	ep->data = data;
> > 	ep->callback = cb;
> > 	
> > 	/* store the endpoint to a list */
> > 	/* check if the endpoint has a remote-endpoint link */
> > 		/* If so, then link the two together and call the
> > 		 * callbacks */
> > }
> > 
> > That's neither expensive or complicated.
> > 
> > Originally I suggested walking the whole tree multiple times, but as
> > mentioned that doesn't scale, and as I thought about the above it isn't
> > even a valid thing to do. Everything has to be driven by drivers, so
> > even if the backlinks are there, nothing can be done with the link until
> > the other side goes through enumeration independently.
> 
> I have implemented your suggestion as follows. Basically, this allows
> either endpoint to contain the remote-endpoint link, as long as all
> drivers register their endpoints in the probe function and return
> -EPROBE_DEFER from their component framework bind callback until all
> their endpoints are connected.

Beside bringing the whole graph down when a single component can't be probed 
(either because the corresponding hardware devices is missing, broken, or the 
driver isn't loaded), that's adding even one more level of complexity with an 
additional callback. I'm afraid I can't accept it as-is, the result is just 
too complex for device drivers and not flexible enough.

I want to keep the ability to walk the graph without requiring all components 
to be probed by their respective driver. What happened to your suggestion of 
parsing the whole DT once at boot time ?

> From fdda1fb2bd133200d4620adcbb28697cb360e1cb Mon Sep 17 00:00:00 2001
> From: Philipp Zabel <p.zabel@pengutronix.de>
> Date: Tue, 11 Mar 2014 15:56:18 +0100
> Subject: [PATCH] of: Implement of_graph_register_endpoint
> 
> This patch adds a function that lets drivers register their endpoints in a
> global list. Newly registered endpoints are compared against known endpoints
> to check if a connection should be made. If so, the driver is notified via
> a simple callback.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/of/base.c        | 69 ++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/of_graph.h | 20 +++++++++++++-
>  2 files changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index ebb001a..77ae54a 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -29,6 +29,7 @@
>  #include "of_private.h"
> 
>  LIST_HEAD(aliases_lookup);
> +LIST_HEAD(endpoint_list);
> 
>  struct device_node *of_allnodes;
>  EXPORT_SYMBOL(of_allnodes);
> @@ -2002,6 +2003,7 @@ int of_graph_parse_endpoint(const struct device_node
> *node, memset(endpoint, 0, sizeof(*endpoint));
> 
>  	endpoint->local_node = node;
> +	endpoint->remote_node = of_parse_phandle(node, "remote-endpoint", 0);
>  	/*
>  	 * It doesn't matter whether the two calls below succeed.
>  	 * If they don't then the default value 0 is used.
> @@ -2126,6 +2128,19 @@ struct device_node *of_graph_get_next_endpoint(const
> struct device_node *parent, }
>  EXPORT_SYMBOL(of_graph_get_next_endpoint);
> 
> +static struct of_endpoint *__of_graph_lookup_endpoint(
> +				const struct device_node *node)
> +{
> +	struct of_endpoint *ep;
> +
> +	list_for_each_entry(ep, &endpoint_list, list) {
> +		if (ep->local_node == node)
> +			return ep;
> +	}
> +
> +	return NULL;
> +}
> +
>  /**
>   * of_graph_get_remote_port_parent() - get remote port's parent node
>   * @node: pointer to a local endpoint device_node
> @@ -2136,11 +2151,15 @@ EXPORT_SYMBOL(of_graph_get_next_endpoint);
>  struct device_node *of_graph_get_remote_port_parent(
>  			       const struct device_node *node)
>  {
> +	struct of_endpoint *ep;
>  	struct device_node *np;
>  	unsigned int depth;
> 
>  	/* Get remote endpoint node. */
> -	np = of_parse_phandle(node, "remote-endpoint", 0);
> +	ep = __of_graph_lookup_endpoint(node);
> +	if (!ep || !ep->remote_node)
> +		return NULL;
> +	np = ep->remote_node;
> 
>  	/* Walk 3 levels up only if there is 'ports' node */
>  	for (depth = 3; depth && np; depth--) {
> @@ -2163,13 +2182,14 @@ EXPORT_SYMBOL(of_graph_get_remote_port_parent);
>   */
>  struct device_node *of_graph_get_remote_port(const struct device_node
> *node) {
> +	struct of_endpoint *ep;
>  	struct device_node *np;
> 
>  	/* Get remote endpoint node. */
> -	np = of_parse_phandle(node, "remote-endpoint", 0);
> -	if (!np)
> +	ep = __of_graph_lookup_endpoint(node);
> +	if (!ep || !ep->remote_node)
>  		return NULL;
> -	np = of_get_next_parent(np);
> +	np = of_get_next_parent(ep->remote_node);
>  	if (of_node_cmp(np->name, "port")) {
>  		of_node_put(np);
>  		return NULL;
> @@ -2177,3 +2197,44 @@ struct device_node *of_graph_get_remote_port(const
> struct device_node *node) return np;
>  }
>  EXPORT_SYMBOL(of_graph_get_remote_port);
> +
> +int of_graph_register_endpoint(const struct device_node *node,
> +		void (*cb)(struct of_endpoint *ep, void *data), void *data)
> +{
> +	struct of_endpoint *remote_ep, *ep = kmalloc(sizeof(*ep), GFP_KERNEL);
> +	if (!ep)
> +		return -ENOMEM;
> +
> +	of_graph_parse_endpoint(node, ep);
> +	ep->callback = cb;
> +	ep->data = data;
> +
> +	list_add(&ep->list, &endpoint_list);
> +
> +	list_for_each_entry(remote_ep, &endpoint_list, list) {
> +		struct of_endpoint *from, *to;
> +		if (ep->remote_node) {
> +			from = ep;
> +			to = remote_ep;
> +		} else {
> +			from = remote_ep;
> +			to = ep;
> +		}
> +		if (from->remote_node &&
> +		    from->remote_node == to->local_node) {
> +			WARN_ON(to->remote_node &&
> +				to->remote_node != from->local_node);
> +			to->remote_node = from->local_node;
> +			to->remote_ep = from;
> +			from->remote_ep = to;
> +			if (from->callback)
> +				from->callback(from, from->data);
> +			if (to->callback)
> +				to->callback(to, to->data);
> +			return 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(of_graph_register_endpoint);
> diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
> index 3a3c5a9..f00ac4e 100644
> --- a/include/linux/of_graph.h
> +++ b/include/linux/of_graph.h
> @@ -23,7 +23,14 @@
>  struct of_endpoint {
>  	unsigned int port;
>  	unsigned int id;
> -	const struct device_node *local_node;
> +	struct device_node *local_node;
> +	struct device_node *remote_node;
> +	struct of_endpoint *remote_ep;
> +
> +	/* Internal use only */
> +	struct list_head list;
> +	void (*callback)(struct of_endpoint *ep, void *data);
> +	void *data;
>  };
> 
>  #ifdef CONFIG_OF
> @@ -35,6 +42,10 @@ struct device_node *of_graph_get_next_endpoint(const
> struct device_node *parent, struct device_node
> *of_graph_get_remote_port_parent(
>  					const struct device_node *node);
>  struct device_node *of_graph_get_remote_port(const struct device_node
> *node); +
> +int of_graph_register_endpoint(const struct device_node *ep_node,
> +				void (*cb)(struct of_endpoint *ep, void *data),
> +				void *data);
>  #else
> 
>  static inline int of_graph_parse_endpoint(const struct device_node *node,
> @@ -68,6 +79,13 @@ static inline struct device_node
> *of_graph_get_remote_port( return NULL;
>  }
> 
> +static inline int of_graph_register_endpoint(const struct device_node
> *ep_node, +				void (*cb)(struct of_endpoint *ep, void *data),
> +				void *data);
> +{
> +	return -ENOSYS;
> +}
> +
>  #endif /* CONFIG_OF */
> 
>  #endif /* __LINUX_OF_GRAPH_H */

-- 
Regards,

Laurent Pinchart

