Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaBZOPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:15:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaBZOPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:15:21 -0500
Message-ID: <1393426129.3248.64.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 26 Feb 2014 15:48:49 +0100
In-Reply-To: <20140226110114.CF2C7C40A89@trevor.secretlab.ca>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
	 < 20140217181451.7EB7FC4044D@trevor.secretlab.ca>
	 <20140218070624.GP17250@ pengutronix.de>
	 <20140218162627.32BA4C40517@trevor.secretlab.ca>
	 < 1393263389.3091.82.camel@pizza.hi.pengutronix.de>
	 <20140226110114.CF2C7C40A89@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

thank you for the comments.

Am Mittwoch, den 26.02.2014, 11:01 +0000 schrieb Grant Likely:
> On Mon, 24 Feb 2014 18:36:29 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Am Dienstag, den 18.02.2014, 16:26 +0000 schrieb Grant Likely:
> > > > 
> > > > You can find it under Documentation/devicetree/bindings/media/video-interfaces.txt
> > > 
> > > Okay, I think I'm okay with moving the helpers, but I will make one
> > > requirement. I would like to have a short binding document describing
> > > the pattern being used. The document above talks a lot about video
> > > specific issues, but the helpers appear to be specifically about the
> > > tree walking properties of the API.
> > 
> > Reusing the non-video-secific parts of video-interfaces.txt, how about
> > the following:
> 
> This is good, but I have some comments. This document describes itself
> as the common way for doing a device graph within the device tree, but
> there is already a well established pattern for device graphs that is
> used by the interrupts-extended, clocks and other bindings. Those are
> all domain-specific bindings, but the core concept is one device uses
> a resource provided by another device. The resource references construct
> a graph independent from the natural FDT node graph. (ie. the interrupts
> binding forms the interrupt graph. Same for the clock binding).
> 
> So, while this binding does describe a pattern for separate device
> graphs, it is by no means the only common way of doing so.
> 
> I would like the document to acknowledge the difference from the
> phandle+args pattern used elsewhere and a description of when it would
> be appropriate to use this instead of a simpler binding.

Alright. The main point of this binding is that the devices may have
multiple distinct ports that each can be connected to other devices.
So, contrary to the other graph bindings, devices are not simple nodes
in a directed graph. For example a single capture device with two
separate inputs connected to camera sensors:

	,--------.
	| cam [port]-.   ,-----------------.
	`--------´    `-[port@0] capture   |
	,---------.   ,-[port@1] interface |
	| cam [port]-´   `-----------------´
	`---------´

Or two separate display controllers with two parallel outputs each, a
4-port multiplexer, and an encoder (e.g. lvds):

	,------------------.
	| display    [port@0]--.   ,-------------.
	| controller [port@1]-. `-[port@0]       |
	`------------------´   `--[port@1]  mux  |
	,------------------.   ,--[port@2]       |    ,-------------.
	| display    [port@0]-´ ,-[port@3] [port@4]--[port] encoder |
	| controller [port@1]--´   `-------------´    `-------------´
	`------------------´

Optionally, the same with the multiplexer integrated into the
encoder device:

	,------------------.
	| display    [port@0]--.   ,----------------.
	| controller [port@1]-. `-[port@0]          |
	`------------------´   `--[port@1] encoder  |
	,------------------.   ,--[port@2] with mux |
	| display    [port@0]-´ ,-[port@3]          |
	| controller [port@1]--´   `----------------´
	`------------------´

Or display controller, encoder, and panel:

 ,--------.    ,---------.
 | dc [port]--[port@0]   |
 `--------´    | encoder |    ,-----------.
               |   [port@1]--[port] panel |
               `---------´    `-----------´ 

> > "Common bindings for device graphs"
> > 
> > General concept
> > ---------------
> > 
> > The hierarchical organisation of the device tree is well suited to describe
> > control flow to devices, but data flow between devices that work together to
> > form a logical compound device can follow arbitrarily complex graphs.
> 
> I would argue that this pattern isn't necessarily restricted to data
> flow descriptions. It wants to describe linkage between devices that are
> sufficiently complex that the simple binding doesn't do the job.

Ok. In principle it would be possible to use the same scheme for other
connections than data links.

> > The device tree graph bindings allow to describe data bus connections between
> > individual devices, that can't be inferred from device tree parent-child
> > relationships. The common bindings do not contain any information about the
> > direction or type of data flow, they just map connections. Specific properties
> > of the connections can be set depending on the type of connection. To see
> > how this binding applies to video pipelines, see for example
> > Documentation/device-tree/bindings/media/video-interfaces.txt.
> 
> Even if you don't want to declare the direction of data flow, there does
> need to be some guidance as to how the binding is constructed. Does
> device A point to device B? Or the other way around? Why would someone
> choose one over the other? I don't want to see a situation where A & B
> point to each other. Things get complex if the graph is allowed to be
> cyclical.

According to video-interfaces.txt, it is expected that endpoints contain
phandles pointing to the remote endpoint on both sides. I'd like to
leave this up to the more specialized bindings, but I can see that this
makes enumerating the connections starting from each device tree node
easier, for example at probe time.
If the back links are not provided in the device tree, a device at the
receiving end of a remote-endpoint phandle can only know about connected
remote ports after the kernel parsed the whole graph and created the
back links itself.

> > Each endpoint can contain a 'remote-endpoint' phandle property that points to
> > the corresponding endpoint in the port of the remote device. Two 'endpoint'
> > nodes are linked with each other through their 'remote-endpoint' phandles.
> 
> I really don't like this aspect. It is far too easy to get wrong.

On the other hand it is really easy to test for and warn about missing
or misdirected backlinks.

>  Graphs should be one direction only.

But this is not what the current binding in video-interfaces.txt
describes. I don't think it is a good idea to explicitly forbid
backlinks in this binding.

regards
Philipp

