Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbaCTRd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:33:57 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51645 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756AbaCTRdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:33:54 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
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
In-Reply-To: <531F09E2.3070407@samsung.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 5427810.BUKJ3iUXnO@avalon> <20140310145815.17595C405FA@trevor.secretlab.ca> <4339286.FzhQ2m6hoA@avalon> <531F09E2.3070407@samsung.com>
Date: Thu, 20 Mar 2014 17:33:48 +0000
Message-Id: <20140320173348.9F96BC4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 14:04:34 +0100, Andrzej Hajda <a.hajda@samsung.com> wrote:
> On 03/10/2014 04:15 PM, Laurent Pinchart wrote:
> > Hi Grant,
> > 
> > On Monday 10 March 2014 14:58:15 Grant Likely wrote:
> >> On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart wrote:
> >>> On Monday 10 March 2014 12:18:20 Tomi Valkeinen wrote:
> >>>> On 08/03/14 13:41, Grant Likely wrote:
> >>>>>> Ok. If we go for single directional link, the question is then: which
> >>>>>> way? And is the direction different for display and camera, which are
> >>>>>> kind of reflections of each other?
> >>>>>
> >>>>> In general I would recommend choosing whichever device you would
> >>>>> sensibly think of as a master. In the camera case I would choose the
> >>>>> camera controller node instead of the camera itself, and in the
> >>>>> display case I would choose the display controller instead of the
> >>>>> panel. The binding author needs to choose what she things makes the
> >>>>> most sense, but drivers can still use if it it turns out to be
> >>>>> 'backwards'
> >>>>
> >>>> I would perhaps choose the same approach, but at the same time I think
> >>>> it's all but clear. The display controller doesn't control the panel any
> >>>> more than a DMA controller controls, say, the display controller.
> >>>>
> >>>> In fact, in earlier versions of OMAP DSS DT support I had a simpler port
> >>>> description, and in that I had the panel as the master (i.e. link from
> >>>> panel to dispc) because the panel driver uses the display controller's
> >>>> features to provide the panel device a data stream.
> >>>>
> >>>> And even with the current OMAP DSS DT version, which uses the v4l2 style
> >>>> ports/endpoints, the driver model is still the same, and only links
> >>>> towards upstream are used.
> >>>>
> >>>> So one reason I'm happy with the dual-linking is that I can easily
> >>>> follow the links from the downstream entities to upstream entities, and
> >>>> other people, who have different driver model, can easily do the
> >>>> opposite.
> >>>>
> >>>> But I agree that single-linking is enough and this can be handled at
> >>>> runtime, even if it makes the code more complex. And perhaps requires
> >>>> extra data in the dts, to give the start points for the graph.
> >>>
> >>> In theory unidirectional links in DT are indeed enough. However, let's not
> >>> forget the following.
> >>>
> >>> - There's no such thing as single start points for graphs. Sure, in some
> >>> simple cases the graph will have a single start point, but that's not a
> >>> generic rule. For instance the camera graphs
> >>> http://ideasonboard.org/media/omap3isp.ps and
> >>> http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus
> >>> two starting points from a data flow point of view. And if you want a
> >>> better understanding of how complex media graphs can become, have a look
> >>> at http://ideasonboard.org/media/vsp1.0.pdf (that's a real world example,
> >>> albeit all connections are internal to the SoC in that particular case,
> >>> and don't need to be described in DT).
> >>>
> >>> - There's also no such thing as a master device that can just point to
> >>> slave devices. Once again simple cases exist where that model could work,
> >>> but real world examples exist of complex pipelines with dozens of
> >>> elements all implemented by a separate IP core and handled by separate
> >>> drivers, forming a graph with long chains and branches. We thus need real
> >>> graph bindings.
> >>>
> >>> - Finally, having no backlinks in DT would make the software
> >>> implementation very complex. We need to be able to walk the graph in a
> >>> generic way without having any of the IP core drivers loaded, and without
> >>> any specific starting point. We would thus need to parse the complete DT
> >>> tree, looking at all nodes and trying to find out whether they're part of
> >>> the graph we're trying to walk. The complexity of the operation would be
> >>> at best quadratic to the number of nodes in the whole DT and to the number
> >>> of nodes in the graph.
> >>
> >> Not really. To being with, you cannot determine any meaning of a node
> >> across the tree (aside from it being an endpoint)
> > 
> > That's the important part. I can assume the target node of the remote-endpoint 
> > phandle to be an endpoint, and can thus assume that it implements the of-graph 
> > bindings. That's all I need to be able to walk the graph in a generic way.
> > 
> >> without also understanding the binding that the node is a part of. That
> >> means you need to have something matching against the compatible string on
> >> both ends of the linkage. For instance:
> >>
> >> panel {
> >> 	compatible = "acme,lvds-panel";
> >> 	lvds-port: port {
> >> 	};
> >> };
> >>
> >> display-controller {
> >> 	compatible = "encom,video";
> >> 	port {
> >> 		remote-endpoint = <&lvds-port>;
> >> 	};
> >> };
> >>
> >> In the above example, the encom,video driver has absolutely zero
> >> information about what the acme,lvds-panel binding actually implements.
> >> There needs to be both a driver for the "acme,lvds-panel" binding and
> >> one for the "encom,video" binding (even if the acme,lvds-panel binding
> >> is very thin and defers the functionality to the video controller).
> > 
> > I absolutely agree with that. We need a driver for each device (in this case 
> > the acme panel and the encom display controller), and we need those drivers to 
> > register entities (in the generic sense of the term) for them to be able to 
> > communicate with each other. The display controller driver must not try to 
> > parse panel-specific properties from the panel node. However, as described 
> > above, I believe it can parse ports and endpoints to walk the graph.
> > 
> >> What you want here is the drivers to register each side of the
> >> connection. That could be modeled with something like the following
> >> (pseudocode):
> >>
> >> struct of_endpoint {
> >> 	struct list_head list;
> >> 	struct device_node *ep_node;
> >> 	void *context;
> >> 	void (*cb)(struct of_endpoint *ep, void *data);
> >> }
> >>
> >> int of_register_port(struct device *node, void (*cb)(struct of_endpoint *ep,
> >> void *data), void *data) {
> >> 	struct of_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
> >>
> >> 	ep->ep_node = node;
> >> 	ep->data = data;
> >> 	ep->callback = cb;
> >>
> >> 	/* store the endpoint to a list */
> >> 	/* check if the endpoint has a remote-endpoint link */
> >> 		/* If so, then link the two together and call the
> >> 		 * callbacks */
> >> }
> >>
> >> That's neither expensive or complicated.
> >>
> >> Originally I suggested walking the whole tree multiple times, but as
> >> mentioned that doesn't scale, and as I thought about the above it isn't
> >> even a valid thing to do. Everything has to be driven by drivers, so
> >> even if the backlinks are there, nothing can be done with the link until
> >> the other side goes through enumeration independently.
> > 
> > For such composite devices, what we need from a drivers point of view is a 
> > mechanism to wait for all components to be in place before proceeding. This 
> > isn't DT-related as such, but the graph is obviously described in DT for DT-
> > based platforms.
> > 
> > There are at least two mainline implementation of such a mechanism. One of 
> > them can be found in drivers/media/v4l2-core/v4l2-async.c, another more recent 
> > one in drivers/base/component.c. Neither of them is DT-specific, and they 
> > don't try to parse DT content.
> > 
> > The main problem, from a DT point of view, is that we need to pick a master 
> > driver that will initiate the process of waiting for all components to be in 
> > place. This is usually the driver of the main component inside the SoC. For a 
> > camera capture pipeline the master is the SoC camera device driver that will 
> > create the V4L2 device node(s). For a display pipeline the master is the SoC 
> > display driver that will create the DRM/KMS devices.
> > 
> > The master device driver needs to create a list of all components it needs, 
> > and wait until all those components have been probed by their respective 
> > driver. Creating such a list requires walking the graph, starting at the 
> > master device (using a CPU-centric view as described by Russell). This is why 
> > we need the backlinks, as the master device can have inbound links.
> > 
> 
> I am not sure if the approach with one device driver parsing links
> between two other devices is the correct one. For example some links can
> be optional, some irrelevant to the pipeline the master device tries to
> create,....

Yes, that is exactly what I'm concerned about. I think it is important
to be able to have an unambiguous dependency graph. In most cases, only
the driver for a component will actually know which links are
dependencies, and which are optional.... And that doesn't even address hot
plug!

> I guess it could be sometimes solved using additional
> properties, but this will complicate things and will not work if the
> routing decision can be taken only during specific driver probe or later.

If a component is sufficiently complex that the routing is dynamic and
'downstream' components may or may not be present/usable, then there
just has to be a driver that understands its behaviour; either
integrated into the master driver, or a separate driver that abstracts
it from the master driver.

g.
