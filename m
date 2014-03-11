Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaCKLmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:42:14 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52497 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaCKLmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:42:10 -0400
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
Date: Tue, 11 Mar 2014 12:43:44 +0100
Message-ID: <139468148.3QhLg3QYq1@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394466030.7380.39.camel@paszta.hi.pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <4339286.FzhQ2m6hoA@avalon> <1394466030.7380.39.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Monday 10 March 2014 16:40:30 Philipp Zabel wrote:
> Am Montag, den 10.03.2014, 16:15 +0100 schrieb Laurent Pinchart:
> > On Monday 10 March 2014 14:58:15 Grant Likely wrote:
> > > On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart wrote:
> > > > On Monday 10 March 2014 12:18:20 Tomi Valkeinen wrote:
> > > > > On 08/03/14 13:41, Grant Likely wrote:
> > > > > >> Ok. If we go for single directional link, the question is then:
> > > > > >> which way? And is the direction different for display and camera,
> > > > > >> which are kind of reflections of each other?
> > > > > > 
> > > > > > In general I would recommend choosing whichever device you would
> > > > > > sensibly think of as a master. In the camera case I would choose
> > > > > > the camera controller node instead of the camera itself, and in
> > > > > > the display case I would choose the display controller instead of
> > > > > > the panel. The binding author needs to choose what she things
> > > > > > makes the most sense, but drivers can still use if it it turns out
> > > > > > to be 'backwards'
> > > > > 
> > > > > I would perhaps choose the same approach, but at the same time I
> > > > > think it's all but clear. The display controller doesn't control the
> > > > > panel any more than a DMA controller controls, say, the display
> > > > > controller.
> > > > > 
> > > > > In fact, in earlier versions of OMAP DSS DT support I had a simpler
> > > > > port description, and in that I had the panel as the master (i.e.
> > > > > link from panel to dispc) because the panel driver uses the display
> > > > > controller's features to provide the panel device a data stream.
> > > > > 
> > > > > And even with the current OMAP DSS DT version, which uses the v4l2
> > > > > style ports/endpoints, the driver model is still the same, and only
> > > > > links towards upstream are used.
> > > > > 
> > > > > So one reason I'm happy with the dual-linking is that I can easily
> > > > > follow the links from the downstream entities to upstream entities,
> > > > > and other people, who have different driver model, can easily do the
> > > > > opposite.
> > > > > 
> > > > > But I agree that single-linking is enough and this can be handled at
> > > > > runtime, even if it makes the code more complex. And perhaps
> > > > > requires extra data in the dts, to give the start points for the
> > > > > graph.
> > > > 
> > > > In theory unidirectional links in DT are indeed enough. However, let's
> > > > not forget the following.
> > > > 
> > > > - There's no such thing as single start points for graphs. Sure, in
> > > > some simple cases the graph will have a single start point, but that's
> > > > not a generic rule. For instance the camera graphs
> > > > http://ideasonboard.org/media/omap3isp.ps and
> > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and
> > > > thus two starting points from a data flow point of view. And if you
> > > > want a better understanding of how complex media graphs can become,
> > > > have a look at http://ideasonboard.org/media/vsp1.0.pdf (that's a real
> > > > world example, albeit all connections are internal to the SoC in that
> > > > particular case, and don't need to be described in DT).
> > > > 
> > > > - There's also no such thing as a master device that can just point to
> > > > slave devices. Once again simple cases exist where that model could
> > > > work, but real world examples exist of complex pipelines with dozens
> > > > of elements all implemented by a separate IP core and handled by
> > > > separate drivers, forming a graph with long chains and branches. We
> > > > thus need real graph bindings.
> > > > 
> > > > - Finally, having no backlinks in DT would make the software
> > > > implementation very complex. We need to be able to walk the graph in a
> > > > generic way without having any of the IP core drivers loaded, and
> > > > without any specific starting point. We would thus need to parse the
> > > > complete DT tree, looking at all nodes and trying to find out whether
> > > > they're part of the graph we're trying to walk. The complexity of the
> > > > operation would be at best quadratic to the number of nodes in the
> > > > whole DT and to the number of nodes in the graph.
> > > 
> > > Not really. To being with, you cannot determine any meaning of a node
> > > across the tree (aside from it being an endpoint)
> > 
> > That's the important part. I can assume the target node of the
> > remote-endpoint phandle to be an endpoint, and can thus assume that it
> > implements the of-graph bindings. That's all I need to be able to walk
> > the graph in a generic way.
> >
> > > without also understanding the binding that the node is a part of. That
> > > means you need to have something matching against the compatible string
> > > on both ends of the linkage. For instance:
> > > 
> > > panel {
> > > 	compatible = "acme,lvds-panel";
> > > 	lvds-port: port {
> > > 	};
> > > };
> > > 
> > > display-controller {
> > > 	compatible = "encom,video";
> > > 	port {
> > > 		remote-endpoint = <&lvds-port>;
> > > 	};
> > > };
> > > 
> > > In the above example, the encom,video driver has absolutely zero
> > > information about what the acme,lvds-panel binding actually implements.
> > > There needs to be both a driver for the "acme,lvds-panel" binding and
> > > one for the "encom,video" binding (even if the acme,lvds-panel binding
> > > is very thin and defers the functionality to the video controller).
> > 
> > I absolutely agree with that. We need a driver for each device (in this
> > case the acme panel and the encom display controller), and we need those
> > drivers to register entities (in the generic sense of the term) for them
> > to be able to communicate with each other. The display controller driver
> > must not try to parse panel-specific properties from the panel node.
> > However, as described above, I believe it can parse ports and endpoints
> > to walk the graph.
> >
> > > What you want here is the drivers to register each side of the
> > > connection. That could be modeled with something like the following
> > > (pseudocode):
> > > 
> > > struct of_endpoint {
> > > 	struct list_head list;
> > > 	struct device_node *ep_node;
> > > 	void *context;
> > > 	void (*cb)(struct of_endpoint *ep, void *data);
> > > }
> > > 
> > > int of_register_port(struct device *node, void (*cb)(struct of_endpoint
> > > *ep, void *data), void *data) {
> > > 	struct of_endpoint *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
> > > 	
> > > 	ep->ep_node = node;
> > > 	ep->data = data;
> > > 	ep->callback = cb;
> > > 	
> > > 	/* store the endpoint to a list */
> > > 	/* check if the endpoint has a remote-endpoint link */
> > > 		/* If so, then link the two together and call the
> > > 		 * callbacks */
> > > }
> > > 
> > > That's neither expensive or complicated.
> > > 
> > > Originally I suggested walking the whole tree multiple times, but as
> > > mentioned that doesn't scale, and as I thought about the above it isn't
> > > even a valid thing to do. Everything has to be driven by drivers, so
> > > even if the backlinks are there, nothing can be done with the link until
> > > the other side goes through enumeration independently.
> > 
> > For such composite devices, what we need from a drivers point of view is a
> > mechanism to wait for all components to be in place before proceeding.
> > This isn't DT-related as such, but the graph is obviously described in DT
> > for DT- based platforms.
> > 
> > There are at least two mainline implementation of such a mechanism. One of
> > them can be found in drivers/media/v4l2-core/v4l2-async.c, another more
> > recent one in drivers/base/component.c. Neither of them is DT-specific,
> > and they don't try to parse DT content.
> > 
> > The main problem, from a DT point of view, is that we need to pick a
> > master driver that will initiate the process of waiting for all components
> > to be in place. This is usually the driver of the main component inside
> > the SoC. For a camera capture pipeline the master is the SoC camera device
> > driver that will create the V4L2 device node(s). For a display pipeline
> > the master is the SoC display driver that will create the DRM/KMS
> > devices.
> > 
> > The master device driver needs to create a list of all components it
> > needs, and wait until all those components have been probed by their
> > respective driver. Creating such a list requires walking the graph,
> > starting at the master device (using a CPU-centric view as described by
> > Russell). This is why we need the backlinks, as the master device can have
> > inbound links.
>
> We could scan the whole tree for entities, ports and endpoints once, in
> the base oftree code, and put that into a graph structure, adding the
> backlinks.
> The of_graph_* helpers could then use that graph instead of the device
> tree.

That could work. The complexity would still be quadratic, but we would parse 
the full device tree once only.

The runtime complexity would still be increased, as the graph helpers would 
need to find the endpoint object in the parsed graph corresponding to the DT 
node they get as an argument. That's proportional to the number of graph 
elements, not the total number of DT nodes, so I suppose it's not too bad.

We also need to make sure this would work with insertion of DT fragments at 
runtime. Probably not a big deal, but it has to be kept in mind.

-- 
Regards,

Laurent Pinchart

