Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaCJO6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:58:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35663 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaCJO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:58:20 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
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
In-Reply-To: <5427810.BUKJ3iUXnO@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> < 5427810.BUKJ3iUXnO@avalon>
Date: Mon, 10 Mar 2014 14:58:15 +0000
Message-Id: <20140310145815.17595C405FA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> On Monday 10 March 2014 12:18:20 Tomi Valkeinen wrote:
> > On 08/03/14 13:41, Grant Likely wrote:
> > >> Ok. If we go for single directional link, the question is then: which
> > >> way? And is the direction different for display and camera, which are
> > >> kind of reflections of each other?
> > > 
> > > In general I would recommend choosing whichever device you would
> > > sensibly think of as a master. In the camera case I would choose the
> > > camera controller node instead of the camera itself, and in the display
> > > case I would choose the display controller instead of the panel. The
> > > binding author needs to choose what she things makes the most sense, but
> > > drivers can still use if it it turns out to be 'backwards'
> > 
> > I would perhaps choose the same approach, but at the same time I think
> > it's all but clear. The display controller doesn't control the panel any
> > more than a DMA controller controls, say, the display controller.
> > 
> > In fact, in earlier versions of OMAP DSS DT support I had a simpler port
> > description, and in that I had the panel as the master (i.e. link from
> > panel to dispc) because the panel driver uses the display controller's
> > features to provide the panel device a data stream.
> > 
> > And even with the current OMAP DSS DT version, which uses the v4l2 style
> > ports/endpoints, the driver model is still the same, and only links
> > towards upstream are used.
> > 
> > So one reason I'm happy with the dual-linking is that I can easily
> > follow the links from the downstream entities to upstream entities, and
> > other people, who have different driver model, can easily do the opposite.
> > 
> > But I agree that single-linking is enough and this can be handled at
> > runtime, even if it makes the code more complex. And perhaps requires
> > extra data in the dts, to give the start points for the graph.
> 
> In theory unidirectional links in DT are indeed enough. However, let's not 
> forget the following.
> 
> - There's no such thing as single start points for graphs. Sure, in some 
> simple cases the graph will have a single start point, but that's not a 
> generic rule. For instance the camera graphs 
> http://ideasonboard.org/media/omap3isp.ps and 
> http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus two 
> starting points from a data flow point of view. And if you want a better 
> understanding of how complex media graphs can become, have a look at 
> http://ideasonboard.org/media/vsp1.0.pdf (that's a real world example, albeit 
> all connections are internal to the SoC in that particular case, and don't 
> need to be described in DT).
> 
> - There's also no such thing as a master device that can just point to slave 
> devices. Once again simple cases exist where that model could work, but real 
> world examples exist of complex pipelines with dozens of elements all 
> implemented by a separate IP core and handled by separate drivers, forming a 
> graph with long chains and branches. We thus need real graph bindings.
> 
> - Finally, having no backlinks in DT would make the software implementation 
> very complex. We need to be able to walk the graph in a generic way without 
> having any of the IP core drivers loaded, and without any specific starting 
> point. We would thus need to parse the complete DT tree, looking at all nodes 
> and trying to find out whether they're part of the graph we're trying to walk. 
> The complexity of the operation would be at best quadratic to the number of 
> nodes in the whole DT and to the number of nodes in the graph.

Not really. To being with, you cannot determine any meaning of a node
across the tree (aside from it being an endpoint) without also
understanding the binding that the node is a part of. That means you
need to have something matching against the compatible string on both
ends of the linkage. For instance:

panel {
	compatible = "acme,lvds-panel";
	lvds-port: port {
	};
};

display-controller {
	compatible = "encom,video";
	port {
		remote-endpoint = <&lvds-port>;
	};
};

In the above example, the encom,video driver has absolutely zero
information about what the acme,lvds-panel binding actually implements.
There needs to be both a driver for the "acme,lvds-panel" binding and
one for the "encom,video" binding (even if the acme,lvds-panel binding
is very thin and defers the functionality to the video controller).

What you want here is the drivers to register each side of the
connection. That could be modeled with something like the following
(pseudocode):

struct of_endpoint {
	struct list_head list;
	struct device_node *ep_node;
	void *context;
	void (*cb)(struct of_endpoint *ep, void *data);
}

int of_register_port(struct device *node, void (*cb)(struct of_endpoint *ep, void *data), void *data)
{
	struct of_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);

	ep->ep_node = node;
	ep->data = data;
	ep->callback = cb;

	/* store the endpoint to a list */
	/* check if the endpoint has a remote-endpoint link */
		/* If so, then link the two together and call the
		 * callbacks */
}

That's neither expensive or complicated.

Originally I suggested walking the whole tree multiple times, but as
mentioned that doesn't scale, and as I thought about the above it isn't
even a valid thing to do. Everything has to be driven by drivers, so
even if the backlinks are there, nothing can be done with the link until
the other side goes through enumeration independently.

g.
