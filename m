Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaCTRCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:02:08 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58807 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:02:05 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
In-Reply-To: <4339286.FzhQ2m6hoA@avalon>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 5427810.BUKJ3iUXnO@avalon> <20140310145815.17595C405FA@trevor.secretlab.ca> <4339286.FzhQ2m6hoA@avalon>
Date: Thu, 20 Mar 2014 17:01:59 +0000
Message-Id: <20140320170159.A9A87C4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 16:15:37 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hi Grant,
> 
> On Monday 10 March 2014 14:58:15 Grant Likely wrote:
> > On Mon, 10 Mar 2014 14:52:53 +0100, Laurent Pinchart wrote:
> > > On Monday 10 March 2014 12:18:20 Tomi Valkeinen wrote:
> > > > On 08/03/14 13:41, Grant Likely wrote:
> > > > >> Ok. If we go for single directional link, the question is then: which
> > > > >> way? And is the direction different for display and camera, which are
> > > > >> kind of reflections of each other?
> > > > > 
> > > > > In general I would recommend choosing whichever device you would
> > > > > sensibly think of as a master. In the camera case I would choose the
> > > > > camera controller node instead of the camera itself, and in the
> > > > > display case I would choose the display controller instead of the
> > > > > panel. The binding author needs to choose what she things makes the
> > > > > most sense, but drivers can still use if it it turns out to be
> > > > > 'backwards'
> > > > 
> > > > I would perhaps choose the same approach, but at the same time I think
> > > > it's all but clear. The display controller doesn't control the panel any
> > > > more than a DMA controller controls, say, the display controller.
> > > > 
> > > > In fact, in earlier versions of OMAP DSS DT support I had a simpler port
> > > > description, and in that I had the panel as the master (i.e. link from
> > > > panel to dispc) because the panel driver uses the display controller's
> > > > features to provide the panel device a data stream.
> > > > 
> > > > And even with the current OMAP DSS DT version, which uses the v4l2 style
> > > > ports/endpoints, the driver model is still the same, and only links
> > > > towards upstream are used.
> > > > 
> > > > So one reason I'm happy with the dual-linking is that I can easily
> > > > follow the links from the downstream entities to upstream entities, and
> > > > other people, who have different driver model, can easily do the
> > > > opposite.
> > > > 
> > > > But I agree that single-linking is enough and this can be handled at
> > > > runtime, even if it makes the code more complex. And perhaps requires
> > > > extra data in the dts, to give the start points for the graph.
> > > 
> > > In theory unidirectional links in DT are indeed enough. However, let's not
> > > forget the following.
> > > 
> > > - There's no such thing as single start points for graphs. Sure, in some
> > > simple cases the graph will have a single start point, but that's not a
> > > generic rule. For instance the camera graphs
> > > http://ideasonboard.org/media/omap3isp.ps and
> > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus
> > > two starting points from a data flow point of view. And if you want a
> > > better understanding of how complex media graphs can become, have a look
> > > at http://ideasonboard.org/media/vsp1.0.pdf (that's a real world example,
> > > albeit all connections are internal to the SoC in that particular case,
> > > and don't need to be described in DT).
> > > 
> > > - There's also no such thing as a master device that can just point to
> > > slave devices. Once again simple cases exist where that model could work,
> > > but real world examples exist of complex pipelines with dozens of
> > > elements all implemented by a separate IP core and handled by separate
> > > drivers, forming a graph with long chains and branches. We thus need real
> > > graph bindings.
> > > 
> > > - Finally, having no backlinks in DT would make the software
> > > implementation very complex. We need to be able to walk the graph in a
> > > generic way without having any of the IP core drivers loaded, and without
> > > any specific starting point. We would thus need to parse the complete DT
> > > tree, looking at all nodes and trying to find out whether they're part of
> > > the graph we're trying to walk. The complexity of the operation would be
> > > at best quadratic to the number of nodes in the whole DT and to the number
> > > of nodes in the graph.
> > 
> > Not really. To being with, you cannot determine any meaning of a node
> > across the tree (aside from it being an endpoint)
> 
> That's the important part. I can assume the target node of the remote-endpoint 
> phandle to be an endpoint, and can thus assume that it implements the of-graph 
> bindings. That's all I need to be able to walk the graph in a generic way.

Yes, you can assume the target node is an endpoint, but you cannot
assume anything beyond that. It is not a good idea to go looking for
more endpoint links in the local hierarchy that terminates the link.

> 
> > without also understanding the binding that the node is a part of. That
> > means you need to have something matching against the compatible string on
> > both ends of the linkage. For instance:
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
> 
> I absolutely agree with that. We need a driver for each device (in this case 
> the acme panel and the encom display controller), and we need those drivers to 
> register entities (in the generic sense of the term) for them to be able to 
> communicate with each other. The display controller driver must not try to 
> parse panel-specific properties from the panel node. However, as described 
> above, I believe it can parse ports and endpoints to walk the graph.

I think depending on a generic graph walk is where I have the biggest
concern about the design. I don't think it is a good idea for the master
device to try a generic walk over the graph looking for other devices
that might be components because it cannot know whether or not further
links are relevant, or even if other endpoint nodes in the target
hierarchy actually conform to the graph binding in the same way.

Consider the example of a system with two video controllers (one
embedded and one discrete), a display mux, and a panel. The display
controller depends on the mux, and the mux depends on the panel. It
would be entirely reasonable to start up the display subsystem with the
embedded controller without the discrete adapter being available, but
the way the current graph pattern is proposed there is no dependency
information between the devices.

I really do think the dependency direction needs to be explicit so that
a driver knows whether or not a given link is relevant for it to start,
and there must be driver know that knows how to interpret the target
node. A device that is a master needs to know which links are
dependencies, and which are not.

I'm not even talking about the bi-directional link issue. This issue
remains regardless of whether or not bidirectional links are used.

I would solve it in one of the following two ways:

1) Make masters only look at one level of dependency. Make the component
driver responsible for checking /its/ dependencies. If its dependencies
aren't yet met, then don't register the component as ready. We could
probably make the drivers/base/component code allow components to pull
in additional components as required. This approach shouldn't even
require a change to the binding and eliminates any need for walking the
full graph.

2) Give the master node an explicit list of all devices it depends on. I
don't like this solution as much, but it does the job.

g.
