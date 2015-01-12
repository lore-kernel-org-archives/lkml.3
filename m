Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbbALJZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:25:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35415 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbALJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:25:45 -0500
Message-ID: <1421054728.3081.28.camel@pengutronix.de>
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
Date: Mon, 12 Jan 2015 10:25:28 +0100
In-Reply-To: <20150109200127.GD12302@n2100.arm.linux.org.uk>
References: <54AE99F5.1010404@ti.com> <20150108174257.557f7ea5@armhf>
	 <54AFA9B0.6040405@ti.com> <20150109123036.4bc4bbf6@armhf>
	 <20150109114529.GH12302@n2100.arm.linux.org.uk>
	 <20150109135401.5b270d46@armhf>
	 <20150109130725.GN12302@n2100.arm.linux.org.uk> <54AFDE8D.3000504@arm.com>
	 <20150109145741.GP12302@n2100.arm.linux.org.uk>
	 <20150109183857.53d701a4@armhf>
	 <20150109200127.GD12302@n2100.arm.linux.org.uk>
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

Am Freitag, den 09.01.2015, 20:01 +0000 schrieb Russell King - ARM
Linux:
[...]
> Neither; we know that there are TDA998x devices which allow SPDIF to be
> input via two separate pins, but only one to be active at any one time.
> Given that the hardware is flexible in that regard, a binding which
> artificially restricts that flexibility would seem unwise.
> 
> If we were to come across a setup which did route two SPDIF streams to
> the TDA998x, and we had to make the decision at run time which to route
> to the HDMI sink, we'd have to rework the binding, and we'd have to
> support the new binding and the old binding in the driver.
> 
> Can you please look at Documentation/devicetree/bindings/graph.txt ?
> 
> I think we may be able to use something like this:
> 
> tda998x: hdmi-encoder {
> 	compatible = "nxp,tda998x";
> 	reg = <0x70>;
> 	video-ports = <0x234501>;
> 
> 	port {
> 		tda998x_video: endpoint {
> 			remote-endpoint = <&lcd0_rgb>;
> 		};
> 	};
> 
> 	port {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		tda998x_spdif0: endpoint@02 {
> 			reg = <0x02>;
> 			remote-endpoint = <&spdif0>;
> 		};
> 
> 		tda998x_spdif1: endpoint@04 {
> 			reg = <0x04>;
> 			remote-endpoint = <&spdif0>;
> 		};
> 
> 		tda998x_i2s: endpoint@03 {
> 			reg = <0x03>;
> 			remote-endpoint = <&i2s>;
> 		};
> 	};
> };
> 
> I'm adding Philipp Zabel for comment.  The issue I see with this is that
> we have two ports here which are not mutually exclusive, and it's not
> obvious how they are dealt with.

Jean-Francois' reply already reflects this, but the 'port' nodes should
correspond to physical ports of the device if possible. If you can
configure the device to have dedicated input pins for I2S, SPDIF0, and
SPDIF1 at the same time, they should appear in the device tree as
separate ports:

tda998x: hdmi-encoder {
	port@0 { /* pixel data according to video-ports */
		reg = <0x00>;
	};
	port@1 { /* AP1: SPDIF0 */
		reg = <0x01>;
	};
	port@2 { /* AP2: SPDIF1 */
		reg = <0x02>;
	};
	port@3 { /* AP3: I2S */
		reg = <0x03>;
	};
};

The tda998x binding would define how the ports are numbered, some
correspondence to the AP pin numbers would be good.

regards
Philipp

