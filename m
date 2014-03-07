Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaCHFan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:30:43 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53011 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaCHFa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:28 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>
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
In-Reply-To: <1393428297.3248.92.camel@paszta.hi.pengutronix.de>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de> <20140226113729. A9D5AC40A89@trevor.secretlab.ca> <1393428297.3248.92.camel@paszta.hi. pengutronix.de>
Date: Sat, 08 Mar 2014 01:18:04 +0800
Message-Id: <20140307171804.EF245C40A32@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 16:24:57 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Grant,
> 
> Am Mittwoch, den 26.02.2014, 11:37 +0000 schrieb Grant Likely:
> [...]
> > >  drivers/media/v4l2-core/v4l2-of.c             | 117 ----------------------
> > >  drivers/of/Makefile                           |   1 +
> > >  drivers/of/of_graph.c                         | 134 ++++++++++++++++++++++++++
> > 
> > Nah. Just put it into drivers/of/base.c. This isn't a separate subsystem
> > and the functions are pretty basic.
> 
> Ok.
> 
> [...]
> > > +struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
> > > +					struct device_node *prev)
> > > +{
> > > +	struct device_node *endpoint;
> > > +	struct device_node *port = NULL;
> > > +
> > > +	if (!parent)
> > > +		return NULL;
> > > +
> > > +	if (!prev) {
> > > +		struct device_node *node;
> > > +		/*
> > > +		 * It's the first call, we have to find a port subnode
> > > +		 * within this node or within an optional 'ports' node.
> > > +		 */
> > > +		node = of_get_child_by_name(parent, "ports");
> > > +		if (node)
> > > +			parent = node;
> > > +
> > > +		port = of_get_child_by_name(parent, "port");
> > 
> > If you've got a "ports" node, then I would expect every single child to
> > be a port. Should not need the _by_name variant.
> 
> The 'ports' node is optional. It is only needed if the parent node has
> its own #address-cells and #size-cells properties. If the ports are
> direct children of the device node, there might be other nodes than
> ports:
> 
> 	device {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		port@0 {
> 			endpoint { ... };
> 		};
> 		port@1 {
> 			endpoint { ... };
> 		};
> 
> 		some-other-child { ... };
> 	};
> 
> 	device {
> 		#address-cells = <x>;
> 		#size-cells = <y>;
> 
> 		ports {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			port@0 {
> 				endpoint { ... };
> 			};
> 			port@1 {
> 				endpoint { ... };
> 			};
> 		};
> 
> 		some-other-child { ... };
> 	};

>From a pattern perspective I have no problem with that.... From an
individual driver binding perspective that is just dumb! It's fine for
the ports node to be optional, but an individual driver using the
binding should be explicit about which it will accept. Please use either
a flag or a separate wrapper so that the driver can select the
behaviour.

> The helper should find the two endpoints in both cases.
> Tomi suggests an even more compact form for devices with just one port:
> 
> 	device {
> 		endpoint { ... };
> 
> 		some-other-child { ... };
> 	};

That's fine. In that case the driver would specifically require the
endpoint to be that one node.... although the above looks a little weird
to me. I would recommend that if there are other non-port child nodes
then the ports should still be encapsulated by a ports node.  The device
binding should not be ambiguous about which nodes are ports.

> > It seems that this function is merely a helper to get all grandchildren
> > of a node (with some very minor constraints). That could be generalized
> > and simplified. If the function takes the "ports" node as an argument
> > instead of the parent, then there is a greater likelyhood that other
> > code can make use of it...
> > 
> > Thinking further. I think the semantics of this whole feature basically
> > boil down to this:
> > 
> > #define for_each_grandchild_of_node(parent, child, grandchild) \
> > 	for_each_child_of_node(parent, child) \
> > 		for_each_child_of_node(child, grandchild)
> > 
> > Correct? Or in this specific case:
> > 
> > 	parent = of_get_child_by_name(np, "ports")
> > 	for_each_grandchild_of_node(parent, child, grandchild) {
> > 		...
> > 	}
> 
> Hmm, that would indeed be a bit more generic, but it doesn't handle the
> optional 'ports' subnode and doesn't allow for other child nodes in the
> device node.

See above. The no-ports-node version could be the
for_each_grandchild_of_node() block, and the yes-ports-node version
could be a wrapper around that.

> > Finally, looking at the actual patch, is any of this actually needed.
> > All of the users updated by this patch only ever handle a single
> > endpoint. Have I read it correctly? Are there any users supporting
> > multiple endpoints?
> 
> Yes, mainline currently only contains simple cases. I have posted i.MX6
> patches that use this scheme for the output path:
>   http://www.spinics.net/lists/arm-kernel/msg310817.html
>   http://www.spinics.net/lists/arm-kernel/msg310821.html

Blurg. On a plane right now. Can't go and read those links.

> > > +
> > > +		if (port) {
> > > +			/* Found a port, get an endpoint. */
> > > +			endpoint = of_get_next_child(port, NULL);
> > > +			of_node_put(port);
> > > +		} else {
> > > +			endpoint = NULL;
> > > +		}
> > > +
> > > +		if (!endpoint)
> > > +			pr_err("%s(): no endpoint nodes specified for %s\n",
> > > +			       __func__, parent->full_name);
> > > +		of_node_put(node);
> > 
> > If you 'return endpoint' here, then the else block can go down a level.
> 
> Note that this patch is a straight move of existing code.
> I can follow up with code beautification and ...

I'm fine with that.

g.
