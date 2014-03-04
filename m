Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbaCDLhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:37:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaCDLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:37:03 -0500
Message-ID: <1393932989.3917.62.camel@paszta.hi.pengutronix.de>
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
Date: Tue, 04 Mar 2014 12:36:29 +0100
In-Reply-To: <531595AB.4000001@ti.com>
References: <1393522540-22887-1-git-send-email-p.zabel@pengutronix.de>
	 <1393522540-22887-6-git-send-email-p.zabel@pengutronix.de>
	 <531595AB.4000001@ti.com>
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

Hi Tomi,

Am Dienstag, den 04.03.2014, 10:58 +0200 schrieb Tomi Valkeinen:
[...]
> > +int of_graph_parse_endpoint(const struct device_node *node,
> > +			    struct of_endpoint *endpoint)
> > +{
> > +	struct device_node *port_node = of_get_parent(node);
> 
> Can port_node be NULL? Probably only if something is quite wrong, but
> maybe it's safer to return error in that case.

both of_property_read_u32 and of_node_put can handle port_node == NULL.
I'll add a WARN_ONCE here as for of_graph_get_next_endpoint and continue
on.

> > +	memset(endpoint, 0, sizeof(*endpoint));
> > +
> > +	endpoint->local_node = node;
> > +	/*
> > +	 * It doesn't matter whether the two calls below succeed.
> > +	 * If they don't then the default value 0 is used.
> > +	 */
> > +	of_property_read_u32(port_node, "reg", &endpoint->port);
> > +	of_property_read_u32(node, "reg", &endpoint->id);
> 
> If the endpoint does not have 'port' as parent (i.e. the shortened
> format), the above will return the 'reg' of the device node (with
> 'device node' I mean the main node, with 'compatible' property).

Yes, a check for the port_node name is in order.

> And generally speaking, if struct of_endpoint is needed, maybe it would
> be better to return the struct of_endpoint when iterating the ports and
> endpoints. That way there's no need to do parsing "afterwards", trying
> to figure out if there's a parent port node, but the information is
> already at hand.

I'd like to keep the iteration separate from parsing so we can
eventually introduce a for_each_endpoint_of_node helper macro around
of_graph_get_next_endpoint.

[...]
> A few thoughts about the iteration, and the API in general.
> 
> In the omapdss version I separated iterating ports and endpoints, for
> the two reasons:
> 
> 1) I think there are cases where you may want to have properties in the
> port node, for things that are common for all the port's endpoints.
>
> 2) if there are multiple ports, I think the driver code is cleaner if
> you first take the port, decide what port that is and maybe call a
> sub-function, and then iterate the endpoints for that port only.

It depends a bit on whether you are actually iterating over individual
ports, or if you are just walking the whole endpoint graph to find
remote devices that have to be added to the component master's waiting
list, for example.

> Both of those are possible with the API in the series, but not very cleanly.
>
> Also, if you just want to iterate the endpoints, it's easy to implement
> a helper using the separate port and endpoint iterations.

I started out to move an existing (albeit lightly used) API to a common
place so others can use it and improve upon it, too. I'm happy to pile
on fixes directly in this series, but could we separate the improvement
step from the move, for the bigger modifications?

I had no immediate use for the port iteration, so I have taken no steps
to add a function for this. I see no problem to add this later when
somebody needs it, or even rewrite of_graph_get_next_endpoint to use it
if it is feasible. Iterating over endpoints on a given port needs no
helper, as you can just use for_each_child_of_node.

> Then, about the get_remote functions: I think there should be only one
> function for that purpose, one that returns the device node that
> contains the remote endpoint.
> 
> My reasoning is that the ports and endpoints, and their contents, should
> be private to the device. So the only use to get the remote is to get
> the actual device, to see if it's been probed, or maybe get some video
> API for that device.

of_graph_get_remote_port currently is used in the exynos4-is/fimc-is.c
v4l2 driver to get the mipi-csi channel id from the remote port, and
I've started using it in imx-drm-core.c for two cases:
- given an endpoint on the encoder, find the remote port connected to
  it, get the associated drm_crtc, to obtain its the drm_crtc_mask
  for encoder->possible_crtcs.
- given an encoder and a connected drm_crtc, walk all endpoints to find
  the remote port associated with the drm_crtc, and then use the local
  endpoint parent port to determine multiplexer settings.

> If the driver model used has some kind of master-driver, which goes
> through all the display entities, I think the above is still valid. When
> the master-driver follows the remote-link, it still needs to first get
> the main device node, as the ports and endpoints make no sense without
> the context of the main device node.

I'm not sure about this. I might just need the remote port node
associated with a remote drm_crtc or drm_encoder structure to find out
which local endpoint I should look at to retrieve configuration.

regards
Philipp

