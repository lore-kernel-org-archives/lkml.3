Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaFWI7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:59:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58320 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaFWI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:59:21 -0400
Message-ID: <1403513950.4136.34.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH] mfd: syscon: add child device support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Mon, 23 Jun 2014 10:59:10 +0200
In-Reply-To: <CAL_JsqLjyNQfjs4cDf8Eh1WeVGauym=qbF_pEAMu7ASVMqaccg@mail.gmail.com>
References: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
	 <CAL_JsqLjyNQfjs4cDf8Eh1WeVGauym=qbF_pEAMu7ASVMqaccg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Am Dienstag, den 17.06.2014, 11:57 -0500 schrieb Rob Herring:
> On Tue, May 27, 2014 at 8:55 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > For devices which have a complete register for themselves, it is possible to
> > place them next to the syscon device with overlapping reg ranges. The same is
> 
> We want to avoid overlapping ranges.
>
> > not possible for devices which only occupy bitfields in registers shared with
> > other users.
> 
> You are addressing the latter case here?

Yes, exactly. Although this patch would make it possible to also use
child nodes in the former case.

> > For devices that are completely controlled by bitfields in the syscon address
> > range, such as multiplexers or voltage regulators, allow to put child devices
> > into the syscon device node.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
> >  drivers/mfd/syscon.c                             |  2 ++
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> > index fe8150b..a7e11d5 100644
> > --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> > +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> > @@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
> >  OS driver) to determine the location of the registers, and access the
> >  registers directly.
> >
> > +Optionally, devices that are only controlled through single syscon
> > +registers or bitfields can also be added as child nodes to the syscon
> > +device node. These devices can implicitly assume their parent node
> > +as syscon provider without referencing it explicitly via phandle.
> > +In this case, the syscon node should have #address-cells = <1> and
> > +#size-cells = <0> and no ranges property.
> > +
> 
> I'd like to see an example.

My indented use case is the the i.MX6 IOMUXC that mainly does pin
control, but also has a set of general purpose registers (GPR) that
among others control the LVDS encoder and some video input and output
multiplexers.
Also the i.MX6 ANATOP driver does a similar thing already by misusing
the "simple-bus" compatible to probe its child regulator devices.

The LVDS display bridge (LDB) has its own register in the IOMUXC GPR
region and is currently described as an overlapping region in imx53.dts:

	iomuxc: iomuxc@53fa8000 {
		reg = <0x53fa8000 0x4000>;
	};
	gpr: iomuxc-gpr@53fa8000 {
		compatible = "syscon";
		reg = <0x53fa8000 0xc>;
	};
	ldb: ldb@53fa8008 {
		reg = <0x53fa8008 0x4>;
		gpr = <&gpr>;
	};

The ldb reg property is not used, the ldb driver is accessing its
register through the iomuxc-gpr regmap, found via the phandle.
In imx6qdl.dtsi the ldb reg property isn't even there. I'd like to move
the ldb node into the gpr node and add a few multiplexers there:

	gpr: iomuxc-gpr@020e0000 {
		compatible = "syscon";
		reg = <0x020e0000 0x38>;
		ldb: ldb@020e0008 {
			/* gpr = <&gpr>; <-- deprecated */
		};
		mipi_ipu1_mux {
			reg = <0x04>;
			bit-mask = <1>;
			bit-shift = <19>;
		};
		mipi_ipu1_mux {
			reg = <0x04>;
			bit-mask = <1>;
			bit-shift = <20>;
		};
	};
	iomuxc: iomuxc@020e0000 {
		reg = <0x020e0000 0x4000>;
	};

I'd  like to describe this in the device tree because these multiplexers
are at different positions and connect different nodes on i.MX6Q and
i.MX6DL (and are missing on i.MX53). The connections would use the graph
bindings documented in Documentation/devicetree/bindings/graph.txt.

>  What does reg in the child contain? The register address?
> What if the child device needs 3 bitfields from 3 different registers?

Good question. I'd use the register address. The reg(ister) / bit-mask /
bit-shift property pattern is already used by the keystone-pll clock
bindings.
Given your point about multiple bitfields, maybe this should be binding
specific. The i.MX6 ANATOP bindings use custom properties for this:

	anatop: anatop@020c8000 {
		/* I'd like to get rid of the simple-bus here: */
		compatible = "syscon", "simple-bus";
		reg = <0x020c8000 0x1000>;
		regulator-1p1@110 {
			compatible = "fsl,anatop-regulator";
			anatop-reg-offset = <0x110>;
			anatop-vol-bit-shift = <8>;
			anatop-vol-bit-width = <5>;
			anatop-min-bit-val = <4>;
			anatop-min-voltage = <800000>;
			anatop-max-voltage = <1375000>;
		};
		/* ... */
	};

> It seems to me that you could then want to describe every single
> bitfield of a block in the DT. That seems like too much information in
> DT much like trying to describe every single clock in DT.

See above. Often there are other reasons already to describe the child
nodes in the device tree anyway, such as regulators, or video nodes that
need to be linked to other nodes using the graph bindings. In those
cases it would be very useful to just use the same nodes to probe the
devices.

regards
Philipp

