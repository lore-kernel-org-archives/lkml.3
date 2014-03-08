Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaCHMXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:23:32 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34164 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaCHMX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:23:29 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <531AF4ED.5020608@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> < 1393340304-19005-2-git-send-email-p.zabel@pengutronix.de> <20140226113729. A9D5AC40A89@trevor.secretlab.ca> <1393428297.3248.92.camel@paszta.hi. pengutronix.de> <20140307171804.EF245C40A32@trevor.secretlab.ca> <531AF4ED. 5020608@ti.com>
Date: Sat, 08 Mar 2014 12:23:21 +0000
Message-Id: <20140308122321.9D433C40612@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2014 12:46:05 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 07/03/14 19:18, Grant Likely wrote:
> 
> > From a pattern perspective I have no problem with that.... From an
> > individual driver binding perspective that is just dumb! It's fine for
> > the ports node to be optional, but an individual driver using the
> > binding should be explicit about which it will accept. Please use either
> > a flag or a separate wrapper so that the driver can select the
> > behaviour.
> 
> Why is that? The meaning of the DT data stays the same, regardless of
> the existence of the 'ports' node. The driver uses the graph helpers to
> parse the port/endpoint data, so individual drivers don't even have to
> care about the format used.

You don't want to give options to the device tree writer. It should work
one way and one way only. Every different combination is a different
permutation to get wrong. The only time we should be allowing for more
than one way to do it is when there is an existing binding that has
proven to be insufficient and it needs to be extended, such as was done
with interrupts-extended to deal with deficiencies in the interrupts
property.

> As I see it, the graph helpers should allow the drivers to iterate the
> ports and the endpoints for a port. These should work the same way, no
> matter which abbreviated format is used in the dts.
>
> >> The helper should find the two endpoints in both cases.
> >> Tomi suggests an even more compact form for devices with just one port:
> >>
> >> 	device {
> >> 		endpoint { ... };
> >>
> >> 		some-other-child { ... };
> >> 	};
> > 
> > That's fine. In that case the driver would specifically require the
> > endpoint to be that one node.... although the above looks a little weird
> 
> The driver can't require that. It's up to the board designer to decide
> how many endpoints are used. A driver may say that it has a single input
> port. But the number of endpoints for that port is up to the use case.

Come now, when you're writing a driver you know if it will ever be
possible to have more than one port. If that is the case then the
binding should be specifically laid out for that. If there will never be
multiple ports and the binding is unambiguous, then, and only then,
should the shortcut be used, and only the shortcut should be accepted.

> > to me. I would recommend that if there are other non-port child nodes
> > then the ports should still be encapsulated by a ports node.  The device
> > binding should not be ambiguous about which nodes are ports.
> 
> Hmm, ambiguous in what way?

Parsing the binding now consists of a ladder of 'ifs' that gives three
distinct different behaviours for no benefit. You don't want that in
bindings because it makes it more difficult to get the parsing right in
the first place, and to make sure that all users parse it in the same
way (Linux, U-Boot, BSD, etc). Bindings should be as absolutely simple
as possible.

Just to be clear, I have no problem with having the option in the
pattern, but the driver needs to be specific about what layout it
expects.

g.
