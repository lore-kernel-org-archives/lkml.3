Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbbALR53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:57:29 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34875 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbbALR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:57:27 -0500
Date: Mon, 12 Jan 2015 17:57:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
Message-ID: <20150112175705.GN12302@n2100.arm.linux.org.uk>
References: <20150109130725.GN12302@n2100.arm.linux.org.uk>
 <54AFDE8D.3000504@arm.com>
 <20150109145741.GP12302@n2100.arm.linux.org.uk>
 <20150109183857.53d701a4@armhf>
 <20150109200127.GD12302@n2100.arm.linux.org.uk>
 <1421054728.3081.28.camel@pengutronix.de>
 <20150112122527.GF12302@n2100.arm.linux.org.uk>
 <1421071197.3081.44.camel@pengutronix.de>
 <20150112140456.GI12302@n2100.arm.linux.org.uk>
 <20150112181341.4a53ea24@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112181341.4a53ea24@armhf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:13:41PM +0100, Jean-Francois Moine wrote:
> On Mon, 12 Jan 2015 14:04:56 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Mon, Jan 12, 2015 at 02:59:57PM +0100, Philipp Zabel wrote:
> > > Note that of_graph_parse_endpoint interprets the port node's reg
> > > property as port id. And the unit address part of the node name should
> > > match the first address in the reg property.
> 
> This is not the case in vexpress-v2p-ca15_a7.dts.

Hmm... as the DT binding doc doesn't specify this restriction, and we
have a DT file which violates what Philipp has said, I think we ought
to document that reg vs unit node name does not need to match each
other, thereby making that official.

> > So that's not going to work very well... because the AP register is a
> > bitmask.
> > 
> > I guess we could specify a node unit and reg, which the code otherwise
> > ignores, and specify a philipps,ap-mask = property for the audio ports
> > instead.
> 
> Also, the video and audio ports must be distinguished. They could be
> defined in different port groups.
> 
> Example from the Cubox:
> 
> 	video-ports: ports@0 {
> 		port {
> 			tda998x_video: endpoint {
> 				remote-endpoint = <&lcd0_0>;
> 				nxp,video-port = <0x230145>;
> 			};
> 		};
> 	};
> 	audio-ports: ports@1 {
> 		port@0 {			/* AP1 = I2S */
> 			tda998x_i2s: endpoint@0 {
> 				remote-endpoint = <&audio1_i2s>;
> 				nxp,audio-port = <0x03>;
> 			};
> 		};
> 		port@1 {			 /* AP2 = S/PDIF */
> 			tda998x_spdif: endpoint@1 {
> 				remote-endpoint = <&audio1_spdif1>;
> 				nxp,audio-port = <0x04>;
> 			};
> 		};
> 	};
> 
> The port type is identified by the bit AP0.

I don't particularly like that - that makes the assumption that AP0
always means I2S.  What if a future chip decides to allow SPDIF on
AP0?  Why should we need to re-invent the binding?

IMHO, it would be much better to make this explicit.

Note that the "video-ports" and "audio-ports" are just labels in the
DT file; they aren't carried through to the resulting DT binary file,
so they don't have any meaning to the kernel.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
