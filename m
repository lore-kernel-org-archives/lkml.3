Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaCDPrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:47:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaCDPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:47:50 -0500
Message-ID: <1393948056.3917.120.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v5 5/7] [media] of: move common endpoint parsing to
 drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Date: Tue, 04 Mar 2014 16:47:36 +0100
In-Reply-To: <5315C535.2070303@ti.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
		 <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>
		 <531595AB.4000001@ti.com>
	 <1393932989.3917.62.camel@paszta.hi.pengutronix.de>
	 <5315C535.2070303@ti.com>
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

Am Dienstag, den 04.03.2014, 14:21 +0200 schrieb Tomi Valkeinen:
> On 04/03/14 13:36, Philipp Zabel wrote:
[...]
> >> Can port_node be NULL? Probably only if something is quite wrong, but
> >> maybe it's safer to return error in that case.
> > 
> > both of_property_read_u32 and of_node_put can handle port_node == NULL.
> > I'll add a WARN_ONCE here as for of_graph_get_next_endpoint and continue
> > on.
> 
> Isn't it better to return an error?

I am not sure. We can still correctly parse the endpoint properties of a
parentless node. All current users ignore the return value anyway. So as
long as we still do the memset and and set local_node and id, returning
an error effectively won't change the current behaviour.

[...]
> > It depends a bit on whether you are actually iterating over individual
> > ports, or if you are just walking the whole endpoint graph to find
> > remote devices that have to be added to the component master's waiting
> > list, for example.
> 
> True, but the latter is easily implemented using the separate
> port/endpoint iteration. So I see it as a more powerful API.

Indeed. I see no problem in adding an of_graph_get_next_port function.
But I'd like to keep the current of_graph_get_next_endpoint function
iterating over all endpoints of the device.

> >> Both of those are possible with the API in the series, but not very cleanly.
> >>
> >> Also, if you just want to iterate the endpoints, it's easy to implement
> >> a helper using the separate port and endpoint iterations.
> > 
> > I started out to move an existing (albeit lightly used) API to a common
> > place so others can use it and improve upon it, too. I'm happy to pile
> > on fixes directly in this series, but could we separate the improvement
> > step from the move, for the bigger modifications?
> 
> Yes, I understand that. What I wonder is that which is easier: make it a
> public API now, more or less as it was in v4l2, or make it a public API
> only when all the improvements we can think of have been made.
> 
> So my fear is that the API is now made public, and you and others start
> to use it.

And I fear that this series might outgrow maintainer attention spans if
I keep adding to it.

> But I can't use it, as I need things like separate
> port/endpoint iteration. I need to add those, which also means that I
> need to change all the users of the API, making the task more difficult
> than I'd like.
>
> However, this is more of "thinking out loud" than "I don't like the
> series". It's a good series =).

Thanks. How about I follow this up with a split port/endpoint parsing
helpers after I get some acks?

> > I had no immediate use for the port iteration, so I have taken no steps
> > to add a function for this. I see no problem to add this later when
> > somebody needs it, or even rewrite of_graph_get_next_endpoint to use it
> > if it is feasible. Iterating over endpoints on a given port needs no
> > helper, as you can just use for_each_child_of_node.
> 
> I would have a helper, which should do some sanity checks, like that the
> node names are "endpoint".

I'd prefer this to be a generic function of_get_next_child_by_name and
possibly a macro for_each_named_child_of_node wrapping that.

[...]
> In omapdss each driver handles only the ports and endpoints defined for
> its device, and they can be considered private to that device. The only
> reason to look for the remote endpoint is to find the remote device. To
> me the omapdss model makes sense, and feels logical and sane =). So I
> have to say I'm not really familiar with the model you're using.

The main difference I see is that a single IPU device will have two port
nodes handled by the DRM driver and two port nodes handled by the V4L2
driver, so we can't go back up to the IPU device tree node and iterate
over all its ports in either the DRM or V4L2 drivers.
You could argue that all the device tree parsing should be done from the
IPU drivers, and the DRM and V4L2 drivers should use preparsed internal
graph structures. But then we are getting into using struct media_entity
in DRM drivers territory, and rather not go there right now.

regards
Philipp

