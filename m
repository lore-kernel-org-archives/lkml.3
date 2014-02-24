Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaBXRhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:37:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaBXRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:36:56 -0500
Message-ID: <1393263389.3091.82.camel@pizza.hi.pengutronix.de>
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
Date: Mon, 24 Feb 2014 18:36:29 +0100
In-Reply-To: <20140218162627.32BA4C40517@trevor.secretlab.ca>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
	 < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
	 < 20140217181451.7EB7FC4044D@trevor.secretlab.ca>
	 <20140218070624.GP17250@ pengutronix.de>
	 <20140218162627.32BA4C40517@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 18.02.2014, 16:26 +0000 schrieb Grant Likely:
> On Tue, 18 Feb 2014 08:06:24 +0100, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Hi Grant,
> > 
> > On Mon, Feb 17, 2014 at 06:14:51PM +0000, Grant Likely wrote:
> > > On Tue, 11 Feb 2014 07:56:33 -0600, Rob Herring <robherring2@gmail.com> wrote:
> > > > On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > > > From: Philipp Zabel <philipp.zabel@gmail.com>
> > > > >
> > > > > This patch moves the parsing helpers used to parse connected graphs
> > > > > in the device tree, like the video interface bindings documented in
> > > > > Documentation/devicetree/bindings/media/video-interfaces.txt, from
> > > > > drivers/media/v4l2-core to drivers/of.
> > > > 
> > > > This is the opposite direction things have been moving...
> > > > 
> > > > > This allows to reuse the same parser code from outside the V4L2 framework,
> > > > > most importantly from display drivers. There have been patches that duplicate
> > > > > the code (and I am going to send one of my own), such as
> > > > > http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> > > > > and others that parse the same binding in a different way:
> > > > > https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
> > > > >
> > > > > I think that all common video interface parsing helpers should be moved to a
> > > > > single place, outside of the specific subsystems, so that it can be reused
> > > > > by all drivers.
> > > > 
> > > > Perhaps that should be done rather than moving to drivers/of now and
> > > > then again to somewhere else.
> > > 
> > > This is just parsing helpers though, isn't it? I have no problem pulling
> > > helper functions into drivers/of if they are usable by multiple
> > > subsystems. I don't really understand the model being used though. I
> > > would appreciate a description of the usage model for these functions
> > > for poor folks like me who can't keep track of what is going on in
> > > subsystems.
> > 
> > You can find it under Documentation/devicetree/bindings/media/video-interfaces.txt
> 
> Okay, I think I'm okay with moving the helpers, but I will make one
> requirement. I would like to have a short binding document describing
> the pattern being used. The document above talks a lot about video
> specific issues, but the helpers appear to be specifically about the
> tree walking properties of the API.

Reusing the non-video-secific parts of video-interfaces.txt, how about
the following:

"Common bindings for device graphs"

General concept
---------------

The hierarchical organisation of the device tree is well suited to describe
control flow to devices, but data flow between devices that work together to
form a logical compound device can follow arbitrarily complex graphs.
The device tree graph bindings allow to describe data bus connections between
individual devices, that can't be inferred from device tree parent-child
relationships. The common bindings do not contain any information about the
direction or type of data flow, they just map connections. Specific properties
of the connections can be set depending on the type of connection. To see
how this binding applies to video pipelines, see for example
Documentation/device-tree/bindings/media/video-interfaces.txt.

Data interfaces on devices are described by their child 'port' nodes. The port
node contains an 'endpoint' subnode for each remote device connected to this
port via a bus. If a port is connected to more than one remote device on the
same bus, an 'endpoint' child node must be provided for each of them. If more
than one port is present in a device node or there is more than one endpoint at
a port, or port node needs to be associated with a selected hardware interface,
a common scheme using '#address-cells', '#size-cells' and 'reg' properties is
used.

device {
	...
	#address-cells = <1>;
	#size-cells = <0>;

	port@0 {
		...
		endpoint@0 { ... };
		endpoint@1 { ... };
	};

	port@1 { ... };
};

All 'port' nodes can be grouped under optional 'ports' node, which allows to
specify #address-cells, #size-cells properties independently for the 'port'
and 'endpoint' nodes and any child device nodes a device might have.

device {
	...
	ports {
		#address-cells = <1>;
		#size-cells = <0>;

		port@0 {
			...
			endpoint@0 { ... };
			endpoint@1 { ... };
		};

		port@1 { ... };
	};
};

Each endpoint can contain a 'remote-endpoint' phandle property that points to
the corresponding endpoint in the port of the remote device. Two 'endpoint'
nodes are linked with each other through their 'remote-endpoint' phandles.

device_1 {
	port {
		device_1_output: endpoint {
			remote-endpoint = <&device_2_input>;
		};
	};
};

device_1 {
	port {
		device_2_input: endpoint {
			remote-endpoint = <&device_1_output>;
		};
	};
};


Required properties
-------------------

If there is more than one 'port' or more than one 'endpoint' node or 'reg'
property is present in port and/or endpoint nodes the following properties
are required in a relevant parent node:

 - #address-cells : number of cells required to define port/endpoint
		    identifier, should be 1.
 - #size-cells    : should be zero.

Optional endpoint properties
----------------------------

- remote-endpoint: phandle to an 'endpoint' subnode of a remote device node.


