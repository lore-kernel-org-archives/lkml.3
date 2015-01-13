Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbbAMMWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:22:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54978 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAMMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:22:13 -0500
Message-ID: <1421151718.4519.24.camel@pengutronix.de>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 13 Jan 2015 13:21:58 +0100
In-Reply-To: <20150112175705.GN12302@n2100.arm.linux.org.uk>
References: <20150109130725.GN12302@n2100.arm.linux.org.uk>
	 <54AFDE8D.3000504@arm.com> <20150109145741.GP12302@n2100.arm.linux.org.uk>
	 <20150109183857.53d701a4@armhf>
	 <20150109200127.GD12302@n2100.arm.linux.org.uk>
	 <1421054728.3081.28.camel@pengutronix.de>
	 <20150112122527.GF12302@n2100.arm.linux.org.uk>
	 <1421071197.3081.44.camel@pengutronix.de>
	 <20150112140456.GI12302@n2100.arm.linux.org.uk>
	 <20150112181341.4a53ea24@armhf>
	 <20150112175705.GN12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 12.01.2015, 17:57 +0000 schrieb Russell King - ARM Linux:
> On Mon, Jan 12, 2015 at 06:13:41PM +0100, Jean-Francois Moine wrote:
> > On Mon, 12 Jan 2015 14:04:56 +0000
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > On Mon, Jan 12, 2015 at 02:59:57PM +0100, Philipp Zabel wrote:
> > > > Note that of_graph_parse_endpoint interprets the port node's reg
> > > > property as port id. And the unit address part of the node name should
> > > > match the first address in the reg property.
> > 
> > This is not the case in vexpress-v2p-ca15_a7.dts.
> 
> Hmm... as the DT binding doc doesn't specify this restriction, and we
> have a DT file which violates what Philipp has said, I think we ought
> to document that reg vs unit node name does not need to match each
> other, thereby making that official.

The (unit address part == first reg property value) is from the ePAPR
and still documented in http://www.devicetree.org/Device_Tree_Usage. It
isn't explicitly stated as a hard requirement, but it is worded in such
a way that I'd expect it to hold true most of the time :/

> > > So that's not going to work very well... because the AP register is a
> > > bitmask.
> > > 
> > > I guess we could specify a node unit and reg, which the code otherwise
> > > ignores, and specify a philipps,ap-mask = property for the audio ports
> > > instead.
> > 
> > Also, the video and audio ports must be distinguished. They could be
> > defined in different port groups.
> > 
> > Example from the Cubox:
> > 
> > 	video-ports: ports@0 {
> > 		port {
> > 			tda998x_video: endpoint {
> > 				remote-endpoint = <&lcd0_0>;
> > 				nxp,video-port = <0x230145>;
> > 			};
> > 		};
> > 	};
> > 	audio-ports: ports@1 {
> > 		port@0 {			/* AP1 = I2S */
> > 			tda998x_i2s: endpoint@0 {
> > 				remote-endpoint = <&audio1_i2s>;
> > 				nxp,audio-port = <0x03>;
> > 			};
> > 		};
> > 		port@1 {			 /* AP2 = S/PDIF */
> > 			tda998x_spdif: endpoint@1 {
> > 				remote-endpoint = <&audio1_spdif1>;
> > 				nxp,audio-port = <0x04>;
> > 			};
> > 		};
> > 	};

Please don't add the complexity of multiple 'ports' nodes to the OF
graph bindings. I'd rather have the driver determine the type of the
port. Ideally it could know that port 0 always is video and all other
ports are audio, otherwise checking the existence of a custom property
in the 'port' node should work, for example 'nxp,audio-port' or
'nxp,video-port'.
Why are those located in the 'endpoint' nodes in your example? Are you
expecting to dynamically reconfigure the port type of a given AP from
i2s to spdif depending on the activated endpoint?

> > The port type is identified by the bit AP0.
> 
> I don't particularly like that - that makes the assumption that AP0
> always means I2S.  What if a future chip decides to allow SPDIF on
> AP0?  Why should we need to re-invent the binding?
>
> IMHO, it would be much better to make this explicit.

I wonder if it wouldn't be nicer to have the AP# and type in the device
tree and then calculate the register value from that in the driver.

	port@1 {
		reg = <1>; /* AP1 */
		nxp,audio-port = "i2s";
		tda998x_i2s: endpoint {
			remote-endpoint = <&audio1_i2s>;
		};
	};

regards
Philipp

