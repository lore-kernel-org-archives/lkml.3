Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaCHPx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:53:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:60565 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaCHPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:53:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Sat, 08 Mar 2014 16:54:58 +0100
Message-ID: <1536567.OYzyi25bjL@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+gwMcfgKre8S4KHPvTVuAuz672aehGrN1UfFpwKAueTAcrMZQ@mail.gmail.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <CA+gwMcfgKre8S4KHPvTVuAuz672aehGrN1UfFpwKAueTAcrMZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Saturday 08 March 2014 13:07:23 Philipp Zabel wrote:
> On Fri, Mar 7, 2014 at 6:18 PM, Grant Likely wrote:
> > On Wed, 26 Feb 2014 16:24:57 +0100, Philipp Zabel wrote:
> >> The 'ports' node is optional. It is only needed if the parent node has
> >> its own #address-cells and #size-cells properties. If the ports are
> >> direct children of the device node, there might be other nodes than
> >> 
> >> ports:
> >>       device {
> >>               #address-cells = <1>;
> >>               #size-cells = <0>;
> >>               
> >>               port@0 {
> >>                       endpoint { ... };
> >>               };
> >>               port@1 {
> >>                       endpoint { ... };
> >>               };
> >>               
> >>               some-other-child { ... };
> >>       };
> >>       
> >>       device {
> >>               #address-cells = <x>;
> >>               #size-cells = <y>;
> >>               
> >>               ports {
> >>                       #address-cells = <1>;
> >>                       #size-cells = <0>;
> >>                       
> >>                       port@0 {
> >>                               endpoint { ... };
> >>                       };
> >>                       port@1 {
> >>                               endpoint { ... };
> >>                       };
> >>               };
> >>               
> >>               some-other-child { ... };
> >>       };
> > 
> > From a pattern perspective I have no problem with that.... From an
> > individual driver binding perspective that is just dumb! It's fine for
> > the ports node to be optional, but an individual driver using the
> > binding should be explicit about which it will accept. Please use either
> > a flag or a separate wrapper so that the driver can select the
> > behaviour.
> 
> If the generic binding exists in both forms, most drivers should be
> able to cope with both. Maybe it should be mentioned in the bindings
> that the short form without ports node should be used where possible
> (i.e. for devices that don't already have #address,size-cells != 1,0).
> 
> Having a separate wrapper to enforce the ports node for devices that
> need it might be useful.
> 
> >> The helper should find the two endpoints in both cases.
> >> 
> >> Tomi suggests an even more compact form for devices with just one port:
> >>       device {
> >>               endpoint { ... };
> >>               
> >>               some-other-child { ... };
> >>       };
> > 
> > That's fine. In that case the driver would specifically require the
> > endpoint to be that one node.... although the above looks a little weird
> > to me. I would recommend that if there are other non-port child nodes
> > then the ports should still be encapsulated by a ports node.  The device
> > binding should not be ambiguous about which nodes are ports.
> 
> Sylwester suggested as an alternative, if I understood correctly, to
> drop the endpoint node and instead keep the port:
> 
>     device-a {
>         implicit_output_ep: port {
>             remote-endpoint = <&explicit_input_ep>;
>         };
>     };
> 
>     device-b {
>         port {
>             explicit_input_ep: endpoint {
>                 remote-endpoint = <&implicit_output_ep>;
>             };
>         };
>     };
> 
> This would have the advantage to reduce verbosity for devices with multiple
> ports that are only connected via one endport each, and you'd always have
> the connected ports in the device tree as 'port' nodes.

I like that idea. I would prefer making the 'port' nodes mandatory and the 
'ports' and 'endpoint' nodes optional. Leaving the 'port' node out slightly 
decreases readability in my opinion, but making the 'endpoint' node optional 
increases it. That's just my point of view though.

> >> > It seems that this function is merely a helper to get all grandchildren
> >> > of a node (with some very minor constraints). That could be generalized
> >> > and simplified. If the function takes the "ports" node as an argument
> >> > instead of the parent, then there is a greater likelyhood that other
> >> > code can make use of it...
> >> > 
> >> > Thinking further. I think the semantics of this whole feature basically
> >> > boil down to this:
> >> > 
> >> > #define for_each_grandchild_of_node(parent, child, grandchild) \
> >> > 
> >> >     for_each_child_of_node(parent, child) \
> >> >     
> >> >             for_each_child_of_node(child, grandchild)
> >> > 
> >> > Correct? Or in this specific case:
> >> >     parent = of_get_child_by_name(np, "ports")
> >> >     for_each_grandchild_of_node(parent, child, grandchild) {
> >> >     
> >> >             ...
> >> >     
> >> >     }
> >> 
> >> Hmm, that would indeed be a bit more generic, but it doesn't handle the
> >> optional 'ports' subnode and doesn't allow for other child nodes in the
> >> device node.
> > 
> > See above. The no-ports-node version could be the
> > for_each_grandchild_of_node() block, and the yes-ports-node version
> > could be a wrapper around that.
> 
> For the yes-ports-node version I see no problem, but without the ports node,
> for_each_grandchild_of_node would also collect the children of non-port
> child nodes.
> The port and endpoint nodes in this binding are identified by their name,
> so maybe adding of_get_next_child_by_name() /
> for_each_named_child_of_node() could be helpful here.
> 
> >> > Finally, looking at the actual patch, is any of this actually needed.
> >> > All of the users updated by this patch only ever handle a single
> >> > endpoint. Have I read it correctly? Are there any users supporting
> >> > multiple endpoints?
> >> 
> >> Yes, mainline currently only contains simple cases. I have posted i.MX6
> >> 
> >> patches that use this scheme for the output path:
> >>   http://www.spinics.net/lists/arm-kernel/msg310817.html
> >>   http://www.spinics.net/lists/arm-kernel/msg310821.html
> > 
> > Blurg. On a plane right now. Can't go and read those links.
> 
> The patches are merged into the staging tree now at bfe24b9.

-- 
Regards,

Laurent Pinchart

