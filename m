Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaBZLBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:01:24 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61192 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBZLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:01:22 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Philipp Zabel <p.zabel@pengutronix.de>
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
In-Reply-To: <1393263389.3091.82.camel@pizza.hi.pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com> < 20140217181451.7EB7FC4044D@trevor.secretlab.ca> <20140218070624.GP17250@ pengutronix.de> <20140218162627.32BA4C40517@trevor.secretlab.ca> < 1393263389.3091.82.camel@pizza.hi.pengutronix.de>
Date: Wed, 26 Feb 2014 11:01:14 +0000
Message-Id: <20140226110114.CF2C7C40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 18:36:29 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Am Dienstag, den 18.02.2014, 16:26 +0000 schrieb Grant Likely:
> > > 
> > > You can find it under Documentation/devicetree/bindings/media/video-interfaces.txt
> > 
> > Okay, I think I'm okay with moving the helpers, but I will make one
> > requirement. I would like to have a short binding document describing
> > the pattern being used. The document above talks a lot about video
> > specific issues, but the helpers appear to be specifically about the
> > tree walking properties of the API.
> 
> Reusing the non-video-secific parts of video-interfaces.txt, how about
> the following:

This is good, but I have some comments. This document describes itself
as the common way for doing a device graph within the device tree, but
there is already a well established pattern for device graphs that is
used by the interrupts-extended, clocks and other bindings. Those are
all domain-specific bindings, but the core concept is one device uses
a resource provided by another device. The resource references construct
a graph independent from the natural FDT node graph. (ie. the interrupts
binding forms the interrupt graph. Same for the clock binding).

So, while this binding does describe a pattern for separate device
graphs, it is by no means the only common way of doing so.

I would like the document to acknowledge the difference from the
phandle+args pattern used elsewhere and a description of when it would
be appropriate to use this instead of a simpler binding.

> 
> "Common bindings for device graphs"
> 
> General concept
> ---------------
> 
> The hierarchical organisation of the device tree is well suited to describe
> control flow to devices, but data flow between devices that work together to
> form a logical compound device can follow arbitrarily complex graphs.

I would argue that this pattern isn't necessarily restricted to data
flow descriptions. It wants to describe linkage between devices that are
sufficiently complex that the simple binding doesn't do the job.

> The device tree graph bindings allow to describe data bus connections between
> individual devices, that can't be inferred from device tree parent-child
> relationships. The common bindings do not contain any information about the
> direction or type of data flow, they just map connections. Specific properties
> of the connections can be set depending on the type of connection. To see
> how this binding applies to video pipelines, see for example
> Documentation/device-tree/bindings/media/video-interfaces.txt.

Even if you don't want to declare the direction of data flow, there does
need to be some guidance as to how the binding is constructed. Does
device A point to device B? Or the other way around? Why would someone
choose one over the other? I don't want to see a situation where A & B
point to each other. Things get complex if the graph is allowed to be
cyclical.

> Data interfaces on devices are described by their child 'port' nodes. The port
> node contains an 'endpoint' subnode for each remote device connected to this
> port via a bus. If a port is connected to more than one remote device on the
> same bus, an 'endpoint' child node must be provided for each of them. If more
> than one port is present in a device node or there is more than one endpoint at
> a port, or port node needs to be associated with a selected hardware interface,
> a common scheme using '#address-cells', '#size-cells' and 'reg' properties is
> used.
> 
> device {
> 	...
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 
> 	port@0 {
> 		...
> 		endpoint@0 { ... };
> 		endpoint@1 { ... };
> 	};
> 
> 	port@1 { ... };
> };
> 
> All 'port' nodes can be grouped under optional 'ports' node, which allows to
> specify #address-cells, #size-cells properties independently for the 'port'
> and 'endpoint' nodes and any child device nodes a device might have.
> 
> device {
> 	...
> 	ports {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		port@0 {
> 			...
> 			endpoint@0 { ... };
> 			endpoint@1 { ... };
> 		};
> 
> 		port@1 { ... };
> 	};
> };
> 
> Each endpoint can contain a 'remote-endpoint' phandle property that points to
> the corresponding endpoint in the port of the remote device. Two 'endpoint'
> nodes are linked with each other through their 'remote-endpoint' phandles.

I really don't like this aspect. It is far too easy to get wrong. Graphs
should be one direction only.

> 
> device_1 {
> 	port {
> 		device_1_output: endpoint {
> 			remote-endpoint = <&device_2_input>;
> 		};
> 	};
> };
> 
> device_1 {
> 	port {
> 		device_2_input: endpoint {
> 			remote-endpoint = <&device_1_output>;
> 		};
> 	};
> };
> 
> 
> Required properties
> -------------------
> 
> If there is more than one 'port' or more than one 'endpoint' node or 'reg'
> property is present in port and/or endpoint nodes the following properties
> are required in a relevant parent node:
> 
>  - #address-cells : number of cells required to define port/endpoint
> 		    identifier, should be 1.
>  - #size-cells    : should be zero.
> 
> Optional endpoint properties
> ----------------------------
> 
> - remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.
> 
> 

