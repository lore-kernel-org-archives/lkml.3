Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaB0KDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:03:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38404 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaB0KDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:03:03 -0500
Message-ID: <1393498356.4507.32.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Thu, 27 Feb 2014 11:52:36 +0100
In-Reply-To: <530EF294.7070801@ti.com>
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
			 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
			 <530DE8A9.9050809@ti.com>
		 <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
		 <530DFF4C.8080807@ti.com>
	 <1393429676.3248.110.camel@paszta.hi.pengutronix.de>
	 <530EF294.7070801@ti.com>
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

Am Donnerstag, den 27.02.2014, 10:08 +0200 schrieb Tomi Valkeinen:
> On 26/02/14 17:47, Philipp Zabel wrote:
> > Please let's not make it mandatory for a port node to contain an
> > endpoint. For any device with multiple ports we can't use the simplified
> > form above, and only adding the (correctly numbered) port in all the
> > board device trees would be a pain.
> 
> That's true. I went with having the ports in the board file, for example
> on omap3 the dss has two ports, and N900 board uses the second one:
> 
> &dss {
> 	status = "ok";
> 
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&dss_sdi_pins>;
> 
> 	vdds_sdi-supply = <&vaux1>;
> 
> 	ports {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		port@1 {
> 			reg = <1>;
> 
> 			sdi_out: endpoint {
> 				remote-endpoint = <&lcd_in>;
> 				datapairs = <2>;
> 			};
> 		};
> 	};
> };

This is a bit verbose, and if your output port is on an encoder device
with multiple inputs, the correct port number would become a bit
unintuitive. For example, we'd have to use port@4 as the output encoder
units that have a 4-port input multiplexer and port@1 for those that
don't.

> Here I guess I could have:
> 
> &dss {
> 	status = "ok";
> 
> 	pinctrl-names = "default";
> 	pinctrl-0 = <&dss_sdi_pins>;
> 
> 	vdds_sdi-supply = <&vaux1>;
> };

What is supplied by this regulator. Is it the PHY?

> &dss_sdi_port {
> 	sdi_out: endpoint {
> 		remote-endpoint = <&lcd_in>;
> 		datapairs = <2>;
> 	};
> };
> 
> But I didn't like that as it splits the pincontrol and regulator supply
> from the port/endpoint, which are functionally linked together.
>
> Actually, somewhat aside the subject, I'd like to have the pinctrl and
> maybe regulator supply also per endpoint, but I didn't see how that
> would be possible with the current framework. If a board would need to
> endpoints for the same port, most likely it would also need to different
> sets of pinctrls.

I have a usecase for this the other way around. The i.MX6 DISP0 parallel
display pads can be connected to two different display controllers via
multiplexers in the pin control block.

parallel-display {
	compatible = "fsl,imx-parallel-display";
	#address-cells = <1>;
	#size-cells = <0>;

	port@0 {
		endpoint {
			remote-endpoint = <&ipu1_di0>;
		};
	};

	port@1 {
		endpoint {
			remote-endpoint = <&ipu2_di0>;
		};
	};

	disp0: port@2 {
		endpoint {
			pinctrl-names = "0", "1";
			pinctrl-0 = <&pinctrl_disp0_ipu1>;
			pinctrl-1 = <&pinctrl_disp0_ipu2>;
			remote-endpoint = <&lcd_in>;
		};
	}
};

Here, depending on the active input port, the corresponding pin control
on the output port could be set. This is probably quite driver specific,
so I don't see yet how the framework should help with this. In any case,
maybe this is a bit out of scope for the generic graph bindings.

regards
Philipp

