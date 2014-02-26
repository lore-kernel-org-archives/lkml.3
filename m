Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBZOyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:54:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39715 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaBZOyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:54:46 -0500
Message-ID: <1393428297.3248.92.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 26 Feb 2014 16:24:57 +0100
In-Reply-To: <20140226113729.A9D5AC40A89@trevor.secretlab.ca>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
	 < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de>
	 <20140226113729.A9D5AC40A89@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Am Mittwoch, den 26.02.2014, 11:37 +0000 schrieb Grant Likely:
[...]
> >  drivers/media/v4l2-core/v4l2-of.c             | 117 ----------------------
> >  drivers/of/Makefile                           |   1 +
> >  drivers/of/of_graph.c                         | 134 ++++++++++++++++++++++++++
> 
> Nah. Just put it into drivers/of/base.c. This isn't a separate subsystem
> and the functions are pretty basic.

Ok.

[...]
> > +struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
> > +					struct device_node *prev)
> > +{
> > +	struct device_node *endpoint;
> > +	struct device_node *port = NULL;
> > +
> > +	if (!parent)
> > +		return NULL;
> > +
> > +	if (!prev) {
> > +		struct device_node *node;
> > +		/*
> > +		 * It's the first call, we have to find a port subnode
> > +		 * within this node or within an optional 'ports' node.
> > +		 */
> > +		node = of_get_child_by_name(parent, "ports");
> > +		if (node)
> > +			parent = node;
> > +
> > +		port = of_get_child_by_name(parent, "port");
> 
> If you've got a "ports" node, then I would expect every single child to
> be a port. Should not need the _by_name variant.

The 'ports' node is optional. It is only needed if the parent node has
its own #address-cells and #size-cells properties. If the ports are
direct children of the device node, there might be other nodes than
ports:

	device {
		#address-cells = <1>;
		#size-cells = <0>;

		port@0 {
			endpoint { ... };
		};
		port@1 {
			endpoint { ... };
		};

		some-other-child { ... };
	};

	device {
		#address-cells = <x>;
		#size-cells = <y>;

		ports {
			#address-cells = <1>;
			#size-cells = <0>;

			port@0 {
				endpoint { ... };
			};
			port@1 {
				endpoint { ... };
			};
		};

		some-other-child { ... };
	};

The helper should find the two endpoints in both cases.
Tomi suggests an even more compact form for devices with just one port:

	device {
		endpoint { ... };

		some-other-child { ... };
	};

> It seems that this function is merely a helper to get all grandchildren
> of a node (with some very minor constraints). That could be generalized
> and simplified. If the function takes the "ports" node as an argument
> instead of the parent, then there is a greater likelyhood that other
> code can make use of it...
> 
> Thinking further. I think the semantics of this whole feature basically
> boil down to this:
> 
> #define for_each_grandchild_of_node(parent, child, grandchild) \
> 	for_each_child_of_node(parent, child) \
> 		for_each_child_of_node(child, grandchild)
> 
> Correct? Or in this specific case:
> 
> 	parent = of_get_child_by_name(np, "ports")
> 	for_each_grandchild_of_node(parent, child, grandchild) {
> 		...
> 	}

Hmm, that would indeed be a bit more generic, but it doesn't handle the
optional 'ports' subnode and doesn't allow for other child nodes in the
device node.

> Finally, looking at the actual patch, is any of this actually needed.
> All of the users updated by this patch only ever handle a single
> endpoint. Have I read it correctly? Are there any users supporting
> multiple endpoints?

Yes, mainline currently only contains simple cases. I have posted i.MX6
patches that use this scheme for the output path:
  http://www.spinics.net/lists/arm-kernel/msg310817.html
  http://www.spinics.net/lists/arm-kernel/msg310821.html

> > +
> > +		if (port) {
> > +			/* Found a port, get an endpoint. */
> > +			endpoint = of_get_next_child(port, NULL);
> > +			of_node_put(port);
> > +		} else {
> > +			endpoint = NULL;
> > +		}
> > +
> > +		if (!endpoint)
> > +			pr_err("%s(): no endpoint nodes specified for %s\n",
> > +			       __func__, parent->full_name);
> > +		of_node_put(node);
> 
> If you 'return endpoint' here, then the else block can go down a level.

Note that this patch is a straight move of existing code.
I can follow up with code beautification and ...

> > +	} else {
> > +		port = of_get_parent(prev);
> > +		if (!port)
> > +			/* Hm, has someone given us the root node ?... */
> > +			return NULL;
> 
> WARN_ONCE(). That's a very definite coding failure if that happens.

... with a fix for this.

> > +
> > +		/* Avoid dropping prev node refcount to 0. */
> > +		of_node_get(prev);
> > +		endpoint = of_get_next_child(port, prev);
> > +		if (endpoint) {
> > +			of_node_put(port);
> > +			return endpoint;
> > +		}
> > +
> > +		/* No more endpoints under this port, try the next one. */
> > +		do {
> > +			port = of_get_next_child(parent, port);
> > +			if (!port)
> > +				return NULL;
> > +		} while (of_node_cmp(port->name, "port"));
> > +
> > +		/* Pick up the first endpoint in this port. */
> > +		endpoint = of_get_next_child(port, NULL);
> > +		of_node_put(port);
> > +	}
> > +
> > +	return endpoint;
> > +}
> > +EXPORT_SYMBOL(of_graph_get_next_endpoint);
> > +
> > +/**
> > + * of_graph_get_remote_port_parent() - get remote port's parent node
> > + * @node: pointer to a local endpoint device_node
> > + *
> > + * Return: Remote device node associated with remote endpoint node linked
> > + *	   to @node. Use of_node_put() on it when done.
> > + */
> > +struct device_node *of_graph_get_remote_port_parent(
> > +			       const struct device_node *node)
> > +{
> > +	struct device_node *np;
> > +	unsigned int depth;
> > +
> > +	/* Get remote endpoint node. */
> > +	np = of_parse_phandle(node, "remote-endpoint", 0);
> > +
> > +	/* Walk 3 levels up only if there is 'ports' node. */
> 
> This needs a some explaining. My reading of the binding pattern is that
> it will always be a fixed number of levels. Why is this test fuzzy?
[...]

See above. The ports subnode level is optional. In most cases, the port
nodes will be direct children of the device node.
Walking up 3 levels from the endpoint node will return the device if
there was a ports node. If there is no ports node, we only have to walk
up two levels.

regards
Philipp

