Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbaCTWaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:30:22 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36688 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaCTWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:30:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
Date: Thu, 20 Mar 2014 23:32:07 +0100
Message-ID: <2848953.vVjghJyYNE@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140320222347.CAB6DC412EA@trevor.secretlab.ca>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de> <3632624.gNVi6QOfGx@avalon> <20140320222347.CAB6DC412EA@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thursday 20 March 2014 22:23:47 Grant Likely wrote:
> On Sat, 08 Mar 2014 16:50:33 +0100, Laurent Pinchart wrote:
> > On Saturday 08 March 2014 12:23:21 Grant Likely wrote:
> > > On Sat, 8 Mar 2014 12:46:05 +0200, Tomi Valkeinen wrote:
> > > > On 07/03/14 19:18, Grant Likely wrote:
> > > > > From a pattern perspective I have no problem with that.... From an
> > > > > individual driver binding perspective that is just dumb! It's fine
> > > > > for the ports node to be optional, but an individual driver using
> > > > > the binding should be explicit about which it will accept. Please
> > > > > use either a flag or a separate wrapper so that the driver can
> > > > > select the behaviour.
> > > > 
> > > > Why is that? The meaning of the DT data stays the same, regardless of
> > > > the existence of the 'ports' node. The driver uses the graph helpers
> > > > to parse the port/endpoint data, so individual drivers don't even have
> > > > to care about the format used.
> > > 
> > > You don't want to give options to the device tree writer. It should work
> > > one way and one way only. Every different combination is a different
> > > permutation to get wrong. The only time we should be allowing for more
> > > than one way to do it is when there is an existing binding that has
> > > proven to be insufficient and it needs to be extended, such as was done
> > > with interrupts-extended to deal with deficiencies in the interrupts
> > > property.
> > > 
> > > > As I see it, the graph helpers should allow the drivers to iterate the
> > > > ports and the endpoints for a port. These should work the same way, no
> > > > matter which abbreviated format is used in the dts.
> > > > 
> > > > >> The helper should find the two endpoints in both cases.
> > > > >> 
> > > > >> Tomi suggests an even more compact form for devices with just one
> > > > >> port:
> > > > >>
> > > > >> 	device {
> > > > >> 		endpoint { ... };
> > > > >> 		
> > > > >> 		some-other-child { ... };
> > > > >> 	};
> > > > > 
> > > > > That's fine. In that case the driver would specifically require the
> > > > > endpoint to be that one node.... although the above looks a little
> > > > > weird
> > > > 
> > > > The driver can't require that. It's up to the board designer to decide
> > > > how many endpoints are used. A driver may say that it has a single
> > > > input port. But the number of endpoints for that port is up to the use
> > > > case.
> > > 
> > > Come now, when you're writing a driver you know if it will ever be
> > > possible to have more than one port. If that is the case then the
> > > binding should be specifically laid out for that. If there will never be
> > > multiple ports and the binding is unambiguous, then, and only then,
> > > should the shortcut be used, and only the shortcut should be accepted.
> > 
> > Whether multiple nodes are possible for a device is indeed known to the
> > driver author, but the number of endpoints depends on the board. In most
> > cases multiple endpoints are possible. If we decide that the level of
> > simplification should be set in stone in the device DT bindings (i.e.
> > making the ports and/or port nodes required or forbidden, but not
> > optional), then I believe this calls for always having a port node even
> > when a single port is needed. I'm fine with leaving the ports node out,
> > but having no port node might be too close to over-simplification.
> 
> Just to make sure we're on the same page (and that I'm parsing correctly):
> Are you saying the individual 'port' nodes should be required? Or that the
> container 'ports' node should always be required?
> 
> If you're saying that the individual port nodes should be required, then
> yes I agree.

That's what I meant, yes. And I'm glad that we finally agree on something, 
even if it's a detail :-)

> I'm still a little uncomfortable about there being a choice between the link
> directly in the port node or in a child endpoint node, but I'll compromise
> on this if we put sanity checking into the API (as I replied on the other
> thread).
>
> Whether or not a container 'ports' node is present I think should be defined
> by the device binding. It really comes down to organization of data. If the
> device is sufficiently complex that it makes sense to group the ports
> together (say, because the device has other children with a different
> purpose), then 'ports' makes absolute sense.

I'm fine with that, as that's what the ports node has been originally designed 
for.

The OF graph bindings documentation could just specify the ports node as 
optional and mandate individual device bindings to specify it as mandatory or 
forbidden (possibly with a default behaviour to avoid making all device 
bindings too verbose).

-- 
Regards,

Laurent Pinchart

