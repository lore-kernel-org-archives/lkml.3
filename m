Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaCHLlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 06:41:25 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56613 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaCHLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 06:41:20 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <531AF1E8.50606@ti.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de> <20140218162627.32BA4C40517@trevor.secretlab.ca> < 1393263389.3091.82.camel@pizza.hi.pengutronix.de> <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <20140307170550.1DFB2C40A0D@trevor.secretlab.ca> <531AF1E8. 50606@ti.com>
Date: Sat, 08 Mar 2014 11:41:15 +0000
Message-Id: <20140308114115.BB08EC40612@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2014 12:33:12 +0200, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 07/03/14 19:05, Grant Likely wrote:
> > On Wed, 26 Feb 2014 15:48:49 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> >> Hi Grant,
> >>
> >> thank you for the comments.
> > 
> > Hi Philipp,
> > 
> > I've got lots of comments and quesitons below, but I must say thank you
> > for doing this. It is a helpful description.
> 
> Thanks for the comments. I'll answer from my point of view, which may be
> different than Philipp's.
> 
> > Bear with me, I'm going to comment on each point. I'm not criticizing,
> > but I do want to understand the HW design. In particular I want to
> > understand why the linkage is treated as bidirectional instead of one
> > device being the master.
> > 
> > In this specific example, what would be managing the transfer? Is there
> > an overarching driver that assembles the pieces, or would you expect
> > individual drivers to find each other?
> 
> The direction of the dataflow depends on the case. For camera, the data
> flows from external components towards the SoC. For display, vice versa.
> I don't know much about camera, but for display there are bi-directional
> buses, like MIPI DBI and MIPI DSI. However, in those cases, the main
> flow direction is clear, towards the display.
> 
> Then again, these are meant to be generic graph bindings, and the
> dataflow could be fully bi-directional.
> 
> As for the driver model (does it matter when we are talking about DT
> bindings?), I think there are very different opinions. My thought for
> display is that there is always an overarching driver, something that
> manages the video pipeline as a whole.
> 
> However, each of the individual drivers in the video pipeline will
> control its input ports. So, say, a panel driver gets a command from the
> overarching control driver to enable the panel device. The panel driver
> reacts by calling the encoder (i.e. the one that outputs pixels to the
> panel), commanding it to enable the video stream.
> 
> I know some (many?) people think the other way around, that the encoder
> commands the panel to enable itself. I don't think that's versatile
> enough. As a theoretical, slightly exaggerated, example, we could have a
> panel that wants the pixel clock to be enabled for a short while before
> enabling the actual pixel stream. And maybe the panel driver needs to do
> something before the pixel stream is enabled (say, send a command to the
> panel).
> 
> The above is very easy to do if the panel driver is in control of the
> received video stream. It's rather difficult to do if the encoder is in
> control.
> 
> Also, I think a panel (or any encoder) can be compared to a display
> controller: a display controller uses DMA to transfer pixel data from
> the memory to the display controller. A panel or encoder uses the
> incoming video bus to transfer pixel data from the previous display
> component to the panel or encoder device. And I don't think anyone says
> the DMA driver should be in control of the display controller.
> 
> But this is going quite a bit into the SW architecture. Does it matter
> when we are talking about the representation of HW in the DT data?

It matter to the point that the binding author makes a decision about
how to represent the hardware. The driver architecture doesn't need to
match the binding layout, but it is nice when they line up.

> > In all of the above examples I see a unidirectional data flow. There are
> > producer ports and consumer ports. Is there any (reasonable) possibility
> > of peer ports that are bidirectional?
> 
> Yes, as I mentioned above. However, I do believe that at the moment all
> the cases have a clear a main direction. But then, if these are generic
> bindings, do we want to rely on that?

Most of my questions are making sure I've got a full understanding. Even
if there are typical devices that have bidirectional interfaces I think
my decisions as a binding author would be the same. Given an arbitrary
graph of devices, I would still choose one place to describe a
connection. If it was a complex setup I may use a completely separate
node that collects all the element devices. On more straightforward
setups I would choose one of the devices as the 'master' and have it
describe the connections to other component devices.

> >> According to video-interfaces.txt, it is expected that endpoints contain
> >> phandles pointing to the remote endpoint on both sides. I'd like to
> >> leave this up to the more specialized bindings, but I can see that this
> >> makes enumerating the connections starting from each device tree node
> >> easier, for example at probe time.
> > 
> > This has come up in the past. That approach comes down to premature
> > optimization at the expense of making the data structure more prone to
> > inconsistency. I consider it to be a bad pattern.
> > 
> > Backlinks are good for things like dynamically linked lists that need to
> > be fast and the software fully manages the links. For a data structure like
> > the FDT it is better to have the data in one place, and one place only.
> > Besides, computers are *good* at parsing data structures. :-)
> > 
> > I appreciate that existing drivers may be using the backlinks, but I
> > strongly recommend not doing it for new users.
> 
> Ok. If we go for single directional link, the question is then: which
> way? And is the direction different for display and camera, which are
> kind of reflections of each other?

In general I would recommend choosing whichever device you would
sensibly think of as a master. In the camera case I would choose the
camera controller node instead of the camera itself, and in the display
case I would choose the display controller instead of the panel. The
binding author needs to choose what she things makes the most sense, but
drivers can still use if it it turns out to be 'backwards'

> > Another thought. In terms of the pattern, I would add a recommendation
> > that there should be a way to identify ports of a particular type. ie.
> > If I were using the pattern to implement an patch bay of DSP filters,
> > where each input and output, then each target node should have a unique
> > identifier property analogous to "interrupt-controller" or
> > "gpio-controller". In this fictitious example I would probably choose
> > "audiostream-input-port" and "audiostream-output-port" as empty
> > properties in the port nodes. (I'm not suggesting a change to the
> > existing binding, but making a recommendation to new users).
> 
> I don't see any harm in that, but I don't right away see what could be
> done with them? Did you have something in mind?

It would help with schema validation and allow ports of the same
interface to get grouped together.

> I guess those could be used to study the graph before the drivers have
> been loaded. After the drivers have been loaded, the drivers should
> somehow register themselves and the ports/endpoints. And as the driver
> knows what kind of ports they are, it can supply this information in the
> runtime data structures.
> 
> If we do that, would it be better to have two pieces of data:
> input/output/bi-directional, and the port type (say, mipi-dpi, lvds, etc.)?

Sure. That's worth considering.

g.

